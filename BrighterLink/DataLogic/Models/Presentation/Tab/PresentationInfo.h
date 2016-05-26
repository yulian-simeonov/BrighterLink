//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PresentationInfo : NSObject
{
    @public
    BOOL m_bSelected;
        NSDictionary * msgDic;
}

@property (nonatomic, strong) NSString*     _id;
@property (nonatomic, strong) NSString*     creatorRole;
@property (nonatomic, strong) NSString*     name;
@property (nonatomic, strong) NSNumber*     __v;
@property (nonatomic, strong) NSString* 	gDriveAssetsFolderId;
@property (nonatomic, strong) NSArray*          tagBindings;
@property (nonatomic, strong) NSDictionary*     parameters;
@property (nonatomic, strong) NSArray*          children;
@property (nonatomic, strong) NSArray*          parents;

@property (nonatomic, strong) NSString*       des;

@property (nonatomic, strong) NSString*     creator;
@property (nonatomic, strong) NSString*      creatorName;
@property (nonatomic, strong) NSNumber*      reimbursementRate;

@property (nonatomic, strong) NSNumber*     isTemplate;
@property (nonatomic, strong) NSNumber*     IsNewPresentation;

@property (nonatomic, strong) NSNumber*     titleView;
@property (nonatomic, strong) NSNumber*     lastUpdatedView;
@property (nonatomic, strong) NSNumber*     generatingSinceView;

@property (nonatomic, strong) NSNumber*     systemSizeView;
@property (nonatomic, strong) NSNumber*     systemSize;
@property (nonatomic, strong) NSString*     webBox;
@property (nonatomic, strong) NSString*     createdDate;
@property (nonatomic, strong) NSString*     Longitude;
@property (nonatomic, strong) NSString*     Logo;
@property (nonatomic, strong) NSString*     Latitude;
@property (nonatomic, strong) NSString*     awsAssetsFolderName;
@property (nonatomic, strong) NSNumber*     duration;
@property (nonatomic, strong) NSString*     awsAssetsKeyPrefix;


@property (nonatomic, retain) NSMutableArray * m_widgets;
- (void) getPresentationDic;
@end
