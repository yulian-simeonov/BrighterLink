//
//  DashboardCreator.h
//  BrighterLink
//
//  Created by Andriy on 11/15/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardCreator : NSObject

- (id) initWithId:(NSString *)creator role:(NSString *)role;

@property (nonatomic, retain) NSString *creator;

@property (nonatomic, retain) NSString *role;

@end
