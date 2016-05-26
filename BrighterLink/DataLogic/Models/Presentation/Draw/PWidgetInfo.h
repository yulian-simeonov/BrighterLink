//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWidgetInfo.h"
#import "Parameter.h"
#import "TimelineData.h"

#import "EnergyInfo.h"
#import "GraphInfo.h"
#import "SolarInfo.h"
#import "WeatherInfo.h"


@interface PWidgetInfo : NSObject
{
    @public
    NSDictionary * msgDic;
    
    EnergyInfo * energy;
    GraphInfo  * graph;
    SolarInfo  * solar;
    WeatherInfo * weather;
    
    
    UIImage    * img_TextAreaImage;
    UIImage    * img_Image;
}

@property (nonatomic, strong) NSNumber * __v;
@property (nonatomic, strong) NSString * _id;
@property (nonatomic, strong) NSString * availableWidgetId;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) Parameter * param;


@property (nonatomic, strong) TimelineData * timeline;


- (void) setWidgetDictionary:(BOOL) flag;

@end
