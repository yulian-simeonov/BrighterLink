//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EditorInfo : NSObject
{
@public
    BOOL m_bSelected;
    
    BOOL m_bAdded;
}

@property (nonatomic, strong) NSNumber * __v;
@property (nonatomic, strong) NSString * _id;
@property (nonatomic, strong) NSArray  * accessibleTags;
@property (nonatomic, strong) NSArray  * accounts;
@property (nonatomic, strong) NSArray  * apps;
@property (nonatomic, strong) NSString * defaultApp;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * emailDomain;
@property (nonatomic, strong) NSString * emailUser;
@property (nonatomic, strong) NSString * enphaseUserId;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * lastEditedDashboardId;
@property (nonatomic, strong) NSString * lastEditedPresentation;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * middleName;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * previousEditedDashboardId;
@property (nonatomic, strong) NSString * previousEditedPresentation;
@property (nonatomic, strong) NSString * profilePictureUrl;
@property (nonatomic, strong) NSString * role;
@property (nonatomic, strong) NSString * sfdcContactId;
@property (nonatomic, strong) NSString * sfdcContactURL;
@property (nonatomic, strong) NSString * socialToken;


@end
