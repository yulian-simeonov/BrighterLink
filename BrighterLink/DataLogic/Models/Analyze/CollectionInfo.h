//
//  CollectionInfo.h
//  BrighterLink
//
//  Created by Andriy on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DashboardInfo;

@interface CollectionInfo : NSObject

@property (nonatomic, retain) NSString *_id;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSMutableArray *aryDashboards;

@property (nonatomic, assign) NSInteger currentDashboard;

- (id) initWithTitle:(NSString *)title;

- (void) addDashboard:(DashboardInfo *)dashboard;

@end
