//
//  ProfileSettingView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "ProfileSettingView.h"
#import "SharedMembers.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "NavigationBarView.h"
#import "UploadPhotoView.h"

@implementation ProfileSettingView

+(ProfileSettingView*)ShowProfileView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileSettingView" owner:self options:nil];
    ProfileSettingView* vw = [nib objectAtIndex:0];
    vw.layer.zPosition = 12;
    [vw Initialize];
    [vw setFrame:CGRectMake(1024, 20, vw.frame.size.width, vw.frame.size.height)];
    [parentView addSubview:vw];
    [UIView animateWithDuration:0.5f animations:^{
        [vw setFrame:CGRectMake(1024 - vw.frame.size.width, vw.frame.origin.y, vw.frame.size.width, vw.frame.size.height)];
        vw.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:vw action:@selector(OnTapOutside:)];
        [parentView addGestureRecognizer:vw.tapGesture];
    }];
    return vw;
}

-(void)Initialize
{
    btn_update.layer.borderWidth = 1;
    btn_update.layer.borderColor = btn_update.titleLabel.textColor.CGColor;
    
    btn_cancel.layer.borderWidth = 1;
    btn_cancel.layer.borderColor = btn_cancel.titleLabel.textColor.CGColor;
    
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(-5, 5);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    [self Refresh];
}

-(IBAction)OnClose:(id)sender
{
    [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    [UIView animateWithDuration:0.5f animations:^{
        [self setFrame:CGRectMake(1024, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)OnTapOutside:(UITapGestureRecognizer*)gesture
{
    if (CGRectContainsPoint(self.frame, [gesture locationInView:gesture.view]))
        return;
    [self OnClose:nil];
}

-(void)Refresh
{
    [txt_username setText:[SharedMembers sharedInstance].userInfo.name];
    [txt_email setText:[SharedMembers sharedInstance].userInfo.email];
    [txt_phoneNumber setText:[SharedMembers sharedInstance].userInfo.phone];
    [lbl_role setText:[SharedMembers sharedInstance].userInfo.role];
    [btn_avatar sd_setImageWithURL:[NSURL URLWithString:[SharedMembers sharedInstance].userInfo.profilePictureUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mm-picture.png"]];
}

-(IBAction)OnUpdate:(id)sender
{
    if (txt_password.text.length > 0 || txt_confirmPassword.text.length > 0)
    {
        if (txt_password.text.length < 8)
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Use 8 characters at least." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        else if (![txt_confirmPassword.text isEqualToString:txt_password.text])
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Passwords are dismatched." delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
            return;
        }
    }
    NSArray* names = [txt_username.text componentsSeparatedByString:@" "];
    if (names.count == 2)
    {
        [SharedMembers sharedInstance].userInfo.firstName = [names objectAtIndex:0];
        [SharedMembers sharedInstance].userInfo.lastName = [names objectAtIndex:1];
        [SharedMembers sharedInstance].userInfo.middleName = @"";
    }
    else if (names.count == 3)
    {
        [SharedMembers sharedInstance].userInfo.firstName = [names objectAtIndex:0];
        [SharedMembers sharedInstance].userInfo.middleName = [names objectAtIndex:1];
        [SharedMembers sharedInstance].userInfo.lastName = [names objectAtIndex:2];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Username format is wrong. it should be 'FirstName [MiddleName] LastName'" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
        return;
    }
    [SharedMembers sharedInstance].userInfo.name = txt_username.text;
    [SharedMembers sharedInstance].userInfo.phone = txt_phoneNumber.text;
    [SharedMembers sharedInstance].userInfo.email = txt_email.text;
    if (txt_password.text.length > 0)
        [SharedMembers sharedInstance].userInfo.password = txt_password.text;
    [SharedMembers ShowGlobalWaiter:@"Updating..." type:0];
    [[SharedMembers sharedInstance].userInfo UpdateUserInfo:^(MKNetworkOperation *operation) {
        [JSWaiter HideWaiter];
        [[SharedMembers sharedInstance].navigationBar Refresh];
        [self OnClose:nil];
    } failed:nil];
}

-(IBAction)OnProfileImage:(id)sender
{
    UploadPhotoView* vw = [UploadPhotoView ShowView:self.superview];
    [vw setDelegate:self];
}

@end
