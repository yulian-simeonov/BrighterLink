//
//  NavigationBarView.m
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "NavigationBarView.h"
#import "UserProfileView.h"
#import "CompanyPanelView.h"
#import "SharedMembers.h"
#import "UIImageView+WebCache.h"

@implementation NavigationBarView

+(NavigationBarView*)AddNavigationBar:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationBarView" owner:self options:nil];
    NavigationBarView* vw = [nib objectAtIndex:0];
    vw.layer.zPosition = 10;
    [vw setFrame:CGRectMake(1024 - vw.frame.size.width, 20, vw.frame.size.width, vw.frame.size.height)];
    [vw Refresh];
    [SharedMembers sharedInstance].navigationBar = vw;
    [parentView addSubview:vw];
    return vw;
}

-(void)SetUserName:(NSString*)userName
{
    [lbl_username setText:userName];
    float curTotalWidth = self.frame.size.width;
    float curNameWidth = lbl_username.frame.size.width;
    CGSize size = [lbl_username sizeThatFits:CGSizeMake(999999, lbl_username.frame.size.height)];
    float offset = curNameWidth - size.width;
    [lbl_username setFrame:CGRectMake(lbl_username.frame.origin.x, lbl_username.frame.origin.y, size.width, lbl_username.frame.size.height)];
    [self setFrame:CGRectMake(self.frame.origin.x + offset, self.frame.origin.y, curTotalWidth - offset, self.frame.size.height)];
}

-(IBAction)OnCompanyPanel:(UIButton*)sender
{
    for(id subView in self.superview.subviews)
    {
        if ([subView isKindOfClass:[CompanyPanelView class]])
            return;
    }
    [CompanyPanelView ShowCompanyPanelView:self.superview];
}

-(IBAction)OnApps:(UIButton*)sender
{
    if (vw_apps)
    {
        [vw_apps removeFromSuperview];
        vw_apps = nil;
        [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    }
    else
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SelectAppsView" owner:self options:nil];
        SelectAppsView* vw = [nib objectAtIndex:0];
        vw.layer.zPosition = 11;
        [vw Initialize];
        [vw setFrame:CGRectMake(self.frame.origin.x + btn_apps.center.x - vw.frame.size.width / 2, self.frame.origin.y + 60, vw.frame.size.width, vw.frame.size.height)];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapOutside:)];
        [self.superview addGestureRecognizer:self.tapGesture];
        [self.superview addSubview:vw];
        vw_apps = vw;
    }
}

-(IBAction)OnProfile:(UIButton*)sender
{
    [UserProfileView ShowUserProfileViewWithName:self.superview xPos:self.frame.origin.x + img_avatar.frame.origin.x - 4];
}

-(void)OnTapOutside:(UITapGestureRecognizer*)gesture
{
    [gesture.view removeGestureRecognizer:gesture];
    [vw_apps removeFromSuperview];
    vw_apps = nil;
}

-(void)Refresh
{
    [self SetUserName:[SharedMembers sharedInstance].userInfo.name];
    [img_avatar sd_setImageWithURL:[NSURL URLWithString:[SharedMembers sharedInstance].userInfo.profilePictureUrl] placeholderImage:[UIImage imageNamed:@"mm-picture.png"]];
}
@end
