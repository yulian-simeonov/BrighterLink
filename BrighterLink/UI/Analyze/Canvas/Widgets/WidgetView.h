//
//  WidgetView.h
//  BrighterLink
//
//  Created by mobile on 11/26/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WidgetInfo.h"

#define WIDGET_TITLEBAR_HEIGHT 40
#define WIDGET_DEFAULT_HEIGHT 240

#define NOTIFICATION_RELOAD_CANVAS @"notification_reload_canvas"

@class AnalyzeViewController;

@protocol WidgetViewDelegate <NSObject>

- (void) updatedWidgetHeight:(UIView *)widgetView;

@end

@interface WidgetView : UIView
{

}

@property (nonatomic, assign) id<WidgetViewDelegate> delegate;

@property (nonatomic, assign) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, assign) UILabel *lblTitle;

@property (nonatomic, assign) UIButton *btnCompress;

@property (nonatomic, strong) NSDictionary* WgInfo;
@property (nonatomic, strong) NSDictionary* WgComparisionData;

@property (nonatomic, assign) BOOL isMinimized;

@property (nonatomic, assign) AnalyzeViewController *analyzeController;

@property (nonatomic, assign) BOOL isUnknownState;

- (id) init;
- (void) _init;

- (NSString *) getWidgetType;

- (void) GetWidgetDatas;
-(void)UpdateWidget;

- (void) setPlaceHolderState;
- (void) setUnknowType;

- (void) minimize:(void (^)())completion;
- (void) maximize:(void (^)())completion;

- (void) hideTooltipView;

- (void) showCompressButton:(AnalyzeViewController *)analyzeController;
- (void) hideCompressButton;

@end
