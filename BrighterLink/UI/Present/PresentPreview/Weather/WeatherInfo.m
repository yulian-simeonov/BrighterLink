//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WeatherInfo.h"
#import "SharedMembers.h"

@implementation WeatherInfo

- (id) init
{
    
    _apparentTemperature = [NSNumber numberWithDouble:0];
    _cloudCover = [NSNumber numberWithDouble:0];
    _dewPoint = [NSNumber numberWithLong:0];
    _humidity = [NSNumber numberWithDouble: 0];
    _icon = @"";
    _nearestStormBearing = [NSNumber numberWithLong:0];
    _nearestStormDistance = [NSNumber numberWithLong:0];
    _ozone = [NSNumber numberWithDouble: 0];
    _precipIntensity = [NSNumber numberWithInt:0];
    _precipProbability = [NSNumber numberWithInt:0];
    _pressure = [NSNumber numberWithDouble: 0];
    _summary = @"";
    _temperature = [NSNumber numberWithDouble:0];
    _time = [NSNumber numberWithLong:0];
    _visibility = [NSNumber numberWithInt:0];
    _windBearing = [NSNumber numberWithLong:0];
    _windSpeed = [NSNumber numberWithDouble:0];
  
    _data = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)  SetGraphInfoDic:(NSDictionary*) dic
{
    
}

@end
