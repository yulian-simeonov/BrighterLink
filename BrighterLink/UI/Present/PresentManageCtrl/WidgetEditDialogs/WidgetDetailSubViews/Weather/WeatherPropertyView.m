//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WeatherPropertyView.h"

#import "SharedMembers.h"

#import "Command.h"

@interface WeatherPropertyView()

@end

@implementation WeatherPropertyView

- (void) awakeFromNib
{
    m_bCurrent = false;
    m_bWeather = false;
    m_bMeasure = false;

    [_m_vFont setHidden:true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    NSArray *  nib = [[NSBundle mainBundle] loadNibNamed:@"ColorPickerView" owner:self options:nil];
    vClrPicker = [nib objectAtIndex:0];
    [vClrPicker setFrame:CGRectMake(self.frame.size.width, self.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    vClrPicker.delegate = self;
    [self addSubview:vClrPicker];
    
    m_FontType = 0;
    
    _m_txt_BodyBgColor.tag = 1;      [_m_txt_BodyBgColor setUserInteractionEnabled:false];
    _m_txt_CurrentFontColor.tag = 2; [_m_txt_CurrentFontColor setUserInteractionEnabled:false];
    _m_txt_TitleBgColor.tag = 3;     [_m_txt_TitleBgColor setUserInteractionEnabled:false];
    _m_txt_WeatherFontColor.tag = 4; [_m_txt_WeatherFontColor setUserInteractionEnabled:false];
    _m_txt_MeasureFontColor.tag = 5; [_m_txt_MeasureFontColor setUserInteractionEnabled:false];
    
    _m_txt_WeatherFontSize.tag = 6; [_m_txt_WeatherFontSize setDelegate:self];
    [_m_txt_WeatherFontName setUserInteractionEnabled:false];
    _m_txt_MeasureFontSize.tag = 7; [_m_txt_MeasureFontSize setDelegate:self];
    [_m_txt_MeasureFontName setUserInteractionEnabled:false];
    _m_txt_CurrentFontSize.tag = 8;  [_m_txt_CurrentFontSize setDelegate:self];
    [_m_txt_CurrentFontName setUserInteractionEnabled:false];

    [_m_txt_Content setDelegate:self];
    
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
    m_bCurrent = false;
    m_bWeather = false;
    m_bMeasure = false;

    [_m_vFont setHidden:true];
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    
    if ( widget.param.backgroundColor) {
        [_m_txt_BodyBgColor setText:  widget.param.backgroundColor];
        [_m_imgClr1 setBackgroundColor:[self colorFromHexString1:widget.param.backgroundColor]];
    }else{
        [_m_txt_BodyBgColor setText:@""];
    }
    
    headerFont * title  = widget.param.headerFnt;
    if ( title ) {
        double font = [title.size doubleValue];
        [_m_txt_CurrentFontSize setText:  [NSString stringWithFormat:@"%.2f", font]];
        [_m_txt_CurrentFontName setText: title.name];
        [_m_txt_CurrentFontColor setText: title.color];
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            [_m_txt_Content setText: title.content];
        }
        
        [_m_imgClr2 setBackgroundColor:[self colorFromHexString1: title.color]];
    }
    
    primaryColor * titleBgClr  = widget.param.primaryClr;
    if ( titleBgClr ) {
        [_m_txt_TitleBgColor setText: titleBgClr.color];
        [_m_imgClr3 setBackgroundColor:[self colorFromHexString1: titleBgClr.color]];
    }
    
    normal1Font * weatherDic  = widget.param.normal1Fnt;
    if ( weatherDic ) {
        double font = [weatherDic.size doubleValue];
        [_m_txt_WeatherFontSize setText: [NSString stringWithFormat:@"%.2f", font]];
        [_m_txt_WeatherFontName setText: weatherDic.name];
        [_m_txt_WeatherFontColor setText: weatherDic.color];
        
        [_m_imgClr4 setBackgroundColor: [self colorFromHexString1: weatherDic.color]];
    }
    
    normal2Font * basicDic  = widget.param.normal2Fnt;
    if ( basicDic ) {
        double font = [basicDic.size doubleValue];
        [_m_txt_MeasureFontSize setText: [NSString stringWithFormat:@"%.2f", font]];
        [_m_txt_MeasureFontName setText: basicDic.name];
        [_m_txt_MeasureFontColor setText: basicDic.color];
        
        [_m_imgClr5 setBackgroundColor:[self colorFromHexString1: basicDic.color]];
    }
}

- (IBAction) onBodyBackgroundColor:(id)sender
{
    m_FontType = 0;
    UIButton * btn = (UIButton*)sender;
    
    [vClrPicker setInfo: [self colorFromHexString1:_m_txt_BodyBgColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden:true];
}

- (IBAction) onCurrentColor:(id)sender
{
    m_FontType = 1;
    UIButton * btn = (UIButton*)sender;
    
    [vClrPicker setInfo: [self colorFromHexString1:_m_txt_CurrentFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden:true];
}

- (IBAction) onTitleColor:(id)sender
{
    m_FontType = 2;
    UIButton * btn = (UIButton*)sender;
    
    [vClrPicker setInfo: [self colorFromHexString1:_m_txt_TitleBgColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x -100, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden:true];
}

- (IBAction) onMeasureColor:(id)sender
{
    m_FontType = 3;
    UIButton * btn = (UIButton*)sender;
    
    [vClrPicker setInfo: [self colorFromHexString1:_m_txt_MeasureFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width + btn.frame.size.width, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden:true];
}

- (IBAction) onWeatherColor:(id)sender
{
    m_FontType = 4;
    UIButton * btn = (UIButton*)sender;
    
    [vClrPicker setInfo: [self colorFromHexString1:_m_txt_WeatherFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x -100, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}

- (IBAction) onCurrentFontName:(id)sender
{
    m_nType  = 0;
    m_bCurrent = !m_bCurrent;
    if ( _m_vFont.isHidden == true ) {
        [_m_vFont setHidden: false];
        [_m_vFont setFrame:CGRectMake( _m_img_CurrentFontName.frame.origin.x,  _m_img_CurrentFontName.frame.origin.y + _m_img_CurrentFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    else{
        [_m_vFont setHidden:  true];
            [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }

    [vClrPicker setHidden:true];
}

- (IBAction) onWeatherFontName:(id)sender
{
    m_nType  = 1;
    m_bWeather = !m_bWeather;
    if ( _m_vFont.isHidden == true ) {
        [_m_vFont setHidden: false];
        [_m_vFont setFrame:CGRectMake( _m_img_WeatherFontName.frame.origin.x,  _m_img_WeatherFontName.frame.origin.y - _m_vFont.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    else{
        [_m_vFont setHidden: true];
            [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }

    [vClrPicker setHidden:true];
}

- (IBAction) onMeasureFontName:(id)sender
{
    m_nType  = 2;
    m_bMeasure  = !m_bMeasure;
    if ( _m_vFont.isHidden == true ) {
        [_m_vFont setHidden: false];
        [_m_vFont setFrame:CGRectMake( _m_img_MeasureFontName.frame.origin.x,  _m_img_MeasureFontName.frame.origin.y + _m_img_MeasureFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    else{
        [_m_vFont setHidden: true];
            [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    
    [vClrPicker setHidden:true];
}

///
#pragma mark Font View

- (void) setFontName:(int) type  Name:(NSString*) name
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    switch ( m_nType) {
        case 0:
        {
            widget.param.headerFnt.name = name;
        }
            break;
        case 1:
        {
            widget.param.normal1Fnt.name  = name;
//            [weatherDic setValue: name forKey:@"name"];
        }
            break;
        case 2:
        {
            widget.param.normal2Fnt.name  = name;
//            [basicDic setValue: name forKey:@"name"];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction) onBentonSans:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"BentonSans"];
        break;
        case 1:
            [_m_txt_WeatherFontName setText:@"BentonSans"];
        break;
        case 2:
            [_m_txt_MeasureFontName setText:@"BentonSans"];
        break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [self setFontName:m_nType Name:@"BentonSans"];
}

- (IBAction) onArial:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Arial"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Arial"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Arial"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Arial"];
}

- (IBAction) onArialBlack:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Arial Black"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Arial Black"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Arial Black"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Arial Black"];
}

- (IBAction) onComicSansMS:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Cochin"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Cochin"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Cochin"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [self setFontName:m_nType Name:@"Comic Sans MS"];
}

- (IBAction) onCourierNew:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Courier New"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Courier New"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Courier New"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Courier New"];
}

- (IBAction) onGeorgia:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Georgia"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Georgia"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Georgia"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [self setFontName:m_nType Name:@"Georgia"];
}

- (IBAction) onImpact:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Iowan Old Style"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Iowan Old Style"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Iowan Old Style"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [self setFontName:m_nType Name:@"Iowan Old Style"];
}

- (IBAction) onLucidaSansUnicode:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Lao Sangam MN"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Lao Sangam MN"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Lao Sangam MN"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Lao Sangam MN"];
}

- (IBAction) onTahoma:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Thonburi"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Thonburi"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Thonburi"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [self setFontName:m_nType Name:@"Thonburi"];
}

- (IBAction) onTimesNewRoman:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Times New Roman"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Times New Roman"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Times New Roman"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [self setFontName:m_nType Name:@"Times New Roman"];
}

- (IBAction) onTrebuchetMS:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Trebuchet MS"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Trebuchet MS"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Trebuchet MS"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Trebuchet MS"];
}

- (IBAction) onVerdana:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txt_CurrentFontName setText:@"Verdana"];
            break;
        case 1:
            [_m_txt_WeatherFontName setText:@"Verdana"];
            break;
        case 2:
            [_m_txt_MeasureFontName setText:@"Verdana"];
            break;
            
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Verdana"];
}

- (void) setFontColor:(NSString *)fontClr
{
    
    PWidgetInfo * widget = [SharedMembers sharedInstance].curWidget;
    
    switch ( m_FontType ) {
        case 0:
        {
            [_m_txt_BodyBgColor setText: fontClr];
            [_m_imgClr1 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.backgroundColor = fontClr;
        }
            break;
        case 1:
        {
            [_m_txt_CurrentFontColor setText:fontClr];
            [_m_imgClr2 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.headerFnt.color  = fontClr;
        }
            break;
        case 2:
        {
            [_m_txt_TitleBgColor setText: fontClr];
            [_m_imgClr3 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.primaryClr.color = fontClr;
        }
            break;
        case 3:
        {
            [_m_txt_MeasureFontColor setText:fontClr];
            [_m_imgClr5 setBackgroundColor:[self colorFromHexString1:fontClr]];

            widget.param.normal1Fnt.color  = fontClr;
        }
            break;
        case 4:
        {
            [_m_txt_WeatherFontColor setText:fontClr];
            [_m_imgClr4 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.normal2Fnt.color = fontClr;
        }
            break;
        default:
            break;
    }
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    widget.param.headerFnt.content = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    NSString * change  = [NSString stringWithFormat:@"%@%@", textView.text, text];
    widget.param.headerFnt.content = change;
    
    return  true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    headerFont * title  = widget.param.headerFnt;
    primaryColor* titleBgClr  = widget.param.primaryClr;
    normal2Font * basicDic  = widget.param.normal2Fnt;
    normal1Font * weatherDic  = widget.param.normal1Fnt;

    
    int tag  = textField.tag;
    
    switch ( tag ) {
        case 1:
            widget.param.backgroundColor = _m_txt_BodyBgColor.text;
            break;
        case 2:
            title.color = _m_txt_CurrentFontColor.text;
            break;
        case 3:
            titleBgClr.color = _m_txt_TitleBgColor.text;
            break;
        case 4:
            weatherDic.color = _m_txt_WeatherFontColor.text;
            break;
        case 5:
            basicDic.color = _m_txt_MeasureFontColor.text;
            break;
        case 6:
            weatherDic.size = [NSNumber numberWithDouble: [_m_txt_WeatherFontSize.text doubleValue]];
            break;
        case 7:

            basicDic.size = [NSNumber numberWithDouble: [_m_txt_MeasureFontSize.text doubleValue]];
            break;
        case 8:
            title.size = [NSNumber numberWithDouble: [_m_txt_CurrentFontSize.text doubleValue]];
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL flag  = true;
    int  tag = textField.tag;
    if ( tag < 6 ) {
        flag = [Command checkHex:string];
        if ( flag ) {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            normal2Font * basicDic  = widget.param.normal2Fnt;
            normal1Font * weatherDic  = widget.param.normal1Fnt;
            
            NSString * change = [NSString stringWithFormat:@"%@%@", textField.text, string];
            
            switch ( tag ) {
                case 1:
                    widget.param.backgroundColor = change;
                    break;
                case 2:
                    title.color = change;
                    break;
                case 3:
                    titleBgClr.color = change;
                    break;
                case 4:
                    weatherDic.color = change;
                    break;
                case 5:
                    basicDic.color = change;
                    break;
                case 6:
                    weatherDic.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case 7:
                    
                    basicDic.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case 8:
                    title.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                    
                default:
                    break;
            }
        }
    }
    else {
        flag = [Command checkDigit:string];
        if ( flag ) {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            normal2Font * basicDic  = widget.param.normal2Fnt;
            normal1Font * weatherDic  = widget.param.normal1Fnt;
            
            NSString * change = [NSString stringWithFormat:@"%@%@", textField.text, string];
            
            switch ( tag ) {
                case 1:
                    widget.param.backgroundColor = change;
                    break;
                case 2:
                    title.color = change;
                    break;
                case 3:
                    titleBgClr.color = change;
                    break;
                case 4:
                    weatherDic.color = change;
                    break;
                case 5:
                    basicDic.color = change;
                    break;
                case 6:
                    weatherDic.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case 7:
                    
                    basicDic.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case 8:
                    title.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return flag;
}

@end
