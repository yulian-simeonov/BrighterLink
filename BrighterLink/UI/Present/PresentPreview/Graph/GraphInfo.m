//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "GraphInfo.h"
#import "SharedMembers.h"
#import "yAxis.h"
#import "SeriesItem.h"
#import "GraphPointInfo.h"

@implementation GraphInfo

- (id) init
{
    _series = [[NSMutableArray alloc] init];
    _yAxis  = [[NSMutableArray alloc] init];
    max = 0;
    return self;
}


- (void)  SetGraphInfoDic:(NSDictionary*) dic
{
    _credits    = [dic objectForKey:@"credits"];
    _exporting  = [dic objectForKey:@"exporting"];
    _legend     = [dic objectForKey:@"legend"];
    _plotOptions = [dic objectForKey:@"plotOptions"];
    
    NSArray * arr = [dic objectForKey:@"series"];
    for ( NSDictionary * dic in arr ) {
        SeriesItem * item = [[SeriesItem alloc] init];
        [item setDictionary:dic];
        NSArray * arr1 = [dic objectForKey:@"data"];
        for ( NSDictionary * dic1 in arr1 ) {
            GraphPointInfo * point = [[GraphPointInfo alloc] init];
            [point setDictionary:dic1];
            [item.datas addObject:point];
        }
        [_series addObject:item];
    }
    
    _title      = [dic objectForKey:@"title"];
    _tooltip    = [dic objectForKey:@"tooltip"];
    _xAxis      = [dic objectForKey:@"xAxis"];

    NSArray * temp  = [dic objectForKey:@"yAxis"];
    for ( NSDictionary * dic in temp ) {
        yAxis * item   = [[yAxis alloc] init];
        [item setDictionary:dic];
        [self.yAxis addObject:item];
    }
    
}

@end
