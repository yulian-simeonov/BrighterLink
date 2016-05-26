//
//  AddMemberView.m
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddMemberView.h"
#import "SharedMembers.h"
#import "Account.h"
#import "TeamView.h"
#import "AccountDetailView.h"

@implementation AddMemberView

+(AddMemberView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddMemberView" owner:self options:nil];
    AddMemberView* vw = [nib objectAtIndex:0];
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
    
    cmb_role = [[JSCombo alloc] initWithFrame:CGRectMake(txt_role.frame.origin.x, txt_role.frame.origin.y, txt_role.frame.size.width, 100)];
    [vw_content addSubview:cmb_role];
    [cmb_role UpdateData:@[@{@"text" : @"Admin", @"value" : @"Admin"}, @{@"text" : @"Team Member", @"value" : @"TM"}]];
    [cmb_role setSelectedItem:@{@"text" : @"Admin"}];
    [cmb_role setDelegate:self];
    [cmb_role setHidden:YES];
    
    cmb_account = [[JSCombo alloc] initWithFrame:CGRectMake(txt_account.frame.origin.x, txt_account.frame.origin.y, txt_account.frame.size.width, 100)];
    [vw_content addSubview:cmb_account];
    NSMutableArray* accounts = [[NSMutableArray alloc] init];
    for(Account* acnt in [SharedMembers sharedInstance].Accounts)
    {
        if (acnt.sfdcAccountId)
            [accounts addObject:@{@"id" : acnt._id, @"text" : acnt.name, @"sfdcAccountId" : acnt.sfdcAccountId}];
        else
            [accounts addObject:@{@"id" : acnt._id, @"text" : acnt.name}];
    }
    [cmb_account UpdateData:accounts];
    [cmb_account setDelegate:self];
    [cmb_account setHidden:YES];
    [lbl_account setHidden:YES];
    
    [txt_role setText:@"Admin"];
    m_role = @"Admin";
    m_gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouch)];
    m_gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:m_gesture];
}

-(IBAction)OnBack:(id)sender
{
    [self removeGestureRecognizer:m_gesture];
    [self removeFromSuperview];
}

-(IBAction)OnSelectRole:(id)sender
{
    [cmb_role setHidden:NO];
}

-(IBAction)OnSelectAccount:(id)sender
{
    if (m_bFromAccountDetail)
        return;
    [cmb_account setHidden:NO];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    if ([control isEqual:cmb_role])
    {
        [txt_role setText:[obj objectForKey:@"text"]];
        m_role = [obj objectForKey:@"value"];
    }
    else if ([control isEqual:cmb_account])
    {
        [txt_account setText:[obj objectForKey:@"text"]];
        m_selectedAccount = obj;
    }
}

-(void)OnTouch
{
    [cmb_account setHidden:YES];
    [cmb_role setHidden:YES];
}

-(void)SetAccount:(NSDictionary*)account
{
    m_selectedAccount = account;
    m_bFromAccountDetail = YES;
    [lbl_account setText:[account objectForKey:@"text"]];
    [lbl_account setHidden:NO];
    [txt_account setHidden:YES];
}

-(IBAction)OnAdd:(id)sender
{
    if (!m_selectedAccount)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select an account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    UserInfo* user = [[UserInfo alloc] init];
    NSArray* names = [txt_name.text componentsSeparatedByString:@" "];
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
    
    user.name = txt_name.text;
    user.role = m_role;
    user.accounts = @[[m_selectedAccount objectForKey:@"id"]];
    user.phone = txt_phone.text;
    user.email = txt_email.text;
    user.emailUser = [[txt_email.text componentsSeparatedByString:@"@"] objectAtIndex:0];
    user.emailDomain = [[txt_email.text componentsSeparatedByString:@"@"] objectAtIndex:1];
    [SharedMembers ShowGlobalWaiter:@"Creating new user" type:0];
    [user AddUser:[m_selectedAccount objectForKey:@"sfdcAccountId"] success:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [[SharedMembers sharedInstance].Members addObject:user];
        if ([_delegate isKindOfClass:[TeamView class]])
        {
            [((TeamView*)_delegate) ReloadData];
        }
        if ([_delegate isKindOfClass:[AccountDetailView class]])
        {
            [((AccountDetailView*)_delegate) ReloadMembers];
        }
        [self OnBack:nil];
    } failed:nil];
}
@end
