//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "Command.h"
#import "TransitionManager.h"


@implementation Command

- (id) init
{
    return  self;
}

+ (NSString*) checkFontName:(NSString*) font
{
    if ( [font isEqualToString: @"BentonSans"] || [font isEqualToString:@"BentonSans, sans-serif"] ) {
        font  = @"Bangla Sangam MN";
    }else if ( [font isEqualToString:@"Arial Black"]){
        font = @"Arial Hebrew";
    }
    return  font;
}


+ (UIColor *) colorFromHexString:(NSString *)hexString
{
    if ( [hexString isEqualToString:@""] ) {
        return [UIColor whiteColor];
    }
    
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

+ (void) setAdjust_TextView_HeightwithFixedWidth:(UITextView *) label
{
    
    CGFloat fixedWidth = label.frame.size.width;
    CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake( fixedWidth, newSize.height);
    label.frame = newFrame;
    
}

+ (void) setAdjustHeightwithFixedWidth:(UILabel *) label
{
    CGFloat fixedWidth = label.frame.size.width;
    CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake(fixedWidth, newSize.height);
    label.frame = newFrame;
}

+ (void) setAdjustHeightFrame:(UILabel *) label
{
    
    CGFloat fixedWidth = label.frame.size.width;
    CGSize newSize = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    label.frame = newFrame;
    
}

+ (void) setAdjustWidthFrame:(UILabel *) label
{
    
    CGFloat fixedHeight = label.frame.size.height;
    CGSize newSize = [label sizeThatFits:CGSizeMake(MAXFLOAT, fixedHeight)];
    CGRect newFrame = label.frame;
    newFrame.size = CGSizeMake(newSize.width, fmaxf(newSize.height, fixedHeight));
    label.frame = newFrame;
    
}


+ (CGFloat) getFontSize:(UILabel*) label
{
    CGFloat fontSize = 60;
    [label setFont:[UIFont systemFontOfSize: fontSize]];
    
    while (fontSize > 0.0)
    {
        CGFloat fixedWidth = label.frame.size.width;
        CGSize size = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        
        if (size.height <= label.frame.size.height) break;
        
        fontSize -= 1.0;
        [label setFont:[UIFont systemFontOfSize: fontSize]];
    }
    
    while (fontSize > 0.0)
    {
        CGFloat fixedHeight = label.frame.size.height;
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, fixedHeight)];
        
        if (size.width <= label.frame.size.width) break;

        fontSize -= 1.0;
        [label setFont:[UIFont systemFontOfSize: fontSize]];
    }
    
    if ( fontSize >= 60 ) {
        fontSize = 60;
    }
    
    return fontSize;
}

+ (CGFloat) getTextViewFontSize:(UITextView*) label
{
    CGFloat fontSize = 60;
    [label setFont:[UIFont systemFontOfSize: fontSize]];
    
    while (fontSize > 0.0)
    {
        CGFloat fixedWidth = label.frame.size.width;
        CGSize size = [label sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        
        if (size.height <= label.frame.size.height) break;
        
        fontSize -= 1.0;
        [label setFont:[UIFont systemFontOfSize: fontSize]];
    }
    
    while (fontSize > 0.0)
    {
        CGFloat fixedHeight = label.frame.size.height;
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, fixedHeight)];
        
        if (size.width <= label.frame.size.width) break;
        
        fontSize -= 1.0;
        [label setFont:[UIFont systemFontOfSize: fontSize]];
    }
    
    if ( fontSize >= 60 ) {
        fontSize = 60;
    }
    
    return fontSize;
}


+ (BOOL) checkHex:(NSString*) string
{
    BOOL flag  = true;
    
    NSString *contain = @"0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm";
    if ([contain rangeOfString: string].location == NSNotFound) {
        if ( [string isEqualToString:@""] || [string isEqualToString:@"\n"] ) {
            flag  = true;
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the correctly" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
            flag  = false;
        }
    } else {
        flag  = true;
    }
    
    return flag;
    
}

+ (BOOL) checkDigit:(NSString*)string
{
    BOOL flag  = true;
    
    NSString *contain = @"0123456789.";
    if ([contain rangeOfString: string].location == NSNotFound) {
        if ( [string isEqualToString:@""] || [string isEqualToString:@"\n"] ) {
            flag  = true;
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the correct number" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
            flag  = false;
        }
    } else {
        flag  = true;
    }
    return flag;
}

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color
{
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

+ (int) GetTransitionEffectIdx:(NSString*) effect
{
    int nRet  = 500;
    
    
    if ( [effect isEqualToString: @"bounce"] ) {
        nRet = T_Bounce;
    }else if ( [effect isEqualToString: @"flash"] ){
        nRet = T_Flash;
    }else if ( [effect isEqualToString: @"pulas"] ){
        nRet = T_Pulse;
    }else if ( [effect isEqualToString: @"rubberBand" ]){
        nRet = T_RubberBand;
    }else if ( [effect isEqualToString: @"shake" ]) {
        nRet = T_Shake;
    }else if ( [effect isEqualToString: @"swing" ]) {
        nRet = T_Swing;
    }else if ( [effect isEqualToString: @"tada"] ) {
        nRet = T_Tada;
    }else if ( [effect isEqualToString: @"wobble"] ){
        nRet = T_Wobble;
    }else if ( [effect isEqualToString: @"bounceIn"]){
        nRet = T_BounceIn;
    }else if ( [effect isEqualToString: @"bounceInDown"]){
        nRet = T_BounceInDown;
    }else if ( [effect isEqualToString: @"bounceInLeft"]){
        nRet = T_BounceInLeft;
    }else if ( [effect isEqualToString: @"bounceInRight"]){
        nRet = T_BounceInRight;
    }else if ( [effect isEqualToString: @"bounceInUp"]) {
        nRet = T_BounceInUp;
    }else if ( [effect isEqualToString: @"bounceOut"]) {
        nRet = T_BounceOut;
    }else if ( [effect isEqualToString: @"bounceOutDown"]){
        nRet = T_BounceOutDown;
    }else if ( [effect isEqualToString: @"bounceOutLeft"]){
        nRet = T_BounceOutLeft;
    }else if ( [effect isEqualToString: @"bounceOutRight"]){
        nRet = T_BounceOutRight;
    }else if ( [effect isEqualToString: @"bounceOutUp"]){
        nRet = T_BounceOutUp;
    }else if ( [effect isEqualToString: @"fadeIn"]) {
        nRet = T_FadeIn;
    }else if ( [effect isEqualToString: @"fadeInDown"]){
        nRet = T_FadeInDown;
    }else if ( [effect isEqualToString: @"fadeInDownBig"]){
        nRet = T_FadeInDownBig;
    }else if ( [effect isEqualToString: @"fadeInLeft"]){
        nRet = T_FadeInLeft;
    }else if ( [effect isEqualToString: @"fadeInLeftBig"]){
        nRet = T_FadeInLeftBig;
    }else if( [effect isEqualToString: @"fadeInRight"]) {
        nRet = T_FadeInRight;
    }else if ( [effect isEqualToString: @"fadeInRightBig"]){
        nRet = T_FadeInRightBig;
    }else if ( [effect isEqualToString: @"fadeInUp"]){
        nRet = T_FadeInUp;
    }else if ( [effect isEqualToString: @"fadeInUpBig"]){
        nRet = T_FadeInUpBig;
    }
    else if ( [effect isEqualToString: @"fadeOut"]) {
        nRet = T_FadeOut;
    }else if ( [effect isEqualToString: @"fadeOutDown"]){
        nRet = T_FadeOutDown;
    }else if ( [effect isEqualToString: @"fadeOutDownBig"]){
        nRet = T_FadeOutDownBig;
    }else if ( [effect isEqualToString: @"fadeOutLeft"]) {
        nRet = T_FadeOutLeft;
    }else if ( [effect isEqualToString: @"fadeOutLeftBig"]) {
        nRet = T_FadeOutLeftBig;
    }else if ( [effect isEqualToString: @"fadeOutRight"]) {
        nRet = T_FadeOutRight;
    }
    else if ( [effect isEqualToString: @"fadeOutRightBig"]) {
        nRet = T_FadeOutRightBig;
    }
    else if ( [effect isEqualToString: @"fadeOutUp" ]) {
        nRet = T_FadeOutUp;
    }
    else if ( [effect isEqualToString: @"fadeOutUpBig"]) {
        nRet = T_FadeOutUpBig;
    }else if ( [effect isEqualToString: @"flip"]) {
        nRet = T_Flip;
    }else if ( [effect isEqualToString: @"flipInX"]) {
        nRet = T_FlipInX;
    }else if ( [effect isEqualToString: @"flipInY"]) {
        nRet = T_FlipInY;
    }else if ( [effect isEqualToString: @"flipOutX"]) {
        nRet = T_FlipOutX;
    }else if ( [effect isEqualToString: @"flipOutY"]) {
        nRet = T_FlipOutY;
    }else if ( [effect isEqualToString: @"lightSpeedIn"]) {
        nRet = T_LightSpeedIn;
    }else if ( [effect isEqualToString: @"lightSpeedOut"]) {
        nRet = T_LightSpeedOut;
    }else if ( [effect isEqualToString: @"rotateIn" ]) {
        nRet = T_RotateIn;
    }else if ( [effect isEqualToString: @"rotateInDownLeft"]) {
        nRet = T_RotateInDownLeft;
    }else if ( [effect isEqualToString: @"rotateInDownRight"]) {
        nRet = T_RotateInDownRight;
    }else if ( [effect isEqualToString: @"rotateInUpLeft"]) {
        nRet = T_RotateInUpLeft;
    }else if ( [effect isEqualToString: @"rotateInUpRight"]) {
        nRet = T_RotateInUpRight;
    }
    else if ( [effect isEqualToString: @"rotateOut"]) {
        nRet = T_RotateOut;
    }else if ( [effect  isEqualToString: @"rotateOutDownLeft"]) {
        nRet = T_RotateOutDownLeft;
    }else if ( [effect isEqualToString: @"rotateOutDownRight"]) {
        nRet = T_RotateOutDownRight;
    }else if ( [effect isEqualToString: @"rotateOutUpLeft"]) {
        nRet = T_RotateOutUpLeft;
    }else if ( [effect  isEqualToString: @"rotateOutUpRight"]) {
        nRet = T_RotateOutUpRight;
    }else if ( [effect isEqualToString: @"slideInDown"]) {
        nRet = T_ZoomInDown;
    }else if ( [effect isEqualToString: @"slideInLeft"]) {
        nRet = T_ZoomInLeft;
    }else if ( [effect isEqualToString: @"slideInRight"]) {
        nRet = T_ZoomInRight;
    }else if ( [effect isEqualToString: @"slideOutLeft"]) {
        nRet = T_ZoomOutLeft;
    }else if ( [effect isEqualToString: @"slideOutRight"]) {
        nRet = T_ZoomOutRight;
    }else if ( [effect isEqualToString: @"slideOutUp" ]) {
        nRet = T_ZoomOutUp;
    }else if ( [effect isEqualToString: @"hinge" ]) {
        nRet = T_Hinge;
    }else if ( [effect isEqualToString: @"rollin"]) {
        nRet = T_RollIn;
    }else if ( [effect isEqualToString: @"rollOut"]) {
        nRet = T_RollOut;
    }
    return  nRet;
    
}

@end
