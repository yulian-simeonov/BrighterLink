//
//  WidgetInfo.h
//  BrighterLink
//
//  Created by Andriy on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WIDGET_TIMELINE,
    WIDGET_PIE,
    WIDGET_BAR,
    WIDGET_TABLE,
    WIDGET_IMAGE,
    WIDGET_EQUIVALENCIES,
    WIDGET_KPI,
} WIDGET_TYPE;

@interface WidgetInfo : NSObject

- (id) initWithTitle:(NSString *)title showTitle:(BOOL)showTitle type:(NSInteger)type metric:(NSString *)metric compareWith:(NSString *)metricCompareWith dashboard:(NSString *)dashboardId;

- (id) initWithTitle:(NSString *)title showTitle:(BOOL)showTitle type:(NSInteger)type;

@property (nonatomic, retain) NSString *_id;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, assign) BOOL showTitle;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, retain) NSString * metric;
@property (nonatomic, retain) NSString * metricCompareWith;

@property (nonatomic, retain) NSString * dashboardId;
@property (nonatomic, strong) NSString * imageUrl;

@property (nonatomic, assign) int showUpTo;

@property (nonatomic, retain) NSString *groupDimention;
@property (nonatomic, retain) NSString *pivotDimention;

@property (nonatomic, assign) int rowsPerTable;

@property (nonatomic, retain) NSString *orientation;
@property (nonatomic, retain) NSString *equivType;

@property (nonatomic, assign) BOOL showAllTime;
@property (nonatomic, assign) BOOL co2Kilograms;
@property (nonatomic, assign) BOOL greenhouseKilograms;

@property (nonatomic, retain) NSString *summaryMethod;

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *compareLabel;


- (NSDictionary *) getRequestParam;

+ (NSString *)getWidgetTypeStringWithIndex:(NSInteger)typeIndex;
+ (NSInteger) getWidgetTypeIndexWithString:(NSString *)typeString;

@end
