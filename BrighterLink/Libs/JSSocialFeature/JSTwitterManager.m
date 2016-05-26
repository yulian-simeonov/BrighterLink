//
//  JSTwitterManager.m
//  PhotoSauce
//
//  Created by NOVNUS LLC on 1/16/13.
//  Copyright (c) 2013 NOVNUS LLC. All rights reserved.
//

#import "JSTwitterManager.h"
#import "JSWaiter.h"

@implementation JSTwitterManager

+(void)Upload:(NSString*)message FilePath:(NSString*)imgPath ParentViewController:(UIViewController*)parent
{
    TWTweetComposeViewController* vw = [[TWTweetComposeViewController alloc] init];
    if (message)
        [vw setInitialText:message];
    if (imgPath)
        [vw addImage:[UIImage imageWithContentsOfFile:imgPath]];
    
    [parent presentViewController:vw animated:YES completion:NULL];
    vw.completionHandler = ^(TWTweetComposeViewControllerResult res)
    {
        [JSWaiter HideWaiter];
        if(res == TWTweetComposeViewControllerResultDone)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"The Tweet was posted successfully." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
        }
        else if(res == TWTweetComposeViewControllerResultCancelled)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancelled" message:@"You Cancelled posting the Tweet." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
        }
        [vw dismissViewControllerAnimated:YES completion:nil];
    };
}
@end
