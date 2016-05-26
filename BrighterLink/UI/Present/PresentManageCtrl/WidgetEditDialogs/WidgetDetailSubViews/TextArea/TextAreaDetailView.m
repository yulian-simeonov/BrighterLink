//
//  CustomDetailTextAreaView.m
//  BrighterLink
//
//  Created by mobile on 12/4/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TextAreaDetailView.h"
#import "PWidgetInfo.h"
#import "SharedMembers.h"

@implementation TextAreaDetailView

-(void)awakeFromNib
{
    NSString *resourceDir = [[NSBundle mainBundle] resourcePath];
    NSArray *pathComponents = [NSArray arrayWithObjects:resourceDir, @"RichText", @"TextEditor.html", nil];
    NSURL *indexUrl = [NSURL fileURLWithPathComponents:pathComponents];
    NSURLRequest *req = [NSURLRequest requestWithURL:indexUrl];
    [vw_web loadRequest:req];
}

-(void)SetText:(NSString*)txt
{
    m_txt = txt;
}

-(NSString*)GetText
{
    NSString* value = [vw_web stringByEvaluatingJavaScriptFromString:@"GetText()"];
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    widget.param.widgetTextareaContent = value;
    
    return value;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"SetText('%@')", m_txt]];
}

- (UIImage *)takeScreenshotFromWebview
{

    UIGraphicsBeginImageContext(self.bounds.size);
    
    [vw_web.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake( 10, 120,  viewImage.size.width -50, viewImage.size.height - 300 );
    
    viewImage = [self getSubImageFrom: viewImage WithRect:rect];
    
    return viewImage;
}

// get sub image
- (UIImage*) getSubImageFrom: (UIImage*) img WithRect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

@end
