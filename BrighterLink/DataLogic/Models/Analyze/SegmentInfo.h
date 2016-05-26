//
//  SegmentInfo.h
//  BrighterLink
//
//  Created by Andriy on 11/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentInfo : NSObject

@property (nonatomic, retain) NSString *_id;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSArray *tagBindings;

- (id) initWithId:(NSString *)_id name:(NSString *)name tags:(NSArray *)tagBinings;
- (id) initWithDictionary:(NSDictionary *)segment;

@end
