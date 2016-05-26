//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "iFrameView.h"

#import "SharedMembers.h"
#import "JSWaiter.h"

@interface iFrameView()

@end

@implementation iFrameView

- (void) awakeFromNib
{

}

- (void) setRefresh
{
    
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
        if ( [v isKindOfClass:[UITextView class]]) {
            [v removeFromSuperview];
        }
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
                    [txt setUserInteractionEnabled:false];                    
                    [txt setBackgroundColor:[self colorFromHexString:titleBgClr.color]];
                    [self addSubview: txt];
                    flag = true;
                }
            }
        }
    }
    
    [self textViewDidChange:txt];
    
    if ( flag ) {
        [_m_webView setFrame: CGRectMake(0, txt.frame.size.height, width, height - txt.frame.size.height)];
        [self setFrame:CGRectMake(self.frame.origin.x, 0, width, height )];
    }
    else{
        [_m_webView setFrame:CGRectMake(0, 0, width, height)];
        [self setFrame:CGRectMake(self.frame.origin.x, 0, width, height)];
    }
}

- (void) resizeAllSubview:(CGRect) frame url:(NSString* ) urlAddress
{
    width = frame.size.width;
    height  = frame.size.height;

    
    [JSWaiter ShowWaiter:self title:@"" type:0];
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_m_webView loadRequest:requestObj];
    
    [_m_webView setFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)];
    [self setInfo];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [JSWaiter HideWaiter];
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
