//
//  PieWidgetLegendView.h
//  BrighterLink
//
//  Created by mobile on 12/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PieChartView;
@interface PieWidgetLegendView : UIView
{
    NSMutableArray* m_whiteSpots;
    NSArray* m_data;
}
@property (nonatomic, weak) PieChartView* delegate;
-(void)UpdateData:(NSArray*)data hiddenData:(NSArray*)hiddenData;
@end
