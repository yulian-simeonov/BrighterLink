//
//  TeamViewCell.m
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TeamViewCell.h"
#import "TeamView.h"

@implementation TeamViewCell

-(void)SetUserInfo:(UserInfo*)user
{
    m_userInfo = user;
    [lbl_name setText:user.name];
    [lbl_email setText:user.email];
    CGSize nameSize = [lbl_name sizeThatFits:CGSizeMake(200, lbl_name.frame.size.height)];
    [lbl_name setFrame:CGRectMake(lbl_name.frame.origin.x, lbl_name.frame.origin.y, nameSize.width, nameSize.height)];
    lbl_admin.clipsToBounds = YES;
    lbl_admin.layer.cornerRadius = 3;
    [lbl_admin setFrame:CGRectMake(lbl_name.frame.origin.x + lbl_name.frame.size.width + 7, lbl_admin.frame.origin.y, lbl_admin.frame.size.width, lbl_admin.frame.size.height)];
    if (![user.role isEqualToString:@"Admin"])
        [lbl_admin setHidden:YES];
}

-(IBAction)OnClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(SelectedTeam:)])
        [_delegate performSelector:@selector(SelectedTeam:) withObject:m_userInfo];
}

-(IBAction)OnSalesForce:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:m_userInfo.sfdcContactURL]];
}
@end
