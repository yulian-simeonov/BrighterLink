//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimelineData : NSObject
{

}

@property (nonatomic, strong) NSString *availableWidgetId;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic, strong) NSNumber *colPosition;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *previousTimelineRowPosition;
@property (nonatomic, strong) NSNumber *resizedOnTimeline;
@property (nonatomic, strong) NSNumber *rowPosition;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSNumber *timelineRowPosition;
@property (nonatomic, strong) NSString *widgetId;

@end
