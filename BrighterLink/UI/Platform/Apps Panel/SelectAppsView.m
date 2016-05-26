//
//  SelectAppsView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SelectAppsView.h"
#import "SharedMembers.h"

@implementation SelectAppsView
-(void)Initialize
{
    self.layer.cornerRadius = 8;
    self.layer.shadowOffset = CGSizeMake(-5, 5);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.3;
}

-(IBAction)OnClick:(UIButton*)sender
{
    if (sender.tag > 1)
        return;
    [self removeFromSuperview];
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* newViewController = nil;
    switch (sender.tag) {
        case 0:
            if (![SharedMembers sharedInstance].presentViewController)
                [SharedMembers sharedInstance].presentViewController = [storyBoard instantiateViewControllerWithIdentifier:@"sb_present"];
            newViewController = [SharedMembers sharedInstance].presentViewController;
            break;
        case 1:
            if (![SharedMembers sharedInstance].analyzerViewController)
                [SharedMembers sharedInstance].analyzerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"sb_analyze"];
            newViewController = [SharedMembers sharedInstance].analyzerViewController;
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        default:
            break;
    }
    if ([newViewController isEqual:[SharedMembers sharedInstance].currentViewController])
        return;
    [SharedMembers sharedInstance].img_screenShot = [SharedMembers CaptureBackground:[SharedMembers sharedInstance].currentViewController.view inRect:CGRectMake(0, 20, 1024, 748) withScale:1.0f];
    
    [[SharedMembers sharedInstance].currentViewController.navigationController popViewControllerAnimated:NO];
    [[SharedMembers sharedInstance].loginViewController.navigationController pushViewController:newViewController animated:NO];
}
@end
