//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SolarInfo : NSObject
{
 
}

@property (nonatomic, strong) NSNumber * currentGeneration;
@property (nonatomic, strong) NSString * endDate;
@property (nonatomic, strong) NSNumber * kWhGenerated;
@property (nonatomic, strong) NSNumber * reimbursement;
@property (nonatomic, strong) NSString * startDate;


- (void)  SetGraphInfoDic:(NSDictionary*) dic;

@end


