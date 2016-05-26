//
//  SegmentInfo.m
//  BrighterLink
//
//  Created by Andriy on 11/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SegmentInfo.h"

#define SEGMENT_ID      @"id"
#define SEGMENT_NAME    @"name"
#define SEGMENT_TAGS    @"tagBindings"

@implementation SegmentInfo

- (id) initWithId:(NSString *)_id name:(NSString *)name tags:(NSArray *)tagBinings
{
    self = [super init];
    if (self) {
        
        self._id = _id;
        self.name = name;
        self.tagBindings = tagBinings;
    }
    
    return self;
}

- (id) initWithDictionary:(NSDictionary *)segment
{
    NSString *_id = [segment objectForKey:SEGMENT_ID];
    NSString *name = [segment objectForKey:SEGMENT_NAME];
    NSArray *tagBindings = [segment objectForKey:SEGMENT_TAGS];

    return [self initWithId:_id name:name tags:tagBindings];
}

@end
