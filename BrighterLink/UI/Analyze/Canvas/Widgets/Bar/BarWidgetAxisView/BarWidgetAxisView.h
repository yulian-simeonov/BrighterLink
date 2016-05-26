//
//  BarWidgetAxisView.h
//  BrighterLink
//
//  Created by Andriy on 12/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarWidgetGraphView;

@protocol BarWidgetAxisViewDelegate <NSObject>

- (void) scrolledGraph;

@end

@interface BarWidgetAxisView : UIView
{
    
}

@property (nonatomic, assign) id<BarWidgetAxisViewDelegate> delegate;

@property (nonatomic, assign) UILabel *lblMetric;

@property (nonatomic, assign) float maxY;

@property (nonatomic, retain) NSArray *aryXLabels;

@property (nonatomic, assign) UIScrollView *svContent;

@property (nonatomic, assign) BarWidgetGraphView *graphView;

- (id) init;

@end
