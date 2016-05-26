//
//  UserProfileView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "UserProfileView.h"
#import "ProfileSettingView.h"
#import "UIImageView+WebCache.h"

@implementation UserProfileView

+(UserProfileView*)ShowUserProfileViewWithName:(UIView*)parentView xPos:(float)xPos
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil];
    UserProfileView* vw = [nib objectAtIndex:0];
    vw.layer.zPosition = 11;
    [vw Initialize];
    [vw Refresh];
    [vw setFrame:CGRectMake(xPos, 20, vw.frame.size.width, vw.frame.size.height)];
    [parentView addSubview:vw];
    vw.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:vw action:@selector(OnTapOutside:)];
    [parentView addGestureRecognizer:vw.tapGesture];
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

-(void)Initialize
{
    self.layer.shadowOffset = CGSizeMake(-3, 3);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.3;
}

-(IBAction)OnSetting:(UIButton*)sender
{
    [ProfileSettingView ShowProfileView:self.superview];
    [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    [self removeFromSuperview];
}

-(IBAction)OnExit:(UIButton*)sender
{
    [[SharedMembers sharedInstance].currentViewController.navigationController popViewControllerAnimated:YES];
}

-(IBAction)OnHelp:(UIButton*)sender
{
    
}

-(IBAction)OnClose:(id)sender
{
    [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    [self removeFromSuperview];
}

-(void)OnTapOutside:(UITapGestureRecognizer*)gesture
{
    if (CGRectContainsPoint(self.frame, [gesture locationInView:gesture.view]))
        return;
    [self OnClose:nil];
}

-(void)Refresh
{
    [self SetUserName:[SharedMembers sharedInstance].userInfo.name];
    [img_avatar sd_setImageWithURL:[NSURL URLWithString:[SharedMembers sharedInstance].userInfo.profilePictureUrl] placeholderImage:[UIImage imageNamed:@"mm-picture.png"]];
}
@end
