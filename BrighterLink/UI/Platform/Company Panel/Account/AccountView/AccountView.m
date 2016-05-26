//
//  AccountView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AccountView.h"
#import "AddAccountView.h"
#import "AccountViewCell.h"
#import "AccountDetailView.h"
#import "SharedMembers.h"

@implementation AccountView

+(UIView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:self options:nil];
    AccountView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    img_searchBar.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1].CGColor;
    img_searchBar.layer.borderWidth = 1;
    img_searchBar.layer.cornerRadius = 4;
    
    btn_createAccount.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    btn_createAccount.layer.borderWidth = 1;
    
    m_filteredAccounts = [[NSMutableArray alloc] initWithArray:[SharedMembers sharedInstance].Accounts];
    [tbl_accounts reloadData];
    
    if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
        [btn_createAccount setHidden:YES];
}

-(IBAction)OnNewAccount:(id)sender
{
    AddAccountView* vw = [AddAccountView ShowView:self.superview];
    [vw setAccountView:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)textFieldDidChange:(UITextField*)textField
{
    [m_filteredAccounts removeAllObjects];
    if (textField.text.length == 0)
    {
        m_filteredAccounts = [[NSMutableArray alloc] initWithArray:[SharedMembers sharedInstance].Accounts];
    }
    else
    {
        for(Account* acnt in [SharedMembers sharedInstance].Accounts)
        {
            if ([acnt.name.lowercaseString rangeOfString:textField.text.lowercaseString].location != NSNotFound)
                [m_filteredAccounts addObject:acnt];
        }
    }
    [tbl_accounts reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_filteredAccounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AccountViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setDelegate:self];
        [cell SetAccount:[m_filteredAccounts objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)SelectedAccount:(id)data
{
    AccountDetailView* vw = [AccountDetailView ShowView:self.superview];
    [vw setAccountView:self];
    [vw SetAccount:data];
}

-(void)Refresh
{
    [self textFieldDidChange:txt_search];
}
@end
