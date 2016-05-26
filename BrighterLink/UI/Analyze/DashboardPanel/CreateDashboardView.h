//
//  CreateDashboardView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionInfo.h"

@protocol  CreateDashboardViewDelegate <NSObject>

- (void) createNewDashboardWith:(DashboardInfo *)dashboard;

- (void) updateDashboard:(DashboardInfo *)dashboard;

@end

@interface CreateDashboardView : UIView
{

}

@property (nonatomic, assign) id <CreateDashboardViewDelegate> delegate;

@property (nonatomic, retain) CollectionInfo *collection;

@property (nonatomic, retain) DashboardInfo *dashboard;

@end
