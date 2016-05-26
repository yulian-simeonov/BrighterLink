//
//  Account.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebManager.h"
#import "UserInfo.h"

@interface Account : NSObject
{

}

@property (nonatomic, strong) NSString*     _id;
@property (nonatomic, strong) NSString*     name;
@property (nonatomic, strong) NSString*     shippingStreet;
@property (nonatomic, strong) NSString*     shippingState;
@property (nonatomic, strong) NSString*     shippingPostalCode;
@property (nonatomic, strong) NSString*     shippingCountry;
@property (nonatomic, strong) NSString*     shippingCity;
@property (nonatomic, strong) NSString*     billingStreet;
@property (nonatomic, strong) NSString*     billingState;
@property (nonatomic, strong) NSString*     billingPostalCode;
@property (nonatomic, strong) NSString*     billingCountry;
@property (nonatomic, strong) NSString*     billingCity;
@property (nonatomic, strong) NSString*     cname;
@property (nonatomic, strong) NSString*     tickerSymbol;
@property (nonatomic, strong) NSString*     dunsNumber;
@property (nonatomic, strong) NSString*     webSite;
@property (nonatomic, strong) NSString*     phone;
@property (nonatomic, strong) NSString*     email;
@property (nonatomic, strong) NSString*     sfdcAccountId;
@property (nonatomic, strong) NSString*     version;
@property (nonatomic, strong) NSString*     billingAddress;
@property (nonatomic, strong) NSString*     shippingAddress;
@property (nonatomic, strong) NSString*     awsAssetsKeyPrefix;
@property (nonatomic, strong) NSString*     sfdcAccountURL;

-(void)AddNewAccount:(UserInfo*)member success:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock;
-(void)UpdateAccount:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock;
@end
