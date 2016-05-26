//
//  AddSourceAndGroupView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddSourceAndGroupView.h"

#import "DataSourceTreeCell.h"

#import "Tag.h"
#import "SharedMembers.h"

#import "JSTreeNode.h"

@interface AddSourceAndGroupView()<DataSourceTreeCellDelegate>
{

}

@property (nonatomic, assign) IBOutlet UIView *mainView;

@property (nonatomic, assign) IBOutlet UIView *viewSearchDataSource;
@property (nonatomic, assign) IBOutlet UIView *viewSegmentName;

@property (nonatomic, assign) IBOutlet UIView *viewComment;

@property (nonatomic, assign) IBOutlet UIButton *btnDelete;
@property (nonatomic, assign) IBOutlet UIButton *btnApply;
@property (nonatomic, assign) IBOutlet UIButton *btnCancel;

@property (nonatomic, assign) IBOutlet UITextField *txtSearchDataSource;
@property (nonatomic, assign) IBOutlet UITextField *txtSegmentName;

@property (nonatomic, assign) IBOutlet UITableView* tvTags;

@property (nonatomic, retain) JSTreeNode* treeNode;


@end

@implementation AddSourceAndGroupView

- (void) awakeFromNib
{
    [self loadData];
    
    [self initView];
}

- (void) initView
{
    self.mainView.layer.borderColor = [UIColor colorWithRed:147.0f / 255.0f green:147.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f].CGColor;
    self.mainView.layer.borderWidth = 1.0f;
    self.mainView.layer.cornerRadius = 5.0f;
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainView.layer.shadowOpacity = 0.5f;
    self.mainView.layer.shadowRadius = 3.0f;
    self.mainView.layer.shadowOffset = CGSizeMake(-3, 3);
    
    self.viewSearchDataSource.backgroundColor = [UIColor whiteColor];
    self.viewSearchDataSource.layer.cornerRadius = 3;
    self.viewSearchDataSource.layer.borderColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f blue:235.0f / 255.0f alpha:1.0f].CGColor;
    self.viewSearchDataSource.layer.borderWidth = 1;
    
    self.viewSegmentName.backgroundColor = [UIColor whiteColor];
    self.viewSegmentName.layer.cornerRadius = 3;
    self.viewSegmentName.layer.borderColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f blue:235.0f / 255.0f alpha:1.0f].CGColor;
    self.viewSegmentName.layer.borderWidth = 1;
    
    self.viewComment.layer.borderColor = [UIColor colorWithRed:235.0f / 255.0f green:235.0f / 255.0f blue:235.0f / 255.0f alpha:1.0f].CGColor;
    self.viewComment.layer.borderWidth = 1;
    
    self.btnDelete.layer.cornerRadius = 3;
    self.btnDelete.layer.borderColor = [UIColor colorWithRed:25.0f / 255.0f green:171.0f / 255.0f blue:95.0f / 255.0f alpha:1.0f].CGColor;
    self.btnDelete.layer.borderWidth = 1;
    
    self.btnApply.layer.cornerRadius = 3;
    self.btnApply.layer.borderColor = [UIColor colorWithRed:25.0f / 255.0f green:171.0f / 255.0f blue:95.0f / 255.0f alpha:1.0f].CGColor;
    self.btnApply.layer.borderWidth = 1;
    
    self.btnCancel.layer.cornerRadius = 3;
    self.btnCancel.layer.borderColor = [UIColor colorWithRed:25.0f / 255.0f green:171.0f / 255.0f blue:95.0f / 255.0f alpha:1.0f].CGColor;
    self.btnCancel.layer.borderWidth = 1;
}

- (void) layoutSubviews
{
    float gap = 10;
    float width = self.btnApply.frame.size.width;
    
    if(self.segment)
    {
        self.txtSegmentName.text = self.segment.name;
        
        self.btnDelete.hidden = NO;
        
        self.btnDelete.center = CGPointMake(self.mainView.frame.size.width / 2 - (width + gap), self.btnDelete.center.y);
        self.btnApply.center = CGPointMake(self.mainView.frame.size.width / 2, self.btnApply.center.y);
        self.btnCancel.center = CGPointMake(self.mainView.frame.size.width / 2 + (width + gap), self.btnCancel.center.y);
    }
    else
    {
        self.btnDelete.hidden = YES;
        
        self.btnApply.center = CGPointMake(self.mainView.frame.size.width / 2 - (width / 2 + gap), self.btnApply.center.y);
        self.btnCancel.center = CGPointMake(self.mainView.frame.size.width / 2 + (width / 2 + gap), self.btnCancel.center.y);
    }
    
    [self updateData];
}

- (void)loadData
{
    self.treeNode = [[JSTreeNode alloc] initWithValue:@"Root"];
    self.treeNode.inclusive = YES;
    for(Tag* tg in [SharedMembers sharedInstance].RootTags)
    {
        [self AddTreeNode:tg parentNode:self.treeNode];
    }
}

- (void) updateData
{
    [self updateTreeNode:self.treeNode];
}

- (IBAction) onDelete:(id)sender
{
    if(self.segment)
    {
        [self.delegate deleteSegment:self.segment];
    }
    
    [self removeFromSuperview];
}

- (IBAction)onApply:(id)sender
{
    NSArray *arySelectedTags = [self getSelectedTags:self.treeNode];
    NSArray *aryFormattedTags = [self getFormattedTags:arySelectedTags];
    
    if(arySelectedTags.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have to select at least one tag for segment." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return;
    }
    
    NSString *name = self.txtSegmentName.text;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(name.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input a valid name for segment." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return;
    }
    
    SegmentInfo *segment = [[SegmentInfo alloc] initWithId:nil name:name tags:aryFormattedTags];
    
    if(self.segment == nil)
    {
        [self.delegate addNewSegment:segment];
    }
    else
    {
        segment._id = self.segment._id;
        
        [self.delegate updateSegment:segment];
    }
    
    [self removeFromSuperview];
}

- (IBAction)onCancel:(id)sender
{
    [self removeFromSuperview];
}

- (NSArray *) getSelectedTags:(JSTreeNode *)treeNode
{
    NSArray *arySelectedTags = [[NSArray alloc] init];
    
    for (JSTreeNode *childTreeNode in treeNode.children) {
        
        if(childTreeNode.selected)
        {
            arySelectedTags = [arySelectedTags arrayByAddingObject:childTreeNode];
        }
        else
        {
            NSArray *aryChildSelectedTags = [self getSelectedTags:childTreeNode];
            
            arySelectedTags = [arySelectedTags arrayByAddingObjectsFromArray:aryChildSelectedTags];
        }
    }
    
    return arySelectedTags;
}

- (NSArray *) getFormattedTags:(NSArray *)aryTags
{
    NSArray *aryFormattedTags = [[NSArray alloc] init];
    
    for (JSTreeNode *treeNode in aryTags) {
        
        id value = treeNode.value;
        
        if([value isKindOfClass:[Tag class]] && value != nil)
        {
            Tag *tag = (Tag *)value;
            
            NSDictionary *dictionary = @{@"tagType" : tag.tagType,
                                         @"id" : tag._id};
            
            aryFormattedTags = [aryFormattedTags arrayByAddingObject:dictionary];
        }
    }
    
    return aryFormattedTags;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.treeNode descendantCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSTreeNode *node = [[self.treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    DataSourceTreeCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", (int)indexPath.row]];
    if (!cell)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DataSourceTreeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell SetData:node.value level:((int)[node levelDepth] - 1) expanded:node.inclusive selected:node.selected];
        [cell setDelegaate:self];
    }
    return cell;
}

#pragma mark DataSourceTreeCellDelegate

-(void)OnExpand:(UITableViewCell*)cell object:(id)object
{
    NSIndexPath* indexPath = [self.tvTags indexPathForCell:cell];
    JSTreeNode *node = [[self.treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    if (!node.hasChildren) return;
    
    node.inclusive = YES;
    [self.treeNode flattenElementsWithCacheRefresh:YES];
    for(JSTreeNode* nd in node.children)
    {
        if ([nd.value isKindOfClass:[Tag class]])
        {
        }
    }
    
    [self.tvTags reloadData];
}

-(void)OnCollaps:(UITableViewCell*)cell object:(id)object
{
    NSIndexPath* indexPath = [self.tvTags indexPathForCell:cell];
    JSTreeNode *node = [[self.treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    if (!node.hasChildren) return;
    
    node.inclusive = NO;
    [self.treeNode flattenElementsWithCacheRefresh:YES];
    [self.tvTags reloadData];
}

-(void)OnSelect:(UITableViewCell*)cell object:(id)object
{
    NSIndexPath* indexPath = [self.tvTags indexPathForCell:cell];
    JSTreeNode *node = [[self.treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    
    [self updateSelectedStateWithTreeNode:node state:!node.selected];
}

- (void) updateSelectedStateWithTreeNode:(JSTreeNode *)node state:(BOOL)isSelected
{
    [node SelectChildren:isSelected];
    [node UpdateParent];
    [self.treeNode flattenElementsWithCacheRefresh:YES];
    [self.tvTags reloadData];
}

-(void)AddTreeNode:(Tag*)tag parentNode:(JSTreeNode*)parentNode
{
    JSTreeNode* node = [[JSTreeNode alloc] initWithValue:tag];
    node.selected = [self hasTagOnOriginalSegment:tag];
    [parentNode addChild:node];
    for(Tag* tg in tag.childrenTags)
    {
        [self AddTreeNode:tg parentNode:node];
    }
}

- (void) updateTreeNode:(JSTreeNode *)parentNode
{
    for (JSTreeNode *childNode in parentNode.children) {
        
        id value = childNode.value;
        
        if([value isKindOfClass:[Tag class]] && [self hasTagOnOriginalSegment:value])
        {
            [self updateSelectedStateWithTreeNode:childNode state:YES];
        }
        else
        {
            [self updateTreeNode:childNode];
        }
    }
}

- (BOOL) hasTagOnOriginalSegment:(Tag *)tag
{
    if(self.segment == nil) return NO;
    
    for(NSDictionary *bindingTag in self.segment.tagBindings)
    {
        NSString *bindingTagId = [bindingTag objectForKey:@"id"];
        
        if([bindingTagId isEqualToString:tag._id])
        {
            return YES;
        }
    }
    
    return NO;
}
@end
