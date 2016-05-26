//
//  TeamView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamView : UIView
{
    IBOutlet UITableView* tbl_members;
    IBOutlet UIButton* btn_addMember;
    IBOutlet UIImageView* img_searchBar;
    IBOutlet UITextField* txt_search;
    NSMutableArray* m_filteredMembers;
}
+(UIView*)ShowView:(UIView*)parentView;
-(void)SelectedTeam:(id)teamId;
-(void)ReloadData;
@end
