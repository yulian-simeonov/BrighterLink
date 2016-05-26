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



@interface iFrameView : UIView
{
    float width;
    float height;
}

@property (nonatomic, weak) IBOutlet UIWebView * m_webView;

- (void) setRefresh;
- (void) resizeAllSubview:(CGRect) frame url:(NSString* ) urlAddress;

- (void) setInfo;

@end
