//
//  TimelineWidgetView.h
//  BrighterLink
//
//  Created by mobile on 11/25/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetView.h"
#import "TimelineGraphView.h"
#import "TimelineWidgetTooltipView.h"
#import "TimelineWidgetLegendView.h"
#import "TimelineWidgetFullScreenView.h"

@interface TimelineWidgetView : WidgetView
{
    TimelineGraphView* m_graph;
    TimelineWidgetLegendView* vw_legend;
    TimelineWidgetTooltipView* vw_tooltip;
    TimelineWidgetFullScreenView* vw_fullScreen;
    NSMutableArray* lbl_units;
    IBOutlet UILabel* lbl_primaryMetricName;
    IBOutlet UILabel* lbl_comparisionMetricName;
    NSMutableArray* m_metricUnits;
    NSMutableArray* m_comparisonMetricUnits;
    NSMutableArray* m_lineData;
    NSMutableArray* m_legendData;
    NSMutableArray* m_hiddenData;
    NSMutableArray* m_dateRange;
}

+(TimelineWidgetView*)ShowGraphic:(UIView*)parentView;

-(void)Captured:(CGPoint)pos offset:(int)offset;
-(void)TouchMoved:(CGPoint)pos  offset:(int)offset;
-(void)Released;
-(void)SetVisibiityGraphData:(NSString*)name show:(BOOL)show;
@end
