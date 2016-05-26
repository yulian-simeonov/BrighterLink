//
//  AddMemberView.h
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "UserInfo.h"

@interface AddMemberView : UIView<JSComboDelegate>
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIButton* btn_update;
    IBOutlet UIButton* btn_cancel;
    IBOutlet UITextField* txt_role;
    IBOutlet UITextField* txt_account;
    IBOutlet UITextField* txt_name;
    IBOutlet UITextField* txt_phone;
    IBOutlet UITextField* txt_email;
    IBOutlet UILabel* lbl_account;
    NSDictionary* m_selectedAccount;
    IBOutlet UIScrollView* vw_content;
    JSCombo* cmb_role;
    JSCombo* cmb_account;
    UITapGestureRecognizer* m_gesture;
    BOOL m_bFromAccountDetail;
    NSString* m_role;
}
@property (nonatomic, weak) id delegate;
+(AddMemberView*)ShowView:(UIView*)parentView;
-(void)SetAccount:(NSDictionary*)account;
@end
