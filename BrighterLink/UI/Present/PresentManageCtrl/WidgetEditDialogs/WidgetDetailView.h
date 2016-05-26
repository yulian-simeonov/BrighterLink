//
//  CISnapshotVC.h
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "ChooseAssetView.h"

// Widget Detail Sub Views
#import "EnergyDetailView.h"
#import "FrameDetailView.h"
#import "GraphDetailView.h"
#import "HowDetailView.h"
#import "ImageDetailView.h"
#import "SolarDetailView.h"
#import "TextAreaDetailView.h"
#import "WeatherDetailView.h"

#import "WeatherPropertyView.h"
#import "GraphPropertyView.h"
#import "EnergyPropertyView.h"
#import "FramePropertyView.h"
#import "HowPropertyView.h"
#import "ImagePropertyView.h"
#import "SolarPropertyView.h"
#import "TextAreaPropertyView.h"
#import "TransitionView.h"


#import "ColorPickerView.h"



@protocol WeatherDelegate;

@interface WidgetDetailView : UIViewController<JSComboDelegate, ChooseAssetViewDelegate, TransitionDelegate, UITextFieldDelegate>
{
    
    WeatherDetailView    * m_vWeather;
    GraphDetailView    * m_vGraph;
    EnergyDetailView    * m_vEnergy;
    HowDetailView    * m_vHow;
    FrameDetailView    * m_vFrame;
    ImageDetailView    * m_vImage;
    SolarDetailView    * m_vSolar;
    TextAreaDetailView    * m_vText;

    EnergyPropertyView  * m_vEnerguyProperty;
    FramePropertyView   * m_vFrameProperty;
    GraphPropertyView   * m_vGraphProperty;
    HowPropertyView     * m_vHowProperty;
    ImagePropertyView   * m_vImageProperty;
    SolarPropertyView   * m_vSolarProperty;
    TextAreaPropertyView * m_vTextAreaProperty;
    WeatherPropertyView * m_vWeatherProperty;
    
    TransitionView      * m_vTransition;
    int                   m_nTransitionType;
    
    int nType;
    
    BOOL bRow;
    BOOL bCol;
    BOOL bTransitionIn;
    BOOL bTransitionOut;
    
    //standard
    NSArray * _pickerDuration;
    NSArray *_pickerRow;
    NSArray *_pickerCol;
    NSArray *_pickerTransitionIn;
    NSArray *_pickerTransitionOut;
    
    int     m_nSelectStandardPicker;
    
    JSCombo * m_ComboDuration;
    JSCombo * m_ComboRow;
    JSCombo * m_ComboCol;
    JSCombo * m_ComboTransitionIn;
    JSCombo * m_ComboTransitionOut;

    
    BOOL  bShowProperty;
    
    
    ColorPickerView * m_vClrPicker;
    
    UIView * m_Prev;
    
    UITapGestureRecognizer *singleTap;
}

@property (nonatomic, weak) id<WeatherDelegate> delegate;


@property (nonatomic, weak) IBOutlet UIButton     * m_btnWidgetParam;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnPreview;

- (IBAction) onWidgetParam:(id)sender;
- (IBAction) onPreview:(id)sender;

@property (nonatomic, weak) IBOutlet UIScrollView * m_tempscroll;
@property (nonatomic, weak) IBOutlet UIScrollView * m_scroll;


//Custom Views
@property (nonatomic, weak) IBOutlet UIView    * m_vStandard;
@property (nonatomic, weak) IBOutlet UIView    * m_vPreview;

@property (nonatomic, weak) IBOutlet UIView    * m_vProperty;
@property (nonatomic, weak) IBOutlet UIScrollView * m_vPropertyScrll;


//Standard View Items
@property (nonatomic, weak) IBOutlet UITextField * m_txtMin;
@property (nonatomic, weak) IBOutlet UITextField * m_txtSec;
@property (nonatomic, weak) IBOutlet UITextField * m_txtDuration;
@property (nonatomic, weak) IBOutlet UITextField * m_txtRow;
@property (nonatomic, weak) IBOutlet UITextField * m_txtCol;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTransitionIn;
@property (nonatomic, weak) IBOutlet UITextField * m_txtTransitionOut;

@property (nonatomic, weak) IBOutlet UILabel  * m_txtCustom;
@property (nonatomic, weak) IBOutlet UIButton * m_btnDuration;


@property (nonatomic, weak) IBOutlet UIImageView * m_img_duration_bg;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_row_bg;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_col_bg;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_transitionIn_bg;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_transitionOut_bg;

@property (nonatomic, weak) IBOutlet UIButton * m_btn_save;
@property (nonatomic, weak) IBOutlet UIButton * m_btn_cancel;

- (IBAction) onTemp:(id)sender;

- (IBAction) onSave:(id)sender;
- (IBAction) onDuration:(id)sender;
- (IBAction) onCustom:(id)sender;
- (IBAction) onRow:(id)sender;
- (IBAction) onCol:(id)sender;
- (IBAction) onTransitionIn:(id)sender;
- (IBAction) onTransitionOut:(id)sender;


- (void) switchViews:(int) ntype;
- (void) setMode:(int) Type;


@property (nonatomic, weak) IBOutlet UIButton * m_btn_open_property;
- (IBAction) onPropertyOpen:(id)sender;
- (IBAction) onPropertyClose:(id)sender;

@end


@protocol WeatherDelegate <NSObject>

- (void)WeatherDidCloseButtonPressed:(WidgetDetailView *)popupVC;


@end