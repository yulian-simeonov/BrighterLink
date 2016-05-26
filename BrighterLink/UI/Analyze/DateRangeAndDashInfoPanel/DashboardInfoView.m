//
//  DashboardInfoView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DashboardInfoView.h"

#import "SharedMembers.h"

@interface DashboardInfoView()

@property (nonatomic, assign) IBOutlet UIView *viewMain;

@property (nonatomic, assign) IBOutlet UIImageView *ivBack;

@property (nonatomic, assign) IBOutlet UIButton *btnCreateDashboard;

@property (nonatomic, assign) IBOutlet UITableView *tvDashboards;

@property (nonatomic, retain) CollectionInfo *collection;

@end

@implementation DashboardInfoView

- (void) awakeFromNib
{
    [self initView];
    
    [self initDatas];
}

- (void) initView
{
    self.viewMain.layer.borderColor = [UIColor colorWithRed:147.0f / 255.0f green:147.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f].CGColor;
    self.viewMain.layer.borderWidth = 1.0f;
    self.viewMain.layer.cornerRadius = 5.0f;
    self.viewMain.backgroundColor = [UIColor whiteColor];
    self.viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewMain.layer.shadowOpacity = 0.5f;
    self.viewMain.layer.shadowRadius = 3.0f;
    self.viewMain.layer.shadowOffset = CGSizeMake(-3, 3);
    
    self.btnCreateDashboard.layer.cornerRadius = 3.0f;
    self.btnCreateDashboard.layer.borderColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f blue:235.0f / 255.0f alpha:1.0f].CGColor;
    self.btnCreateDashboard.layer.borderWidth = 1;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    [self.ivBack addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

- (void) initDatas
{
    DashboardInfo *currentDashboard = [SharedMembers sharedInstance].currentDashboard;
    
    for (CollectionInfo *collection in [SharedMembers sharedInstance].aryCollections) {
        
        if([collection.title isEqualToString:currentDashboard.collectionName])
        {
            self.collection = collection;
            
            break;
        }
    }
    
    [self.tvDashboards reloadData];
}

- (IBAction)onCreateDashboard:(id)sender
{
    [self.delegate createNewDashboardWithCollection:self.collection];
    
    [self removeFromSuperview];
}

- (void) tapBack
{
    [self removeFromSuperview];;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.collection.aryDashboards.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        imageIcon.tag = 1000;
        imageIcon.image = [UIImage imageNamed:@"analyze_dashboard_icon_arrow"];
        imageIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell.contentView addSubview:imageIcon];
        imageIcon = nil;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.tvDashboards.frame.size.width - 30, 40)];
        label.tag = 1001;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        [cell.contentView addSubview:label];
        label = nil;
    }
    
    DashboardInfo *dashboard = [self.collection.aryDashboards objectAtIndex:indexPath.row];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1001];
    label.text = dashboard.title;
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1000];
    
    if(dashboard == [SharedMembers sharedInstance].currentDashboard)
    {
        imageView.hidden = NO;
        label.textColor = [UIColor colorWithRed:90.0f / 255.0f green:37.0f / 255.0f blue:89.0f / 255.0f alpha:1.0f];
    }
    else
    {
        imageView.hidden = YES;
        label.textColor = [UIColor colorWithRed:43.0f / 255.0f green:153.0f / 255.0f blue:216.0f / 255.0f alpha:1.0f];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DashboardInfo *dashboard = [self.collection.aryDashboards objectAtIndex:indexPath.row];
    
    [[SharedMembers sharedInstance] updateCurrentDashboard:dashboard];
    
    [self.tvDashboards reloadData];
}


@end
