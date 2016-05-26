//
//  DataSourceTreeNode.h
//  BrighterLink
//
//  Created by mobile master on 11/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSourceTreeNode : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *children;

- (id)initWithName:(NSString *)name children:(NSArray *)array;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

- (void)addChild:(id)child;
- (void)removeChild:(id)child;
@end
