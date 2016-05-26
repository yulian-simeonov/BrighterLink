//
//  AccountDetailView.h
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@class AccountView;
@interface AccountDetailView : UIView
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIButton* btn_edit;
    IBOutlet UIButton* btn_createMember;
    IBOutlet UITableView* tbl_members;
    IBOutlet UILabel* lbl_teamMembers;
    Account* m_account;
    NSMutableArray* m_members;
    
    IBOutlet UILabel* lbl_name;
    IBOutlet UILabel* lbl_phone;
    IBOutlet UILabel* lbl_customUrl;
    IBOutlet UILabel* lbl_email;
    IBOutlet UILabel* lbl_website;
    IBOutlet UILabel* lbl_billingAddr;
    IBOutlet UILabel* lbl_shippingAddr;
}

@property (nonatomic, weak) AccountView* accountView;

+(AccountDetailView*)ShowView:(UIView*)parentView;
-(void)SelectedTeam:(id)teamId;
-(void)SetAccount:(Account*)account;
-(void)ReloadMembers;
@end
