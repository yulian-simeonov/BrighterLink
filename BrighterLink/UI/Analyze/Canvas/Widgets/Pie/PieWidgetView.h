//
//  PieWidgetView.h
//  BrighterLink
//
//  Created by mobile on 12/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetView.h"
#import "PieChartView.h"

@interface PieWidgetView : WidgetView
{
    NSMutableArray* m_pieCharts;
}
+(PieWidgetView*)ShowPieWidget:(UIView*)parent;
@end
