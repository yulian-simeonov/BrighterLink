//
//  Tag.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+KJSerializer.h"
#import "SharedMembers.h"

@interface Tag : NSObject
{
@public
    Tag* m_parent;
    BOOL m_selected;
}

@property (nonatomic, strong) NSString*     _id;
@property (nonatomic, strong) NSString*     tagType;
@property (nonatomic, strong) NSString*     name;
@property (nonatomic, strong) NSString*     creatorRole;
@property (nonatomic, strong) NSString*     creator;
@property (nonatomic, strong) NSString*     version;
@property (nonatomic, strong) NSArray*      usersWithAccess;
@property (nonatomic, strong) NSArray*      appEntities;
@property (nonatomic, strong) NSArray*      children;
@property (nonatomic, strong) NSArray*      parents;
@property (nonatomic, strong) NSString*     formula;
@property (nonatomic, strong) NSString*     metricID;
@property (nonatomic, strong) NSString*     metricType;
@property (nonatomic, strong) NSString*     metric;
@property (nonatomic, strong) NSString*     metricList;
@property (nonatomic, strong) NSString*     sensorTarget;
@property (nonatomic, strong) NSString*     enphaseUserId;
@property (nonatomic, strong) NSString*     endDate;
@property (nonatomic, strong) NSString*     weatherStation;
@property (nonatomic, strong) NSNumber*     longitude;
@property (nonatomic, strong) NSNumber*     latitude;
@property (nonatomic, strong) NSString*     webAddress;
@property (nonatomic, strong) NSString*     interval;
@property (nonatomic, strong) NSString*     destination;
@property (nonatomic, strong) NSString*     accessMethod;
@property (nonatomic, strong) NSString*     summaryMethod;
@property (nonatomic, strong) NSString*     deviceID;
@property (nonatomic, strong) NSString*     device;
@property (nonatomic, strong) NSString*     manufacturer;
@property (nonatomic, strong) NSArray*      utilityAccounts;
@property (nonatomic, strong) NSString*     utilityProvider;
@property (nonatomic, strong) NSString*     nonProfit;
@property (nonatomic, strong) NSString*     taxID;
@property (nonatomic, strong) NSString*     street;
@property (nonatomic, strong) NSString*     state;
@property (nonatomic, strong) NSString*     postalCode;
@property (nonatomic, strong) NSString*     country;
@property (nonatomic, strong) NSString*     city;
@property (nonatomic, strong) NSMutableArray*      childrenTags;


-(void)SetDataWithDictionary:(NSDictionary*)dic parent:(Tag*)parentTag;
-(void)AddNewTag:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock;
-(void)UpdateTag:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock;
-(void)DeleteTag:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock;
-(void)setSelected:(BOOL)selected;
-(void)UpdateParent;
@end
