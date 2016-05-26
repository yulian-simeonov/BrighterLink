//
//  AddMemberView.m
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EditMemberView.h"
#import "SharedMembers.h"
#import "Account.h"

@implementation EditMemberView

+(EditMemberView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EditMemberView" owner:self options:nil];
    EditMemberView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    btn_update.layer.borderWidth = 1;
    btn_update.layer.borderColor = btn_update.titleLabel.textColor.CGColor;
    
    btn_cancel.layer.borderWidth = 1;
    btn_cancel.layer.borderColor = btn_cancel.titleLabel.textColor.CGColor;
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(void)UpdateWithData:(MemberDetailView*)parent member:(UserInfo*)userInfo
{
    m_parent = parent;
    m_userInfo = userInfo;
    
    [lbl_role setText:userInfo.role];
    NSString* accountName = nil;
    for(Account* acnt in [SharedMembers sharedInstance].Accounts)
    {
        if ([userInfo.accounts containsObject:acnt._id])
        {
            accountName = acnt.name;
            break;
        }
    }
    
    if (accountName)
        [lbl_account setText:accountName];
    
    [txt_name setText:userInfo.name];
    [txt_email setText:userInfo.email];
    [txt_phone setText:userInfo.phone];
}

-(IBAction)OnUpdate:(id)sender
{
    NSArray* names = [txt_name.text componentsSeparatedByString:@" "];
    if (names.count == 2)
    {
        m_userInfo.firstName = [names objectAtIndex:0];
        m_userInfo.lastName = [names objectAtIndex:1];
        m_userInfo.middleName = @"";
    }
    else if (names.count == 3)
    {
        m_userInfo.firstName = [names objectAtIndex:0];
        m_userInfo.middleName = [names objectAtIndex:1];
        m_userInfo.lastName = [names objectAtIndex:2];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Username format is wrong. it should be 'FirstName [MiddleName] LastName'" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
        return;
    }
    
    if (![SharedMembers validateEmailWithString:txt_email.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid Email format" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    m_userInfo.name = txt_name.text;
    m_userInfo.email = txt_email.text;
    m_userInfo.emailUser = [[txt_email.text componentsSeparatedByString:@"@"] objectAtIndex:0];
    m_userInfo.emailDomain = [[txt_email.text componentsSeparatedByString:@"@"] objectAtIndex:1];
    m_userInfo.phone = txt_phone.text;
    [SharedMembers ShowGlobalWaiter:@"Updating..." type:0];
    [m_userInfo UpdateUserInfo:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [m_parent SetUserInfo:m_userInfo];
        [self OnBack:nil];
    } failed:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
}
@end
