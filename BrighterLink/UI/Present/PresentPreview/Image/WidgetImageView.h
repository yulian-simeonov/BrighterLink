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



@interface WidgetImageView : UIView
{
    float width;
    float height;
    
    UIImage * m_image;
}

@property (nonatomic, weak) IBOutlet UIImageView * imgView;


- (void) setRefresh:(UIImage*) image;
- (void) resizeAllSubview:(CGRect) frame;
- (void) setInfo;

@end
