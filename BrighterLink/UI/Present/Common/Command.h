//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Command : NSObject
{
    
}

+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (void) setAdjustHeightFrame:(UILabel *) label;
+ (void) setAdjustWidthFrame:(UILabel *) label;
+ (CGFloat) getFontSize:(UILabel*) label;

+ (CGFloat) getTextViewFontSize:(UITextView*) label;

+ (NSString*) checkFontName:(NSString*) font;

+ (void) setAdjustHeightwithFixedWidth:(UILabel *) label;

+ (BOOL) checkHex:(NSString*) string;
+ (BOOL) checkDigit:(NSString*)string;

+ (void) setAdjust_TextView_HeightwithFixedWidth:(UITextView *) label;

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;

+ (int) GetTransitionEffectIdx:(NSString*) effect;
@end
