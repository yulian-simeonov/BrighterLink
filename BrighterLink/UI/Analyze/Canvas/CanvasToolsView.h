//
//  CanvasToolsView.h
//  BrighterLink
//
//  Created by Andriy on 12/2/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CanvasToolsViewDelegate <NSObject>

- (void)startDragWidgetView:(UIView *)view;
- (void)moveDragWidgetView:(UIView *)view;
- (void)stopDragWidgetView:(UIView *)view;

- (void) minimizeCurrentWidgetView:(UIView *)view;
- (void) maxmizeCurrentWidgetView:(UIView *)view;

- (void) deleteWidgetView:(UIView *)view;
- (void) editWidgetView:(UIView *)view;

- (void) expandWidgetView:(UIView *)view;

@end

@interface CanvasToolsView : UIView

@property (nonatomic, assign) id <CanvasToolsViewDelegate> delegate;

@property (nonatomic, assign) IBOutlet UIButton *btnMinimize;

- (void) setMinimizeState:(BOOL)isMinimized;

@end
