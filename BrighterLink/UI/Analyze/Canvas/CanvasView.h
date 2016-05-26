//
//  CanvasView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SharedMembers.h"

@class WidgetView;

typedef enum : NSUInteger {
    CanvasType1 = 1,
    CanvasType2,
    CanvasType3,
    CanvasType4,
    CanvasType5,
    CanvasType6,
} CANVAS_TYPE;

@protocol CanvasViewDelegate <NSObject>

- (void) deleteWidgetWithId:(NSString *)widgetId;
- (void) editWidgetWithId:(NSString *)widgetId;

- (void) expandWidgetView:(WidgetView *)view;

@end

@interface CanvasView : UIView
{

}

@property (nonatomic, assign) id <CanvasViewDelegate> delegate;

@property (nonatomic, assign) NSInteger type;

- (void) updateCanvasWithType:(NSInteger) type;

@end
