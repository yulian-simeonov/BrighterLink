//
//  ImageWidgetView.h
//  BrighterLink
//
//  Created by apple developer on 1/3/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetView.h"

@interface ImageWidgetView : WidgetView
{
    UIImageView* img_widget;
}
+(ImageWidgetView*)ShowImageWidget:(UIView*)parent;
@end
