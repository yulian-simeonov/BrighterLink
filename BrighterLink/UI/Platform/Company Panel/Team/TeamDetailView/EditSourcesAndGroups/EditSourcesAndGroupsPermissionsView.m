//
//  EditSourcesAndGroupsPermissionsView.m
//  BrighterLink
//
//  Created by mobile master on 11/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EditSourcesAndGroupsPermissionsView.h"
#import "DataSourceTreeCell.h"
#import "Tag.h"
#import "SharedMembers.h"

@interface EditSourcesAndGroupsPermissionsView ()

@end

@implementation EditSourcesAndGroupsPermissionsView

+(EditSourcesAndGroupsPermissionsView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EditSourcesAndGroupsPermissionsView" owner:self options:nil];
    EditSourcesAndGroupsPermissionsView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    img_searchBar.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1].CGColor;
    img_searchBar.layer.borderWidth = 1;
    img_searchBar.layer.cornerRadius = 4;
    m_treeNode = [[JSTreeNode alloc] initWithValue:@"Root"];
    m_treeNode.inclusive = YES;
    for(Tag* tg in [SharedMembers sharedInstance].RootTags)
    {
        [self AddTreeNode:tg parentNode:m_treeNode];
    }
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_treeNode descendantCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    DataSourceTreeCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DataSourceTreeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell SetData:node.value level:[node levelDepth] - 1 expanded:node.inclusive selected:node.selected];
        [cell setDelegaate:self];
    }
    return cell;
}

-(void)OnExpand:(UITableViewCell*)cell object:(id)object
{
    NSIndexPath* indexPath = [tbl_tree indexPathForCell:cell];
    JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    if (!node.hasChildren) return;
    
    node.inclusive = YES;
    [m_treeNode flattenElementsWithCacheRefresh:YES];
    for(JSTreeNode* nd in node.children)
    {
        if ([nd.value isKindOfClass:[Tag class]])
        {
            if ([self IsAccessableTag:nd.value])
            {
                [nd SelectChildren:YES];
            }
        }
    }
    [tbl_tree reloadData];
}

-(void)OnCollaps:(UITableViewCell*)cell object:(id)object
{
    NSIndexPath* indexPath = [tbl_tree indexPathForCell:cell];
    JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    if (!node.hasChildren) return;
    
    node.inclusive = NO;
    [m_treeNode flattenElementsWithCacheRefresh:YES];
    [tbl_tree reloadData];
}

-(void)OnSelect:(UITableViewCell*)cell object:(id)object
{
    NSIndexPath* indexPath = [tbl_tree indexPathForCell:cell];
    JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    Tag* tg = node.value;
    tg.selected = !tg->m_selected;
    [tg UpdateParent];
    [[SharedMembers sharedInstance].webManager UpdateAccessibleTag:[self GetAccessibleTags] userID:_userInfo._id success:^(MKNetworkOperation *networkOperation) {
        [_userInfo setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
        [node SelectChildren:!node.selected];
        [node UpdateParent];
        [m_treeNode flattenElementsWithCacheRefresh:YES];
        [tbl_tree reloadData];
    } failure:nil];
}

-(NSArray*)GetAccessibleTags
{
    NSMutableArray* accessibleTags = [[NSMutableArray alloc] init];
    for(Tag* tg in [SharedMembers sharedInstance].RootTags)
    {
        [self AddAccessibleTag:accessibleTags tag:tg];
    }
    return accessibleTags;
}

-(void)AddAccessibleTag:(NSMutableArray*)tags tag:(Tag*)tg
{
    if (tg->m_selected)
        [tags addObject:@{@"id" : tg._id, @"tagType" : tg.tagType}];
    else
    {
        for(Tag* item in tg.childrenTags)
            [self AddAccessibleTag:tags tag:item];
    }
}

-(void)AddTreeNode:(Tag*)tag parentNode:(JSTreeNode*)parentNode
{
    if ([self IsAccessableTag:tag])
    {
        [tag setSelected:YES];
        [tag UpdateParent];
    }
    
    JSTreeNode* node = [[JSTreeNode alloc] initWithValue:tag];
    [parentNode addChild:node];
    for(Tag* tg in tag.childrenTags)
    {
        [self AddTreeNode:tg parentNode:node];
    }
}

-(void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    for(JSTreeNode* node in m_treeNode.flattenElements)
    {
        if ([node.value isKindOfClass:[Tag class]])
        {
            if ([self IsAccessableTag:node.value])
            {
                [node SelectChildren:YES];
            }
        }
    }
    [tbl_tree reloadData];
}

-(BOOL)IsAccessableTag:(Tag*)tag
{
    for(NSDictionary* dic in _userInfo.accessibleTags)
    {
        if ([[dic objectForKey:@"id"] isEqualToString:tag._id])
        {
            return YES;
        }
    }
    return NO;
}

@end
