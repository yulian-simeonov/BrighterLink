//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWaiter.h"
#import "WebManager.h"
#import "ColorPickerView.h"



@interface SolarPropertyView : UIView<ColorPickerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    int       m_nType;
    
    BOOL      m_bTitle;
    BOOL      m_bCalcu;
    BOOL      m_bBasic;
    BOOL      m_bSupport;
    
    @public
    ColorPickerView * vClrPicker;
    int       m_FontType;

}

@property (nonatomic, weak) IBOutlet UITextField * m_txtBgImage;
@property (nonatomic, weak) IBOutlet UITextField * m_txtBodyBgColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleFontColor;
@property (nonatomic, weak) IBOutlet UITextView  * m_txtContent;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtTitleBgColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txtCalcuFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtCalcuFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txtCalcuFontColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txtBasicFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtBasicFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txtBasicFontColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txtSupportFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtSupportFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txtSupportFontColor;

@property (nonatomic, weak) IBOutlet UITextView  * m_txtSupportContent;

@property (nonatomic, weak) IBOutlet UIImageView * m_imgTitleFontName;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgCalcuFontName;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgBasicFontName;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgSupportFontName;


@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr1;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr2;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr3;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr4;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr5;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr6;

- (IBAction) onBodyBgColor:(id)sender;
- (IBAction) onTitleFontColor:(id)sender;
- (IBAction) onTitleBgColor:(id)sender;
- (IBAction) onCalcuBgColor:(id)sender;
- (IBAction) onBasicFontColor:(id)sender;
- (IBAction) onSupportFontColor:(id)sender;

- (IBAction) onBgImage:(id)sender;
- (IBAction) onTitleFontName:(id)sender;
- (IBAction) onCalcuFontName:(id)sender;
- (IBAction) onBasicFontName:(id)sender;
- (IBAction) onSupportFontName:(id)sender;



///

@property (nonatomic, weak) IBOutlet UIView * m_vFont;

- (IBAction) onBentonSans:(id)sender;
- (IBAction) onArial:(id)sender;
- (IBAction) onArialBlack:(id)sender;
- (IBAction) onComicSansMS:(id)sender;
- (IBAction) onCourierNew:(id)sender;
- (IBAction) onGeorgia:(id)sender;
- (IBAction) onImpact:(id)sender;
- (IBAction) onLucidaSansUnicode:(id)sender;
- (IBAction) onTahoma:(id)sender;
- (IBAction) onTimesNewRoman:(id)sender;
- (IBAction) onTrebuchetMS:(id)sender;
- (IBAction) onVerdana:(id)sender;

- (void) setInfo;



@end
