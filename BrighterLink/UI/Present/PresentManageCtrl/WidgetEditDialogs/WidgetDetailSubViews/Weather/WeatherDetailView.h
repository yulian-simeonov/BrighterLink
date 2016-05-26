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



@interface WeatherDetailView : UIView<JSComboDelegate>
{
    // weather
    BOOL bWeather;
    NSArray *_pickerDataWeather;
    //weather
    JSCombo * m_ComboWeather;

}

// Weather Items
@property (nonatomic, weak) IBOutlet UITextField  * m_txtWeatherType;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_weather_bg;
- (IBAction) onWeatherType:(id)sender;


@end
