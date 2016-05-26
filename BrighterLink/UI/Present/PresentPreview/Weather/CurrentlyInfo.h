//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentlyInfo : NSObject
{

}

@property (nonatomic, strong) NSString * apparentTemperature;
@property (nonatomic, strong) NSString * cloudCover;
@property (nonatomic, strong) NSString * dewPoint;
@property (nonatomic, strong) NSString * humidity;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSNumber * nearestStormBearing;
@property (nonatomic, strong) NSNumber * nearestStormDistance;
@property (nonatomic, strong) NSString * ozone;
@property (nonatomic, strong) NSNumber * precipIntensity;
@property (nonatomic, strong) NSNumber * precipProbability;
@property (nonatomic, strong) NSString * pressure;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * temperature;
@property (nonatomic, strong) NSNumber * time;
@property (nonatomic, strong) NSString * visibility;
@property (nonatomic, strong) NSNumber * windBearing;
@property (nonatomic, strong) NSString * windSpeed;


- (void)  SetGraphInfoDic:(NSDictionary*) dic;

@end


