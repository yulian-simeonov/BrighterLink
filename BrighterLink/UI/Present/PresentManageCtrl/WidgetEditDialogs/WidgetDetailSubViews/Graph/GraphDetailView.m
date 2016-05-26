//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "GraphDetailView.h"

#import "SharedMembers.h"

@interface GraphDetailView()

@end

@implementation GraphDetailView

- (void) awakeFromNib
{
    [self setInfo];
}

- (void) setInfo
{
    // Graph
    bpInterval = false;
    bpDataRange = false;
    bGeneration = false;
    bpGeneration = false;
    bTemperature = false;
    bpTemperature = false;
    bHumidity =false;
    bpHumidity = false;
    bCurrent = false;
    bpCurrent = false;
    bMax = false;
    bpMax = false;
    bGraphWeather = false;
    
    dataInterval = @[@"Hourly", @"Daily", @"Weekly", @"Monthly", @"Yearly"];
    
    NSMutableArray* data6 = [[NSMutableArray alloc] init];
    m_ComboInterval = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_graph_interval_bg.frame.origin.x, _m_img_graph_interval_bg.frame.origin.y + _m_img_graph_interval_bg.frame.size.height, _m_img_graph_interval_bg.frame.size.width, 100)];
    [m_ComboInterval setDelegate:self];
    
    for( int i = 0; i < [dataInterval count]; i++ )
        [ data6 addObject:@{@"text" : dataInterval[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboInterval UpdateData:data6];
    [self addSubview:m_ComboInterval];
    
    dataDateRange = @[@"Day", @"3 Days", @"Week", @"Month", @"Year", @"All", @"-- Custom -- "];
    NSMutableArray* data7 = [[NSMutableArray alloc] init];
    m_ComboDateRange = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_graph_dageRange_bg.frame.origin.x, _m_img_graph_dageRange_bg.frame.origin.y + _m_img_graph_dageRange_bg.frame.size.height, _m_img_graph_dageRange_bg.frame.size.width, 100)];
    [m_ComboDateRange setDelegate:self];
    
    for( int i = 0; i < [dataDateRange count]; i++ )
        [ data7 addObject:@{@"text" : dataDateRange[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboDateRange UpdateData:data7];
    [self addSubview:m_ComboDateRange];
    
    dataGeneration = @[@"bar", @"line"];
    NSMutableArray* data8 = [[NSMutableArray alloc] init];
    m_ComboGeneration = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_graph_generation_chatType_bg.frame.origin.x, _m_img_graph_generation_chatType_bg.frame.origin.y + _m_img_graph_generation_chatType_bg.frame.size.height, _m_img_graph_generation_chatType_bg.frame.size.width, 100)];
    [m_ComboGeneration setDelegate:self];
    
    for( int i = 0; i < [dataGeneration count]; i++ )
        [ data8 addObject:@{@"text" : dataGeneration[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboGeneration UpdateData:data8];
    [self addSubview:m_ComboGeneration];
    
    
    m_ComboTemperature = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_grapg_temperature_ChatType_bg.frame.origin.x, _m_img_grapg_temperature_ChatType_bg.frame.origin.y + _m_img_grapg_temperature_ChatType_bg.frame.size.height, _m_img_grapg_temperature_ChatType_bg.frame.size.width, 100)];
    [m_ComboTemperature setDelegate:self];
    [m_ComboTemperature UpdateData:data8];
    [self addSubview:m_ComboTemperature];
    
    
    m_ComboHumidity = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_graph_humidity_bg.frame.origin.x, _m_img_graph_humidity_bg.frame.origin.y + _m_img_graph_humidity_bg.frame.size.height, _m_img_graph_humidity_bg.frame.size.width, 100)];
    [m_ComboHumidity setDelegate:self];
    [m_ComboHumidity UpdateData:data8];
    [self addSubview:m_ComboHumidity];
    
    
    
    m_ComboCurrent = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_graph_current_bg.frame.origin.x, _m_img_graph_current_bg.frame.origin.y + _m_img_graph_current_bg.frame.size.height, _m_img_graph_current_bg.frame.size.width, 100)];
    [m_ComboCurrent setDelegate:self];
    [m_ComboCurrent UpdateData:data8];
    [self addSubview:m_ComboCurrent];
    
    m_ComboGraphMax = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_graph_max_bg.frame.origin.x, _m_img_graph_max_bg.frame.origin.y + _m_img_graph_max_bg.frame.size.height, _m_img_graph_max_bg.frame.size.width, 100)];
    [m_ComboGraphMax setDelegate:self];
    [m_ComboGraphMax UpdateData:data8];
    [self addSubview:m_ComboGraphMax];

}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    
    if( [control isEqual: m_ComboInterval] )
    {
        [_m_txtGraph_Interval setText:[obj objectForKey:@"text"]];
        info.param.widgetGraphInterval = _m_txtGraph_Interval.text;
    }
    else if ( [control isEqual: m_ComboDateRange] ) {
        [_m_txtGraph_DateRange setText:[obj objectForKey:@"text"]];
        info.param.widgetGraphDateRange = _m_txtGraph_DateRange.text;
    }
    else if ( [control isEqual: m_ComboGeneration] ){
        [_m_txtGraph_Generation_ChatType setText:[obj objectForKey:@"text"]];
        info.param.widgetGraphGenerationChartType = _m_txtGraph_Generation_ChatType.text;
    }
    else if ( [control isEqual: m_ComboTemperature] ){
        [_m_txtGraph_Temperature_ChatType setText:[obj objectForKey:@"text"]];
        info.param.wIdgetGraphTemperatureChartType = _m_txtGraph_Temperature_ChatType.text;
    }
    else if ( [control isEqual: m_ComboHumidity] ){
        [_m_txtGraph_Humidity setText:[obj objectForKey:@"text"]];
        info.param.widgetGraphHumidityChartType = _m_txtGraph_Humidity.text;
    }
    else if ( [control isEqual: m_ComboCurrent] ){
        [_m_txtGraph_Current setText:[obj objectForKey:@"text"]];
        info.param.widgetGraphCurrentPowerChartType = _m_txtGraph_Current.text;
    }
    else if ( [control isEqual: m_ComboGraphMax]){
        [_m_txtGraph_Max setText:[obj objectForKey:@"text"]];
        info.param.widgetGraphMaxPowerChartType = _m_txtGraph_Max.text;
    }
}

// Graph
- (IBAction) on_pGraph_Interval:(id)sender
{
    bpInterval = !bpInterval;
    [m_ComboInterval setHidden:false];
}

- (IBAction) on_pGraph_DataRange:(id)sender
{
    bpDataRange  = !bpDataRange;
    [m_ComboDateRange setHidden:false];
}

- (IBAction) on_btnGraph_Generation:(id)sender
{
    bGeneration  = !bGeneration;
    UIButton * btn  = (UIButton*) sender;
    if ( bGeneration ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetGraphGeneration = [NSNumber numberWithBool: bGeneration];
}

- (IBAction) on_pGraph_Generation:(id)sender
{
    bpGeneration = !bGeneration;
    
    [m_ComboGeneration setHidden:false];
}

- (IBAction) on_btnGraph_Temperature:(id)sender
{
    bTemperature = !bTemperature;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bTemperature ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetGraphTemperature = [NSNumber numberWithBool: bTemperature];
    
}

- (IBAction) on_pGraph_Temperature:(id)sender
{
    bpTemperature = !bpTemperature;
    [m_ComboTemperature setHidden:false];
}

- (IBAction) on_btnGraph_Humidity:(id)sender
{
    bHumidity = !bHumidity;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bHumidity ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetGraphHumidity = [NSNumber numberWithBool:bHumidity];
}

- (IBAction) on_pGraph_Humidity :(id)sender
{
    bpHumidity = !bpHumidity;
    
    [m_ComboHumidity setHidden:false];
}

- (IBAction) on_btnGraph_Current:(id)sender
{
    bCurrent = !bCurrent;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bCurrent ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetGraphCurrentPower = [NSNumber numberWithBool:bCurrent];
}

- (IBAction) on_pGraph_Current:(id)sender
{
    bpCurrent = !bpCurrent;
    
    [m_ComboCurrent setHidden:false];
}

- (IBAction) on_btnGraph_Max:(id)sender
{
    bMax = !bMax;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bMax ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetGraphMaxPower = [NSNumber numberWithBool:bMax];
}

- (IBAction) on_pGraph_Max:(id)sender
{
    bpMax = !bpMax;
    
    [m_ComboGraphMax setHidden:false];
}

- (IBAction) on_btnGraph_weather:(id)sender
{
    bGraphWeather = !bGraphWeather;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bGraphWeather ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    //hb check point
    
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetGraphWeather = [NSNumber numberWithBool:bGraphWeather];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_ComboInterval setHidden:true];
    [m_ComboDateRange setHidden: true];
    [m_ComboGeneration setHidden: true];
    [m_ComboTemperature setHidden: true];
    [m_ComboHumidity setHidden: true];
    [m_ComboCurrent setHidden: true];
    [m_ComboGraphMax setHidden: true];
    
    bpInterval = false;
    bpDataRange = false;
    bpGeneration = false;
    bpTemperature = false;
    bpHumidity = false;
    bpCurrent = false;
    bpMax = false;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

@end
