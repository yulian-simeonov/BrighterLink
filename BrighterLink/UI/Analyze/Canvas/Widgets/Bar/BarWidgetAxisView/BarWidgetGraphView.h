//
//  BarWidgetGraphView.h
//  BrighterLink
//
//  Created by Andriy on 12/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarWidgetGraphViewDelegate <NSObject>

- (void) showGraphDetailInfo:(UIView *)view  segment:(NSString *)segmentName index:(NSInteger)index point:(CGPoint)point;
- (void) hideGraphDetailInfo:(UIView *)view;

@end

@interface BarWidgetGraphView : UIView

@property (nonatomic, assign) id<BarWidgetGraphViewDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *aryDatas;

@property (nonatomic, assign) float oneBarWidth;
@property (nonatomic, assign) float maxValue;

- (void) setGraphDatas:(NSMutableArray *)aryDatas;

@end
