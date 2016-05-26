//
//  TagsPanelView.m
//  BrighterLink
//
//  Created by mobile on 11/28/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TagsPanelView.h"
#import "DataSourceTreeCell.h"
#import "Tag.h"
#import "SharedMembers.h"
#import "TagCell.h"

@implementation TagsPanelView

+(TagsPanelView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TagsPanelView" owner:self options:nil];
    TagsPanelView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    txt_search.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1].CGColor;
    m_treeNode = [[JSTreeNode alloc] initWithValue:@"Root"];
    m_treeNode.inclusive = YES;
    [scvw_tree setFrame:CGRectMake(scvw_tree.frame.origin.x, scvw_tree.frame.origin.y, scvw_tree.frame.size.width, scvw_tree.frame.size.height)];
    m_facilities = [[NSMutableArray alloc] init];
    m_scopes = [[NSMutableArray alloc] init];
    m_nodes = [[NSMutableArray alloc] init];
    m_metrics = [[NSMutableArray alloc] init];
    
    m_filteredTags = [[NSMutableArray alloc] init];
    
    [self ReloadTags];
}

-(void)ReloadTags
{
    [m_treeNode.children removeAllObjects];
    for(Tag* tg in [SharedMembers sharedInstance].RootTags)
    {
        [self AddTreeNode:tg parentNode:m_treeNode];
    }
    [self setUserInfo:[SharedMembers sharedInstance].userInfo];
    [tbl_tree reloadData];
}

-(void)AddTreeNode:(Tag*)tag parentNode:(JSTreeNode*)parentNode
{
    if ([tag.tagType isEqualToString:@"Facility"])
        [m_facilities addObject:tag];
    else if ([tag.tagType isEqualToString:@"Scope"])
        [m_scopes addObject:tag];
    else if ([tag.tagType isEqualToString:@"Node"])
        [m_nodes addObject:tag];
    else if ([tag.tagType isEqualToString:@"Metric"])
        [m_metrics addObject:tag];
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
    for(NSDictionary* dic in [SharedMembers sharedInstance].userInfo.accessibleTags)
    {
        if ([[dic objectForKey:@"id"] isEqualToString:tag._id])
        {
            return YES;
        }
    }
    return NO;
}

-(void)ResizeTableSize
{
    float maxWidth = 190;
    if (txt_search.text.length > 0)
    {
        for(Tag* tg in m_filteredTags)
        {
            UILabel* lbl = [[UILabel alloc] init];
            [lbl setFont:[UIFont systemFontOfSize:15]];
            [lbl setText:tg.name];
            CGSize size = [lbl sizeThatFits:CGSizeMake(999999, 30)];
            float totalWidth = size.width + 30;
            if (maxWidth < totalWidth)
                maxWidth = totalWidth;
        }
    }
    else
    {
        for(int i = 1; i <= [m_treeNode descendantCount]; i++)
        {
            JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:i];
            UILabel* lbl = [[UILabel alloc] init];
            [lbl setFont:[UIFont systemFontOfSize:16 - node.levelDepth]];
            [lbl setText:((Tag*)node.value).name];
            float left = 20 * (node.levelDepth - 1);
            CGSize size = [lbl sizeThatFits:CGSizeMake(999999, 30)];
            float totalWidth = left + size.width + 60;
            if (maxWidth < totalWidth)
                maxWidth = totalWidth;
        }
    }
    [tbl_tree setFrame:CGRectMake(tbl_tree.frame.origin.x, tbl_tree.frame.origin.y, maxWidth, tbl_tree.frame.size.height)];
    [scvw_tree setContentSize:tbl_tree.frame.size];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self ResizeTableSize];
    if (txt_search.text.length > 0)
        return m_filteredTags.count;
    else
        return [m_treeNode descendantCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (txt_search.text.length > 0)
    {
        TagCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"list_cell_%d", indexPath.row]];
        if (!cell)
        {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TagCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            Tag* tg = [m_filteredTags objectAtIndex:indexPath.row];
            [cell SetData:tg selected:tg->m_selected cellWidth:tableView.frame.size.width];
            [cell setDelegaate:self];
        }
        return cell;
    }
    else
    {
        JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:indexPath.row + 1];
        DataSourceTreeCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
        if (!cell)
        {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DataSourceTreeCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
            [cell SetDataForPresent:node.value level:[node levelDepth] - 1 expanded:node.inclusive selected:node.selected cellWidth:tableView.frame.size.width];
            [cell setDelegaate:self];
        }
        return cell;
    }
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
    if (txt_search.text.length > 0)
    {
        NSIndexPath* indexPath = [tbl_tree indexPathForCell:cell];
        Tag* tg = [m_filteredTags objectAtIndex:indexPath.row];
        tg.selected = !tg->m_selected;
        [tg UpdateParent];
        [[SharedMembers sharedInstance].webManager UpdateAccessibleTag:[self GetAccessibleTags] userID:_userInfo._id success:^(MKNetworkOperation *networkOperation) {
            [_userInfo setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
            for (int i = 1; i < [m_treeNode flattenElements].count; i++)
            {
                JSTreeNode* node = [[m_treeNode flattenElements] objectAtIndex:i];
                if ([((Tag*)node.value)._id isEqualToString:tg._id])
                {
                    [node SelectChildren:!node.selected];
                    [node UpdateParent];
                    [m_treeNode flattenElementsWithCacheRefresh:YES];
                    break;
                }
            }
            [tbl_tree reloadData];
        } failure:nil];
    }
    else
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

-(IBAction)OnTextChanged:(UITextField*)sender
{
    [m_filteredTags removeAllObjects];
    if (sender.text.length > 0)
    {
        for(Tag* tg in m_facilities)
        {
            if ([tg.name.lowercaseString rangeOfString:sender.text.lowercaseString].length > 0)
                [m_filteredTags addObject:tg];
        }
        for(Tag* tg in m_scopes)
        {
            if ([tg.name.lowercaseString rangeOfString:sender.text.lowercaseString].length > 0)
                [m_filteredTags addObject:tg];
        }
        for(Tag* tg in m_nodes)
        {
            if ([tg.name.lowercaseString rangeOfString:sender.text.lowercaseString].length > 0)
                [m_filteredTags addObject:tg];
        }
        for(Tag* tg in m_metrics)
        {
            if ([tg.name.lowercaseString rangeOfString:sender.text.lowercaseString].length > 0)
                [m_filteredTags addObject:tg];
        }
    }
    [tbl_tree reloadData];
}
@end
