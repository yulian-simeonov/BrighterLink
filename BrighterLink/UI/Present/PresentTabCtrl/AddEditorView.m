//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddEditorView.h"

#import "SharedMembers.h"

#import "SDWebImageManager.h"

@interface AddEditorView()

@end

@implementation AddEditorView


-(void)Initialize
{

    m_treeNode = [[JSTreeNode alloc] initWithValue:@"Root"];
    m_treeNode.inclusive = YES;
    [scvw_tree setFrame:CGRectMake(scvw_tree.frame.origin.x, scvw_tree.frame.origin.y, scvw_tree.frame.size.width, scvw_tree.frame.size.height)];
    m_facilities = [[NSMutableArray alloc] init];
    m_scopes = [[NSMutableArray alloc] init];
    m_nodes = [[NSMutableArray alloc] init];
    m_metrics = [[NSMutableArray alloc] init];
    
    m_filteredTags = [[NSMutableArray alloc] init];
    
//    [tbl_tree setUserInteractionEnabled:false];
    
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
    for(NSDictionary* dic in _userInfo.accessibleTags)
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
    float maxWidth = 556;
//    {
//        for(int i = 1; i <= [m_treeNode descendantCount]; i++)
//        {
//            JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:i];
//            UILabel* lbl = [[UILabel alloc] init];
//            [lbl setFont:[UIFont systemFontOfSize:16 - node.levelDepth]];
//            [lbl setText:((Tag*)node.value).name];
//            float left = 20 * (node.levelDepth - 1);
//            CGSize size = [lbl sizeThatFits:CGSizeMake(999999, 30)];
//            float totalWidth = left + size.width + 60;
//            if (maxWidth < totalWidth)
//                maxWidth = totalWidth;
//        }
//    }
    [tbl_tree setFrame:CGRectMake(tbl_tree.frame.origin.x, tbl_tree.frame.origin.y, maxWidth, tbl_tree.frame.size.height)];
    [scvw_tree setContentSize:tbl_tree.frame.size];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28; //28
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [self ResizeTableSize];
    return [m_treeNode descendantCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    DataSourceTreeCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DataSourceTreeCell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
        
        [cell->img_eye setHidden:true];
    
        [cell SetDataForPresent1:node.value level:[node levelDepth] - 1 expanded:node.inclusive selected:node.selected cellWidth:556];
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
//    NSIndexPath* indexPath = [tbl_tree indexPathForCell:cell];
//    JSTreeNode *node = [[m_treeNode flattenElements] objectAtIndex:indexPath.row + 1];
//    Tag* tg = node.value;
//    if(!node.selected)
//    {
//        [tg AddAccessableTag:_userInfo._id success:^(MKNetworkOperation *networkOperation) {
//            [_userInfo setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
//            [node SelectChildren:!node.selected];
//            [node UpdateParent];
//            [m_treeNode flattenElementsWithCacheRefresh:YES];
//            [tbl_tree reloadData];
//        } failed:nil];
//    }
//    else
//    {
//        [tg RemoveAccessableTag:_userInfo._id success:^(MKNetworkOperation *networkOperation) {
//            [_userInfo setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
//            [node SelectChildren:!node.selected];
//            [node UpdateParent];
//            [m_treeNode flattenElementsWithCacheRefresh:YES];
//            [tbl_tree reloadData];
//        } failed:nil];
//    }
}

-(void)UpdatedParentSelection:(id)node
{
    
}

-(IBAction)OnTextChanged:(UITextField*)sender
{
    
}

- (void) setSubTextColor
{
    
//    _txtTitle.text
    NSString * changeName =  [_txtTitle.text stringByReplacingOccurrencesOfString:@"NAME" withString: _lName.text];
    _txtTitle.text = changeName;
    
   NSString* changeName1 =  [_txtTitle1.text stringByReplacingOccurrencesOfString:@"NAME" withString: _lName.text];
    _txtTitle1.text = changeName1;
    
    
    NSArray *words=[_txtTitle.text componentsSeparatedByString:@" "];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:_txtTitle.text];
    NSArray * arrNames  = [ _lName.text componentsSeparatedByString:@" "];
    
    for ( int i = 0; i < [arrNames count]; i++  ) {
        NSString * str  = [arrNames objectAtIndex:i];
        
        for ( NSString *word in words ) {
            if ([word hasPrefix:str]) {
                NSRange range=[changeName rangeOfString:word];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:128.f/255.f blue:185.f/255.f alpha:1] range:range];
            }
        }
        
    }
    [_txtTitle setAttributedText:string];
    
    
    NSArray *words1=[_txtTitle1.text componentsSeparatedByString:@" "];
    
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:_txtTitle1.text];
    NSArray * arrNames1  = [ _lName.text componentsSeparatedByString:@" "];
    
    for ( int i = 0; i < [arrNames1 count]; i++  ) {
        NSString * str  = [arrNames1 objectAtIndex:i];
        
        for ( NSString *word in words1 ) {
            if ([word hasPrefix:str]) {
                NSRange range=[changeName1 rangeOfString:word];
                [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:128.f/255.f blue:185.f/255.f alpha:1] range:range];
            }
        }
        
    }
    [_txtTitle1 setAttributedText:string1];
    
    
    [_txtTitle setFont:[UIFont systemFontOfSize:16]];
    [_txtTitle1 setFont:[UIFont systemFontOfSize:16]];
}

- (void) setInfo :(NSString*) UserId Email:(NSString*) email Name:(NSString*) name Index:(int) idx picture:(NSString*) imgUrl
{
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    userId = UserId;
    
    presentationId = info._id;
    _lName.text  = name;
    _lEmail.text = email;
    m_Idx  = idx;
    _tempView.layer.cornerRadius = 5.f;

    
    pictureUrl = [NSString stringWithFormat:@"%@%@", @"https://blmobile.brightergy.com", imgUrl];
    
    [_waiter startAnimating];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: pictureUrl] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!image)
            return;
        [_imgProfile setImage:image];

        [_waiter stopAnimating]; [_waiter setHidden: true];
    }];

    
    [self setSubTextColor];
    [self Initialize];
}

- (IBAction) onConfirm:(id)sender
{
    
    EditorInfo * info  = [[SharedMembers sharedInstance].arrEditors objectAtIndex:m_Idx];
    info->m_bAdded  = true;
    info->m_bSelected = false;
    
    [[NSNotificationCenter defaultCenter]         postNotificationName:@"ConfrimEditor"  object:self];
    
    [self removeFromSuperview];
    
    
//    NSDictionary * dic  = @{
//                            @"userId" : userId,
//                            @"presentationId" :  presentationId,
//                            };
//    
//    [[SharedMembers sharedInstance].webManager AddEditors:presentationId param:dic success:^(MKNetworkOperation *networkOperation) {
//        [self removeFromSuperview];
//        
//        [[NSNotificationCenter defaultCenter]         postNotificationName:@"ConfrimEditor"         object:self];
//        
//    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
//        [self removeFromSuperview];
//    }];
}

- (IBAction) onCancel:(id)sender
{
    [self removeFromSuperview];
}

@end
