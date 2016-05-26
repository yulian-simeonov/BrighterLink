//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SharedMembers.h"

@protocol DashboardPanelViewDelegate <NSObject>

- (void) createNewDashboard;
- (void) editDashboard:(DashboardInfo *)dashboard;

@end

@interface DashboardPanelView : UIView
{

}

@property (nonatomic, assign) id <DashboardPanelViewDelegate> delegate;

- (void) _update;

@end
