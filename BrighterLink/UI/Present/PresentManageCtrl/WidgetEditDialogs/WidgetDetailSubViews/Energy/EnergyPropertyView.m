//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EnergyPropertyView.h"

#import "SharedMembers.h"
#import "UIViewController+CWPopup.h"
#import "PWidgetInfo.h"

#import "Command.h"

@interface EnergyPropertyView()

@end

@implementation EnergyPropertyView


NSString * imgName[] = {
    @"/bl-bv-management/assets/img/vertical-cars.png",
    
    @"/bl-bv-management/assets/img/tons.png",
    
    @"/bl-bv-management/assets/img/gallons.png",
    
    @"/bl-bv-management/assets/img/tanker.png",
    
    @"/bl-bv-management/assets/img/energy-home.png",
    
    @"/bl-bv-management/assets/img/electricity-home.png",
    
    @"/bl-bv-management/assets/img/railcars.png",
    
    @"/bl-bv-management/assets/img/barrels.png",
    
    @"/bl-bv-management/assets/img/propane.png",
    
    @"/bl-bv-management/assets/img/coal.png",
    
    @"/bl-bv-management/assets/img/tree.png",
    
    @"/bl-bv-management/assets/img/acres.png",
    
    @"/bl-bv-management/assets/img/acres-corpland.png",
};

- (void) awakeFromNib
{
      m_bTitle = false;
      m_bBasic = false;
      m_bCalcu = false;
      m_bSupport = false;

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

    _m_txtBodyBgColor.tag = 1; [_m_txtBodyBgColor setUserInteractionEnabled:false];
    _m_txtTitleFontColor.tag = 2; [_m_txtTitleFontColor setUserInteractionEnabled:false];
    _m_txtTitleBgColor.tag  = 3; [_m_txtTitleBgColor setUserInteractionEnabled:false];
    _m_txtCalcuFontColor.tag = 4; [_m_txtCalcuFontColor setUserInteractionEnabled:false];
    _m_txtBasicFontColor.tag  = 5; [_m_txtBasicFontColor setUserInteractionEnabled:false];
    _m_txtSupportFontColor.tag = 6; [_m_txtSupportFontColor setUserInteractionEnabled:false];

    
    _m_txtTitleFontSize.tag = 7;  [_m_txtTitleFontSize setDelegate:self];
    [_m_txtTitleFontName setUserInteractionEnabled:false];
    
    _m_txtCalcuFontSize.tag = 8; [_m_txtCalcuFontSize setDelegate:self];
    [_m_txtCalcuFontName setUserInteractionEnabled:false];
    
    _m_txtBasicFontSize.tag = 9; [_m_txtBasicFontSize setDelegate:self];
    [_m_txtBasicFontName setUserInteractionEnabled:false];
    
    _m_txtSupportFontSize.tag  = 10; [_m_txtSupportFontSize setDelegate:self];
    [_m_txtSupportFontName setUserInteractionEnabled:false];
    
    _m_txtBgImage.tag = 15; [_m_txtBgImage setDelegate:self];
    
    
    _m_txtContent.tag = 1;  [_m_txtContent setDelegate:self];
    _m_txtSupportContent.tag = 2;  [_m_txtSupportContent setDelegate:self];
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

- (void) setBgImgPath
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    NSString * sType  = widget.param.widgetEnergyType;
    if ( [sType isEqualToString:@"Cars Removed"] ) {
        widget.param.backgroundImage = imgName[0];
    }
    else if ( [sType isEqualToString: @"Waste Recycled"] )
    {
        widget.param.backgroundImage = imgName[1];
    }
    else  if ( [sType isEqualToString:@"Gallons Gas Saved"])
    {
        widget.param.backgroundImage = imgName[2];
    }
    else if ( [sType isEqualToString:@"Tanker Gas Saved"] )
    {
        widget.param.backgroundImage = imgName[3];
    }
    else if ( [sType isEqualToString:@"Energy Homes Generated"])
    {
        widget.param.backgroundImage = imgName[4];
    }
    else if ( [sType isEqualToString:@"Electricity Homes Generated"])
    {
        widget.param.backgroundImage = imgName[5];
    }else if ( [sType isEqualToString:@"Coal Elimanated"]){
        widget.param.backgroundImage = imgName[6];
    }else if ( [sType isEqualToString:@"Oil Unneeded"]){
        widget.param.backgroundImage = imgName[7];
    }else if ( [sType isEqualToString: @"Propane Cylinders" ]){
        widget.param.backgroundImage = imgName[8];
    }else if ( [sType isEqualToString: @"Plants Idled"]){
        widget.param.backgroundImage = imgName[9];
    }else if ( [sType isEqualToString: @"Seedling Grown"]){
        widget.param.backgroundImage = imgName[10];
    }else if ( [sType isEqualToString:@"Forests Preserved"]){
        widget.param.backgroundImage = imgName[11];
    }else if ( [sType isEqualToString:@"Forests Conversion Prevented"]){
        widget.param.backgroundImage = imgName[12];
    }
    
    [_m_txtBgImage setText:  widget.param.backgroundImage];
}

- (void) setInfo
{
    m_bTitle = false;
    m_bBasic = false;
    m_bSupport = false;
    m_bCalcu = false;

    [_m_vFont setHidden:true];
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    if ( widget.param.backgroundImage  ) {

        [_m_txtBgImage setText:  widget.param.backgroundImage];
        if ( [widget.param.backgroundImage isEqualToString:@""] ){
            [self setBgImgPath];
        }
        
    }else{
        [self setBgImgPath];
    }

    if ( widget.param.backgroundColor) {
        [_m_txtBodyBgColor setText:  widget.param.backgroundColor];
        [_m_imgClr1 setBackgroundColor:[self colorFromHexString1: widget.param.backgroundColor]];
    }else{
        [_m_txtBodyBgColor setText:@""];
    }
    
    headerFont * title  = widget.param.headerFnt;
    if ( title ) {
        double font = [title.size doubleValue];
        [_m_txtTitleFontSize setText:  [NSString stringWithFormat:@"%.2f", font]];
        [_m_txtTitleFontName setText: title.name];
        [_m_txtTitleFontColor setText: title.color ];
        [_m_imgClr2 setBackgroundColor:[self colorFromHexString1: title.color]];
        NSString * str  = title.content;
        if ( ![str isKindOfClass:[NSNull class]] ) {
            [_m_txtContent setText: title.content];
        }
    }
    
    primaryColor * titleBgClr  = widget.param.primaryClr;
    if ( titleBgClr ) {
        [_m_txtTitleBgColor setText: titleBgClr.color];
        [_m_imgClr3 setBackgroundColor: [self colorFromHexString1: titleBgClr.color]];
    }
    
    normal1Font * calcDic  = widget.param.normal1Fnt;
    if ( calcDic ) {
        double font = [calcDic.size doubleValue];
        [_m_txtCalcuFontSize setText: [NSString stringWithFormat:@"%.2f", font]];
        [_m_txtCalcuFontName setText: calcDic.name];
        [_m_txtCalcuFontColor setText: calcDic.color];
        [_m_imgClr4 setBackgroundColor:[self colorFromHexString1: calcDic.color]];
    }
    
    normal2Font * basicDic  = widget.param.normal2Fnt;
    if ( basicDic ) {
        double font = [basicDic.size doubleValue];
        [_m_txtBasicFontSize setText: [NSString stringWithFormat:@"%.2f", font]];
        [_m_txtBasicFontName setText: basicDic.name];
        [_m_txtBasicFontColor setText: basicDic.color];
        [_m_imgClr5 setBackgroundColor:[self colorFromHexString1: basicDic.color]];
    }
    
    subHeaderFont * suppDic  = widget.param.subHeaderFnt;
    if ( suppDic ) {
        double font = [suppDic.size doubleValue];
        [_m_txtSupportFontSize setText: [NSString stringWithFormat:@"%.2f", font]];
        [_m_txtSupportFontName setText: suppDic.name];
        [_m_txtSupportFontColor setText: suppDic.color];
        [_m_imgClr6 setBackgroundColor:[self colorFromHexString1: suppDic.color ]];
        NSString * str = suppDic.content;
        if( ![str isKindOfClass:[NSNull class]] )
            [ _m_txtSupportContent setText: suppDic.content ];
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
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
}

- (IBAction) onCalcuBgColor:(id)sender
{
    m_FontType = 3;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtCalcuFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - 100, btn.frame.origin.y - vClrPicker.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden: true];
}

- (IBAction) onBasicFontColor:(id)sender
{
    m_FontType = 4;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtBasicFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden: true];
}

- (IBAction) onSupportFontColor:(id)sender
{
    m_FontType = 5;
    UIButton * btn = (UIButton*)sender;
    [vClrPicker setInfo: [self colorFromHexString1:_m_txtSupportFontColor.text]];
    [vClrPicker setFrame:CGRectMake( btn.frame.origin.x - vClrPicker.frame.size.width, btn.frame.origin.y + btn.frame.size.height, vClrPicker.frame.size.width, vClrPicker.frame.size.height)];
    [vClrPicker setHidden:false];

    [_m_vFont setHidden:true];
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
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    if (parent.popupViewController != nil) {
        [parent dismissPopupViewControllerAnimated:YES completion:^{
            NSString * imgUrl = [SharedMembers sharedInstance].imgUrl;
            [_m_txtBgImage setText: imgUrl];
            
            widget.param.backgroundImage  = imgUrl;

        }];
    }
}

- (IBAction) onTitleFontName:(id)sender
{
    m_nType  = 0;
    m_bTitle = !m_bTitle;
    if ( _m_vFont.isHidden == true ) {
        [_m_vFont setHidden: false];
        [_m_vFont setFrame:CGRectMake( _m_imgTitleFontName.frame.origin.x,  _m_imgTitleFontName.frame.origin.y + _m_imgTitleFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    else{
        [_m_vFont setHidden:  true];
        [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }

    [vClrPicker setHidden:true];
}

- (IBAction) onCalcuFontName:(id)sender
{
    m_nType  = 1;
    m_bCalcu = !m_bCalcu;
    if ( _m_vFont.isHidden == true ) {
        [_m_vFont setHidden: false];
        [_m_vFont setFrame:CGRectMake( _m_imgCalcuFontName.frame.origin.x,  _m_imgCalcuFontName.frame.origin.y + _m_imgCalcuFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    else{
        [_m_vFont setHidden:  true];
        [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    
    [vClrPicker setHidden:true];
}

- (IBAction) onBasicFontName:(id)sender
{
    m_nType  = 2;
    m_bBasic = !m_bBasic;
    if ( _m_vFont.isHidden == true ) {
        [_m_vFont setHidden: false];
        [_m_vFont setFrame:CGRectMake( _m_imgBasicFontName.frame.origin.x,  _m_imgBasicFontName.frame.origin.y + _m_imgBasicFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    else{
        [_m_vFont setHidden:  true];
        [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }

    [vClrPicker setHidden:true];
}

- (IBAction) onSupportFontName:(id)sender
{
    m_nType  = 3;
    m_bSupport = !m_bSupport;
    if ( _m_vFont.isHidden == true ) {
        [_m_vFont setHidden: false];
        [_m_vFont setFrame:CGRectMake( _m_imgSupportFontName.frame.origin.x,  _m_imgSupportFontName.frame.origin.y + _m_imgSupportFontName.frame.size.height,  _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    else{
        [_m_vFont setHidden:  true];
        [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];
    }
    
    [vClrPicker setHidden:true];
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
            [_m_txtCalcuFontName setText:@"BentonSans"];
        break;
        case 2:
            [_m_txtBasicFontName setText:@"BentonSans"];
        break;
        case 3:
            [_m_txtSupportFontName setText:@"BentonSans"];
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
            [_m_txtCalcuFontName setText:@"Arial"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Arial"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Arial"];
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
            [_m_txtCalcuFontName setText:@"Arial Black"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Arial Black"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Arial Black"];
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
            [_m_txtCalcuFontName setText:@"Cochin"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Cochin"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Cochin"];
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
            [_m_txtCalcuFontName setText:@"Courier New"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Courier New"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Courier New"];
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
            [_m_txtCalcuFontName setText:@"Georgia"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Georgia"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Georgia"];
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
            [_m_txtCalcuFontName setText:@"Iowan Old Style"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Iowan Old Style"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Iowan Old Style"];
            break;
    
        default:
            break;
    }
    [_m_vFont setHidden: true];
    [_m_vFont setFrame:CGRectMake( self.frame.size.width, self.frame.size.height, _m_vFont.frame.size.width, _m_vFont.frame.size.height)];

    [self setFontName:m_nType Name:@"Iowan Old Style Roman"];
}
- (IBAction) onLucidaSansUnicode:(id)sender
{
    switch ( m_nType) {
        case 0:
            [_m_txtTitleFontName setText:@"Lao Sangam MN"];
            break;
        case 1:
            [_m_txtCalcuFontName setText:@"Lao Sangam MN"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Lao Sangam MN"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Lao Sangam MN"];
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
            [_m_txtCalcuFontName setText:@"Thonburi"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Thonburi"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Thonburi"];
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
            [_m_txtCalcuFontName setText:@"Times New Roman"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Times New Roman"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Times New Roman"];
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
            [_m_txtCalcuFontName setText:@"Trebuchet MS"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Trebuchet MS"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Trebuchet MS"];
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
            [_m_txtCalcuFontName setText:@"Verdana"];
            break;
        case 2:
            [_m_txtBasicFontName setText:@"Verdana"];
            break;
        case 3:
            [_m_txtSupportFontName setText:@"Verdana"];
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
    
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    switch ( m_FontType ) {
        case 0:
        {
            [_m_txtBodyBgColor setText: fontClr];
            [_m_imgClr1 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.backgroundColor = fontClr;
        }
            break;
        case 1:
        {
            [_m_txtTitleFontColor setText: fontClr];
            [_m_imgClr2 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.headerFnt.color = fontClr;
        }
            break;
        case 2:
        {
            [_m_txtTitleBgColor setText: fontClr];
            [_m_imgClr3 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.primaryClr.color  = fontClr;
//            if ( titleBgClr ) {
//                [titleBgClr setValue:fontClr forKey:@"color"];
//            }
        }
            break;
        case 3:
        {
            [_m_txtCalcuFontColor setText:fontClr];
            [_m_imgClr4 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.normal1Fnt.color = fontClr;

        }
            break;
        case 4:
        {
            [_m_txtBasicFontColor setText: fontClr];
            [_m_imgClr5 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.normal2Fnt.color  = fontClr;

        }
            break;
        case 5:
        {
            [_m_txtSupportFontColor setText:fontClr];
            [_m_imgClr6 setBackgroundColor:[self colorFromHexString1:fontClr]];
            
            widget.param.subHeaderFnt.color  = fontClr;
        }
            break;
        default:
            break;
    }
}

- (void) setFontName:(int) type Name:(NSString*) name
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    switch ( m_nType) {
        case 0:
            widget.param.headerFnt.name = name;
            break;
        case 1:
            widget.param.normal1Fnt.name = name;
            break;
        case 2:
            widget.param.normal2Fnt.name  = name;
            break;
        case 3:
            widget.param.subHeaderFnt.name  = name;
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    int tag = textView.tag;
    
    NSString * change  = [NSString stringWithFormat: @"%@%@", textView.text, text];
    if ( tag == 1 ) {
        widget.param.headerFnt.content = change;
    }
    else{
        widget.param.subHeaderFnt.content = change;
    }
    
    return  true;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
 
    int tag = textView.tag;
    if ( tag == 1 ) {
        widget.param.headerFnt.content = _m_txtContent.text;
    }
    else{
        widget.param.subHeaderFnt.content = _m_txtSupportContent.text;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    headerFont * title  = widget.param.headerFnt;
    primaryColor* titleBgClr  = widget.param.primaryClr;
    normal1Font * calcDic  = widget.param.normal1Fnt;
    normal2Font * basicDic  = widget.param.normal2Fnt;
    subHeaderFont * suppDic  = widget.param.subHeaderFnt;
    
    int tag  = textField.tag;
    
    switch ( tag ) {
        case 1:
            widget.param.backgroundColor = _m_txtBodyBgColor.text;
            break;
        case 2:
            title.color  = _m_txtTitleFontColor.text;
            break;
        case 3:
            titleBgClr.color = _m_txtTitleBgColor.text;
            break;
        case 4:
            calcDic.color = _m_txtCalcuFontColor.text;
            break;
        case 5:
            basicDic.color = _m_txtBasicFontColor.text;
            break;
        case 6:
            suppDic.color = _m_txtSupportFontColor.text;
            break;
        case 7:
            title.size = [NSNumber numberWithDouble: [_m_txtTitleFontSize.text doubleValue]];
            break;
        case 8:
            calcDic.size = [NSNumber numberWithDouble:[_m_txtCalcuFontSize.text doubleValue]];
            break;
        case 9:
            basicDic.size  = [NSNumber numberWithDouble:[_m_txtBasicFontSize.text doubleValue]];
            break;
        case 10:
            suppDic.size = [NSNumber numberWithDouble: [_m_txtSupportFontSize.text doubleValue]];
            break;
        case  15:
            widget.param.backgroundImage = _m_txtBgImage.text;
            break;
            
        default:
            break;
    }    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_m_vFont setHidden:true];
    [vClrPicker setHidden:true];
    
    return  true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL flag  = true;
    int  tag = textField.tag;
    if ( tag < 7 ) {
        flag =        [Command checkHex:string];
        if( flag )
        {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            normal1Font * calcDic  = widget.param.normal1Fnt;
            normal2Font * basicDic  = widget.param.normal2Fnt;
            subHeaderFont * suppDic  = widget.param.subHeaderFnt;
            
            int tag  = textField.tag;
            NSString * change = [NSString stringWithFormat:@"%@%@", textField.text, string];
            
            switch ( tag ) {
                case 1:
                    widget.param.backgroundColor = change;
                    break;
                case 2:
                    title.color  = change;
                    break;
                case 3:
                    titleBgClr.color = change;
                    break;
                case 4:
                    calcDic.color = change;
                    break;
                case 5:
                    basicDic.color = change;
                    break;
                case 6:
                    suppDic.color = change;
                    break;
                case 7:
                    title.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case 8:
                    calcDic.size = [NSNumber numberWithDouble:[change doubleValue]];
                    break;
                case 9:
                    basicDic.size  = [NSNumber numberWithDouble:[change doubleValue]];
                    break;
                case 10:
                    suppDic.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case  15:
                    widget.param.backgroundImage = change;
                    break;
                    
                default:
                    break;
            }    

        }
    }
    else if(tag  >= 7 && tag < 15) {
        flag =        [Command checkDigit:string];
        if( flag )
        {
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            headerFont * title  = widget.param.headerFnt;
            primaryColor* titleBgClr  = widget.param.primaryClr;
            normal1Font * calcDic  = widget.param.normal1Fnt;
            normal2Font * basicDic  = widget.param.normal2Fnt;
            subHeaderFont * suppDic  = widget.param.subHeaderFnt;
            
            int tag  = textField.tag;
            NSString * change = [NSString stringWithFormat:@"%@%@", textField.text, string];
            
            switch ( tag ) {
                case 1:
                    widget.param.backgroundColor = change;
                    break;
                case 2:
                    title.color  = change;
                    break;
                case 3:
                    titleBgClr.color = change;
                    break;
                case 4:
                    calcDic.color = change;
                    break;
                case 5:
                    basicDic.color = change;
                    break;
                case 6:
                    suppDic.color = change;
                    break;
                case 7:
                    title.size = [NSNumber numberWithDouble: [change doubleValue]];
                    break;
                case 8:
                    calcDic.size = [NSNumber numberWithDouble:[change doubleValue]];
                    break;
                case 9:
                    basicDic.size  = [NSNumber numberWithDouble:[change doubleValue]];
                    break;
                case 10:
                    suppDic.size = [NSNumber numberWithDouble: [change doubleValue]];
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
    {
        flag = true;
    }
    
    return flag;
}



@end
