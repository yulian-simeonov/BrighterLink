//
//  DataSourceTreeNode.m
//  BrighterLink
//
//  Created by mobile master on 11/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DataSourceTreeNode.h"

@implementation DataSourceTreeNode
- (id)initWithName:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = [NSArray arrayWithArray:children];
        self.name = name;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithName:name children:children];
}

- (void)addChild:(id)child
{
    NSMutableArray *children = [self.children mutableCopy];
    [children insertObject:child atIndex:0];
    self.children = [children copy];
}

- (void)removeChild:(id)child
{
    NSMutableArray *children = [self.children mutableCopy];
    [children removeObject:child];
    self.children = [children copy];
}
@end
