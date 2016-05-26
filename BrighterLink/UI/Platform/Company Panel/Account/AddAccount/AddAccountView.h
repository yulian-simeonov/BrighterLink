//
//  AddAccountView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@class AccountDetailView;
@class AccountView;
@interface AddAccountView : UIView
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIButton* btn_update;
    IBOutlet UIButton* btn_cancel;
    IBOutlet UIButton* btn_verify;
    IBOutlet UILabel* lbl_title;
    IBOutlet UITextField* txt_caption;
    IBOutlet UITextField* txt_brigherLinkUrl;
    IBOutlet UITextField* txt_customUrl;
    IBOutlet UITextField* txt_contactName;
    IBOutlet UITextField* txt_contactPhone;
    IBOutlet UITextField* txt_email;
    IBOutlet UITextField* txt_website;
    IBOutlet UITextView* txt_billingAddress;
    IBOutlet UITextView* txt_shippingAddress;
    IBOutlet UIScrollView* vw_content;
    
    BOOL m_bEditMode;
    Account* m_account;
}
+(AddAccountView*)ShowView:(UIView*)parentView;
-(void)UpdateWithData:(Account*)account parent:(AccountDetailView*)parent;

@property (nonatomic, weak) AccountDetailView* delegate;
@property (nonatomic, weak) AccountView* accountView;
@end
