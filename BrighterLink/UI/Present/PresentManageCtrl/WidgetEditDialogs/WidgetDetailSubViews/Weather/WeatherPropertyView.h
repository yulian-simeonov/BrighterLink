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
//#import "SSFlipsideViewController.h"
//#import "SSColorPicker.h"


@interface WeatherPropertyView : UIView<ColorPickerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    // weather
    int       m_nType;
    
    BOOL      m_bCurrent;
    BOOL      m_bWeather;
    BOOL      m_bMeasure;
    

    
    int      m_FontType;
    @public
    ColorPickerView * vClrPicker;
}



@property (nonatomic, weak) IBOutlet UITextField * m_txt_BodyBgColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txt_CurrentFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_CurrentFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_CurrentFontColor;

@property (nonatomic, weak) IBOutlet UITextView  * m_txt_Content;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_TitleBgColor;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_WeatherFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_WeatherFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_WeatherFontColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txt_MeasureFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_MeasureFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_MeasureFontColor;

@property (nonatomic, weak) IBOutlet UIImageView * m_img_CurrentFontName;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_WeatherFontName;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_MeasureFontName;

@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr1;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr2;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr3;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr4;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr5;

- (void) setInfo;

- (IBAction) onBodyBackgroundColor:(id)sender;
- (IBAction) onCurrentColor:(id)sender;
- (IBAction) onTitleColor:(id)sender;
- (IBAction) onMeasureColor:(id)sender;
- (IBAction) onWeatherColor:(id)sender;

- (IBAction) onCurrentFontName:(id)sender;
- (IBAction) onWeatherFontName:(id)sender;
- (IBAction) onMeasureFontName:(id)sender;

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



@end
