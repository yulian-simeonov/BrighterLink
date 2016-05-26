//
//  SolarPreview.m
//  BrighterLink
//
//  Created by mobile on 12/4/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "HowPreview.h"
#import "PWidgetInfo.h"
#import "SharedMembers.h"

@implementation HowPreview

-(void)awakeFromNib
{
    m_arrowOffset = CGSizeMake(5, 2);
    m_arrowPoints[0] = img_arrow1.center;
    m_arrowPoints[1] = img_arrow2.center;
    m_arrowPoints[2] = img_arrow3.center;
}

-(void)dealloc
{
    m_bStopAnimation = YES;
}

-(void)SetTexts:(NSArray*)txts
{
    for(int i = 0; i < 4; i++)
    {
        UILabel* lbl = [lbl_steps objectAtIndex:i];
        UIImageView* step = [img_steps objectAtIndex:i];
        [step setHidden:YES];
        UIImageView* stepFrame = [img_frameSteps objectAtIndex:i];
        [stepFrame setHidden:YES];
        [lbl setText:[txts objectAtIndex:i]];
        [lbl setHidden:YES];
    }
}

-(void)setFrame:(CGRect)frame
{
    CGSize originSize = self.frame.size;
    [super setFrame:frame];
    CGSize scale = CGSizeMake(frame.size.width / originSize.width, frame.size.height / originSize.height);
    
    [img_beam1 setFrame:CGRectMake(img_beam1.frame.origin.x * scale.width, img_beam1.frame.origin.y * scale.height, img_beam1.frame.size.width * scale.width, img_beam1.frame.size.height * scale.height)];
    [img_beam2 setFrame:CGRectMake(img_beam2.frame.origin.x * scale.width, img_beam2.frame.origin.y * scale.height, img_beam2.frame.size.width * scale.width, img_beam2.frame.size.height * scale.height)];
    
    [img_currency1 setFrame:CGRectMake(img_currency1.frame.origin.x * scale.width, img_currency1.frame.origin.y * scale.height, img_currency1.frame.size.width * scale.width, img_currency1.frame.size.height * scale.height)];
    [img_currency2 setFrame:CGRectMake(img_currency2.frame.origin.x * scale.width, img_currency2.frame.origin.y * scale.height, img_currency2.frame.size.width * scale.width, img_currency2.frame.size.height * scale.height)];
    
    [img_arrow1 setFrame:CGRectMake(img_arrow1.frame.origin.x * scale.width, img_arrow1.frame.origin.y * scale.height, img_arrow1.frame.size.width * scale.width, img_arrow1.frame.size.height * scale.height)];
    [img_arrow2 setFrame:CGRectMake(img_arrow2.frame.origin.x * scale.width, img_arrow2.frame.origin.y * scale.height, img_arrow2.frame.size.width * scale.width, img_arrow2.frame.size.height * scale.height)];
    [img_arrow3 setFrame:CGRectMake(img_arrow3.frame.origin.x * scale.width, img_arrow3.frame.origin.y * scale.height, img_arrow3.frame.size.width * scale.width, img_arrow3.frame.size.height * scale.height)];
    m_arrowPoints[0] = img_arrow1.center;
    m_arrowPoints[1] = img_arrow2.center;
    m_arrowPoints[2] = img_arrow3.center;
    
    m_arrowOffset = CGSizeMake(m_arrowOffset.width * scale.width, m_arrowOffset.height * scale.height);

    for(int i = 0; i < 4; i++)
    {
        UIImageView* step = [img_steps objectAtIndex:i];
        [step setFrame:CGRectMake(step.frame.origin.x * scale.width, step.frame.origin.y * scale.height, step.frame.size.width * scale.width, step.frame.size.height * scale.height)];
        
        UIImageView* stepFrame = [img_frameSteps objectAtIndex:i];
        [stepFrame setFrame:CGRectMake(stepFrame.frame.origin.x * scale.width, stepFrame.frame.origin.y * scale.height, stepFrame.frame.size.width * scale.width, stepFrame.frame.size.height * scale.height)];
        
        UILabel* lbl = [lbl_steps objectAtIndex:i];
        CGSize size = [lbl sizeThatFits:CGSizeMake(stepFrame.frame.size.width - 20, 999999)];
        [lbl setFrame:CGRectMake(stepFrame.frame.origin.x + 10, stepFrame.frame.origin.y + 10, stepFrame.frame.size.width - 20, size.height)];
        [stepFrame setFrame:CGRectMake(stepFrame.frame.origin.x, stepFrame.frame.origin.y, stepFrame.frame.size.width, size.height + 20)];
    }
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
                   
                    flag = true;
                }
            }
        }
    }
    
    [self textViewDidChange:txt];
    
    if ( flag ) {
        float delta = txt.frame.size.height - img_bg.frame.origin.y;
//        for ( UIView * v in [self subviews]) {
//            if ( ![v isKindOfClass:[UITextView class]]) {
//                v.center = CGPointMake( v.center.x, v.center.y + delta);
//            }
//        }
        [self setFrame:CGRectMake(self.frame.origin.x, txt.frame.size.height, self.frame.size.width, self.frame.size.height - txt.frame.size.height)];
        [self addSubview: txt];
        [txt setFrame: CGRectMake(0, - txt.frame.size.height, txt.frame.size.width, txt.frame.size.height)];
    }
    else{
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }
}

-(void)setAdjustFrame:(CGRect)frame
{
    CGSize originSize = self.frame.size;
    CGSize scale = CGSizeMake(frame.size.width / originSize.width, frame.size.height / originSize.height);
    
    [img_beam1 setFrame:CGRectMake(img_beam1.frame.origin.x * scale.width, img_beam1.frame.origin.y * scale.height, img_beam1.frame.size.width * scale.width, img_beam1.frame.size.height * scale.height)];
    [img_beam2 setFrame:CGRectMake(img_beam2.frame.origin.x * scale.width, img_beam2.frame.origin.y * scale.height, img_beam2.frame.size.width * scale.width, img_beam2.frame.size.height * scale.height)];
    
    [img_currency1 setFrame:CGRectMake(img_currency1.frame.origin.x * scale.width, img_currency1.frame.origin.y * scale.height, img_currency1.frame.size.width * scale.width, img_currency1.frame.size.height * scale.height)];
    [img_currency2 setFrame:CGRectMake(img_currency2.frame.origin.x * scale.width, img_currency2.frame.origin.y * scale.height, img_currency2.frame.size.width * scale.width, img_currency2.frame.size.height * scale.height)];
    
    [img_arrow1 setFrame:CGRectMake(img_arrow1.frame.origin.x * scale.width, img_arrow1.frame.origin.y * scale.height, img_arrow1.frame.size.width * scale.width, img_arrow1.frame.size.height * scale.height)];
    [img_arrow2 setFrame:CGRectMake(img_arrow2.frame.origin.x * scale.width, img_arrow2.frame.origin.y * scale.height, img_arrow2.frame.size.width * scale.width, img_arrow2.frame.size.height * scale.height)];
    [img_arrow3 setFrame:CGRectMake(img_arrow3.frame.origin.x * scale.width, img_arrow3.frame.origin.y * scale.height, img_arrow3.frame.size.width * scale.width, img_arrow3.frame.size.height * scale.height)];
    m_arrowPoints[0] = img_arrow1.center;
    m_arrowPoints[1] = img_arrow2.center;
    m_arrowPoints[2] = img_arrow3.center;
    
    m_arrowOffset = CGSizeMake(m_arrowOffset.width * scale.width, m_arrowOffset.height * scale.height);
    
    for(int i = 0; i < 4; i++)
    {
        UIImageView* step = [img_steps objectAtIndex:i];
        [step setFrame:CGRectMake(step.frame.origin.x * scale.width, step.frame.origin.y * scale.height, step.frame.size.width * scale.width, step.frame.size.height * scale.height)];
        
        UIImageView* stepFrame = [img_frameSteps objectAtIndex:i];
        [stepFrame setFrame:CGRectMake(stepFrame.frame.origin.x * scale.width, stepFrame.frame.origin.y * scale.height, stepFrame.frame.size.width * scale.width, stepFrame.frame.size.height * scale.height)];
        
        UILabel* lbl = [lbl_steps objectAtIndex:i];
        CGSize size = [lbl sizeThatFits:CGSizeMake(stepFrame.frame.size.width - 20, 999999)];
        [lbl setFrame:CGRectMake(stepFrame.frame.origin.x + 10, stepFrame.frame.origin.y + 10, stepFrame.frame.size.width - 20, size.height)];
        [stepFrame setFrame:CGRectMake(stepFrame.frame.origin.x, stepFrame.frame.origin.y, stepFrame.frame.size.width, size.height + 20)];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
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

-(void)StartAnimation
{
    m_beamTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(BeamAnimation) userInfo:nil repeats:YES];
    m_stepTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(StepAniation) userInfo:nil repeats:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            while(!m_bStopAnimation)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [img_currency1 setHidden:!img_currency1.hidden];
                    [img_currency2 setHidden:!img_currency2.hidden];
                });
                
                [NSThread sleepForTimeInterval:0.3f];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    img_arrow1.center = CGPointMake(img_arrow1.center.x + m_arrowOffset.width, img_arrow1.center.y - m_arrowOffset.height);
                });
                
                [NSThread sleepForTimeInterval:0.3f];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    img_arrow2.center = CGPointMake(img_arrow2.center.x + m_arrowOffset.width, img_arrow2.center.y - m_arrowOffset.height);
                    img_arrow3.center = CGPointMake(img_arrow3.center.x + m_arrowOffset.width, img_arrow3.center.y - m_arrowOffset.height);
                });
                
                [NSThread sleepForTimeInterval:0.3f];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    img_arrow1.center = m_arrowPoints[0];
                    img_arrow2.center = m_arrowPoints[1];
                    img_arrow3.center = m_arrowPoints[2];
                });
            }
        });
}

-(void)BeamAnimation
{
    [img_beam1 setHidden:!img_beam1.hidden];
    [img_beam2 setHidden:!img_beam2.hidden];
}

-(void)StepAniation
{
    for(int i = 0; i < 4; i++)
    {
        if (i == 3)
        {
            [m_stepTimer invalidate];
            m_stepTimer = nil;
        }
        UIImageView* imgSpot = [img_steps objectAtIndex:i];
        UIImageView* imgFrame = [img_frameSteps objectAtIndex:i];
        UILabel* lbl = [lbl_steps objectAtIndex:i];
        if (lbl.hidden)
        {
            [lbl setHidden:NO];
            [imgSpot setHidden:NO];
            [imgFrame setHidden:NO];
            break;
        }
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

@end
