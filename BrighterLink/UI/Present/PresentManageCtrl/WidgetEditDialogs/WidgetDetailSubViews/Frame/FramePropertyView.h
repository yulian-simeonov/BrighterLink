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



@interface FramePropertyView : UIView<ColorPickerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    // weather
@public
    ColorPickerView * vClrPicker;
    int       m_FontType;

}

@property (nonatomic, weak) IBOutlet UITextField * m_txtFontSize;
@property (nonatomic, weak) IBOutlet UITextField * m_txtFontName;
@property (nonatomic, weak) IBOutlet UITextField * m_txtFontColor;
@property (nonatomic, weak) IBOutlet UITextView  * m_txtContent;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTitleBgColor;

@property (nonatomic, weak) IBOutlet UITextField * m_imgFontName;

@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr1;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClr2;

- (void) setInfo;

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
