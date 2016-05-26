//
//  DashboardCreator.m
//  BrighterLink
//
//  Created by Andriy on 11/15/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DashboardCreator.h"

@implementation DashboardCreator

- (id) initWithId:(NSString *)creator role:(NSString *)role
{
    self = [super init];
    
    if(self)
    {
        self.creator = creator;
        
        self.role = role;
    }
    
    return self;
}

@end
