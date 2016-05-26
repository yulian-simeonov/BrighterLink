//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TextAreaView.h"

#import "SharedMembers.h"
#import "PWidgetInfo.h"
#import "Command.h"
#import "SDWebImageManager.h"


@interface TextAreaView()

@end

@implementation TextAreaView

-(void)setText:(NSString*)text
{
    [webVw_content loadHTMLString:text baseURL:nil];
}

-(void)SetImage:(UIImage*)img
{
    [img_bg setHidden:false];
    [img_bg setImage:img];
}

- (void) setInfo
{
    
//    [self setBackgroundColor:[UIColor lightGrayColor]];
    
    float width  = self.frame.size.width;
    float height = self.frame.size.height;
    
    for ( UIView * v in [self subviews]) {
        if ( [v isKindOfClass:[UITextView class]]) {
            [v removeFromSuperview];
        }
    }
    
    PWidgetInfo * widget = [SharedMembers sharedInstance].curWidget;
    headerFont * title  = widget.param.headerFnt;
    primaryColor* titleBgClr  = widget.param.primaryClr;
    
    
    [self setBackgroundColor:[Command colorFromHexString:widget.param.backgroundColor]];
    
    BOOL flag = false;
    
    UILabel * txt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    if ( title ) {
        
        double font = [title.size doubleValue];
        NSString * fontName  = [Command checkFontName:title.name];
        [txt setFont: [UIFont fontWithName: fontName  size: (int)(font*10)]];
        [txt setTextColor:[Command colorFromHexString: title.color]];
        
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            if ( str ) {
                if ( ![str isEqualToString:@""] ) {
                    [txt setHidden: false];
                    [txt setText: [NSString stringWithFormat:@"%@", title.content]];
                    txt.textAlignment = NSTextAlignmentCenter;
                    [txt setBackgroundColor:[Command colorFromHexString:titleBgClr.color]];
                    [Command setAdjustHeightwithFixedWidth:txt];
                    [self addSubview: txt];
                    flag = true;
                }
            }
        }
    }
    
    if ( flag ) {
        [webVw_content setFrame: CGRectMake(0, txt.frame.size.height, width, height-txt.frame.size.height)];
        [self setFrame:CGRectMake(self.frame.origin.x, 0, width, height)];
    }
    else{
        [webVw_content setFrame:CGRectMake(0, 0, width, height)];
        [self setFrame:CGRectMake(self.frame.origin.x, 0, width, height)];
    }
    
    [img_bg setHidden:true];
    
    if ( ![widget.param.backgroundImage isEqualToString:@""]) {
        [JSWaiter ShowWaiter:self title: @"" type:0];
         [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: widget.param.backgroundImage] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!image)
                return;
                [self SetImage: image];
                [JSWaiter HideWaiter];
         }];
    }
}
@end
