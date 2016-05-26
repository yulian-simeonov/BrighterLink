//
//  DashboardInfo.m
//  BrighterLink
//
//  Created by Andriy on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DashboardInfo.h"

#import "SharedMembers.h"

@implementation DashboardInfo

- (id) initWithTitle:(NSString *)title collection:(NSString *)name type:(NSInteger)type
{
    self = [super init];
    
    if (self) {
        
        self.updated = NO;
        
        self.title = title;
        self.collectionName = name;
        self.type = type;
        
        [self _init];
    }
    
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dashboard
{
    self = [super init];
    
    if (self) {
        
        self.updated = NO;
        
        [self _initWithDictionary:dashboard];
    }
    
    return self;
}

- (void) _init
{
    self._id = nil;
    
    self.widgets = [[NSMutableArray alloc] init];
    
    self.segments = [[NSMutableArray alloc] init];
    
    self.dateRangeType = RANGE_CUSTOM;
    
    self.useCompare = NO;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [comp setDay:1];
    
    NSDate *date = [gregorian dateFromComponents:comp];
    
    self.startDate = date;
    self.endDate = [NSDate date];
    
    self.compareStartDate = date;
    self.compareEndDate = [NSDate date];
}

- (void) _initWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@", dictionary);
    
    self.__v = [dictionary objectForKey:@"__v"];
    self._id = [dictionary objectForKey:@"_id"];
    
    self.title = [dictionary objectForKey:@"title"];
    
    self.type = [[[dictionary objectForKey:@"layout"] objectForKey:@"selectedStyle"] intValue];
    
    self.awsAssetsKeyPrefix = [dictionary objectForKey:@"awsAssetsKeyPrefix"];
    
    NSArray *collections = [dictionary objectForKey:@"collections"];
    if(collections.count > 0)
    {
        self.collectionName = [collections objectAtIndex:0];
    }
    
    self.startDate = [SharedMembers getDateWithString:[dictionary objectForKey:@"startDate"]];
    self.endDate = [SharedMembers getDateWithString:[dictionary objectForKey:@"endDate"]];
    
    self.compareStartDate = [SharedMembers getDateWithString:[dictionary objectForKey:@"compareStartDate"]];
    self.compareEndDate = [SharedMembers getDateWithString:[dictionary objectForKey:@"compareEndDate"]];
    
    if(self.compareStartDate != nil && self.compareEndDate)
    {
        self.useCompare = YES;
    }
    
    self.creator = [[DashboardCreator alloc] initWithId:[dictionary objectForKey:@"creator"] role:[dictionary objectForKey:@"creatorRole"]];
    
    self.widgets = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"widgets"]];
    
    if(self.segments == nil)
    {
        self.segments = [[NSMutableArray alloc] init];
    }
    [self.segments removeAllObjects];
    
    NSArray *segments = [dictionary objectForKey:@"segments"];
    
    for (NSDictionary *segment in segments) {
        
        SegmentInfo *segmentInfo = [[SegmentInfo alloc] initWithDictionary:segment];
        
        [self.segments addObject:segmentInfo];
        segmentInfo = nil;
    }
}

- (void) updateSegments:(NSArray *)segments
{
    if(self.segments == nil)
    {
        self.segments = [[NSMutableArray alloc] init];
    }
    [self.segments removeAllObjects];
    
    for (NSDictionary *segment in segments) {
        
        SegmentInfo *segmentInfo = [[SegmentInfo alloc] initWithDictionary:segment];
        
        [self.segments addObject:segmentInfo];
        segmentInfo = nil;
    }
}

- (void) addNewWidget:(NSString *)widgetId
{
    if(self.widgets == nil)
    {
        self.widgets = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *widget = [NSDictionary dictionaryWithObjectsAndKeys:widgetId, @"widget", nil];
    
    [self.widgets addObject:widget];
}

- (NSString *) getDateStringForRequest:(BOOL)isStart compare:(BOOL)isCompare
{
    NSDate *date = nil;
    
    if(!isCompare)
    {
        if(isStart)
            date = self.startDate;
        else
            date = self.endDate;
    }
    else
    {
        if(isStart)
            date = self.compareStartDate;
        else
            date = self.compareEndDate;
    }
    
    if(date == nil) return @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *string = [dateFormatter stringFromDate:date];
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    
    return string;
}

- (void) updateDashboard:(NSDictionary *)fullDashboard
{
    self.updated = YES;
    
    NSArray *segments = [fullDashboard objectForKey:@"segments"];
    
    [self updateSegments:segments];
    
    NSLog(@"%@", fullDashboard);
    
    self.widgetDatas = [fullDashboard objectForKey:@"widgets"];
    
    if(self.widgets == nil) self.widgets = [[NSMutableArray alloc] init];
    [self.widgets removeAllObjects];
    
    for (NSDictionary *widget in self.widgetDatas) {
        NSDictionary *oneWidgetDataInfo = [widget objectForKey:@"widget"];
        NSString *oneWidgetId = [oneWidgetDataInfo objectForKey:@"_id"];
        
        NSDictionary *simpleWidgetData = [NSDictionary dictionaryWithObjectsAndKeys:oneWidgetId, @"widget", nil];
        
        [self.widgets addObject:simpleWidgetData];
    }
}

@end
