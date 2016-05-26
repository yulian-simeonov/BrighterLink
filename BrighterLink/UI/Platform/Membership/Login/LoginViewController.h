//
//  LoginViewController.h
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UILabel* lbl_forgetPassword;
    IBOutlet UIView* vw_login;
    IBOutlet UIView* vw_forgetPassword;
    IBOutlet UITextField* txt_email;
    BOOL    m_bLoginView;
}
@end
