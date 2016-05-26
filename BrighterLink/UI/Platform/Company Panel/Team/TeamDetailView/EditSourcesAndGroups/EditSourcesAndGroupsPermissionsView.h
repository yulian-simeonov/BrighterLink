//
//  EditSourcesAndGroupsPermissionsView.h
//  BrighterLink
//
//  Created by mobile master on 11/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceTreeCell.h"
#import "JSTreeNode.h"
#import "UserInfo.h"

@interface EditSourcesAndGroupsPermissionsView : UIView<DataSourceTreeCellDelegate>
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIImageView* img_searchBar;
    IBOutlet UITextField* txt_search;
    IBOutlet UIView* vw_treeContainer;
    IBOutlet UITableView* tbl_tree;
    JSTreeNode* m_treeNode;
}
@property (nonatomic, strong) UserInfo* userInfo;
+(EditSourcesAndGroupsPermissionsView*)ShowView:(UIView*)parentView;

@end
