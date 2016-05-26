//
//  WidgetInfo.m
//  BrighterLink
//
//  Created by Andriy on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WidgetInfo.h"

#import "DashboardInfo.h"

@implementation WidgetInfo

- (id) initWithTitle:(NSString *)title showTitle:(BOOL)showTitle type:(NSInteger)type metric:(NSString *)metric compareWith:(NSString *)metricCompareWith dashboard:(NSString *)dashboardId
{
    self = [super init];
    if (self) {
        
        [self _init];
        
        self.title = title;
        
        self.showTitle = showTitle;
        
        self.type = type;
        
        self.metric = metric;
        self.metricCompareWith = metricCompareWith;
        
        self.dashboardId = dashboardId;
    }
    
    return self;
}

- (id) initWithTitle:(NSString *)title showTitle:(BOOL)showTitle type:(NSInteger)type
{
    self = [super init];
    if (self) {
        
        [self _init];
        
        self.title = title;
        
        self.showTitle = showTitle;
        
        self.type = type;
        
        self.metric = nil;
        self.metricCompareWith = nil;
        
        self.dashboardId = nil;
    }
    
    return self;
}

- (void) _init
{
    self._id = nil;
    
    self.title = @"Test Widget";
    
    self.showTitle = YES;
    
    self.type = WIDGET_TIMELINE;
    
    self.metric = nil;
    self.metricCompareWith = nil;
    
    self.showUpTo = 5;
    self.groupDimention = nil;
    self.pivotDimention = nil;
    
    self.rowsPerTable = 0;
    
    self.dashboardId = nil;
    
    self.orientation = nil;
    self.equivType = nil;
    
    self.showAllTime = false;
    self.co2Kilograms = false;
    self.greenhouseKilograms = false;
    
    self.summaryMethod = @"";
    
    self.label = @"";
    self.compareLabel = @"";
}

- (NSDictionary *) getRequestParam
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setValue:[WidgetInfo getWidgetTypeStringWithIndex:self.type] forKey:@"type"];
    [param setValue:self.title forKey:@"title"];
    
    [param setValue:[NSNumber numberWithBool:self.showTitle] forKey:@"titleShow"];
    
    if(self._id) [param setValue:self._id forKey:@"_id"];
    
    if(self.metric && self.metric.length > 0)
        [param setValue:self.metric forKey:@"metric"];
    
    if(self.metricCompareWith && self.metricCompareWith.length > 0)
        [param setValue:self.metricCompareWith forKey:@"compareMetric"];
    
    [param setValue:[NSNumber numberWithInt:self.showUpTo] forKey:@"showUpTo"];
    
    if(self.dashboardId)
    {
        [param setValue:self.dashboardId forKey:@"drillDown"];
    }
    
    if(self.groupDimention && self.groupDimention.length > 0)
    {
        [param setValue:self.groupDimention forKey:@"groupDimension"];
    }
    
    if(self.pivotDimention && self.pivotDimention.length > 0)
    {
        [param setValue:self.pivotDimention forKey:@"pivotDimension"];
    }
    
    if(self.type == WIDGET_TABLE)
    {
        [param setValue:[NSNumber numberWithInt:self.rowsPerTable] forKey:@"rowsPerTable"];
    }
    
    if(self.type == WIDGET_EQUIVALENCIES)
    {
        if(self.orientation) [param setValue:self.orientation forKey:@"orientation"];
        if(self.equivType) [param setValue:self.equivType forKey:@"equivType"];
        
        [param setValue:[NSNumber numberWithBool:self.showAllTime] forKey:@"showAllTime"];
        [param setValue:[NSNumber numberWithBool:self.co2Kilograms] forKey:@"co2Kilograms"];
        [param setValue:[NSNumber numberWithBool:self.greenhouseKilograms] forKey:@"greenhouseKilograms"];
    }
    if(self.imageUrl)
    {
        [param setValue:self.imageUrl forKey:@"imageUrl"];
    }
    
    if(self.type == WIDGET_KPI)
    {
        [param setValue:self.summaryMethod forKey:@"summaryMethod"];
        [param setValue:self.label forKey:@"label"];
        [param setValue:self.compareLabel forKey:@"compareLabel"];
    }
    
    return param;
}

+ (NSString *)getWidgetTypeStringWithIndex:(NSInteger)typeIndex
{
    NSString *type = @"";
    
    switch (typeIndex) {
        case WIDGET_TIMELINE:
            type = @"Timeline";
            break;
            
        case WIDGET_PIE:
            type = @"Pie";
            break;
            
        case WIDGET_BAR:
            type = @"Bar";
            break;
            
        case WIDGET_TABLE:
            type = @"Table";
            break;
            
        case WIDGET_IMAGE:
            type = @"Image";
            break;
            
        case WIDGET_EQUIVALENCIES:
            type = @"Equivalencies";
            break;
            
        case WIDGET_KPI:
            type = @"Kpi";
            break;
            
        default:
            break;
    }
    
    return type;
}

+ (NSInteger) getWidgetTypeIndexWithString:(NSString *)typeString
{
    NSInteger type = WIDGET_TIMELINE;
    
    if([typeString isEqualToString:@"Timeline"])
    {
        type = WIDGET_TIMELINE;
    }
    else if([typeString isEqualToString:@"Pie"])
    {
        type = WIDGET_PIE;
    }
    else if([typeString isEqualToString:@"Bar"])
    {
        type = WIDGET_BAR;
    }
    else if([typeString isEqualToString:@"Table"])
    {
        type = WIDGET_TABLE;
    }
    else if([typeString isEqualToString:@"Image"])
    {
        type = WIDGET_IMAGE;
    }
    else if([typeString isEqualToString:@"Equivalencies"])
    {
        type = WIDGET_EQUIVALENCIES;
    }
    else if([typeString isEqualToString:@"Kpi"])
    {
        type = WIDGET_KPI;
    }

    return type;
}

@end
