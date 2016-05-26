//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WidgetImageView.h"

#import "SharedMembers.h"
#import "JSWaiter.h"
#import "SDWebImageManager.h"

@interface WidgetImageView()

@end

@implementation WidgetImageView

- (void) awakeFromNib
{

}

- (void) setRefresh:(UIImage*) image
{
    m_image  = image;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void) setInfo
{
    for ( UIView * v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    PWidgetInfo * widget = [SharedMembers sharedInstance].curWidget;
    headerFont * title  = widget.param.headerFnt;
    primaryColor* titleBgClr  = widget.param.primaryClr;
    BOOL flag = false;

    UITextView * txt = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    if ( title ) {
        
        double font = [title.size doubleValue];
        NSString * fontName  = [self checkFontName:title.name];
        [txt setFont: [UIFont fontWithName: fontName  size: (int)(font*10)]];
        [txt setTextColor:[self colorFromHexString: title.color]];
        
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            if ( str ) {
                if ( ![str isEqualToString:@""] ) {
                    [txt setHidden: false];
                    [txt setText: [NSString stringWithFormat:@"%@", title.content]];
                    txt.textAlignment = NSTextAlignmentCenter;
                    [txt setBackgroundColor:[self colorFromHexString:titleBgClr.color]];
                    [txt setUserInteractionEnabled:false];                    
                    [self addSubview: txt];
                    flag = true;
                }
            }
        }
    }
    
    [self textViewDidChange:txt];
    
    if ( flag ) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, txt.frame.size.height, width, height-txt.frame.size.height)];
        if ( m_image ) {
            [imgView setImage: m_image];
        }
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imgView];
        [self setFrame:CGRectMake(self.frame.origin.x, 0, width, height)];
    }
    else{
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        if ( m_image ) {
            [imgView setImage: m_image];
        }
        [self addSubview:imgView];
        
        [self setFrame:CGRectMake(self.frame.origin.x, 0, width, height)];
    }
}

- (void) resizeAllSubview:(CGRect) frame
{
    width = frame.size.width;
    height  = frame.size.height;
    
    
    PWidgetInfo * widget = [SharedMembers sharedInstance].curWidget;
    [_imgView setFrame: CGRectMake( 0, 0, frame.size.width, frame.size.height)];
    
    if ( ![widget.param.widgetURL isEqualToString:@""]) {
        [JSWaiter ShowWaiter:self title: @"" type:0];
        
//        dispatch_async(dispatch_get_global_queue(0,0), ^{
//            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: widget.param.widgetURL] ];
//            if ( data == nil )
//                return;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // WARNING: is the cell still using the same data by this point??
//                
//               
//            });
//        });
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: widget.param.widgetURL] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!image){
                [JSWaiter HideWaiter];
                return;
            }
            m_image =  image;
                [self setInfo];
                [JSWaiter HideWaiter];
        }];
    }
}

- (NSString*) checkFontName:(NSString*) font
{
    if ( [font isEqualToString: @"BentonSans"] || [font isEqualToString:@"BentonSans, sans-serif"] ) {
        font  = @"Bangla Sangam MN"; 
    }else if ( [font isEqualToString:@"Arial Black"]){
        font = @"Arial Hebrew";
    }
    return  font;
}

- (UIColor *) colorFromHexString:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
