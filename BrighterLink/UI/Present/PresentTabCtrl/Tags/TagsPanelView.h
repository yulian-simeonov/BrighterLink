//
//  TagsPanelView.h
//  BrighterLink
//
//  Created by mobile on 11/28/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceTreeCell.h"
#import "JSTreeNode.h"

@interface TagsPanelView : UIView<DataSourceTreeCellDelegate>
{
    IBOutlet UITextField* txt_search;
    IBOutlet UITableView* tbl_tree;
    IBOutlet UIScrollView* scvw_tree;
    JSTreeNode* m_treeNode;
    NSMutableArray* m_facilities;
    NSMutableArray* m_scopes;
    NSMutableArray* m_nodes;
    NSMutableArray* m_metrics;
    NSMutableArray* m_filteredTags;
}
@property (nonatomic, strong) UserInfo* userInfo;
+(TagsPanelView*)ShowView:(UIView*)parentView;
@end
