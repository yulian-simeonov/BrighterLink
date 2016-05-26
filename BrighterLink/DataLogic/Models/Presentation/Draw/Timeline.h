//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timeline.h"

@interface Timeline : NSObject
{

}

@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *startDate;
//@property (nonatomic, strong) NSArray  *date;

@property (nonatomic, strong) NSMutableArray * arrDate;

@end
