//
//  ReorderDashboardView.h
//  BrighterLink
//
//  Created by Andriy on 1/23/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReorderDashboardViewDelegate <NSObject>

- (void) onDoneReorderDashboard:(NSMutableArray *)aryUpdatedDashboards;
- (void) onCancelReorderDashboard;

@end

@interface ReorderDashboardView : UIView

@property (nonatomic, assign) id <ReorderDashboardViewDelegate> delegate;

- (void) initWithDashboards:(NSMutableArray *)aryDashboards;

@end
