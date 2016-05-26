//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebManager.h"

@interface UserInfo : NSObject
{

}

@property (nonatomic, strong) NSString*     _id;
@property (nonatomic, strong) NSString*     firstName;
@property (nonatomic, strong) NSString*     lastName;
@property (nonatomic, strong) NSString*     email;
@property (nonatomic, strong) NSString* 	emailUser;
@property (nonatomic, strong) NSString* 	emailDomain;
@property (nonatomic, strong) NSArray*      accounts;
@property (nonatomic, strong) NSString*     profilePictureUrl;
@property (nonatomic, strong) NSString*     sfdcContactId;
@property (nonatomic, strong) NSString*     defaultApp;
@property (nonatomic, strong) NSArray*      apps;
@property (nonatomic, strong) NSArray*      previousPasswords;
@property (nonatomic, strong) NSString*     previousEditedDashboardId;
@property (nonatomic, strong) NSString*     lastEditedDashboardId;
@property (nonatomic, strong) NSString*     previousEditedPresentation;
@property (nonatomic, strong) NSString*     lastEditedPresentation;
@property (nonatomic, strong) NSString*     role;
@property (nonatomic, strong) NSString*     enphaseUserId;
@property (nonatomic, strong) NSString*     socialToken;
@property (nonatomic, strong) NSString*     password;
@property (nonatomic, strong) NSString*     phone;
@property (nonatomic, strong) NSString*     middleName;
@property (nonatomic, strong) NSString*     name;
@property (nonatomic, strong) NSString*     sfdcContactURL;
@property (nonatomic, strong) NSNumber*     __v;
@property (nonatomic, strong) NSArray*      accessibleTags;
@property (nonatomic, strong) NSArray*      collections;

-(void)login:(NSString*)username password:(NSString*)password success:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock;
-(void)SocialLogin:(NSString*)token nonce:(NSString*)nonce success:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock;
-(void)UpdateUserInfo:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock;
-(void)AddUser:(NSString*)sfdcAccountId success:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock;
-(void)DeleteUser:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock;
@end
