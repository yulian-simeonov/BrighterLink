//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentlyInfo.h"
#import "WeatherDataInfo.h"


@interface WeatherInfo : NSObject
{

}

@property (nonatomic, strong) NSNumber * apparentTemperature;
@property (nonatomic, strong) NSNumber * cloudCover;
@property (nonatomic, strong) NSNumber * dewPoint;
@property (nonatomic, strong) NSNumber * humidity;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSNumber * nearestStormBearing;
@property (nonatomic, strong) NSNumber * nearestStormDistance;
@property (nonatomic, strong) NSNumber * ozone;
@property (nonatomic, strong) NSNumber * precipIntensity;
@property (nonatomic, strong) NSNumber * precipProbability;
@property (nonatomic, strong) NSNumber * pressure;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSNumber * temperature;
@property (nonatomic, strong) NSNumber * time;
@property (nonatomic, strong) NSNumber * visibility;
@property (nonatomic, strong) NSNumber * windBearing;
@property (nonatomic, strong) NSNumber * windSpeed;

@property NSMutableArray * data;

- (void)  SetGraphInfoDic:(NSDictionary*) dic;
@end


