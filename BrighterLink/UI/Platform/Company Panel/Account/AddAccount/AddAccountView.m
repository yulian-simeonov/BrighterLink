//
//  AddAccountView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddAccountView.h"
#import "SharedMembers.h"
#import "Account.h"
#import "AccountDetailView.h"
#import "AccountView.h"

@implementation AddAccountView

+(AddAccountView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddAccountView" owner:self options:nil];
    AddAccountView* vw = [nib objectAtIndex:0];
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
    
    btn_verify.layer.borderWidth = 1;
    btn_verify.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    txt_billingAddress.layer.cornerRadius = 3;
    txt_billingAddress.layer.borderWidth = 1;
    txt_billingAddress.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1].CGColor;
    
    txt_shippingAddress.layer.cornerRadius = 3;
    txt_shippingAddress.layer.borderWidth = 1;
    txt_shippingAddress.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1].CGColor;
}

-(void)UpdateWithData:(Account*)account parent:(AccountDetailView*)parent
{
    _delegate = parent;
    m_bEditMode = YES;
    m_account = account;
    [txt_email setText:m_account.email];
    [txt_caption setText:m_account.name];
    [txt_brigherLinkUrl setText:m_account.sfdcAccountURL];
    [txt_contactPhone setText:m_account.phone];
    [txt_website setText:m_account.webSite];
    [txt_customUrl setText:m_account.cname];
    [txt_billingAddress setText:m_account.billingAddress];
    [txt_shippingAddress setText:m_account.shippingAddress];
    
    [lbl_title setText:@"Edit Account"];
    [btn_update setTitle:@"Update Account" forState:UIControlStateNormal];
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)OnVerify:(id)sender
{
    if (txt_customUrl.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input the custom url" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    [JSWaiter ShowWaiter:self title:@"Validating..." type:0];
    [[SharedMembers sharedInstance].webManager VerifyAccountCName:txt_customUrl.text success:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Valid Custom URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } failure:nil];
}

-(IBAction)OnUpdate:(id)sender
{
    if (m_bEditMode)
    {
        m_account.name = txt_caption.text;
        m_account.sfdcAccountURL = txt_brigherLinkUrl.text;
        m_account.cname = txt_customUrl.text;
        m_account.phone = txt_contactPhone.text;
        m_account.email = txt_email.text;
        m_account.webSite = txt_website.text;
        m_account.billingAddress = txt_billingAddress.text;
        m_account.shippingAddress = txt_shippingAddress.text;
        [SharedMembers ShowGlobalWaiter:@"Updating account..." type:0];
        [m_account UpdateAccount:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [self OnBack:nil];
            [_delegate SetAccount:m_account];
            [_accountView Refresh];
        } failed:nil];
    }
    else
    {        
        Account* account = [[Account alloc] init];
        account.name = txt_caption.text;
        account.sfdcAccountURL = txt_brigherLinkUrl.text;
        account.cname = txt_customUrl.text;
        account.phone = txt_contactPhone.text;
        account.email = txt_email.text;
        account.webSite = txt_website.text;
        account.billingAddress = txt_billingAddress.text;
        account.shippingAddress = txt_shippingAddress.text;
        UserInfo* user = [[UserInfo alloc] init];
        NSArray* names = [txt_contactName.text componentsSeparatedByString:@" "];
        if (names.count == 2)
        {
            user.firstName = [names objectAtIndex:0];
            user.lastName = [names objectAtIndex:1];
            user.middleName = @"";
        }
        else if (names.count == 3)
        {
            user.firstName = [names objectAtIndex:0];
            user.middleName = [names objectAtIndex:1];
            user.lastName = [names objectAtIndex:2];
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
        
        user.name = txt_contactName.text;
        user.role = @"Admin";
        user.phone = txt_contactPhone.text;
        user.email = txt_email.text;
        user.emailUser = [[txt_email.text componentsSeparatedByString:@"@"] objectAtIndex:0];
        user.emailDomain = [[txt_email.text componentsSeparatedByString:@"@"] objectAtIndex:1];
        
        [SharedMembers ShowGlobalWaiter:@"Creating new account..." type:0];
        [account AddNewAccount:user success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [[SharedMembers sharedInstance].Accounts addObject:account];
            [[SharedMembers sharedInstance].webManager GetMembers:^(MKNetworkOperation *networkOperation) {
                NSArray* members = [networkOperation.responseJSON objectForKey:@"message"];
                [[SharedMembers sharedInstance].Members removeAllObjects];
                for(NSDictionary* member in members)
                {
                    UserInfo* user = [[UserInfo alloc] init];
                    [user setDictionary:member];
                    [[SharedMembers sharedInstance].Members addObject:user];
                }
                [self OnBack:nil];
                [_accountView Refresh];
            } failure:nil];
        } failed:nil];
    }
}
@end
