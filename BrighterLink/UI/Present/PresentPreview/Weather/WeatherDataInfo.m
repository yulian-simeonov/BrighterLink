//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WeatherDataInfo.h"
#import "SharedMembers.h"

@implementation WeatherDataInfo

- (id) init
{

    _currentTime = [NSNumber numberWithLong: 0];
    _icon = @"";
    _temperatureMax = [NSNumber numberWithDouble: 0];
    _temperatureMin = [NSNumber numberWithDouble: 0];
    
    return self;
}



@end
