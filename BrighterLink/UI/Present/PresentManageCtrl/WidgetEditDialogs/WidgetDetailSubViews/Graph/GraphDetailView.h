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
#import "JSCombo.h"



@interface GraphDetailView : UIView<JSComboDelegate>
{
    
    //graph
    
    NSArray * dataInterval;
    NSArray * dataDateRange;
    NSArray * dataGeneration;
    NSArray * dataTemperature;
    NSArray * dataHumidity;
    NSArray * dataCurrent;
    NSArray * dataGraphMax;
    JSCombo * m_ComboInterval;
    JSCombo * m_ComboDateRange;
    JSCombo * m_ComboGeneration;
    JSCombo * m_ComboTemperature;
    JSCombo * m_ComboHumidity;
    JSCombo * m_ComboCurrent;
    JSCombo * m_ComboGraphMax;

    
    //Graph
    BOOL bpInterval;
    BOOL bpDataRange;
    BOOL bGeneration;
    BOOL bpGeneration;
    BOOL bTemperature;
    BOOL bpTemperature;
    BOOL bHumidity;
    BOOL bpHumidity;
    BOOL bCurrent;
    BOOL bpCurrent;
    BOOL bMax;
    BOOL bpMax;
    BOOL bGraphWeather;

}

//Graph Items
@property (nonatomic, weak) IBOutlet UITextField  * m_txtGraph_Interval;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_graph_interval_bg;

@property (nonatomic, weak) IBOutlet UITextField  * m_txtGraph_DateRange;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_graph_dageRange_bg;

@property (nonatomic, weak) IBOutlet UIButton     * m_btnGraph_Generation;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtGraph_Generation_ChatType;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_graph_generation_chatType_bg;

@property (nonatomic, weak) IBOutlet UIButton     * m_btnGraph_Temperature;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtGraph_Temperature_ChatType;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_grapg_temperature_ChatType_bg;

@property (nonatomic, weak) IBOutlet UIButton     * m_btnGraph_Humidity;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtGraph_Humidity;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_graph_humidity_bg;

@property (nonatomic, weak) IBOutlet UIButton     * m_btnGraph_Current;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtGraph_Current;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_graph_current_bg;

@property (nonatomic, weak) IBOutlet UIButton     * m_btnGraph_Max;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtGraph_Max;
@property (nonatomic, weak) IBOutlet UITextField  * m_img_graph_max_bg;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnWeather;

- (IBAction) on_pGraph_Interval:(id)sender;
- (IBAction) on_pGraph_DataRange:(id)sender;
- (IBAction) on_btnGraph_Generation:(id)sender;
- (IBAction) on_pGraph_Generation:(id)sender;
- (IBAction) on_btnGraph_Temperature:(id)sender;
- (IBAction) on_pGraph_Temperature:(id)sender;
- (IBAction) on_btnGraph_Humidity:(id)sender;
- (IBAction) on_pGraph_Humidity :(id)sender;
- (IBAction) on_btnGraph_Current:(id)sender;
- (IBAction) on_pGraph_Current:(id)sender;
- (IBAction) on_btnGraph_Max:(id)sender;
- (IBAction) on_pGraph_Max:(id)sender;
- (IBAction) on_btnGraph_weather:(id)sender;


@end
