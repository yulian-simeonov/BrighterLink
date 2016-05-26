//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWaiter.h"
#import "WebManager.h"



@interface TextAreaView : UIView
{
    IBOutlet UIWebView* webVw_content;
    IBOutlet UIImageView* img_bg;
    

}

-(void)setText:(NSString*)text;
-(void)SetImage:(UIImage*)img;

- (void) setInfo;
@end
