//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DashboardPanelView.h"

#import "ReorderDashboardView.h"

#define COLLECTION_HEIGHT 44

#define SELECT_COLOR [UIColor colorWithRed:90.0f / 255.0f green:37.0f / 255.0f blue:89.0f / 255.0f alpha:1.0f]
#define DESELECT_COLOR [UIColor colorWithRed:43.0f / 255.0f green:153.0f / 255.0f blue:216.0f / 255.0f alpha:1.0f]

@interface DashboardPanelView()<ReorderDashboardViewDelegate>
{

}

@property (nonatomic, assign) IBOutlet UIButton * btnAdd;

@property (nonatomic, assign) IBOutlet UIView *viewSearch;

@property (nonatomic, assign) IBOutlet UITextField *txtKeyword;
@property (nonatomic, assign) IBOutlet UITableView *tvDashboards;

@property (nonatomic, assign) IBOutlet UIButton *btnReorderDashboards;

@property (nonatomic, assign) ReorderDashboardView *viewReorderDashboards;

@property (nonatomic, retain) NSMutableArray *aryCollections;

@property (nonatomic, assign) NSInteger selectedCollection;

@end

@implementation DashboardPanelView

- (void) awakeFromNib
{
    self.btnAdd.layer.borderWidth = 1;
    self.btnAdd.layer.borderColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f].CGColor;
    
    self.viewSearch.backgroundColor = [UIColor whiteColor];
    self.viewSearch.layer.borderWidth = 1;
    self.viewSearch.layer.borderColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f].CGColor;
    
    [self loadDashboardInfo];
}

- (void) loadDashboardInfo
{
    if(self.aryCollections == nil)
    {
        self.aryCollections = [[NSMutableArray alloc] init];
    }
    
    [self.aryCollections removeAllObjects];
    
    self.selectedCollection = 0;
    
    for (CollectionInfo *collection in [SharedMembers sharedInstance].aryCollections) {
        
        CollectionInfo *newCollection = [[CollectionInfo alloc] initWithTitle:collection.title];
        
        for (DashboardInfo *dashboard in collection.aryDashboards) {
            
            BOOL isShowable = [self isShowableWithDashboard:dashboard];
            
            if(isShowable)
            {
                [newCollection addDashboard:dashboard];
            }
        }
        
        [self.aryCollections addObject:newCollection];
        
        if([collection.title isEqualToString:[SharedMembers sharedInstance].currentDashboard.collectionName])
        {
            self.selectedCollection = [[SharedMembers sharedInstance].aryCollections indexOfObject:collection];
        }
    }
    
    [self.tvDashboards reloadData];
}

- (BOOL) isShowableWithDashboard:(DashboardInfo *)dashboard
{
    NSString *keyword = self.txtKeyword.text;
    keyword = [keyword lowercaseString];
    
    if(keyword.length == 0)
        return YES;
    
    NSString *lowerDashboard = [dashboard.title lowercaseString];
    
    return [lowerDashboard rangeOfString:keyword].length != 0;
}

- (IBAction)onAdd:(id)sender
{
    [self.delegate createNewDashboard];
}

- (IBAction)onReorderDashboards:(id)sender
{
    if(self.viewReorderDashboards == nil)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"ReorderDashboardView" owner:self options:nil];
        self.viewReorderDashboards = [nib objectAtIndex:0];
        self.viewReorderDashboards.delegate = self;
        
        [self addSubview:self.viewReorderDashboards];
    }
    
    self.viewReorderDashboards.hidden = NO;
    [self bringSubviewToFront:self.viewReorderDashboards];
    
    self.viewReorderDashboards.frame = CGRectMake(self.tvDashboards.frame.origin.x,
                                                  self.btnReorderDashboards.frame.origin.y,
                                                  self.tvDashboards.frame.size.width,
                                                  (self.frame.size.height - self.btnReorderDashboards.frame.origin.y - 10));
    
    [self.viewReorderDashboards initWithDashboards:[SharedMembers sharedInstance].aryCollections];
}

- (IBAction)onChangedKeyword:(id)sender
{
    [self loadDashboardInfo];
}

- (void) tapCollectionItem:(UITapGestureRecognizer *)gesture
{
    self.selectedCollection = gesture.view.tag;

    [self.tvDashboards reloadData];
}

- (void) onSetting:(UIButton *)button
{
    int tag = (int)button.tag;
    
    int collectionIndex = tag  / 1000;
    int dashboardIndex = tag % 1000;
    
    CollectionInfo *collection = [self.aryCollections objectAtIndex:collectionIndex];
    DashboardInfo *dashboard = [collection.aryDashboards objectAtIndex:dashboardIndex];
    
    [self.delegate editDashboard:dashboard];
}

- (void) _update
{
    [self loadDashboardInfo];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.aryCollections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selectedCollection != section)
        return 0;
    
    CollectionInfo *collection = [self.aryCollections objectAtIndex:section];
    
    return collection.aryDashboards.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return COLLECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CollectionInfo *collection = [self.aryCollections objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tvDashboards.frame), COLLECTION_HEIGHT)];
    view.tag = section;
    view.backgroundColor = [UIColor clearColor];
    
    float iconSize = 12;
    
    UIImageView *ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconSize / 2, (COLLECTION_HEIGHT - iconSize) / 2, iconSize, iconSize)];
    
    if(self.selectedCollection == section)
        ivIcon.image = [UIImage imageNamed:@"analyze_icon_openitem"];
    else
        ivIcon.image = [UIImage imageNamed:@"analyze_icon_closeitem"];
    
    [view addSubview:ivIcon];
    ivIcon = nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, CGRectGetWidth(view.frame) - 30, COLLECTION_HEIGHT)];
    
    if(self.selectedCollection == section)
        label.textColor = SELECT_COLOR;
    else
        label.textColor = DESELECT_COLOR;
    
    label.text = collection.title;
    label.font = [UIFont systemFontOfSize:16.0f];
    
    [view addSubview:label];
    label = nil;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, COLLECTION_HEIGHT , CGRectGetWidth(view.frame), 1)];
    line.backgroundColor = [UIColor colorWithRed:234.0f / 255.0f green:234.0f / 255.0f blue:234.0f / 255.0f alpha:1.0f];
    
    [view addSubview:line];
    line = nil;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCollectionItem:)];
    [view addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    CollectionInfo *collection = [self.aryCollections objectAtIndex:indexPath.section];
    
    DashboardInfo *dashboard = [collection.aryDashboards objectAtIndex:indexPath.row];
    
    DashboardInfo *currentDashboard = [SharedMembers sharedInstance].currentDashboard;
    
    NSString *dashboardTitle = [NSString stringWithFormat:@"  %@", dashboard.title] ;
    
    cell.textLabel.text = dashboardTitle;
    cell.textLabel.textColor = (dashboard == currentDashboard) ? SELECT_COLOR : DESELECT_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    cell.backgroundColor = [UIColor clearColor];
    
    if(dashboard == currentDashboard)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, COLLECTION_HEIGHT, COLLECTION_HEIGHT)];
        button.tag = indexPath.section * 1000 + indexPath.row;
        [button addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
        [button setContentEdgeInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
        [button setImage:[UIImage imageNamed:@"analyze_image_setting"] forState:UIControlStateNormal];
        cell.accessoryView = button;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionInfo *collection = [self.aryCollections objectAtIndex:indexPath.section];
    DashboardInfo *dashboard = [collection.aryDashboards objectAtIndex:indexPath.row];
    
    [[SharedMembers sharedInstance] updateCurrentDashboard:dashboard];
}

#pragma mark -
#pragma mark ReorderDashboardViewDelegate

- (void) onDoneReorderDashboard:(NSMutableArray *)aryUpdatedDashboards
{
    self.viewReorderDashboards.hidden = YES;
    
    NSMutableArray* collections = [[NSMutableArray alloc] init];
    for(CollectionInfo* collection in aryUpdatedDashboards)
    {
        NSMutableArray* dashboards = [[NSMutableArray alloc] init];
        for(DashboardInfo* dashboard in collection.aryDashboards)
            [dashboards addObject:dashboard._id];
        [collections addObject:@{@"dashboards" : dashboards, @"text" : collection.title}];
    }
    [SharedMembers sharedInstance].userInfo.collections = collections;
    [JSWaiter ShowWaiter:[SharedMembers sharedInstance].currentViewController.view title:@"Updating..." type:0];

    [[SharedMembers sharedInstance].userInfo UpdateUserInfo:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [SharedMembers sharedInstance].aryCollections = aryUpdatedDashboards;
        [self _update];
    } failed:nil];
}

- (void) onCancelReorderDashboard
{
    self.viewReorderDashboards.hidden = YES;
}

@end
