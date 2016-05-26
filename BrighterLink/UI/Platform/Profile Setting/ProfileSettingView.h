//
//  ProfileSettingView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "SharedMembers.h"

@interface ProfileSettingView : UIView<UITextFieldDelegate>
{
    IBOutlet UIButton* btn_update;
    IBOutlet UIButton* btn_cancel;
    IBOutlet UITextField* txt_username;
    IBOutlet UILabel* lbl_role;
    IBOutlet UITextField* txt_email;
    IBOutlet UITextField* txt_phoneNumber;
    IBOutlet UITextField* txt_password;
    IBOutlet UITextField* txt_confirmPassword;
    IBOutlet UIButton* btn_avatar;
}
@property (nonatomic, strong) UIGestureRecognizer* tapGesture;
+(ProfileSettingView*)ShowProfileView:(UIView*)parentView;
-(void)Initialize;
-(void)Refresh;
@end
