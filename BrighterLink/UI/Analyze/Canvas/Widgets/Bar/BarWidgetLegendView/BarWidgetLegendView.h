//
//  BarWidgetLegendView.h
//  BrighterLink
//
//  Created by Andriy on 12/11/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEGMENT_NAME @"segmentname"
#define SEGMENT_STATE @"state"

@protocol BarWidgetLegentViewDelegate <NSObject>

- (void) updatedSegmentStateData:(NSMutableArray *)arySegmentStateData;

@end

@interface BarWidgetLegendView : UIView

@property (nonatomic, assign) id<BarWidgetLegentViewDelegate>delegate;

- (void) setSegmentList:(NSArray *)arySegments;

@end
