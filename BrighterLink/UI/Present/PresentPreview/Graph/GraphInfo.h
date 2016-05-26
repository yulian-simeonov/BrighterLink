//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GraphInfo : NSObject
{
    float max;
}

@property (nonatomic, strong) NSDictionary*  credits;
@property (nonatomic, strong) NSDictionary*  exporting;
@property (nonatomic, strong) NSDictionary*  legend;
@property (nonatomic, strong) NSDictionary*  plotOptions;
@property (nonatomic, strong) NSMutableArray*  series;
@property (nonatomic, strong) NSDictionary*  title;
@property (nonatomic, strong) NSDictionary*  tooltip;
@property (nonatomic, strong) NSDictionary*  xAxis;
@property (nonatomic, strong) NSMutableArray*  yAxis;

- (void)  SetGraphInfoDic:(NSDictionary*) dic;

@end


