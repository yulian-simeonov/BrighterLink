//
//  EditAppsPermissionsView.m
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EditAppsPermissionsView.h"
#import "SharedMembers.h"

@implementation EditAppsPermissionsView

+(EditAppsPermissionsView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EditAppsPermissionsView" owner:self options:nil];
    EditAppsPermissionsView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    btn_save.layer.borderWidth = 1;
    btn_save.layer.borderColor = btn_save.titleLabel.textColor.CGColor;
    m_arySelectedApps = [[NSMutableArray alloc] init];
    
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)OnSelect:(UIButton*)sender
{
    img_home.center = CGPointMake(img_home.center.x, sender.superview.center.y - 3);
    m_selectedApp = sender.tag;
}

-(IBAction)OnActive:(UIButton*)sender
{
    int idx = (int)[btn_activites indexOfObject:sender];
    m_bActiveApps[idx] = !m_bActiveApps[idx];
    if (m_bActiveApps[idx])
    {
        [sender setImage:[UIImage imageNamed:@"icon_eye.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_eye.png"] forState:UIControlStateHighlighted];
        [sender setAlpha:1.0f];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"icon_add.png"] forState:UIControlStateNormal];
        [sender setAlpha:0.3f];
    }
}

-(IBAction)OnSave:(id)sender
{
    [JSWaiter ShowWaiter:self title:@"Saving..." type:0];
    [m_arySelectedApps removeAllObjects];
    for(int i = 0; i < 8; i++)
    {
        if (m_bActiveApps[i])
        {
            [m_arySelectedApps addObject:[SharedMembers sharedInstance]->m_appNames[i]];
        }
    }
    [m_userInfo setApps:m_arySelectedApps];
    [m_userInfo setDefaultApp:[SharedMembers sharedInstance]->m_appNames[m_selectedApp]];
    [m_userInfo UpdateUserInfo:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [self removeFromSuperview];
    } failed:nil];
}

-(void)SetUserInfo:(UserInfo*)userInfo
{
    m_userInfo = userInfo;
    NSLog(@"%@", m_userInfo);
    img_home.center = CGPointMake(img_home.center.x, 103 + [self GetAppIndex:m_userInfo.defaultApp] * 44 - 3);
    for(NSString* activeApp in m_userInfo.apps)
    {
        int idx = [self GetAppIndex:activeApp];
        UIButton* btn = [btn_activites objectAtIndex:idx];
        m_bActiveApps[idx] = YES;
        [btn setImage:[UIImage imageNamed:@"icon_eye.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_eye.png"] forState:UIControlStateHighlighted];
        [btn setAlpha:1.0f];
    }
}

-(int)GetAppIndex:(NSString*)appName
{
    if (!appName)
        return 0;
    for(int i = 0; i < 8; i++)
    {
        if ([[SharedMembers sharedInstance]->m_appNames[i] isEqualToString:appName])
            return i;
    }
    return 0;
}

@end
