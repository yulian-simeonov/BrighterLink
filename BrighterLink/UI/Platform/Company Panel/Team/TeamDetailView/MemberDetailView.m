//
//  MemberDetailView.m
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "MemberDetailView.h"
#import "EditAppsPermissionsView.h"
#import "EditSourcesAndGroupsPermissionsView.h"
#import "EditMemberView.h"
#import "SharedMembers.h"
#import "AccountDetailView.h"
#import "TeamView.h"

@implementation MemberDetailView

+(MemberDetailView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"MemberDetailView" owner:self options:nil];
    MemberDetailView* vw = [nib objectAtIndex:0];
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
    
    if([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
    {
        [btn_edit setHidden:YES];
        [btn_delete setHidden:YES];
    }
}

-(IBAction)OnBack:(id)sender
{
    [_teamView ReloadData];
    [self removeFromSuperview];
}

-(IBAction)OnAppsPermissions:(id)sender
{
    EditAppsPermissionsView* vw = [EditAppsPermissionsView ShowView:self.superview];
    [vw SetUserInfo:m_userInfo];
}

-(IBAction)OnSourcesAndGroups:(id)sender
{
    EditSourcesAndGroupsPermissionsView* vw = [EditSourcesAndGroupsPermissionsView ShowView:self.superview];
    [vw setUserInfo:m_userInfo];
}

-(IBAction)OnEdit:(id)sender
{
    EditMemberView* vw = [EditMemberView ShowView:self.superview];
    [vw UpdateWithData:self member:m_userInfo];
}

-(IBAction)OnDelete:(id)sender
{
    [JSWaiter ShowWaiter:self title:@"Deleting" type:0];
    [m_userInfo DeleteUser:^(MKNetworkOperation *networkOperation) {
        [[SharedMembers sharedInstance].Members removeObject:m_userInfo];
       if(_teamView)
           [_teamView ReloadData];
        if (_accountDetailView)
            [_accountDetailView ReloadMembers];
        [JSWaiter HideWaiter];
        [self OnBack:nil];
    } failed:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
}

-(void)SetUserInfo:(UserInfo*)user
{
    m_userInfo = user;
    [lbl_name setText:user.name];
    [lbl_email setText:user.email];
    [lbl_phone setText:user.phone];
}
@end
