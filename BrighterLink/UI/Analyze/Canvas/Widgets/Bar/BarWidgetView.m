//
//  BarWidgetView.m
//  BrighterLink
//
//  Created by Andriy on 12/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "BarWidgetView.h"

#import "BarWidgetAxisView.h"
#import "BarWidgetGraphView.h"

#import "BarWidgetLegendView.h"

#import "BarWidgetTooltipView.h"

#import "SharedMembers.h"

#define BAR_WIDGET_HEIGHT 320
#define BAR_WIDGET_LEGEND_HEIGHT 20

@interface BarWidgetView()<BarWidgetLegentViewDelegate, BarWidgetGraphViewDelegate, BarWidgetAxisViewDelegate>

@property (nonatomic, assign) BarWidgetAxisView *axisView;

@property (nonatomic, assign) BarWidgetLegendView *legendView;

@property (nonatomic, assign) BarWidgetTooltipView *tooltipView;

@property (nonatomic, retain) NSMutableArray *aryFilteredGraphData;
@property (nonatomic, retain) NSMutableArray *arySegmentStateData;

@end

@implementation BarWidgetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    if (self = [super init])
    {

    }
    return self;
}

- (id) initWithParent:(UIView *)parent
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, parent.frame.size.width, BAR_WIDGET_HEIGHT);
        
        [self updateLayout];
        
        [parent addSubview:self];
    }
    return self;
}

- (void) _init
{
    [super _init];
    
    if(self.axisView == nil)
    {
        BarWidgetAxisView *axisView = [[BarWidgetAxisView alloc] init];
        axisView.frame = CGRectMake(0, (WIDGET_TITLEBAR_HEIGHT + BAR_WIDGET_LEGEND_HEIGHT), self.frame.size.width, self.frame.size.height - (WIDGET_TITLEBAR_HEIGHT + BAR_WIDGET_LEGEND_HEIGHT));
        
        [self addSubview:axisView];
        self.axisView = axisView;
        self.axisView.delegate = self;
        self.axisView.graphView.delegate = self;
        axisView = nil;
    }
    
    if(self.legendView == nil)
    {
        BarWidgetLegendView *legendView = [[BarWidgetLegendView alloc] init];
        legendView.delegate = self;
        legendView.frame = CGRectMake(0, WIDGET_TITLEBAR_HEIGHT, self.frame.size.width,BAR_WIDGET_LEGEND_HEIGHT);
        
        [self addSubview:legendView];
        self.legendView = legendView;
        legendView = nil;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayout];
}

- (void) updateLayout
{
    self.axisView.frame = CGRectMake(0, (WIDGET_TITLEBAR_HEIGHT + BAR_WIDGET_LEGEND_HEIGHT), self.frame.size.width, self.frame.size.height - (WIDGET_TITLEBAR_HEIGHT + BAR_WIDGET_LEGEND_HEIGHT));
    self.legendView.frame = CGRectMake(0, WIDGET_TITLEBAR_HEIGHT, self.frame.size.width,BAR_WIDGET_LEGEND_HEIGHT);
}

- (BOOL) isExistCompareDateRangeData
{
    NSArray *compareDateRange = [self.WgComparisionData objectForKey:@"compareDateRange"];
    
    for (int n = 0 ; n < compareDateRange.count;  n++) {
        NSDictionary *segmentData = [compareDateRange objectAtIndex:n];
        
        NSArray *metricDatas = [segmentData.allValues firstObject];
        
        if(metricDatas.count > 0)
        {
            NSDictionary *primaryMetricDatas = [metricDatas objectAtIndex:0];
            NSDictionary *dicPrimaryMetricDatas = [primaryMetricDatas.allValues firstObject];
            NSArray *aryPrimaryMetricDatas = [dicPrimaryMetricDatas objectForKey:@"data"];
            
            if(aryPrimaryMetricDatas.count > 0) return YES;
        }
    }
    
    return NO;
}

-(void)UpdateWidget
{
    [super UpdateWidget];
    
    NSLog(@"%@", self.WgComparisionData);
    
    self.axisView.lblMetric.text = [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"];
    
    NSArray *primaryDateRange = [self.WgComparisionData objectForKey:@"primaryDateRange"];
    
    NSMutableArray *arySegmentNames = [[NSMutableArray alloc] init];
    
    NSMutableArray *aryLabels = [[NSMutableArray alloc] init];
    for (int n = 0 ; n < primaryDateRange.count;  n++) {
        NSDictionary *segmentData = [primaryDateRange objectAtIndex:n];
        
        NSArray *metricDatas = [segmentData.allValues firstObject];
        NSString *segmentName = [segmentData.allKeys firstObject];
        
        [arySegmentNames addObject:segmentName];
        
        if(metricDatas.count > 0)
        {
            NSDictionary *primaryMetricDatas = [metricDatas objectAtIndex:0];
            NSDictionary *dicPrimaryMetricDatas = [primaryMetricDatas.allValues firstObject];
            NSArray *aryPrimaryMetricDatas = [dicPrimaryMetricDatas objectForKey:@"data"];
            
            for (NSDictionary *data in aryPrimaryMetricDatas) {
                
                NSString *label = [data objectForKey:@"label"];
                
                if(![aryLabels containsObject:label])
                {
                    [aryLabels addObject:label];
                }
            }
        }
    }
    
    if([self isExistCompareDateRangeData])
    {
        NSArray *compareDateRange = [self.WgComparisionData objectForKey:@"compareDateRange"];

        for (int n = 0 ; n < compareDateRange.count;  n++) {
            NSDictionary *segmentData = [compareDateRange objectAtIndex:n];
            
            NSString *segmentName = [segmentData.allKeys firstObject];
            
            [arySegmentNames addObject:segmentName];
        }
    }
    
    [self.legendView setSegmentList:arySegmentNames];
    arySegmentNames = nil;
    
    NSMutableArray *aryGraphDatas = [[NSMutableArray alloc] init];
    for (int n = 0 ; n < primaryDateRange.count;  n++) {
        
        NSMutableArray *arySegmentGraphDatas = [[NSMutableArray alloc] init];
        
        NSDictionary *segmentData = [primaryDateRange objectAtIndex:n];
        NSString *segmentName = [segmentData.allKeys firstObject];
        NSArray *metricDatas = [segmentData.allValues firstObject];
        
        if(metricDatas.count > 0)
        {
            NSDictionary *primaryMetricDatas = [metricDatas objectAtIndex:0];
            NSDictionary *dicPrimaryMetricDatas = [primaryMetricDatas.allValues firstObject];
            NSArray *aryPrimaryMetricDatas = [dicPrimaryMetricDatas objectForKey:@"data"];
            
            for (NSString *label in aryLabels) {
                
                BOOL isExit = NO;
                for (NSDictionary *data in aryPrimaryMetricDatas) {
                    
                    NSString *label_ = [data objectForKey:@"label"];
                    
                    if([label isEqualToString:label_])
                    {
                        [arySegmentGraphDatas addObject:data];
                        
                        isExit = YES;
                        
                        break;
                    }
                }
                
                if(!isExit)
                {
                    NSDictionary *dic = @{@"date" : label, @"label" : label, @"value" : [NSNumber numberWithFloat:0]};
                    
                    [arySegmentGraphDatas addObject:dic];
                }
            }
        }
        
        if(arySegmentGraphDatas.count > 0)
        {
            NSDictionary *dic = @{segmentName : arySegmentGraphDatas};
            
            [aryGraphDatas addObject:dic];
        }
        
        arySegmentGraphDatas = nil;
    }
    
    if([self isExistCompareDateRangeData])
    {
        NSArray *compareDateRange = [self.WgComparisionData objectForKey:@"compareDateRange"];
        
        for (int n = 0 ; n < compareDateRange.count;  n++) {
            
            NSMutableArray *arySegmentGraphDatas = [[NSMutableArray alloc] init];
            
            NSDictionary *segmentData = [compareDateRange objectAtIndex:n];
            NSString *segmentName = [segmentData.allKeys firstObject];
            NSArray *metricDatas = [segmentData.allValues firstObject];
            
            if(metricDatas.count > 0)
            {
                NSDictionary *compareMetricDatas = [metricDatas objectAtIndex:0];
                NSDictionary *dicCompareMetricDatas = [compareMetricDatas.allValues firstObject];
                NSArray *aryCompareMetricDatas = [dicCompareMetricDatas objectForKey:@"data"];
                
                for (NSString *label in aryLabels) {
                    
                    BOOL isExit = NO;
                    for (NSDictionary *data in aryCompareMetricDatas) {
                        
                        NSString *label_ = [data objectForKey:@"label"];
                        
                        if([label isEqualToString:label_])
                        {
                            [arySegmentGraphDatas addObject:data];
                            
                            isExit = YES;
                            
                            break;
                        }

                    }
                    
                    if(!isExit)
                    {
                        NSDictionary *dic = @{@"date" : label, @"label" : label, @"value" : [NSNumber numberWithFloat:0]};
                        
                        [arySegmentGraphDatas addObject:dic];
                    }
                }
            }
            
            if(arySegmentGraphDatas.count > 0)
            {
                NSDictionary *dic = @{segmentName : arySegmentGraphDatas};
                
                [aryGraphDatas addObject:dic];
            }
            
            arySegmentGraphDatas = nil;
        }
    }
    
    self.aryFilteredGraphData = aryGraphDatas;
    aryGraphDatas = nil;
    
    [self loadGraphData];
}

- (void) loadGraphData
{
    if(self.aryFilteredGraphData.count == 0) return;
    
    NSMutableArray *aryLabels = [[NSMutableArray alloc] init];
    NSMutableArray *aryValues = [[NSMutableArray alloc] init];
    
    float maxValue = 0;
    
    for (int index = 0 ; index < self.aryFilteredGraphData.count ; index ++) {
        
        NSDictionary *dicSegmentGraphData = [self.aryFilteredGraphData objectAtIndex:index];

        NSArray *segmentGraphData = [dicSegmentGraphData.allValues firstObject];
        NSString *segmentName = [dicSegmentGraphData.allKeys firstObject];
        
        BOOL state = [self isShowableSegmentWithName:segmentName index:index];
        
        if(!state) continue;
        
        NSMutableArray *arySegmentValues = [[NSMutableArray alloc] init];
        
        for (NSDictionary *graphData in segmentGraphData) {
            
            NSString *label = [graphData objectForKey:@"label"];
            
            NSString *value = [graphData objectForKey:@"value"];
            float fValue = 0;
            if(value != nil) fValue = [value floatValue];
            
            if(fValue > maxValue) maxValue = fValue;
            
            if(![aryLabels containsObject:label]) [aryLabels addObject:label];
            
            [arySegmentValues addObject:[NSNumber numberWithFloat:fValue]];
        }
        
        if(arySegmentValues.count > 0)
        {
            UIColor *color = [[SharedMembers sharedInstance] getSegmentColorWithIndex:index];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:color, @"color",
                                 segmentName, @"name",
                                 arySegmentValues, @"value", nil];
            
            [aryValues addObject:dic];
        }
        arySegmentValues = nil;
    }
    
    [self.axisView setMaxY:maxValue];
    [self.axisView setAryXLabels:aryLabels];
    
    [self.axisView.graphView setGraphDatas:aryValues];
    
    aryLabels = nil;
    aryValues = nil;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.axisView.frame.size.height + (WIDGET_TITLEBAR_HEIGHT + BAR_WIDGET_LEGEND_HEIGHT));
    
    //[self.delegate updatedWidgetHeight:self];
}

- (BOOL) isShowableSegmentWithName:(NSString *)segmentName index:(int)index
{
    if(self.arySegmentStateData == nil || index >= self.arySegmentStateData.count) return YES;
    
    NSMutableDictionary *segment = [self.arySegmentStateData objectAtIndex:index];
        
    NSString *segmentName_ = [segment objectForKey:SEGMENT_NAME];
    
    if([segmentName_ isEqualToString:segmentName])
    {
        BOOL state = [[segment objectForKey:SEGMENT_STATE] boolValue];
        
        return state;
    }
    
    return false;
}

- (void) showBarWigetPopView:(NSString *)segmentName label:(NSString *)label value:(NSString *)value point:(CGPoint)pt
{
    if(self.tooltipView == nil)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"BarWidgetTooltipView" owner:self options:nil];
        BarWidgetTooltipView* vw = [nib objectAtIndex:0];
        vw.layer.borderColor = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:208.0f / 255.0f alpha:1.0f].CGColor;
        vw.layer.borderWidth = 1;

        [self addSubview:vw];
        self.tooltipView = vw;
    }
    
    self.tooltipView.hidden = NO;
    
    CGSize szTooltip = self.tooltipView.frame.size;
    
    float centerX = MAX(szTooltip.width / 2, MIN(self.frame.size.width - szTooltip.width / 2, pt.x));
    float centerY = MAX(szTooltip.height / 2, MIN(self.frame.size.height - szTooltip.height / 2, pt.y - self.tooltipView.frame.size.height / 2));
    
    self.tooltipView.center = CGPointMake(centerX, centerY);
    
    [self.tooltipView setSegmentDataWithName:segmentName value:[NSString stringWithFormat:@"%@ on %@", value, label]];
    [self bringSubviewToFront:self.tooltipView];
}

- (void) hideTooltipView
{
    self.tooltipView.hidden = YES;
}

#pragma mark BarWidgetLegendViewDelegate

- (void) updatedSegmentStateData:(NSMutableArray *)arySegmentStateData
{
    self.arySegmentStateData = arySegmentStateData;
    
    [self loadGraphData];
}

#pragma mark BarWidgetGraphViewDelegate

- (void) showGraphDetailInfo:(UIView *)view  segment:(NSString *)segmentName index:(NSInteger)dataIndex point:(CGPoint)point
{
    CGPoint pt = [self convertPoint:point fromView:view];
    
    for (int index = 0 ; index < self.aryFilteredGraphData.count ; index ++) {
        
        NSDictionary *dicSegmentGraphData = [self.aryFilteredGraphData objectAtIndex:index];
        
        NSString *segmentName_ = [dicSegmentGraphData.allKeys firstObject];
        
        if([segmentName_ isEqualToString:segmentName])
        {
            NSArray *segmentGraphData = [dicSegmentGraphData.allValues firstObject];
            
            if(dataIndex < segmentGraphData.count)
            {
                NSDictionary *graphData = [segmentGraphData objectAtIndex:dataIndex];
                
                NSString *label = [graphData objectForKey:@"label"];
                NSString *value = [graphData objectForKey:@"value"];
                
                [self showBarWigetPopView:segmentName label:label value:value point:pt];
                
                break;
            }
        }
    }
}

- (void) hideGraphDetailInfo:(UIView *)view
{
    [self hideTooltipView];
}

#pragma mark BarWidgetAxisViewDelegate

- (void) scrolledGraph
{
    [self hideTooltipView];
}

@end
