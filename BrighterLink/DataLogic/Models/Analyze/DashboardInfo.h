//
//  DashboardInfo.h
//  BrighterLink
//
//  Created by Andriy on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WidgetInfo;
@class DashboardCreator;

typedef enum : NSUInteger {
    DASHBOARD_BLANK = 1,
    DASHBOARD_STARTER
} DASHBOARD_TYPE;

typedef enum : NSUInteger {
    RANGE_CUSTOM,
    RANGE_LAST_7_DAYS,
    RANGE_CURRENT_WEEK,
    RANGE_LAST_WEEK,
    RANGE_LAST_30_DAYS,
    RANGE_CURRENT_MONTH,
    RANGE_LAST_MONTH,
    RANGE_CURRENT_YEAR,
    RANGE_LAST_YEAR,
} RANGE_TYPE;

@interface DashboardInfo : NSObject

- (id) initWithTitle:(NSString *)title collection:(NSString *)name type:(NSInteger)type;

- (id) initWithDictionary:(NSDictionary *)dashboard;

// main info

@property (nonatomic, retain) NSString *__v;

@property (nonatomic, retain) NSString *_id;

@property (nonatomic, retain) NSString *awsAssetsKeyPrefix;

@property (nonatomic, retain) NSString *collectionName;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, retain) DashboardCreator *creator;

@property (nonatomic, retain) NSMutableArray *widgets;

@property (nonatomic, retain) NSMutableArray *widgetDatas;

@property (nonatomic, retain) NSMutableArray *segments;

@property (nonatomic, assign) BOOL updated;

// date range

@property (nonatomic, assign) int dateRangeType;

@property (nonatomic, assign) BOOL useCompare;

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

@property (nonatomic, retain) NSDate *compareEndDate;
@property (nonatomic, retain) NSDate *compareStartDate;

- (NSString *) getDateStringForRequest:(BOOL)isStart compare:(BOOL)isCompare;

- (void) updateSegments:(NSArray *)segments;

- (void) addNewWidget:(NSString *)widgetId;

- (void) updateDashboard:(NSDictionary *)fullDashboard;

@end
