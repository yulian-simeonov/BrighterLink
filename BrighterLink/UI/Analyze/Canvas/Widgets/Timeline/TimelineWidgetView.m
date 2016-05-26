//
//  TimelineWidgetView.m
//  BrighterLink
//
//  Created by mobile on 11/25/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TimelineWidgetView.h"
#import "SharedMembers.h"
#import "AppDelegate.h"

#import <float.h>

#define YUnitCount 4

@implementation TimelineWidgetView

+(TimelineWidgetView*)ShowGraphic:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TimelineWidgetView" owner:parentView options:nil];
    TimelineWidgetView* vw = [nib objectAtIndex:0];
    [vw setFrame:CGRectMake(0, 0, parentView.frame.size.width, vw.frame.size.height)];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    m_graph = [TimelineGraphView ShowGraphic:self];
    [m_graph setDelegate:self];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    [m_graph addGestureRecognizer:tapGesture];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    vw_fullScreen = [TimelineWidgetFullScreenView ShowFullScreen:app.window.rootViewController.view];
    
    vw_legend = [[TimelineWidgetLegendView alloc] init];
    [vw_legend setDelegate:self];
    
    [self addSubview:vw_legend];
    
    m_lineData = [[NSMutableArray alloc] init];
    m_legendData = [[NSMutableArray alloc] init];
    m_hiddenData = [[NSMutableArray alloc] init];
    m_dateRange = [[NSMutableArray alloc] init];
    lbl_units = [[NSMutableArray alloc] init];
    m_metricUnits = [[NSMutableArray alloc] init];
    m_comparisonMetricUnits = [[NSMutableArray alloc] init];
    
    [m_graph setFrame:CGRectMake(50, 80, self.frame.size.width - 100, 140)];
    
    lbl_primaryMetricName.transform = CGAffineTransformMakeRotation(-M_PI_2);
    lbl_comparisionMetricName.transform = CGAffineTransformMakeRotation(M_PI_2);
}

-(void)DoubleTap:(UIGestureRecognizer*)gesture
{
    [UIView animateWithDuration:1.0f animations:^{
        [vw_fullScreen setAlpha:1.0f];
    }];
}

-(void)UpdateWidget
{
    [super UpdateWidget];
 
    if (!self.WgInfo || !self.WgComparisionData)
    {
        [self setHidden:YES];
        return;
    }
    [self setHidden:NO];

    [self InitLegendLabels];
    [vw_legend UpdateData:m_legendData];
    [self UpdateGraph];
    [vw_fullScreen UpdateWidget];
}

-(void)setWgInfo:(NSDictionary *)WgInfo
{
    super.WgInfo = WgInfo;
    [vw_fullScreen setWgInfo:WgInfo];
}

-(void)setWgComparisionData:(NSDictionary *)WgComparisionData
{
    super.WgComparisionData = WgComparisionData;
    [vw_fullScreen setWgComparisionData:WgComparisionData];
}

-(void)UpdateGraph
{
    [self InitGraphLabels];
    [self UpdateLineData];
    
    [lbl_primaryMetricName setHidden:NO];
    [lbl_primaryMetricName setText:[[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]];
    [lbl_primaryMetricName sizeToFit];
    
    [lbl_comparisionMetricName setHidden:NO];
    if (![[self.WgInfo objectForKey:@"compareMetric"] isEqual:[NSNull null]])
        [lbl_comparisionMetricName setText:[[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]];
    [lbl_comparisionMetricName sizeToFit];
    
    for(UILabel* lbl in lbl_units)
        [lbl removeFromSuperview];
    
    float graphYPos = vw_legend.frame.size.height + WIDGET_TITLEBAR_HEIGHT;
    float graphHeight = 140;
    float maxMetricUnitWidth = [self GetLabelMaxSize:m_metricUnits withFontSize:10].width;
    float maxDateUnitWidth = [self GetLabelMaxSize:m_dateRange withFontSize:12].width;
    float dateLabelOffset = maxDateUnitWidth / 2 * sin(M_PI_4);
    float dateLblHeight = [self GetLabelMaxSize:m_dateRange withFontSize:12].height;
    float graphXPos = 0;
    if (28 + maxMetricUnitWidth < dateLabelOffset * 2)
        maxMetricUnitWidth = dateLabelOffset * 2 - 28;
    graphXPos = 28 + maxMetricUnitWidth;
    
    NSDictionary* primaryMetricRange = [self GetPrimaryMetricRange:[self.WgComparisionData objectForKey:@"primaryDateRange"]];
    int offset = [[primaryMetricRange objectForKey:@"max"] intValue] - [[primaryMetricRange objectForKey:@"min"] intValue];
    if (offset > 0)
    {
        for(int i = 0; i < YUnitCount + 1; i++)
        {
            UILabel* lbl = [[UILabel alloc] init];
            [lbl setFont:[UIFont boldSystemFontOfSize:10]];
            [lbl setTextAlignment:NSTextAlignmentRight];
            [lbl setText:m_metricUnits[YUnitCount - i]];
            [lbl sizeToFit];
            lbl.center = CGPointMake(25 + maxMetricUnitWidth - lbl.frame.size.width / 2, graphYPos + graphHeight / YUnitCount * i);
            if (i == 4)
                lbl.center = CGPointMake(lbl.center.x, lbl.center.y - lbl.frame.size.height / 2);

            [self addSubview:lbl];
            [lbl_units addObject:lbl];
        }
    }
    else
    {
        [lbl_primaryMetricName setHidden:YES];
        graphXPos = 3 + dateLabelOffset * 2;
    }
    float maxComparisionMetricUnitWidth = [self GetLabelMaxSize:m_comparisonMetricUnits withFontSize:10].width;
    float graphWidth = self.frame.size.width - graphXPos - maxComparisionMetricUnitWidth - 28;
    
    NSDictionary* comparisionMetricRange = [self GetComparisionMetricRange:[self.WgComparisionData objectForKey:@"primaryDateRange"]];
    offset = [[comparisionMetricRange objectForKey:@"max"] intValue] - [[comparisionMetricRange objectForKey:@"min"] intValue];
    if (offset > 0)
    {
        for(int i = 0; i < YUnitCount + 1; i++)
        {
            UILabel* lbl = [[UILabel alloc] init];
            [lbl setFont:[UIFont boldSystemFontOfSize:10]];
            [lbl setText:m_comparisonMetricUnits[YUnitCount - i]];
            [lbl sizeToFit];
            lbl.center = CGPointMake(graphXPos + graphWidth + 3 + lbl.frame.size.width / 2, graphYPos + graphHeight / YUnitCount * i);
            if (i == 4)
                lbl.center = CGPointMake(lbl.center.x, lbl.center.y - lbl.frame.size.height / 2);
            [self addSubview:lbl];
            [lbl_units addObject:lbl];
        }
    }
    else
    {
        [lbl_comparisionMetricName setHidden:YES];
        graphWidth = self.frame.size.width - graphXPos - 5;
    }
    
    [self RearrangeDateUnits:graphWidth];
    float dateCount = m_dateRange.count - 1;
    if(dateCount == 0) dateCount = 1;
    
    for(int i = 0; i < m_dateRange.count; i++)
    {
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxDateUnitWidth, dateLblHeight)];
        [lbl setText:[m_dateRange objectAtIndex:i]];
        [lbl setTextAlignment:NSTextAlignmentRight];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        lbl.transform = CGAffineTransformMakeRotation(-M_PI_2 / 2);
        lbl.center = CGPointMake(graphXPos + i * (graphWidth / dateCount) - dateLabelOffset, graphYPos + graphHeight + dateLabelOffset + 5);
        [self addSubview:lbl];
        [lbl_units addObject:lbl];
    }
    lbl_primaryMetricName.center = CGPointMake(lbl_primaryMetricName.center.x, graphYPos + graphHeight / 2);
    lbl_comparisionMetricName.center = CGPointMake(lbl_comparisionMetricName.center.x, graphYPos + graphHeight / 2);

    [m_graph setFrame:CGRectMake(graphXPos, graphYPos, graphWidth, graphHeight)];
    [m_graph UpdateGraph:dateCount yLength:YUnitCount data:m_lineData];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, graphYPos + graphHeight + dateLabelOffset * 2 + 10)];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CANVAS object:nil];
}

-(void)Captured:(CGPoint)pos offset:(int)offset
{
    int colorIdx = 0;
    NSString* date = nil;
    NSMutableArray* tooltipData = [[NSMutableArray alloc] init];
    for(NSDictionary* seg in [self.WgComparisionData objectForKey:@"primaryDateRange"])
    {
        for(NSDictionary* item in seg.allValues.firstObject)
        {
            NSArray* data = [[item objectForKey:@"primaryMetric"] objectForKey:@"data"];
            if (data.count >= offset + 1 && ![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]]])
            {
                [tooltipData addObject:@{@"color" : [NSNumber numberWithInt:colorIdx], @"text" : [NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]], @"value" : [[data objectAtIndex:offset] objectForKey:@"value"], @"type" : [self GetType:m_metricUnits]}];
                date = [[data objectAtIndex:offset] objectForKey:@"label"];
            }
            if (data.count > 0)
                colorIdx++;
            
            data = [[item objectForKey:@"compareMetric"] objectForKey:@"data"];
            if (![[self.WgInfo objectForKey:@"compareMetric"] isEqual:[NSNull null]])
            {
                if (data.count >= offset + 1 && ![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]]])
                {
                    [tooltipData addObject:@{@"color" : [NSNumber numberWithInt:colorIdx], @"text" : [NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]], @"value" : [[data objectAtIndex:offset] objectForKey:@"value"], @"type" : [self GetType:m_comparisonMetricUnits]}];
                    date = [[data objectAtIndex:offset] objectForKey:@"label"];
                }
            }
            if (data.count > 0)
                colorIdx++;
        }
    }
    
    if (!vw_tooltip)
    {
        vw_tooltip = [[TimelineWidgetTooltipView alloc] init];
        [self addSubview:vw_tooltip];
        [vw_tooltip UpdateData:tooltipData date:date];
    }
    [vw_tooltip setFrame:CGRectMake(pos.x + 50, pos.y - 50, vw_tooltip.frame.size.width, vw_tooltip.frame.size.height)];
}

-(NSString*)GetType:(NSArray*)ary
{
    for(NSString* item in ary)
    {
        if ([item rangeOfString:@"."].location != NSNotFound)
            return @"float";
    }
    return @"int";
}

-(void)TouchMoved:(CGPoint)pos  offset:(int)offset
{
    int colorIdx = 0;
    NSString* date = nil;
    NSMutableArray* tooltipData = [[NSMutableArray alloc] init];
    for(NSDictionary* seg in [self.WgComparisionData objectForKey:@"primaryDateRange"])
    {
        for(NSDictionary* item in seg.allValues.firstObject)
        {
            NSArray* data = [[item objectForKey:@"primaryMetric"] objectForKey:@"data"];
            if (data.count >= offset + 1 && ![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]]])
            {
                [tooltipData addObject:@{@"color" : [NSNumber numberWithInt:colorIdx], @"text" : [NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]], @"value" : [[data objectAtIndex:offset] objectForKey:@"value"], @"type" : [self GetType:m_metricUnits]}];
                date = [[data objectAtIndex:offset] objectForKey:@"label"];
            }
            if (data.count > 0)
                colorIdx++;
            
            data = [[item objectForKey:@"compareMetric"] objectForKey:@"data"];
            if (![[self.WgInfo objectForKey:@"compareMetric"] isEqual:[NSNull null]])
            {
                if (data.count >= offset + 1 && ![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]]])
                {
                    [tooltipData addObject:@{@"color" : [NSNumber numberWithInt:colorIdx], @"text" : [NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]], @"value" : [[data objectAtIndex:offset] objectForKey:@"value"], @"type" : [self GetType:m_comparisonMetricUnits]}];
                    date = [[data objectAtIndex:offset] objectForKey:@"label"];
                }
            }
            if (data.count > 0)
                colorIdx++;
        }
    }
    
    [vw_tooltip UpdateData:tooltipData date:date];
    if (pos.x + 50 + vw_tooltip.frame.size.width > self.frame.size.width)
        [vw_tooltip setFrame:CGRectMake(pos.x - 50 - vw_tooltip.frame.size.width, pos.y - 50, vw_tooltip.frame.size.width, vw_tooltip.frame.size.height)];
    else
        [vw_tooltip setFrame:CGRectMake(pos.x + 50, pos.y - 50, vw_tooltip.frame.size.width, vw_tooltip.frame.size.height)];
}

-(void)Released
{
    [vw_tooltip removeFromSuperview];
    vw_tooltip = nil;
}

-(void)InitLegendLabels
{
    [m_legendData removeAllObjects];
    for(NSDictionary* seg in [self.WgComparisionData objectForKey:@"primaryDateRange"])
    {
        BOOL hasPrimaryMetric = NO;
        BOOL hasCompareMetric = NO;
        for(NSDictionary* item in seg.allValues.firstObject)
        {
            NSArray* data = [[item objectForKey:@"primaryMetric"] objectForKey:@"data"];
            if (data.count > 0)
                hasPrimaryMetric = YES;
            data = [[item objectForKey:@"compareMetric"] objectForKey:@"data"];
            if (data.count > 0)
                hasCompareMetric = YES;
        }
        if (hasPrimaryMetric && ![[self.WgInfo objectForKey:@"metric"] isEqual:[NSNull null]])
            [m_legendData addObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]]];
        if (hasCompareMetric && ![[self.WgInfo objectForKey:@"compareMetric"] isEqual:[NSNull null]])
            [m_legendData addObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]]];
    }
}

-(void)InitGraphLabels
{
    [m_metricUnits removeAllObjects];
    [m_comparisonMetricUnits removeAllObjects];
    
    NSDictionary* primaryMetricRange = [self GetPrimaryMetricRange:[self.WgComparisionData objectForKey:@"primaryDateRange"]];
    int offset = [[primaryMetricRange objectForKey:@"max"] intValue] - [[primaryMetricRange objectForKey:@"min"] intValue];
    [m_metricUnits addObject:[NSString stringWithFormat:@"%d", [[primaryMetricRange objectForKey:@"min"] intValue]]];
    
    for(int i = 1; i < YUnitCount; i++)
    {
        if (offset > YUnitCount * 10)
            [m_metricUnits addObject:[NSString stringWithFormat:@"%d", [[primaryMetricRange objectForKey:@"min"] intValue] + (int)offset / YUnitCount * i]];
        else
            [m_metricUnits addObject:[NSString stringWithFormat:@"%.2f", [[primaryMetricRange objectForKey:@"min"] floatValue] + offset / (float)YUnitCount * i]];
    }
    [m_metricUnits addObject:[NSString stringWithFormat:@"%d", [[primaryMetricRange objectForKey:@"max"] intValue]]];
    
    NSDictionary* comparisionMetricRange = [self GetComparisionMetricRange:[self.WgComparisionData objectForKey:@"primaryDateRange"]];
    offset = [[comparisionMetricRange objectForKey:@"max"] intValue] - [[comparisionMetricRange objectForKey:@"min"] intValue];
    [m_comparisonMetricUnits addObject:[NSString stringWithFormat:@"%d", [[comparisionMetricRange objectForKey:@"min"] intValue]]];
    for(int i = 1; i < YUnitCount; i++)
    {
        if (offset > YUnitCount * 10)
            [m_comparisonMetricUnits addObject:[NSString stringWithFormat:@"%d", [[comparisionMetricRange objectForKey:@"min"] intValue] + (int)offset / YUnitCount * i]];
        else
            [m_comparisonMetricUnits addObject:[NSString stringWithFormat:@"%.2f", [[comparisionMetricRange objectForKey:@"min"] floatValue] + offset / (float)YUnitCount * i]];
    }
    [m_comparisonMetricUnits addObject:[NSString stringWithFormat:@"%d", [[comparisionMetricRange objectForKey:@"max"] intValue]]];
}

-(void)RearrangeDateUnits:(float)graphWidth
{
    int removableCount = 0;
    while(true)
    {
        float count = (m_dateRange.count - 1) / (removableCount + 1);
        if (graphWidth / count > 50)
            break;
        removableCount++;
        if (removableCount == m_dateRange.count - 2)
            break;
    }
    if (removableCount == 0)
        return;
    NSMutableArray* tmpAry = [[NSMutableArray alloc] init];
    for(int i = 0; i < m_dateRange.count; i = i + (removableCount + 1))
    {
        [tmpAry addObject:[m_dateRange objectAtIndex:i]];
    }
    [m_dateRange removeAllObjects];
    m_dateRange = tmpAry;
}

-(void)UpdateLineData
{
    [m_lineData removeAllObjects];
    [m_dateRange removeAllObjects];
    
    NSDictionary* primaryMetricRange = [self GetPrimaryMetricRange:[self.WgComparisionData objectForKey:@"primaryDateRange"]];
    float primaryMetricOffset = [[primaryMetricRange objectForKey:@"max"] intValue] - [[primaryMetricRange objectForKey:@"min"] intValue];
    
    NSDictionary* comparisionMetricRange = [self GetComparisionMetricRange:[self.WgComparisionData objectForKey:@"primaryDateRange"]];
    float compareMetricOffset = [[comparisionMetricRange objectForKey:@"max"] intValue] - [[comparisionMetricRange objectForKey:@"min"] intValue];
    
    int colorIdx = 0;
    for(NSDictionary* seg in [self.WgComparisionData objectForKey:@"primaryDateRange"])
    {
        for(NSDictionary* item in seg.allValues.firstObject)
        {
            NSMutableArray* primaryMetricData = [[NSMutableArray alloc] init];
            for(NSDictionary* metric in [[item objectForKey:@"primaryMetric"] objectForKey:@"data"])
            {
                float value = ([[metric objectForKey:@"value"] floatValue] - [[primaryMetricRange objectForKey:@"min"] floatValue]) / primaryMetricOffset;
                [primaryMetricData addObject:[NSNumber numberWithFloat:value]];
                if (![m_dateRange containsObject:[metric objectForKey:@"label"]])
                    [m_dateRange addObject:[metric objectForKey:@"label"]];
            }
                
            if (primaryMetricData.count > 0)
            {
                if (![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]]])
                    [m_lineData addObject:@{@"color" : [NSNumber numberWithInt:colorIdx], @"data" : primaryMetricData}];
                colorIdx++;
            }

            NSMutableArray* compareMetricData = [[NSMutableArray alloc] init];
            for(NSDictionary* metric in [[item objectForKey:@"compareMetric"] objectForKey:@"data"])
            {
                float value = ([[metric objectForKey:@"value"] floatValue] - [[comparisionMetricRange objectForKey:@"min"] floatValue]) / compareMetricOffset;
                [compareMetricData addObject:[NSNumber numberWithFloat:value]];
                if (![m_dateRange containsObject:[metric objectForKey:@"label"]])
                    [m_dateRange addObject:[metric objectForKey:@"label"]];
            }
            if (compareMetricData.count > 0 && ![[self.WgInfo objectForKey:@"compareMetric"] isEqual:[NSNull null]])
            {
                if (![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]]])
                    [m_lineData addObject:@{@"color" : [NSNumber numberWithInt:colorIdx], @"data" : compareMetricData}];
                colorIdx++;
            }
        }
    }
}

-(CGSize)GetLabelMaxSize:(NSArray*)strAry withFontSize:(int)fontSize
{
    NSString* maxTxt = @"";
    for(int i = 0; i < strAry.count; i++)
    {
        if(((NSString*)[strAry objectAtIndex:i]).length > maxTxt.length)
            maxTxt = [strAry objectAtIndex:i];
    }
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setFont:[UIFont boldSystemFontOfSize:fontSize]];
    [lbl setText:maxTxt];
    [lbl sizeToFit];
    return CGSizeMake(lbl.frame.size.width, lbl.frame.size.height) ;
}

-(NSDictionary*)GetPrimaryMetricRange:(NSArray*)ary
{
    float min, max;
    min = FLT_MAX;
    max = FLT_MIN;
    for(NSDictionary* seg in ary)
    {
        if (![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"metric"] objectForKey:@"name"]]])
        {
            for(NSDictionary* item in seg.allValues.firstObject)
            {
                for(NSDictionary* metric in [[item objectForKey:@"primaryMetric"] objectForKey:@"data"])
                {
                    if ([[metric objectForKey:@"value"] floatValue] >= max)
                        max = [[metric objectForKey:@"value"] floatValue];
                    if ([[metric objectForKey:@"value"] floatValue] < min)
                        min = [[metric objectForKey:@"value"] floatValue];
                }
            }
        }
    }
    return @{@"min" : [NSNumber numberWithFloat:min], @"max" : [NSNumber numberWithFloat:max]};
}

-(NSDictionary*)GetComparisionMetricRange:(NSArray*)ary
{
    float min, max;
    min = FLT_MAX;
    max = FLT_MIN;
    for(NSDictionary* seg in ary)
    {
        if (![[self.WgInfo objectForKey:@"compareMetric"] isEqual:[NSNull null]])
        {
            if (![m_hiddenData containsObject:[NSString stringWithFormat:@"%@ (%@)", seg.allKeys.firstObject, [[self.WgInfo objectForKey:@"compareMetric"] objectForKey:@"name"]]])
            {
                for(NSDictionary* item in seg.allValues.firstObject)
                {
                    for(NSDictionary* metric in [[item objectForKey:@"compareMetric"] objectForKey:@"data"])
                    {
                        if ([[metric objectForKey:@"value"] floatValue] >= max)
                            max = [[metric objectForKey:@"value"] floatValue];
                        if ([[metric objectForKey:@"value"] floatValue] < min)
                            min = [[metric objectForKey:@"value"] floatValue];
                    }
                }
            }
        }
    }
    return @{@"min" : [NSNumber numberWithFloat:min], @"max" : [NSNumber numberWithFloat:max]};
}

-(void)SetVisibiityGraphData:(NSString*)name show:(BOOL)show
{
    if (show)
        [m_hiddenData removeObject:name];
    else
        [m_hiddenData addObject:name];
    [self UpdateGraph];
}
@end
