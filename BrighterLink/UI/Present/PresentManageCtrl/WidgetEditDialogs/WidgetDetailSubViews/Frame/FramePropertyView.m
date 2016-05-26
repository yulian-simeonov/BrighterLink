//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "FramePropertyView.h"

#import "SharedMembers.h"

#import "Command.h"

@interface FramePropertyView()

@end

@implementation FramePropertyView

- (void) awakeFromNib
{
    [_m_vFont setHidden:true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    NSArray *  nib = [[NSBundle mainBundle] loadNibNamed:@"ColorPickerView" owner:self options:nil];
    vClrPicker = [nib objectAtIndex:0];
    [vClrPicker setFrame:CGRectMake(self.frame.size.width, self.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    vClrPicker.delegate = self;
    [self addSubview:vClrPicker];
    
    m_FontType = 0;
    
    _m_txtFontSize.tag = 3;  [_m_txtFontSize setDelegate:self];
    [_m_txtFontName setUserInteractionEnabled:false];
    _m_txtFontColor.tag = 1;  [_m_txtFontColor setUserInteractionEnabled:false];
    
    _m_txtTitleBgColor.tag = 2; [_m_txtTitleBgColor setUserInteractionEnabled:false];
    [_m_imgFontName setUserInteractionEnabled: false];
    
    [_m_txtContent setDelegate:self];
}

- (UIColor *) colorFromHexString1:(NSString *)hexString {
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

- (void) setInfo
{
    [_m_vFont setHidden:true];
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    headerFont * title  = widget.param.headerFnt;
    if ( title ) {
        double font = [title.size doubleValue];
        [_m_txtFontSize setText:  [NSString stringWithFormat:@"%.2f", font]];
        [_m_txtFontName setText: title.name];
        [_m_txtFontColor setText: title.color];
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            [_m_txtContent setText: title.content];
        }
        [_m_imgClr1 setBackgroundColor:[self colorFromHexString1:title.color]];
    }
    
    primaryColor * titleBgClr  = widget.param.primaryClr;
    if ( titleBgClr ) {
        [_m_txtTitleBgColor setText: titleBgClr.color];
        [_m_imgClr2 setBackgroundColor:[self colorFromHexString1: titleBgClr.color]];
    }
}

- (IBAction) onFontName:(id)sender
{
    [_m_vFont setHidden: false];
    [_m_vFont setFrame:CGRectMake( _m_imgFontName.frame.origin.x,  _m_imgFontName.frame.origin.y + _m_imgFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [vClrPicker setHidden: true];
}

- (IBAction) onFontColor:(id)sender
{
    m_FontType = 0;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden: true];
}

- (IBAction) onTitleBgColor:(id)sender
{
    m_FontType = 1;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtTitleBgColor.text]];    
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden: true];
}

///
#pragma mark Font View

- (IBAction) onBentonSans:(id)sender
{
    [self setFontName: @"BentonSans"];
    [_m_txtFontName setText:@"BentonSans"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onArial:(id)sender
{
    [self setFontName: @"Arial"];
    [_m_txtFontName setText:@"Arial"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    
}
- (IBAction) onArialBlack:(id)sender
{
    [self setFontName: @"Arial Black"];
    [_m_txtFontName setText:@"Arial Black"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    
}

- (IBAction) onComicSansMS:(id)sender
{
 [self setFontName: @"Cochin"];
    [_m_txtFontName setText:@"Cochin"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onCourierNew:(id)sender
{
 [self setFontName: @"Courier New"];
    [_m_txtFontName setText:@"Courier New"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onGeorgia:(id)sender
{
    [self setFontName: @"Georgia"];
    [_m_txtFontName setText:@"Georgia"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
}

- (IBAction) onImpact:(id)sender
{
 [self setFontName: @"Iowan Old Style"];
    [_m_txtFontName setText:@"Iowan Old Style"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onLucidaSansUnicode:(id)sender
{
 [self setFontName: @"Lao Sangam MN"];
    [_m_txtFontName setText:@"Lao Sangam MN"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onTahoma:(id)sender
{
 [self setFontName: @"Thonburi"];
    [_m_txtFontName setText:@"Thonburi"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onTimesNewRoman:(id)sender
{
 [self setFontName: @"Times New Roman"];
    [_m_txtFontName setText:@"Times New Roman"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onTrebuchetMS:(id)sender
{
 [self setFontName: @"Trebuchet MS"];
    [_m_txtFontName setText:@"Trebuchet MS"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

}

- (IBAction) onVerdana:(id)sender
{
    [self setFontName: @"Verdana"];
    [_m_txtFontName setText:@"Verdana"];
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
}

- (void) setFontColor:(NSString *)fontClr
{
    PWidgetInfo * widget = [SharedMembers sharedInstance].curWidget;
    
    switch ( m_FontType ) {
        case 0:
            [_m_txtFontColor setText: fontClr];
            [_m_imgClr1 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.headerFnt.color = fontClr;
            break;
        case 1:
            [_m_txtTitleBgColor setText: fontClr];
            [_m_imgClr2 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.primaryClr.color  = fontClr;
            break;
        default:
            break;
    }
}

- (void) setFontName:(NSString*) name
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    widget.param.headerFnt.name = name;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_m_vFont setHidden:true];
    [vClrPicker setHidden:true];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_m_vFont setHidden:true];
    [vClrPicker setHidden:true];
    
    return  true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    widget.param.headerFnt.content = [NSString stringWithFormat:@"%@%@", textView.text, text];
    return  true;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    widget.param.headerFnt.content = textView.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    headerFont * title  = widget.param.headerFnt;
    primaryColor* titleBgClr  = widget.param.primaryClr;
    
    int tag  = textField.tag;
    
    switch ( tag ) {
        case 1:
            title.color = _m_txtFontColor.text;
            break;
        case 2:
            titleBgClr.color = _m_txtTitleBgColor.text;
            break;
        case 3:
            title.size = [NSNumber numberWithDouble:[_m_txtFontSize.text doubleValue]];
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL flag  = true;
    int  tag = textField.tag;
    if ( tag == 1 || tag == 2) {
        flag =        [Command checkHex:string];
        if ( flag ) {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            
            NSString * change = [NSString stringWithFormat:@"%@%@", textField.text , string];
            
            switch ( tag ) {
                case 1:
                    title.color = change;
                    break;
                case 2:
                    titleBgClr.color = change;
                    break;
                case 3:
                    title.size = [NSNumber numberWithDouble:[change doubleValue]];
                    break;
                    
                default:
                    break;
            }

        }
    }
    else if(tag  == 3) {
        flag =        [Command checkDigit:string];
        
        if ( flag ) {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            
            NSString * change = [NSString stringWithFormat:@"%@%@", textField.text , string];
            
            switch ( tag ) {
                case 1:
                    title.color = change;
                    break;
                case 2:
                    titleBgClr.color = change;
                    break;
                case 3:
                    title.size = [NSNumber numberWithDouble:[change doubleValue]];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return flag;
}

@end
