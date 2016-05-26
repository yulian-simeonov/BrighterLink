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
#import "ChooseAssetView.h"


@interface GraphPropertyView : UIView<ColorPickerDelegate, ChooseAssetViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    int       m_nType;
    
   
    int       m_FontType;
    
@public
    UIViewController * parent;
 ColorPickerView * vClrPicker;    
}

@property (nonatomic, retain) ChooseAssetView *assetVC;


@property (nonatomic, weak) IBOutlet UITextField * m_txtBgImg;
@property (nonatomic, weak) IBOutlet UITextField * m_txtBodyBgColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleFontColor;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleFontName;
@property (nonatomic, weak) IBOutlet UITextView * m_txtTitleContent;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleBgColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelFontColor;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelGenerationGraph;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelTemperatureGraph;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelHumidityGraph;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelCurrentPowerGraph;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelMaxPowerGraph;
@property (nonatomic, weak) IBOutlet UITextField * m_txtLabelWeatherGraph;

@property (nonatomic, weak) IBOutlet UIImageView * m_imgTitleFontName;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgLabelFontName;

@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr1;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr2;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr3;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr4;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr5;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr6;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr7;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr8;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr9;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr10;


- (IBAction) onBgImage:(id)sender;
- (IBAction) onBodyBgColor:(id)sender;

- (IBAction) onTitleFontName:(id)sender;
- (IBAction) onTitleFontColor:(id)sender;
- (IBAction) onTitleBgColor:(id)sender;

- (IBAction) onLabelFontName:(id)sender;
- (IBAction) onLabelFontColor:(id)sender;
- (IBAction) onLabelGenerationGraph:(id)sender;
- (IBAction) onLabelTemperatureGraph:(id)sender;
- (IBAction) onLabelHumidityGraph:(id)sender;
- (IBAction) onLabelCurrentPowerGraph:(id)sender;
- (IBAction) onLabelMaxPowerGraph:(id)sender;
- (IBAction) onLabelWeatherGraph:(id)sender;

- (void) setInfo;

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
