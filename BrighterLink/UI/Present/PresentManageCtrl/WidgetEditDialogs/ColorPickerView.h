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
#import "RSColorPickerView.h"
#import "RSColorFunctions.h"
#import "RSBrightnessSlider.h"

@protocol ColorPickerDelegate <NSObject>

- (void) setFontColor:(NSString*) fontClr;


@end


@interface ColorPickerView : UIView<RSColorPickerViewDelegate, UITextFieldDelegate>
{

    
}

@property (nonatomic, weak) id<ColorPickerDelegate> delegate;

@property (nonatomic) IBOutlet RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) IBOutlet UIView *colorPatch;

@property (nonatomic) IBOutlet UITextField * m_txtR;
@property (nonatomic) IBOutlet UITextField * m_txtG;
@property (nonatomic) IBOutlet UITextField * m_txtB;
@property (nonatomic) IBOutlet UITextField * m_txtHex;

@property (nonatomic) IBOutlet UITextField * m_txtHue;
@property (nonatomic) IBOutlet UITextField * m_txtSat;
@property (nonatomic) IBOutlet UITextField * m_txtBrighter;

@property (nonatomic) IBOutlet UIButton * m_btnOK;
@property (nonatomic) IBOutlet UIButton * m_btnCancel;

@property (nonatomic) IBOutlet UIView * m_vOrigin;

- (void) setInfo:(UIColor*) color;

- (IBAction) onOk:(id)sender;
- (IBAction) onCancel:(id)sender;

@end
