//
//  TagRule.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagRule : NSObject
{

}

@property (nonatomic, strong) NSString*     id;
@property (nonatomic, strong) NSString*     tagType;
@property (nonatomic, strong) NSString*     creatorRole;
@property (nonatomic, strong) NSString*     creator;
@property (nonatomic, strong) NSArray*      parentTagTypes;
@property (nonatomic, strong) NSArray*      childrenTagTypes;
@end
