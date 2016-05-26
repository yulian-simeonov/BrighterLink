//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WeatherDetailView.h"

#import "SharedMembers.h"

@interface WeatherDetailView()

@end

@implementation WeatherDetailView

- (void) awakeFromNib
{
    // weather
    bWeather = false;
    
    _pickerDataWeather = @[@"Minimal", @"Detailed"];
    
    NSMutableArray* data4 = [[NSMutableArray alloc] init];
    m_ComboWeather = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_weather_bg.frame.origin.x, _m_img_weather_bg.frame.origin.y + _m_img_weather_bg.frame.size.height, _m_img_weather_bg.frame.size.width, 100)];
    [m_ComboWeather setDelegate:self];
    
    for( int i = 0; i < [_pickerDataWeather count]; i++ )
        [ data4 addObject:@{@"text" : _pickerDataWeather[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboWeather UpdateData:data4];
    [self addSubview:m_ComboWeather];
}

- (void) setInfo
{
  
}

//Weather

- (IBAction) onWeatherType:(id)sender
{
    bWeather = !bWeather;
    if ( bWeather ) {
        [m_ComboWeather setHidden:false];
    }
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    
    if ( [control isEqual: m_ComboWeather]){
        [_m_txtWeatherType setText: [obj objectForKey:@"text"]];
        info.param.widgetWeatherType = _m_txtWeatherType.text;
    }
    
    bWeather  = false;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_ComboWeather setHidden: true];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

@end
