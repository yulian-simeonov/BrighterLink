//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SeriesItem : NSObject
{

}

@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * yAxis;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSMutableArray * datas;

@end
