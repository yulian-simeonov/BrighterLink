//
//  AddMemberView.h
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDetailView.h"

@interface EditMemberView : UIView
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIButton* btn_update;
    IBOutlet UIButton* btn_cancel;
    
    IBOutlet UILabel* lbl_role;
    IBOutlet UILabel* lbl_account;
    IBOutlet UITextField* txt_name;
    IBOutlet UITextField* txt_email;
    IBOutlet UITextField* txt_phone;
    MemberDetailView* m_parent;
    UserInfo* m_userInfo;
}
+(EditMemberView*)ShowView:(UIView*)parentView;
-(void)UpdateWithData:(MemberDetailView*)parent member:(UserInfo*)userInfo;
@end
