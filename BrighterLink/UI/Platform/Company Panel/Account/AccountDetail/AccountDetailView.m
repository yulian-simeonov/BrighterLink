//
//  AccountDetailView.m
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AccountDetailView.h"
#import "TeamViewCell.h"
#import "AddMemberView.h"
#import "MemberDetailView.h"
#import "AddAccountView.h"
#import "UserInfo.h"
#import "SharedMembers.h"

@implementation AccountDetailView

+(AccountDetailView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AccountDetailView" owner:self options:nil];
    AccountDetailView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    btn_edit.layer.borderWidth = 1;
    btn_edit.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    btn_createMember.layer.borderWidth = 1;
    btn_createMember.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    m_members = [[NSMutableArray alloc] init];
    [tbl_members reloadData];
    
    if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
    {
        [btn_createMember setHidden:YES];
        [btn_edit setHidden:YES];
        [lbl_teamMembers setHidden:YES];
        [tbl_members setHidden:YES];
    }
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)OnEdit:(id)sender
{
    AddAccountView* vw = [AddAccountView ShowView:self.superview];
    [vw setAccountView:self.accountView];
    [vw UpdateWithData:m_account parent:self];
}

-(IBAction)OnSaleForce:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:m_account.sfdcAccountURL]];
}

-(IBAction)OnAddMember:(id)sender
{
    AddMemberView* vw = [AddMemberView ShowView:self.superview];
    [vw SetAccount:@{@"id" : m_account._id, @"text" : m_account.name, @"sfdcAccountId" : m_account.sfdcAccountId}];
    [vw setDelegate:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TeamViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setDelegate:self];
        [cell SetUserInfo:[m_members objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)SelectedTeam:(id)userInfo
{
    MemberDetailView* vw = [MemberDetailView ShowView:self.superview];
    [vw setAccountDetailView:self];
    [vw SetUserInfo:userInfo];
}

-(void)SetAccount:(Account*)account
{
    m_account = account;
    [lbl_name setText:account.name];
    [lbl_phone setText:account.phone];
    [lbl_email setText:account.email];
    [lbl_website setText:m_account.webSite];
    [lbl_customUrl setText:[NSString stringWithFormat:@"http://%@.brightergy.com", account.cname]];
    NSMutableString* billingAddr = [[NSMutableString alloc] init];
    for(NSString* item in [account.billingAddress componentsSeparatedByString:@"\n"])
    {
        [billingAddr appendString:item];
        [billingAddr appendString:@" "];
    }
    
    NSMutableString* shippingAddr = [[NSMutableString alloc] init];
    for(NSString* item in [account.shippingAddress componentsSeparatedByString:@"\n"])
    {
        [shippingAddr appendString:item];
        [shippingAddr appendString:@" "];
    }
    [lbl_billingAddr setText:billingAddr];
    [lbl_shippingAddr setText:shippingAddr];
    [self ReloadMembers];
}

-(void)ReloadMembers
{
    [m_members removeAllObjects];
    for(UserInfo* user in [SharedMembers sharedInstance].Members)
    {
        if ([user.accounts containsObject:m_account._id])
            [m_members addObject:user];
    }
    [tbl_members reloadData];
}
@end
