//
//  MemberDetailView.h
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@class TeamView;
@class AccountDetailView;

@interface MemberDetailView : UIView
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIButton* btn_edit;
    IBOutlet UIButton* btn_delete;
    
    IBOutlet UILabel* lbl_name;
    IBOutlet UILabel* lbl_phone;
    IBOutlet UILabel* lbl_email;
    
    UserInfo* m_userInfo;
}
@property (nonatomic, weak) TeamView* teamView;
@property (nonatomic, weak) AccountDetailView* accountDetailView;

+(MemberDetailView*)ShowView:(UIView*)parentView;
-(void)SetUserInfo:(UserInfo*)user;
@end
