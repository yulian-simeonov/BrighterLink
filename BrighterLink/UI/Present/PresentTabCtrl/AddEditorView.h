//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWaiter.h"
#import "WebManager.h"
#import "EditorInfo.h"
#import "DataSourceTreeCell.h"
#import "JSTreeNode.h"




@interface AddEditorView : UIView<DataSourceTreeCellDelegate>
{

    NSString * userId;
    NSString * presentationId;
    
    IBOutlet UITableView* tbl_tree;
    IBOutlet UIScrollView* scvw_tree;
    JSTreeNode* m_treeNode;
    NSMutableArray* m_facilities;
    NSMutableArray* m_scopes;
    NSMutableArray* m_nodes;
    NSMutableArray* m_metrics;
    NSMutableArray* m_filteredTags;
    

    int     m_Idx;
    NSString * pictureUrl;
}

@property (nonatomic, strong) UserInfo* userInfo;

@property (nonatomic, weak)  IBOutlet UIView * tempView;


@property ( nonatomic, weak ) IBOutlet UIImageView * imgProfile;
@property ( nonatomic, weak ) IBOutlet UITextView * txtTitle;
@property ( nonatomic, weak ) IBOutlet UITextView * txtTitle1;
@property ( nonatomic, weak ) IBOutlet UILabel    * lName;
@property ( nonatomic, weak ) IBOutlet UILabel    * lEmail;

@property ( nonatomic, weak ) IBOutlet UIActivityIndicatorView * waiter;

- (void) setInfo :(NSString*) UserId Email:(NSString*) email Name:(NSString*) name Index:(int) idx picture:(NSString*) imgUrl;
- (IBAction) onConfirm:(id)sender;
- (IBAction) onCancel:(id)sender;


@end
