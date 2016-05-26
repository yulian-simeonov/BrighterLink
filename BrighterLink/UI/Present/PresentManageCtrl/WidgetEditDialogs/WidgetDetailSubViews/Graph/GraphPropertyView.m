//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "GraphPropertyView.h"

#import "SharedMembers.h"
#import "UIViewController+CWPopup.h"

#import "Command.h"

@interface GraphPropertyView()

@end

@implementation GraphPropertyView

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
    
    _assetVC = [[ChooseAssetView alloc] initWithNibName:@"ChooseAssetView" bundle:nil];
    [_assetVC setDelegate:self];


    [_m_txtTitleFontName setUserInteractionEnabled:false]; [_m_txtTitleFontName setDelegate:self];
    [_m_txtLabelFontName setUserInteractionEnabled:false];
    
    _m_txtBgImg.tag = 15;  [_m_txtBgImg setDelegate:self];
    _m_txtBodyBgColor.tag = 1; [_m_txtBodyBgColor setUserInteractionEnabled:false];
    _m_txtTitleFontColor.tag = 2; [_m_txtTitleFontColor setUserInteractionEnabled:false];
    _m_txtTitleBgColor.tag = 3; [_m_txtTitleBgColor setUserInteractionEnabled:false];
    _m_txtLabelFontColor.tag = 4; [_m_txtLabelFontColor setUserInteractionEnabled:false];
    _m_txtLabelGenerationGraph.tag = 5; [_m_txtLabelGenerationGraph setUserInteractionEnabled:false];
    _m_txtLabelTemperatureGraph.tag = 6; [_m_txtLabelTemperatureGraph setUserInteractionEnabled:false];
    _m_txtLabelHumidityGraph.tag = 7; [_m_txtLabelHumidityGraph setUserInteractionEnabled:false];
    _m_txtLabelCurrentPowerGraph.tag = 8; [_m_txtLabelCurrentPowerGraph setUserInteractionEnabled:false];
    _m_txtLabelMaxPowerGraph.tag = 9; [_m_txtLabelMaxPowerGraph setUserInteractionEnabled:false];
    _m_txtLabelWeatherGraph.tag = 10; [_m_txtLabelWeatherGraph setUserInteractionEnabled:false];
    
    _m_txtTitleFontSize.tag = 11; [_m_txtTitleFontSize setDelegate:self];
    _m_txtLabelFontSize.tag = 12; [_m_txtLabelFontSize setDelegate:self];
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
   [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    if ( widget.param.backgroundImage ) {
        [_m_txtBgImg setText:  widget.param.backgroundImage];
    }else{
        [_m_txtBgImg setText:  @""];
    }
    
    if ( widget.param.backgroundColor) {
        [_m_txtBodyBgColor setText:  widget.param.backgroundColor];
        [_m_imgClr1 setBackgroundColor:[self colorFromHexString1:widget.param.backgroundColor]];
    }else{
        [_m_txtBodyBgColor setText:@""];
    }
    
    headerFont * title  = widget.param.headerFnt;
    if ( title ) {
        double font = [title.size doubleValue];
        [_m_txtTitleFontSize setText:  [NSString stringWithFormat:@"%.2f", font]];
        [_m_txtTitleFontName setText: title.name ];
        [_m_txtTitleFontColor setText: title.color];
        [_m_imgClr2 setBackgroundColor:[self colorFromHexString1: title.color]];
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            [_m_txtTitleContent setText: title.content];
        }
    }
    
    primaryColor* titleBgClr  = widget.param.primaryClr;
    if ( titleBgClr ) {
        [_m_txtTitleBgColor setText:titleBgClr.color];
        [_m_imgClr3 setBackgroundColor:[self colorFromHexString1: titleBgClr.color]];
    }
    
    
    normal2Font * basicDic  = widget.param.normal2Fnt;
    if ( basicDic ) {
        double font = [basicDic.size doubleValue];
        [_m_txtLabelFontSize setText: [NSString stringWithFormat:@"%.2f", font]];
        [_m_txtLabelFontName setText: basicDic.name ];
        [_m_txtLabelFontColor setText: basicDic.color ];
        [_m_imgClr4 setBackgroundColor:[self colorFromHexString1: basicDic.color]];
    }
    
    secondaryColor * generationDic  = widget.param.secondaryClr;
    if ( generationDic ) {
        [_m_txtLabelGenerationGraph setText: generationDic.color];
        [_m_imgClr5 setBackgroundColor:[self colorFromHexString1:generationDic.color]];
    }
    
    tertiaryColor * temperatureDic  = widget.param.tertiaryClr;
    if ( temperatureDic ) {
        [_m_txtLabelTemperatureGraph setText: temperatureDic.color];
        [_m_imgClr6 setBackgroundColor:[self colorFromHexString1:temperatureDic.color]];
    }

    fourthColor * humidityDic  = widget.param.fourthClr;
    if ( humidityDic ) {
        [_m_txtLabelHumidityGraph setText: humidityDic.color];
        [_m_imgClr7 setBackgroundColor:[self colorFromHexString1: humidityDic.color]];
    }

    fifthColor * currentDic  = widget.param.fifthClr;
    if ( currentDic ) {
        [_m_txtLabelCurrentPowerGraph setText: currentDic.color];
        [_m_imgClr8 setBackgroundColor:[self colorFromHexString1: currentDic.color]];
    }

    sixthColor * maxDic  = widget.param.sixthClr;
    if ( maxDic ) {
        [_m_txtLabelMaxPowerGraph setText: maxDic.color];
        [_m_imgClr9 setBackgroundColor:[self colorFromHexString1: maxDic.color]];
    }
    
    seventhColor * weatherDic  = widget.param.seventhClr;
    if ( weatherDic ) {
        [_m_txtLabelWeatherGraph setText: weatherDic.color];
        [_m_imgClr10 setBackgroundColor:[self colorFromHexString1: weatherDic.color]];
    }
}

- (IBAction) onBgImage:(id)sender
{
//    _assetVC.m_selectedAccountId = [SharedMembers sharedInstance].selectedAccountId;
    [_assetVC refresh:2];
    [parent presentPopupViewController:_assetVC type:false animated:YES completion:^(void) {
    }];
}

- (void)ChooseAssetViewDidCloseButtonPressed:(ChooseAssetView *)popupVC
{
    if (parent.popupViewController != nil) {
        [parent dismissPopupViewControllerAnimated:YES completion:^{
            NSString * imgUrl = [SharedMembers sharedInstance].imgUrl;
            [_m_txtBgImg setText: imgUrl];
            
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            widget.param.backgroundImage  = imgUrl;
        }];
    }
}

- (IBAction) onBodyBgColor:(id)sender
{
    m_FontType = 0;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtBodyBgColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden:true];
}

- (IBAction) onTitleFontName:(id)sender
{
    m_nType  = 0;
    [_m_vFont setHidden: false];
    [_m_vFont setFrame:CGRectMake( _m_imgTitleFontName.frame.origin.x,  _m_imgTitleFontName.frame.origin.y + _m_imgTitleFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    
    [vClrPicker setHidden:true];
}

- (IBAction) onTitleFontColor:(id)sender
{
    m_FontType = 1;
    
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtTitleFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden:true];
}

- (IBAction) onTitleBgColor:(id)sender
{
    m_FontType = 2;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtTitleBgColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x -100, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}

- (IBAction) onLabelFontName:(id)sender
{
    m_nType  = 1;
    [_m_vFont setHidden: false];
    [_m_vFont setFrame:CGRectMake( _m_imgLabelFontName.frame.origin.x,  _m_imgLabelFontName.frame.origin.y + _m_imgLabelFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [vClrPicker setHidden:true];
}

- (IBAction) onLabelFontColor:(id)sender
{
    m_FontType = 3;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtLabelFontColor.text]];
   [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y +  btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];
    
    [_m_vFont setHidden:true];
}

- (IBAction) onLabelGenerationGraph:(id)sender
{
    m_FontType = 4;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtLabelGenerationGraph.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}

- (IBAction) onLabelTemperatureGraph:(id)sender
{
    m_FontType = 5;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtLabelTemperatureGraph.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}

- (IBAction) onLabelHumidityGraph:(id)sender
{
    m_FontType = 6;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtLabelHumidityGraph.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}

- (IBAction) onLabelCurrentPowerGraph:(id)sender
{
    m_FontType = 7;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtLabelCurrentPowerGraph.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden: true];
}

- (IBAction) onLabelMaxPowerGraph:(id)sender
{
    m_FontType = 8;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtLabelMaxPowerGraph.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}
- (IBAction) onLabelWeatherGraph:(id)sender
{
    m_FontType = 9;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtLabelWeatherGraph.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}

///
#pragma mark Font View

- (IBAction) onBentonSans:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txtTitleFontName setText:@"BentonSans"];
        break;
        case 1:
            [_m_txtLabelFontName setText:@"BentonSans"];
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
            [_m_txtTitleFontName setText:@"Arial"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Arial"];
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
            [_m_txtTitleFontName setText:@"Arial Black"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Arial Black"];
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
            [_m_txtTitleFontName setText:@"Cochin"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Cochin"];
            break;
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Cochin"];
}

- (IBAction) onCourierNew:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txtTitleFontName setText:@"Courier New"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Courier New"];
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
            [_m_txtTitleFontName setText:@"Georgia"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Georgia"];
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
            [_m_txtTitleFontName setText:@"Iowan Old Style"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Iowan Old Style"];
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
            [_m_txtTitleFontName setText:@"Lao Sangam MN"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Lao Sangam MN"];
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
            [_m_txtTitleFontName setText:@"Thonburi"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Thonburi"];
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
            [_m_txtTitleFontName setText:@"Times New Roman"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Times New Roman"];
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
            [_m_txtTitleFontName setText:@"Trebuchet MS"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Trebuchet MS"];
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
            [_m_txtTitleFontName setText:@"Verdana"];
            break;
        case 1:
            [_m_txtLabelFontName setText:@"Verdana"];
            break;
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Verdana"];
}

- (void) setFontName:(int) type Name:(NSString*) name
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    switch ( m_nType) {
        case 0:
            widget.param.headerFnt.name = name;
            break;
        case 1:
            widget.param.normal2Fnt.name = name;
            break;
        default:
            break;
    }
}

- (void) setFontColor:(NSString *)fontClr
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    switch ( m_FontType ) {
        case 0:
            [_m_txtBodyBgColor setText: fontClr];
            [_m_imgClr1 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.backgroundColor  = fontClr;
            break;
        case 1:
            [_m_txtTitleFontColor setText: fontClr];
            [_m_imgClr2 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.headerFnt.color = fontClr;
            break;
        case 2:
            [_m_txtTitleBgColor setText: fontClr];
            [_m_imgClr3 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.primaryClr.color = fontClr;
            break;
        case 3:
            [_m_txtLabelFontColor setText: fontClr];
            [_m_imgClr4 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.normal2Fnt.color = fontClr;
            break;
        case 4:
            [_m_txtLabelGenerationGraph setText: fontClr];
            [_m_imgClr5 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.secondaryClr.color  = fontClr;
            break;
        case 5:
            [_m_txtLabelTemperatureGraph setText: fontClr];
            [_m_imgClr6 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.tertiaryClr.color  = fontClr;
            break;
        case 6:
            [_m_txtLabelHumidityGraph setText: fontClr];
            [_m_imgClr7 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.fourthClr.color  = fontClr;
            break;
        case 7:
            [_m_txtLabelCurrentPowerGraph setText: fontClr];
            [_m_imgClr8 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.fifthClr.color  = fontClr;
            break;
        case 8:
            [_m_txtLabelMaxPowerGraph setText: fontClr];
            [_m_imgClr9 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.sixthClr.color  = fontClr;
            break;
        case 9:
            [_m_txtLabelWeatherGraph setText: fontClr];
            [_m_imgClr10 setBackgroundColor:[self colorFromHexString1:fontClr]];
            widget.param.seventhClr.color  = fontClr;
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
    
    widget.param.headerFnt.content = [NSString stringWithFormat:@"%@%@", textView.text, text];
    
    return  true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    headerFont * title  = widget.param.headerFnt;
    primaryColor* titleBgClr  = widget.param.primaryClr;
    normal2Font * basicDic  = widget.param.normal2Fnt;
    secondaryColor * generationDic  = widget.param.secondaryClr;
    tertiaryColor * temperatureDic  = widget.param.tertiaryClr;
    fifthColor * currentDic  = widget.param.fifthClr;
    fourthColor * humidityDic  = widget.param.fourthClr;
    sixthColor * maxDic  = widget.param.sixthClr;
    seventhColor * weatherDic  = widget.param.seventhClr;
    
    int tag  = textField.tag;
    
    switch ( tag ) {
        case 1:
            widget.param.backgroundColor = _m_txtBodyBgColor.text;
            break;
        case 2:
            title.color = _m_txtTitleFontColor.text;
            break;
        case 3:
            titleBgClr.color = _m_txtTitleBgColor.text;
            break;
        case 4:
            basicDic.color = _m_txtLabelFontColor.text;
            break;
        case 5:
            generationDic.color = _m_txtLabelGenerationGraph.text;
            break;
        case 6:
            temperatureDic.color = _m_txtLabelTemperatureGraph.text;
            break;
        case 7:
            humidityDic.color = _m_txtLabelHumidityGraph.text;
            break;
        case 8:
            currentDic.color = _m_txtLabelCurrentPowerGraph.text;
            break;
        case 9:
            maxDic.color = _m_txtLabelMaxPowerGraph.text;
            break;
        case 10:
            weatherDic.color = _m_txtLabelWeatherGraph.text;
            break;
        case 11:
            title.size =  [NSNumber numberWithDouble: [ _m_txtTitleFontSize.text doubleValue]];
            break;
        case 12:
            basicDic.size = [NSNumber numberWithDouble: [_m_txtLabelFontSize.text doubleValue]];
            break;
        case  15:
            widget.param.backgroundImage = _m_txtBgImg.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL flag  = true;
    int  tag = textField.tag;
    if ( tag < 11 ) {
        flag =        [Command checkHex:string];
        if ( flag ) {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            normal2Font * basicDic  = widget.param.normal2Fnt;
            secondaryColor * generationDic  = widget.param.secondaryClr;
            tertiaryColor * temperatureDic  = widget.param.tertiaryClr;
            fifthColor * currentDic  = widget.param.fifthClr;
            fourthColor * humidityDic  = widget.param.fourthClr;
            sixthColor * maxDic  = widget.param.sixthClr;
            seventhColor * weatherDic  = widget.param.seventhClr;
            

            NSString * change  = [NSString stringWithFormat:@"%@%@", textField.text, string];
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
                    basicDic.color = change;
                    break;
                case 5:
                    generationDic.color = change;
                    break;
                case 6:
                    temperatureDic.color = change;
                    break;
                case 7:
                    humidityDic.color = change;
                    break;
                case 8:
                    currentDic.color = change;
                    break;
                case 9:
                    maxDic.color = change;
                    break;
                case 10:
                    weatherDic.color = change;
                    break;
                case 11:
                    title.size =  [NSNumber numberWithDouble: [ change doubleValue]];
                    break;
                case 12:
                    basicDic.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case  15:
                    widget.param.backgroundImage = change;
                    break;
                    
                default:
                    break;
            }

        }
    }
    else if( tag >= 11 && tag < 15 ){
        flag =        [Command checkDigit:string];
        if ( flag ) {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            normal2Font * basicDic  = widget.param.normal2Fnt;
            secondaryColor * generationDic  = widget.param.secondaryClr;
            tertiaryColor * temperatureDic  = widget.param.tertiaryClr;
            fifthColor * currentDic  = widget.param.fifthClr;
            fourthColor * humidityDic  = widget.param.fourthClr;
            sixthColor * maxDic  = widget.param.sixthClr;
            seventhColor * weatherDic  = widget.param.seventhClr;
            
            
            NSString * change  = [NSString stringWithFormat:@"%@%@", textField.text, string];
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
                    basicDic.color = change;
                    break;
                case 5:
                    generationDic.color = change;
                    break;
                case 6:
                    temperatureDic.color = change;
                    break;
                case 7:
                    humidityDic.color = change;
                    break;
                case 8:
                    currentDic.color = change;                             break;
                case 9:
                    maxDic.color = change;
                    break;
                case 10:
                    weatherDic.color = change;
                    break;
                case 11:
                    title.size =  [NSNumber numberWithDouble: [ change doubleValue]];
                    break;
                case 12:
                    basicDic.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case  15:
                    widget.param.backgroundImage = change;
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    else
        flag = true;
    return flag;
}

@end
