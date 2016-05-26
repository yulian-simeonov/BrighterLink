//
//  TeamView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TeamView.h"
#import "TeamViewCell.h"
#import "AddMemberView.h"
#import "MemberDetailView.h"
#import "SharedMembers.h"

@implementation TeamView

+(UIView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TeamView" owner:self options:nil];
    TeamView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    img_searchBar.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1].CGColor;
    img_searchBar.layer.borderWidth = 1;
    img_searchBar.layer.cornerRadius = 4;
    btn_addMember.layer.borderWidth = 1;
    btn_addMember.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    m_filteredMembers = [[NSMutableArray alloc] initWithArray:[SharedMembers sharedInstance].Members];
    [tbl_members reloadData];
    
    if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
    {
        [btn_addMember setHidden:YES];
    }
}

-(IBAction)OnAddMember:(id)sender
{
    AddMemberView* vw = [AddMemberView ShowView:self.superview];
    [vw setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)textFieldDidChange:(UITextField*)textField
{
    [m_filteredMembers removeAllObjects];
    if (textField.text.length == 0)
    {
        m_filteredMembers = [[NSMutableArray alloc] initWithArray:[SharedMembers sharedInstance].Members];
    }
    else
    {
        for(UserInfo* user in [SharedMembers sharedInstance].Members)
        {
            if ([user.name.lowercaseString rangeOfString:textField.text.lowercaseString].location != NSNotFound)
                [m_filteredMembers addObject:user];
        }
    }
    [tbl_members reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_filteredMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TeamViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setDelegate:self];
        [cell SetUserInfo:[m_filteredMembers objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)SelectedTeam:(id)userInfo
{
    MemberDetailView* vw = [MemberDetailView ShowView:self.superview];
    [vw setTeamView:self];
    [vw SetUserInfo:userInfo];
}

-(void)ReloadData
{
    [self textFieldDidChange:txt_search];
}
@end
