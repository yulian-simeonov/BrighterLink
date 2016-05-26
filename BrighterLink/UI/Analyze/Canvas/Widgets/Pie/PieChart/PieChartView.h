//
//  PieChartView.h
//  BrighterLink
//
//  Created by mobile on 12/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieWidgetLegendView.h"
#import "PieWidgetTooltipView.h"

#define PieRadius   60
#define PieChartOffset 50
#define PieLineWidth 10

@interface PieChartView : UIView
{
    float m_totalValue;
    NSMutableArray* m_labels;
    PieWidgetLegendView* vw_legend;
    PieWidgetTooltipView* vw_tooltip;
    NSMutableArray* m_hiddenData;
}
@property (nonatomic, strong) NSString* SegmentName;
@property (nonatomic, strong) NSArray* MetricData;
@property (nonatomic, strong) UIColor* MetricColor;
@property (nonatomic) int SliceCount;
-(void)Refresh;
-(void)SetVisibiityGraphData:(NSString*)name show:(BOOL)show;
@end
