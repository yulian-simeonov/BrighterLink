//
//  CISnapshotVC.m
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import "WidgetDetailView.h"
#import "PresentationInfo.h"
#import "SharedMembers.h"
#import "UIViewController+CWPopup.h"

#import "EnergyView.h"
#import "WeatherView.h"
#import "GraphView.h"
#import "GraphInfo.h"
#import "EnergyInfo.h"
#import "SolarView.h"
#import "iFrameView.h"
#import "WidgetImageView.h"
#import "SolarInfo.h"
#import "HowPreview.h"
#import "TextAreaView.h"

#import "TransitionManager.h"
#import "TransitionView.h"

#import "Command.h"

#import <CoreText/CoreText.h>


#define BIG_BUTTON_Y        43
#define BIG_BUUTON_HEIGHT   53
#define SMALL_BUTTON_Y      54
#define SMALL_BUTTON_HEIGHT 42

#define SCROLL_HEIGHT       373
#define SCROLL_WIDTH        465

@interface WidgetDetailView ()

typedef enum:int {
    P_WEATHER = 0,
    P_GRAPH,
    P_ENERGY,
    P_HOW,
    P_iFRAME,
    P_IMAGE,
    P_SOLAR,
    P_TEXT,
} PWIDGET_TYPE;


@end

@implementation WidgetDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //temp code
    bShowProperty = false;
    ////////////////////////
    
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherDetailView" owner:self options:nil];
    m_vWeather = [nib objectAtIndex:0];
    [_m_scroll addSubview: m_vWeather];
    [m_vWeather setFrame:CGRectMake(0, 0, m_vWeather.frame.size.width, m_vWeather.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"GraphDetailView" owner:self options:nil];
    m_vGraph = [nib objectAtIndex:0];

    [_m_scroll addSubview: m_vGraph];
    [m_vGraph setFrame:CGRectMake(0, 0, m_vGraph.frame.size.width, m_vGraph.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"EnergyDetailView" owner:self options:nil];
    m_vEnergy = [nib objectAtIndex:0];
    [_m_scroll addSubview: m_vEnergy];
    [m_vEnergy setFrame:CGRectMake(0, 0, m_vEnergy.frame.size.width, m_vEnergy.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"HowDetailView" owner:self options:nil];
    m_vHow = [nib objectAtIndex:0];
    [_m_scroll addSubview: m_vHow];
    [m_vHow setFrame:CGRectMake(0, 0, m_vHow.frame.size.width, m_vHow.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"FrameDetailView" owner:self options:nil];
    m_vFrame = [nib objectAtIndex:0];
    [_m_scroll addSubview: m_vFrame];
    [m_vFrame setFrame:CGRectMake(0, 0, m_vFrame.frame.size.width, m_vFrame.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"ImageDetailView" owner:self options:nil];
    m_vImage = [nib objectAtIndex:0];
    m_vImage->parent  = self;
    [_m_scroll addSubview: m_vImage];
    [m_vImage setFrame:CGRectMake(0, 0, m_vImage.frame.size.width, m_vImage.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"SolarDetailView" owner:self options:nil];
    m_vSolar = [nib objectAtIndex:0];
    [_m_scroll addSubview: m_vSolar];
    [m_vSolar setFrame:CGRectMake(0, 0, m_vSolar.frame.size.width, m_vSolar.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"TextAreaDetailView" owner:self options:nil];
    m_vText = [nib objectAtIndex:0];
    [_m_scroll addSubview: m_vText];
    [m_vText setFrame:CGRectMake(0, 0, m_vText.frame.size.width, m_vText.frame.size.height)];
    
    [_m_tempscroll addSubview: _m_vPreview];
    [_m_vPreview setFrame:CGRectMake(0, 71, _m_vPreview.frame.size.width, _m_vPreview.frame.size.height)];
    
    _m_btn_save.layer.cornerRadius  =5.0f;
    _m_btn_cancel.layer.cornerRadius  =5.0f;
    
    bRow = false; bCol  = false; bTransitionOut  = false; bTransitionIn  = false; m_nSelectStandardPicker = 0;
    
    _pickerDuration = @[@"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20"];
    _pickerCol = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16"];
    _pickerRow = @[@"2", @"3", @"4", @"5", @"6", @"7"];
    _pickerTransitionIn = @[@"-- Choose Transition In --", //0,1,10,16, 22, 32, 42, 48, 51, 57, 63, 70
                            @"Attention Seekers", //1
                                @"  bounce", @" flash", @"  pulas", @"  rubberBand", @" shake", @"  swing", @"  tada", @"   wobble",
                            @"Bouncing Entrances", //10
                                @"  bounceIn", @" bounceInDown", @"    bounceInLeft", @"   bounceInRight", @" bounceInUp",
                            @"Bouncing Exits", //16
                                @"  bounceOut", @"  bounceOutDown", @"  bounceOutLeft", @"  bounceOutRight", @" bounceOutUp",
                            @"Fading Entrances", //22
                                @"  fadeIn", @" fadeInDown", @" fadeInDownBig", @"  fadeInLeft", @" fadeInLeftBig", @"	fadeInRight", @"    fadeInRightBig", @" fadeInUp", @"   fadeInUpBig",
                            @"Fading Exits", //32
                                @"  fadeOut", @"    fadeOutDown", @"    fadeOutDownBig", @" fadeOutLeft", @"    fadeOutLeftBig", @" fadeOutRight", @"   fadeOutRightBig", @"    fadeOutUp", @" fadeOutUpBig",
                            @"Flippers", //42
                                @"  flip", @"   flipInX", @"    flipInY", @"    flipOutX", @"   flipOutY",
                            @"Lightspeed", //48
                                @"  lightSpeedIn", @"   lightSpeedOut",
                            @"Rotating Entrances", //51
                                @"  rotateIn", @"   rotateInDownLeft", @"   rotateInDownRight", @"  rotateInUpLeft", @" rotateInUpRight",
                            @"Rotating Exits", //57
                                @"  rotateOut", @"  rotateOutDownLeft", @"  rotateOutDownRight", @" rotateOutUpLeft", @"    rotateOutUpRight",
                            @"Sliders", //63
                                @"  slideInDown", @"	slideInLeft", @"	slideInRight", @"   slideOutLeft", @"	slideOutRight", @"	slideOutUp",
                            @"Specials", //70
                                @"  hinge", @"	rollIn", @" rollOut"];
    
    
    m_ComboRow = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_row_bg.frame.origin.x, _m_img_row_bg.frame.origin.y + _m_img_row_bg.frame.size.height, _m_img_row_bg.frame.size.width, 100)];
    [m_ComboRow setDelegate:self];
    
    NSMutableArray* data = [[NSMutableArray alloc] init];
    for( int i = 0; i < [_pickerRow count]; i++ )
        [ data addObject:@{@"text" : _pickerRow[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboRow UpdateData:data];
    [_m_vStandard addSubview:m_ComboRow];
    
    NSMutableArray* dataDuration = [[NSMutableArray alloc] init];
    m_ComboDuration = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_duration_bg.frame.origin.x, _m_img_duration_bg.frame.origin.y + _m_img_duration_bg.frame.size.height, _m_img_duration_bg.frame.size.width, 100)];
    [m_ComboDuration setDelegate:self];
    
    for( int i = 0; i < [_pickerDuration count]; i++ )
        [ dataDuration addObject:@{@"text" : _pickerDuration[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboDuration UpdateData:dataDuration];
    [_m_vStandard addSubview:m_ComboDuration];
    
    NSMutableArray* data1 = [[NSMutableArray alloc] init];
    m_ComboCol = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_col_bg.frame.origin.x, _m_img_col_bg.frame.origin.y + _m_img_col_bg.frame.size.height, _m_img_col_bg.frame.size.width, 100)];
    [m_ComboCol setDelegate:self];
    
    for( int i = 0; i < [_pickerCol count]; i++ )
        [ data1 addObject:@{@"text" : _pickerCol[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboCol UpdateData:data1];
    [_m_vStandard addSubview:m_ComboCol];


    NSMutableArray* data2 = [[NSMutableArray alloc] init];
    m_ComboTransitionIn = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_transitionIn_bg.frame.origin.x, _m_img_transitionIn_bg.frame.origin.y + _m_img_transitionIn_bg.frame.size.height, _m_img_transitionIn_bg.frame.size.width, 100)];
    [m_ComboTransitionIn setDelegate:self];
    
    for( int i = 0; i < [_pickerTransitionIn count]; i++ )
        [ data2 addObject:@{@"text" : _pickerTransitionIn[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboTransitionIn UpdateData:data2];
    [_m_vStandard addSubview:m_ComboTransitionIn];

    
    NSMutableArray* data3 = [[NSMutableArray alloc] init];
    m_ComboTransitionOut = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_transitionOut_bg.frame.origin.x, _m_img_transitionOut_bg.frame.origin.y + _m_img_transitionOut_bg.frame.size.height, _m_img_transitionOut_bg.frame.size.width, 100)];
    [m_ComboTransitionOut setDelegate:self];
    
    for( int i = 0; i < [_pickerTransitionIn count]; i++ )
        [ data3 addObject:@{@"text" : _pickerTransitionIn[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboTransitionOut UpdateData:data3];
    [_m_vStandard addSubview:m_ComboTransitionOut];
    
    
    nType = 0;
    [self onWidgetParam:nil];
    
    [_m_tempscroll addSubview: _m_vProperty];
    
    [_m_vProperty setFrame:CGRectMake( self.view.frame.size.width- _m_btn_open_property.frame.size.width , 0, _m_vProperty.frame.size.width, _m_vProperty.frame.size.height)];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherPropertyView" owner:self options:nil];
    m_vWeatherProperty = [nib objectAtIndex:0];
    [m_vWeatherProperty setFrame:CGRectMake(0, 0, m_vWeatherProperty.frame.size.width, m_vWeatherProperty.frame.size.height)];
    [_m_vPropertyScrll addSubview:m_vWeatherProperty];
    [m_vWeatherProperty setHidden: true];

    nib = [[NSBundle mainBundle] loadNibNamed:@"EnergyPropertyView" owner:self options:nil];
    m_vEnerguyProperty = [nib objectAtIndex:0];
    [m_vEnerguyProperty setFrame:CGRectMake(0, 0, m_vEnerguyProperty.frame.size.width, m_vEnerguyProperty.frame.size.height)];
    [_m_vPropertyScrll addSubview: m_vEnerguyProperty];
    m_vEnerguyProperty->parent  = self;
    [m_vEnerguyProperty setHidden:true];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"GraphPropertyView" owner:self options:nil];
    m_vGraphProperty = [nib objectAtIndex:0];
    [m_vGraphProperty setFrame:CGRectMake(0, 0, m_vGraphProperty.frame.size.width, m_vGraphProperty.frame.size.height)];
    m_vGraphProperty->parent  = self;
    [_m_vPropertyScrll addSubview: m_vGraphProperty];
    [m_vGraphProperty setHidden:true];

    nib = [[NSBundle mainBundle] loadNibNamed:@"FramePropertyView" owner:self options:nil];
    m_vFrameProperty = [nib objectAtIndex:0];
    [m_vFrameProperty setFrame:CGRectMake(0, 0, m_vFrameProperty.frame.size.width, m_vFrameProperty.frame.size.height)];
    [_m_vPropertyScrll addSubview: m_vFrameProperty];
    [m_vFrameProperty setHidden:true];

    nib = [[NSBundle mainBundle] loadNibNamed:@"HowPropertyView" owner:self options:nil];
    m_vHowProperty = [nib objectAtIndex:0];
    [m_vHowProperty setFrame:CGRectMake(0, 0, m_vHowProperty.frame.size.width, m_vHowProperty.frame.size.height)];
    [_m_vPropertyScrll addSubview: m_vHowProperty];
    [m_vHowProperty setHidden:true];
   
    nib = [[NSBundle mainBundle] loadNibNamed:@"ImagePropertyView" owner:self options:nil];
    m_vImageProperty = [nib objectAtIndex:0];
    [m_vImageProperty setFrame:CGRectMake(0, 0, m_vImageProperty.frame.size.width, m_vImageProperty.frame.size.height)];
    [_m_vPropertyScrll addSubview: m_vImageProperty];
    [m_vImageProperty setHidden:true];

    nib = [[NSBundle mainBundle] loadNibNamed:@"SolarPropertyView" owner:self options:nil];
    m_vSolarProperty = [nib objectAtIndex:0];
    [m_vSolarProperty setFrame:CGRectMake(0, 0, m_vSolarProperty.frame.size.width, m_vSolarProperty.frame.size.height)];
    [_m_vPropertyScrll addSubview: m_vSolarProperty];
    [m_vSolarProperty setHidden:true];

    nib = [[NSBundle mainBundle] loadNibNamed:@"TextAreaPropertyView" owner:self options:nil];
    m_vTextAreaProperty = [nib objectAtIndex:0];
    [m_vTextAreaProperty setFrame:CGRectMake(0, 0, m_vTextAreaProperty.frame.size.width, m_vTextAreaProperty.frame.size.height)];
    m_vTextAreaProperty->parent  = self;
    [_m_vPropertyScrll addSubview: m_vTextAreaProperty];
    [m_vTextAreaProperty setHidden:true];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"TransitionView" owner:self options:nil];
    m_vTransition = [nib objectAtIndex:0];
    [m_vTransition setFrame:CGRectMake(0, 0, m_vTransition.frame.size.width, m_vTransition.frame.size.height)];
    m_vTransition.center  = self.view.center;
    [self.view addSubview: m_vTransition];
    [m_vTransition setHidden:true];
    [m_vTransition setDelegate:self];
    m_vTransition.layer.cornerRadius = 10.0f;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveComboHidden:)
                                                 name:@"ReceiveComboHidden"
                                               object:nil];

    _m_txtMin.tag = 1;  [_m_txtMin setDelegate:self];
    _m_txtSec.tag = 2;   [_m_txtSec setDelegate:self];
    _m_txtDuration.tag = 3; [_m_txtDuration setDelegate:self];
    
}

- (void) receiveComboHidden:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    [m_vTransition setHidden: true];
    
    [m_ComboDuration setHidden:true];
    [m_ComboRow setHidden: true];
    [m_ComboCol setHidden: true];
    [m_ComboTransitionIn setHidden: true];
    [m_ComboTransitionOut setHidden: true];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [m_vTransition setHidden: true];
    
    [m_ComboDuration setHidden:true];
    [m_ComboRow setHidden: true];
    [m_ComboCol setHidden: true];
    [m_ComboTransitionIn setHidden: true];
    [m_ComboTransitionOut setHidden: true];
    
    [_m_scroll removeGestureRecognizer: gesture];
}

- (void) setMode:(int) Type
{
    bShowProperty = false;
    
     [_m_vProperty setFrame:CGRectMake( self.view.frame.size.width- _m_btn_open_property.frame.size.width , 0, _m_vProperty.frame.size.width, _m_vProperty.frame.size.height)];
    [_m_btn_open_property setImage:[UIImage imageNamed:@"btn_property_open.png"] forState:UIControlStateNormal];
    
    if ( Type == 0 ) {
        [self onWidgetParam:nil];
    }
    else{
        [self onPreview:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    
    if([control isEqual:m_ComboDuration])
    {
        [_m_txtDuration setText:[obj objectForKey:@"text"]];
        
        NSString * row  = _m_txtDuration.text;
        info.param.duration = [NSNumber numberWithInt: [row intValue]];
    }
    
    if([control isEqual:m_ComboRow])
    {
        [_m_txtRow setText:[obj objectForKey:@"text"]];
        
        NSString * row  = _m_txtRow.text;
        info.param.rowCount = [NSNumber numberWithInt: [row intValue]];
    }
    else if([control isEqual:m_ComboCol])
    {
        [_m_txtCol setText:[obj objectForKey:@"text"]];
        NSString * col  = _m_txtCol.text;
        info.param.colCount = [NSNumber numberWithInt: [col intValue]];
    }
    else if([control isEqual:m_ComboTransitionIn])
    {
        //0,1,10,16, 22, 32, 42, 48, 51, 57, 63, 70
        int n = [[obj objectForKey:@"id"] intValue];
        if ( n == 0 || n == 1 || n == 10 || n == 16 || n == 22 || n == 32 || n == 42 || n == 48 || n == 51 || n == 57 || n == 63 || n == 70 ) {
        }
        else
            [_m_txtTransitionIn setText:[obj objectForKey:@"text"]];
    }
    else if ([control isEqual:m_ComboTransitionOut])
    {
        int n = [[obj objectForKey:@"id"] intValue];
        if ( n == 0 || n == 1 || n == 10 || n == 16 || n == 22 || n == 32 || n == 42 || n == 48 || n == 51 || n == 57 || n == 63 || n == 70 ) {
        }
        else
            [_m_txtTransitionOut setText:[obj objectForKey:@"text"]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//   _snapshotIV.image = _snapshotImage;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (IBAction)closeBtnPressed:(id)sender {
    id<WeatherDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(WeatherDidCloseButtonPressed:)]) {
        [strongDelegate WeatherDidCloseButtonPressed:self];
    }
}

- (void) switchViews:(int) ntype
{
    
    nType = ntype;
    
    [m_vWeather setHidden:true];
    [m_vGraph setHidden:true];
    [m_vEnergy setHidden:true];
    [m_vHow setHidden:true];
    [m_vFrame setHidden:true];
    [m_vImage setHidden:true];
    [m_vSolar setHidden:true];
    [m_vText setHidden: true];
    
    float height = 0.0f;
    switch ( ntype) {
        case P_WEATHER:
        {
            [m_vWeather setHidden:false];
            height = m_vWeather.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
            
            
        }
            break;
        case P_GRAPH:
        {
            [m_vGraph setHidden:false];
            height = m_vGraph.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
        }
            break;
        case  P_ENERGY:
        {
            [m_vEnergy setHidden:false];
            height = m_vEnergy.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
        }
            break;
        case  P_HOW:
        {
            [m_vHow setHidden:false];
            height = m_vHow.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
        }
            break;
        case  P_iFRAME:
        {
            [m_vFrame setHidden:false];
            height = m_vFrame.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
        }
            break;
        case  P_IMAGE:
        {
            [m_vImage setHidden:false];
            height = m_vImage.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
        }
            break;
        case  P_SOLAR:
        {
            [m_vSolar setHidden:false];
            height = m_vSolar.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
        }
            break;
        case P_TEXT:
        {
            [m_vText setHidden: false];
            height = m_vText.frame.size.height;
            if ( SCROLL_HEIGHT < height ) {
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, height + 100)];
            }
            else
                [_m_scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT)];
        }
            break;
        default:
            break;
    }

    [self setWidgetInfo];
}

//standard
- (IBAction) onCustom:(id)sender
{
    if ( [_m_txtCustom.text isEqualToString: @"Custom"] ) {
        _m_txtCustom.text = @"Select";
        [_m_btnDuration setHidden:true];
        [_m_img_duration_bg setImage:[UIImage imageNamed:@"textfield_medium.png"]];
        
        [m_ComboDuration setHidden:true];
        [m_ComboRow setHidden: true];
        [m_ComboCol setHidden: true];
        [m_ComboTransitionIn setHidden: true];
        [m_ComboTransitionOut setHidden: true];
        
    }else{
        _m_txtCustom.text = @"Custom";
        [_m_btnDuration setHidden:false];
        [_m_img_duration_bg setImage:[UIImage imageNamed:@"textfield_spin.png"]];
    }
}

- (IBAction) onDuration:(id)sender
{
    if ( !m_ComboCol.isHidden || !m_ComboTransitionIn.isHidden || !m_ComboTransitionOut.isHidden || !m_ComboRow.isHidden) {
        return;
    }
    
    if ( m_ComboDuration.isHidden ) {
        [m_ComboDuration setHidden: false];
    }
    else
    {
        [m_ComboDuration setHidden: true];
    }
}

- (IBAction) onRow:(id)sender
{
    if ( !m_ComboCol.isHidden || !m_ComboTransitionIn.isHidden || !m_ComboTransitionOut.isHidden ) {
        return;
    }
    
    if ( m_ComboRow.isHidden ) {
        [m_ComboRow setHidden: false];
    }
    else
    {
        [m_ComboRow setHidden: true];
    }
}

- (IBAction) onCol:(id)sender
{
    if ( !m_ComboRow.isHidden || !m_ComboTransitionIn.isHidden || !m_ComboTransitionOut.isHidden ) {
        return;
    }
    
    if ( m_ComboCol.isHidden ) {
        [m_ComboCol setHidden: false];
//        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
//        [_m_scroll addGestureRecognizer:singleTap];

    }
    else{
        [m_ComboCol setHidden: true];
//        [_m_scroll removeGestureRecognizer:singleTap];
    }
}

- (IBAction) onTransitionIn:(id)sender
{
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_m_scroll addGestureRecognizer:singleTap];
    
    m_nTransitionType  = 0;
    [m_vTransition setHidden: false];

    [m_vTransition setEffect: _m_txtTransitionIn.text];
}

- (IBAction) onTransitionOut:(id)sender
{
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_m_scroll addGestureRecognizer:singleTap];

    m_nTransitionType  = 1;
    [m_vTransition setHidden: false];
    [m_vTransition setEffect: _m_txtTransitionOut.text];
}

- (void) setWidgetInfo
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    //standard
    //Standard View Items
    NSString * startPoint  = info.param.startDate;
    if ( [startPoint isEqualToString:@""] ) {
        [_m_txtMin setText:@"0"];
        [_m_txtSec setText: @"0"];
    }
    else{
        NSArray *  arr = [startPoint componentsSeparatedByString:@":"];
        if ( [arr[0] isEqualToString:@""] ) {
            [_m_txtMin setText:@"0"];
        }
        else
        [_m_txtMin setText: arr[0]];
        
        if( [arr[1] isEqualToString:@""] )
            [_m_txtSec setText: @"0"];
        else
        [_m_txtSec setText: arr[1]];
    }
    
    [_m_txtDuration setText:[NSString stringWithFormat:@"%d", [info.param.duration intValue] ]] ;

    [_m_txtRow setText: [NSString stringWithFormat:@"%d", [info.param.rowCount intValue] ]];
    [_m_txtCol setText:  [NSString stringWithFormat:@"%d", [info.param.colCount intValue] ]];
    
    [_m_txtTransitionIn setText: info.param.transitionIn];
    [_m_txtTransitionOut setText: info.param.transitionOut];
    
    switch ( nType ) {
        case P_WEATHER:
        {
            [ m_vWeather.m_txtWeatherType setText: info.param.widgetWeatherType];
        }
            break;
        case P_GRAPH:
        {
            [ m_vGraph.m_txtGraph_Interval setText: info.param.widgetGraphInterval];
            [ m_vGraph.m_txtGraph_DateRange setText: info.param.widgetGraphDateRange];
            
            BOOL bflag  = [info.param.widgetGraphGeneration boolValue];
            if ( bflag ) {
                [ m_vGraph.m_btnGraph_Generation setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else{
                [m_vGraph.m_btnGraph_Generation setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
            }

            [ m_vGraph.m_txtGraph_Generation_ChatType setText: info.param.widgetGraphGenerationChartType];
            
            bflag = [info.param.widgetGraphTemperature boolValue];
            if ( bflag ) {
                [m_vGraph.m_btnGraph_Temperature setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else{
                [m_vGraph.m_btnGraph_Temperature setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
            }
                

            [m_vGraph.m_txtGraph_Temperature_ChatType setText: info.param.wIdgetGraphTemperatureChartType];
            
            bflag = [info.param.widgetGraphHumidity boolValue];
            if ( bflag ) {
                [m_vGraph.m_btnGraph_Humidity setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else{
                [m_vGraph.m_btnGraph_Humidity setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
            }

            [m_vGraph.m_txtGraph_Humidity setText: info.param.widgetGraphHumidityChartType];
            
            bflag = [info.param.widgetGraphCurrentPower boolValue];
            if ( bflag ) {
                [m_vGraph.m_btnGraph_Current setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else
                [m_vGraph.m_btnGraph_Current setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
            [m_vGraph.m_txtGraph_Current setText: info.param.widgetGraphCurrentPowerChartType];
            
            bflag = [info.param.widgetGraphMaxPower boolValue];
            if ( bflag ) {
                [m_vGraph.m_btnGraph_Max setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else
                [m_vGraph.m_btnGraph_Max setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];

            [m_vGraph.m_txtGraph_Max setText: info.param.widgetGraphMaxPowerChartType ];
        }
            break;
            
        case  P_ENERGY:
        {
            [m_vEnergy.m_txtEnergy_Orientation setText: info.param.widgetEnergyOrientation];
            
            [m_vEnergy.m_txtEnergy_Type setText: info.param.widgetEnergyType];
            [m_vEnergy.m_txtEnergy_DateRange setText: info.param.widgetEnergyDateRange];
            BOOL bflag  = [info.param.widgetEnergyCO2Kilograms boolValue];
            if ( bflag ) {
                [m_vEnergy.m_btnCO2 setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else
                [m_vEnergy.m_btnCO2 setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];

            bflag = [info.param.widgetEnergyGreenhouseKilograms boolValue];
            if ( bflag ) {
                [m_vEnergy.m_btnGreenhouse setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else
                [m_vEnergy.m_btnGreenhouse setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];

        }
            break;
        case  P_HOW:
        {
            [m_vHow.m_txtVHow_One setText: info.param.widgetHowDoesSolarWorkStepOneText];
            [m_vHow.m_txtHow_One setText: [NSString stringWithFormat:@"%d", [info.param.widgetHowDoesSolarWorkStepOneDuration intValue]]];
            [m_vHow.m_txtVHow_Two setText: info.param.widgetHowDoesSolarWorkStepTwoText];
            [m_vHow.m_txtHow_Two setText: [NSString stringWithFormat:@"%d", [info.param.widgetHowDoesSolarWorkStepTwoDuration intValue]]];
            [m_vHow.m_txtVHow_Three setText: info.param.widgetHowDoesSolarWorkStepThreeText];
            [m_vHow.m_txtHow_Three setText: [NSString stringWithFormat:@"%d", [info.param.widgetHowDoesSolarWorkStepThreeDuration intValue] ]];
            [m_vHow.m_txtVHow_Four setText: info.param.widgetHowDoesSolarWorkStepFourText];
            [m_vHow.m_txtHow_Four setText: [NSString stringWithFormat:@"%d", [info.param.widgetHowDoesSolarWorkStepFourDuration intValue] ]];
        }
            break;
        case  P_iFRAME:
        {
            [m_vFrame.m_txtFrame_URL setText: info.param.widgetIFrameUrl];
        }
            break;
        case  P_IMAGE:
        {
            [ m_vImage.m_txtImage_URL setText: info.param.widgetURL];
        }
            break;
        case  P_SOLAR:
        {
            [ m_vSolar.m_txtVSolar_DataRange setText: info.param.widgetSolarGenerationDateRange];
            [ m_vSolar.m_txtVSolar_Orientation setText:info.param.widgetSolarGenerationOrientation];

            BOOL bflag = [info.param.widgetSolarGenerationCurrent boolValue];
            if ( bflag ) {
                [ m_vSolar.m_btnSolar_Current setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else
                [ m_vSolar.m_btnSolar_Current setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];

            bflag = [info.param.widgetSolarGenerationkWh boolValue];
            if ( bflag ) {
                [ m_vSolar.m_btnSolar_kWh setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else
                [ m_vSolar.m_btnSolar_kWh setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];

            bflag  = [info.param.widgetSolarGenerationReimbursement boolValue];
            if ( bflag ) {
                [ m_vSolar.m_btnSolar_Reimbursement setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
            }
            else
                [ m_vSolar.m_btnSolar_Reimbursement setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];

        }
            break;
        case P_TEXT:
        {
            [m_vText SetText: info.param.widgetTextareaContent];
        }
            break;
        default:
            break;
    }
}

- (IBAction) onWidgetParam:(id)sender
{
    float oriX  = _m_btnWidgetParam.frame.origin.x;
    float sizeX = _m_btnWidgetParam.frame.size.width;
    
    [_m_btnWidgetParam setFrame:CGRectMake( oriX, 15, sizeX, 42)];
    [_m_btnWidgetParam setBackgroundImage:[UIImage imageNamed:@"btn_choose_highlight.png"] forState:UIControlStateNormal];
    
    oriX = _m_btnPreview.frame.origin.x;
    [_m_btnPreview setFrame:CGRectMake( oriX, 25, sizeX, 32)];
    [_m_btnPreview setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];
    
    [_m_vPreview setHidden: true];
}

- (IBAction) onPreview:(id)sender
{
    float oriX  = _m_btnPreview.frame.origin.x;
    float sizeX = _m_btnPreview.frame.size.width;
    
    [_m_btnPreview setFrame:CGRectMake( oriX, 15, sizeX, 42)];
    [_m_btnPreview setBackgroundImage:[UIImage imageNamed:@"btn_choose_highlight.png"] forState:UIControlStateNormal];
    
    oriX = _m_btnWidgetParam.frame.origin.x;
    [_m_btnWidgetParam setFrame:CGRectMake( oriX, 25, sizeX, 32)];
    [_m_btnWidgetParam setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];
    
    [self showPreview];
}

- (void) showPreview
{
    for ( UIView * v in [_m_vPreview subviews] ) {
        [v removeFromSuperview];
    }
    PresentationInfo * present = [SharedMembers sharedInstance].curPresent;
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    int col = [info.param.colCount intValue];
    int row  = [info.param.rowCount intValue];
    
    NSString * name = info.name;
    
    for ( UIView * v in [_m_vPreview subviews] ) {
        [v removeFromSuperview];
    }
    [_m_vPreview setHidden:false];
    
    if ( [name isEqualToString:@"Graph"] )
    {
     
        [JSWaiter ShowWaiter:self.view title:@"" type:0];
        [[SharedMembers sharedInstance].webManager GetGraphWidget: present._id Object:info._id success:^(MKNetworkOperation *networkOperation)
        {
            
            NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            GraphInfo *  graph  = [[GraphInfo alloc] init];
            [graph SetGraphInfoDic: dic];
            
             info->graph  = graph;
             
            GraphView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"GraphView" owner:self options:nil];
            view = [nib objectAtIndex:0];
            [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
            view.center  = CGPointMake(_m_vPreview.center.x, view.center.y);
             [view  setInfo: graph Widget:info generation:[info.param.widgetGraphGeneration boolValue] maxPower:[info.param.widgetGraphMaxPower boolValue]];
            [_m_vPreview addSubview: view];
            
            [JSWaiter HideWaiter];
            
            m_Prev = view;
             
             int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
            [TransitionManager SetData:view transitionType: idx];
            
             int dur = [info.param.duration intValue];
             
             [NSTimer scheduledTimerWithTimeInterval: dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            [JSWaiter HideWaiter];
        }];
        
    }
    else if ( [name isEqualToString:@"Weather"]){
        
        
        [JSWaiter ShowWaiter:self.view title:@"" type:0];
        [[SharedMembers sharedInstance].webManager GetWeatherWidget: present._id success:^(MKNetworkOperation *networkOperation) {
            NSLog(@"%@", networkOperation.responseJSON);
            NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            WeatherInfo  * weather  = [[WeatherInfo alloc] init];
            
            NSDictionary * dicCurrent  = [dic objectForKey: @"currently"];
            [weather setDictionary: dicCurrent];
            
            
            NSDictionary * dicDaily  = [dic objectForKey: @"daily"];
            NSArray      * datas  = [dicDaily objectForKey:@"data"];
            
            for ( int i = 0; i < [datas count]; i++ ) {
                NSDictionary * dicData  = [datas objectAtIndex:i];
                WeatherDataInfo * weatherData  = [[WeatherDataInfo alloc] init];
                [weatherData setDictionary: dicData];
                
                [weather.data addObject: weatherData];
            }
        
            info->weather  = weather;
            
            WeatherView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
            view = [nib objectAtIndex:0];
            [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
            [view setRefresh:weather Col:col Row:row];
            [view resizeAllSubview:view.frame];
            view.center  = CGPointMake(_m_vPreview.center.x, view.center.y);
            
            [_m_vPreview addSubview: view];
            
            m_Prev = view;
            int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
            [TransitionManager SetData:view transitionType: idx];
            
            int dur = [info.param.duration intValue];
            [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
            [JSWaiter HideWaiter];
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            [JSWaiter HideWaiter];
        }];
        
    }
    else if ( [name isEqualToString:@"Energy Equivalencies"]){
        
        [JSWaiter ShowWaiter:self.view title:@"" type:0];
        
        [[SharedMembers sharedInstance].webManager GetEnergyWidget:present._id Object:info._id success:^(MKNetworkOperation *networkOperation) {
            
            NSLog(@"%@", networkOperation.responseJSON);
            
            NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            EnergyInfo *  energy  = [[EnergyInfo alloc] init];
            [energy setDictionary: dic];
            
            info->energy  = energy;
            
            EnergyView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil];
            view = [nib objectAtIndex:0];
            [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
            [view setRefresh: energy];
            [view resizeAllSubview:view.frame];
            view.center  = CGPointMake(_m_vPreview.center.x, view.center.y);
            
            [_m_vPreview addSubview: view];
            m_Prev = view;
            
            int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
            [TransitionManager SetData:view transitionType: idx];
            
            int dur = [info.param.duration intValue];
            [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
            
            [JSWaiter HideWaiter];
        } failure:^(MKNetworkOperation *errorOp, NSError *error)
         {
            [JSWaiter HideWaiter];
         }];
    }
    else if ( [name isEqualToString:@"How Does Solar Work"]){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"HowPreview" owner:self options:nil];
            HowPreview* vw = [nib objectAtIndex:0];
            [vw SetTexts:@[ info.param.widgetHowDoesSolarWorkStepOneText , info.param.widgetHowDoesSolarWorkStepTwoText, info.param.widgetHowDoesSolarWorkStepThreeText, info.param.widgetHowDoesSolarWorkStepFourText]];
            [vw setFrame:CGRectMake(0, -12, col * 42.f, row * 42.0f)];
            vw.center  = CGPointMake(_m_vPreview.center.x, vw.center.y);
        [vw setInfo];
            [_m_vPreview addSubview: vw];
        [vw StartAnimation];
        
            m_Prev = vw;
            
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
            [TransitionManager SetData:vw transitionType: idx];
        int dur = [info.param.duration intValue];
        [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
    }
    else if ( [name isEqualToString:@"iFrame"]){
        iFrameView * view;
        info.param.widgetIFrameUrl =  m_vFrame.m_txtFrame_URL.text;
        
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"iFrameView" owner:self options:nil];
        view = [nib objectAtIndex:0];
        [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
        [view resizeAllSubview:view.frame url: info.param.widgetIFrameUrl];
        view.center  = CGPointMake(_m_vPreview.center.x, view.center.y);
        [view setRefresh];
        [_m_vPreview addSubview: view];
        
        m_Prev  = view;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
        [TransitionManager SetData:view transitionType: idx];
        int dur = [info.param.duration intValue];
        [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
    }
    else if ( [name isEqualToString:@"Image"] ){
        WidgetImageView * view;
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WidgetImageView" owner:self options:nil];
        view = [nib objectAtIndex:0];
        [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
        [view resizeAllSubview:view.frame];
        view.center  = CGPointMake(_m_vPreview.center.x, view.center.y);
        [view setRefresh: info->img_Image];
        [_m_vPreview addSubview: view];
        
        m_Prev  = view;
        
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
        [TransitionManager SetData:view transitionType: idx];
        int dur = [info.param.duration intValue];
        [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
    }
    else if ( [name isEqualToString:@"Solar Generation"]){
        
        [JSWaiter ShowWaiter:self.view title:@"" type:0];
        [[SharedMembers sharedInstance].webManager GetSolarWidget:present._id Object:info._id success:^(MKNetworkOperation *networkOperation) {
            NSLog(@"%@", networkOperation.responseJSON );
            
            NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            SolarInfo * solar = [[SolarInfo alloc] init];
            [solar setDictionary:dic];
        
            info->solar = solar;
            
            PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
            SolarView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SolarView" owner:self options:nil];
            view = [nib objectAtIndex:0];
            [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
            [view setRefresh:solar];
            
            if ( [widget.param.widgetSolarGenerationOrientation isEqualToString:@"Vertical"] ) {
                [view resizeAllSubview:view.frame origentation:false];
            }
            else{
                [view resizeAllSubview:view.frame origentation:true];
            }
            view.center  = CGPointMake(_m_vPreview.center.x, view.center.y);

            [_m_vPreview addSubview: view];
            
            m_Prev  = view;
        
            int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
            [TransitionManager SetData:view transitionType: idx];
            int dur = [info.param.duration intValue];
            [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
            [JSWaiter HideWaiter];
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            NSLog(@"failed");
            [JSWaiter HideWaiter];
        }];
        
    }
    else if ( [name isEqualToString:@"TextArea"]){
        
        NSString * str = [m_vText GetText];
        TextAreaView * view;
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TextAreaView" owner:self options:nil];
        view = [nib objectAtIndex:0];
        [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
        [view setText:str];
        [view setInfo];
        view.center  = CGPointMake(_m_vPreview.center.x, view.center.y);
        [_m_vPreview addSubview: view];
        
        m_Prev  = view;
        
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionIn.text ];
        [TransitionManager SetData:view transitionType: idx];
        int dur = [info.param.duration intValue];
        [NSTimer scheduledTimerWithTimeInterval:dur target:self selector:@selector(TransitionAnimation) userInfo:nil repeats:NO];
    }
}
    
-(void)TransitionAnimation
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    NSString * name = info.name;
    
    if ( [name isEqualToString:@"Graph"] ) {
        GraphView  * view = (GraphView*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];
    }
    else if ( [name isEqualToString:@"Weather"]){
        WeatherView  * view = (WeatherView*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];
    }
    else if ( [name isEqualToString:@"Energy Equivalencies"]){
        EnergyView  * view = (EnergyView*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];
    }
    else if ( [name isEqualToString:@"How Does Solar Work"]){
        HowPreview  * view = (HowPreview*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];
    }
    else if ( [name isEqualToString:@"iFrame"]){
        iFrameView  * view = (iFrameView*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];
    }
    else if ( [name isEqualToString:@"Image"] ){
        WidgetImageView  * view = (WidgetImageView*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];
    }
    else if ( [name isEqualToString:@"Solar Generation"]){
        SolarView  * view = (SolarView*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];

    }
    else if ( [name isEqualToString:@"TextArea"]){
        TextAreaView  * view = (TextAreaView*)m_Prev;
        int idx  =    [Command GetTransitionEffectIdx: _m_txtTransitionOut.text ];
        [TransitionManager SetData:view transitionType: idx];
    }
}

- (IBAction) onSave:(id)sender
{
    if ( m_vText ) {
        [m_vText GetText];
    }
    
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    [info setWidgetDictionary:true];
    
    [JSWaiter ShowWaiter:self.view title:@"" type:0];
    [[SharedMembers sharedInstance].webManager UpdateWidget:info._id param:info->msgDic success:^(MKNetworkOperation *networkOperation) {

        [JSWaiter HideWaiter];
        id<WeatherDelegate> strongDelegate = self.delegate;
        
        if ([strongDelegate respondsToSelector:@selector(WeatherDidCloseButtonPressed:)]) {
            [strongDelegate WeatherDidCloseButtonPressed:self];
        }

    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        
        [JSWaiter HideWaiter];
        [[[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Fail to save Widget Information" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
    }];
}

- (IBAction) onPropertyOpen:(id)sender
{
    UIButton * btn = (UIButton*) sender;
    
    PWidgetInfo * widget = (PWidgetInfo*)[SharedMembers sharedInstance].curWidget;
    NSString * name  = widget.name;
    
    bShowProperty = !bShowProperty;
    if ( bShowProperty ) {
        
        [m_vWeatherProperty setHidden:true]; [m_vWeatherProperty->vClrPicker setHidden:true];
        [m_vEnerguyProperty setHidden:true]; [m_vEnerguyProperty->vClrPicker setHidden:true];
        [m_vGraphProperty setHidden:true]; [m_vGraphProperty->vClrPicker setHidden:true];
        [m_vHowProperty setHidden:true]; [m_vHowProperty->vClrPicker setHidden:true];
        [m_vFrameProperty setHidden:true]; [m_vFrameProperty->vClrPicker setHidden:true];
        [m_vImageProperty setHidden:true]; [m_vImageProperty->vClrPicker setHidden:true];
        [m_vSolarProperty setHidden:true]; [m_vSolarProperty->vClrPicker setHidden:true];
        [m_vTextAreaProperty setHidden:true]; [m_vTextAreaProperty->vClrPicker setHidden:true];
        
        [btn setImage:[UIImage imageNamed:@"btn_property_close.png"] forState:UIControlStateNormal];
        
        if ( [name isEqualToString:@"Graph"] ) {
            [m_vGraphProperty setHidden:false];
            [m_vGraphProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( _m_vPropertyScrll.frame.size.width, m_vGraphProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        else if ( [name isEqualToString:@"Weather"]){
            [m_vWeatherProperty setHidden:false];
            [m_vWeatherProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( _m_vPropertyScrll.frame.size.width, m_vWeatherProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        else if ( [name isEqualToString:@"Energy Equivalencies"]){
            [m_vEnerguyProperty setHidden:false];
            [m_vEnerguyProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( _m_vPropertyScrll.frame.size.width, m_vEnerguyProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        else if ( [name isEqualToString:@"How Does Solar Work"]){
            [m_vHowProperty setHidden:false];
            [m_vHowProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( m_vHowProperty.frame.size.width, m_vHowProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        else if ( [name isEqualToString:@"iFrame"]){
            [m_vFrameProperty setHidden:false];
            [m_vFrameProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( m_vFrameProperty.frame.size.width, m_vFrameProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        else if ( [name isEqualToString:@"Image"]){
            [m_vImageProperty setHidden:false];
            [m_vImageProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( m_vImageProperty.frame.size.width, m_vImageProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        else if ( [name isEqualToString:@"Solar Generation"] ){
            [m_vSolarProperty setHidden:false];
            [m_vSolarProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( m_vSolarProperty.frame.size.width, m_vSolarProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        else if ( [name isEqualToString:@"TextArea"]){
            [m_vTextAreaProperty setHidden:false];
            [m_vTextAreaProperty setInfo];
            [_m_vPropertyScrll setContentSize:CGSizeMake( m_vTextAreaProperty.frame.size.width, m_vTextAreaProperty.frame.size.height)];
            [_m_vProperty setHidden:false];
        }
        
        float dis  =  (_m_btn_open_property.frame.size.width - _m_vProperty.frame.size.width);
        const float dur  = 0.5f;
        [UIView beginAnimations:@"anim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration: dur];
        _m_vProperty.frame = CGRectOffset(_m_vProperty.frame,  dis, 0);
        [UIView commitAnimations];
    }
    else{
        [btn setImage:[UIImage imageNamed:@"btn_property_open.png"] forState:UIControlStateNormal];
        
        float dis  =  (_m_vProperty.frame.size.width-_m_btn_open_property.frame.size.width);
        const float dur  = 0.5f;
        [UIView beginAnimations:@"anim" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration: dur];
        _m_vProperty.frame = CGRectOffset(_m_vProperty.frame,  dis, 0);
        [UIView commitAnimations];
        
        
        for ( UIView * v in [_m_vPreview subviews] ) {
            if( [v isKindOfClass:[EnergyView class]] ){
                EnergyView * energy = (EnergyView*)v;
                [energy resizeAllSubview:v.frame];
            }
            else if ([v isKindOfClass:[GraphView class]] ){
                GraphView * graph = (GraphView*)v;
                [graph setInfo:graph->m_Info Widget:widget generation:[widget.param.widgetGraphGeneration boolValue] maxPower:[widget.param.widgetGraphMaxPower boolValue]];
            }
            else if ( [v isKindOfClass:[WidgetImageView class]]){
                WidgetImageView * image = (WidgetImageView*)v;
                [image setInfo];
            }
            else if ( [v isKindOfClass:[TextAreaView class]]){
                TextAreaView * textArea = (TextAreaView*)v;
                [textArea setInfo];
            }
            else if ( [v isKindOfClass:[iFrameView class]]){
                iFrameView * frame = (iFrameView*)v;
                [frame setInfo];
            }
            else if ( [v isKindOfClass:[HowPreview class]]){
                HowPreview * how = (HowPreview*)v;
                [how setInfo];
            }
            else if( [v isKindOfClass:[SolarView class]]){
                SolarView * solar = (SolarView*)v;                
                if ( [widget.param.widgetSolarGenerationOrientation isEqualToString:@"Vertical"] ) {
                    [solar resizeAllSubview:solar.frame origentation:false];
                }
                else{
                    [solar resizeAllSubview:solar.frame origentation:true];
                }
                
            }
            else if ( [v isKindOfClass:[WeatherView class]]){
                WeatherView * solar = (WeatherView*)v;
                [solar resizeAllSubview: solar.frame];
            }


        }

    }
    
}

- (IBAction) onPropertyClose:(id)sender
{
    
}

- (void) ChooseAssetViewDidCloseButtonPressed:(ChooseAssetView *)popupVC
{
    
}

#pragma mark Transition Effect

- (void) sendSelectTransition:(NSString*) effect
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;
    
    [m_vTransition setHidden:true];
    
    if ( m_nTransitionType == 0 ) {
        [_m_txtTransitionIn setText: effect];
        widget.param.transitionIn = effect;
    }
    else if ( m_nTransitionType  == 1 ){
        [_m_txtTransitionOut setText: effect];
        widget.param.transitionOut = effect;
    }
    
    [_m_scroll removeGestureRecognizer:singleTap];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [m_vTransition setHidden:true];
//    
//    [m_ComboDuration setHidden:true];
//    [m_ComboRow setHidden: true];
//    [m_ComboCol setHidden: true];
//    [m_ComboTransitionIn setHidden: true];
//    [m_ComboTransitionOut setHidden: true];
}

- (IBAction) onTemp:(id)sender
{
    [m_vTransition setHidden: true];
    
    [m_ComboDuration setHidden:true];
    [m_ComboRow setHidden: true];
    [m_ComboCol setHidden: true];
    [m_ComboTransitionIn setHidden: true];
    [m_ComboTransitionOut setHidden: true];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [m_ComboDuration setHidden:true];
    [m_ComboRow setHidden: true];
    [m_ComboCol setHidden: true];
    [m_ComboTransitionIn setHidden: true];
    [m_ComboTransitionOut setHidden: true];
    
    return  true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL flag  = true;
    if ( [string isEqualToString:@"0"] || [string isEqualToString:@"1"] || [string isEqualToString:@"2"] || [string isEqualToString:@"3"] || [string isEqualToString:@"4"] || [string isEqualToString:@"5"] || [string isEqualToString:@"6"] || [string isEqualToString:@"7"] ||
        [string isEqualToString:@"8"] || [string isEqualToString:@"9"] || [string isEqualToString:@""] || [string isEqualToString:@"."] || [string isEqualToString:@"\n"]) {
        flag  = true;
        
        int tag  = textField.tag;
        PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
        
        NSString * change  = [NSString stringWithFormat:@"%@%@", textField.text, string];
        
        switch ( tag ) {
            case 1:
                info.param.startDate = [NSString stringWithFormat: @"%@:%@", change, _m_txtSec.text];
                break;
            case 2:
                info.param.startDate = [NSString stringWithFormat: @"%@:%@", _m_txtMin.text, change];
                break;
            case 3:
                info.param.duration = [NSNumber numberWithInt: [change intValue]];
                break;
                
            default:
                break;
        }

    }
    else{
        flag = false;
         [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter only Number" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
    }

    return flag;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int tag  = textField.tag;
    
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    
    switch ( tag ) {
        case 1:
            info.param.startDate = [NSString stringWithFormat: @"%@:%@", _m_txtMin.text, _m_txtSec.text];
            break;
        case 2:
            info.param.startDate = [NSString stringWithFormat: @"%@:%@", _m_txtMin.text, _m_txtSec.text];
            break;
        case 3:
            info.param.duration = [NSNumber numberWithInt: [textField.text intValue]];
            break;
            
        default:
            break;
    }    
}

@end
