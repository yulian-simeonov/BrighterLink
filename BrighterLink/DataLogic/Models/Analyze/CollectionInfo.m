//
//  CollectionInfo.m
//  BrighterLink
//
//  Created by Andriy on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "CollectionInfo.h"

#import "DashboardInfo.h"

@implementation CollectionInfo

- (id) initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
        
        self.aryDashboards = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addDashboard:(DashboardInfo *)dashboard
{
    [self.aryDashboards addObject:dashboard];
}

@end
