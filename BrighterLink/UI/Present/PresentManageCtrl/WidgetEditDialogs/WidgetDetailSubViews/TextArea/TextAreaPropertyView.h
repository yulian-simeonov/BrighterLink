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


@interface TextAreaPropertyView : UIView<ColorPickerDelegate, ChooseAssetViewDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    
  
    int       m_FontType;
    
@public
    ColorPickerView * vClrPicker;    
    UIViewController * parent;
    
}


@property (nonatomic, retain) ChooseAssetView *assetVC;

@property (nonatomic, weak) IBOutlet UITextField * m_txtBgImg;
@property (nonatomic, weak) IBOutlet UITextField * m_txtBodyBgColor;

@property (nonatomic, weak) IBOutlet UITextField * m_txtFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txtFontColor;
@property (nonatomic, weak) IBOutlet UITextView  * m_txtContent;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleBgColor;
@property (nonatomic, weak) IBOutlet UITextField * m_imgFontName;

@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr1;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr2;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr3;

- (void) setInfo;

- (IBAction) onBgImg:(id)sender;
- (IBAction) onBodyBgColor:(id)sender;

- (IBAction) onFontName:(id)sender;
- (IBAction) onFontColor:(id)sender;
- (IBAction) onTitleBgColor:(id)sender;

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
