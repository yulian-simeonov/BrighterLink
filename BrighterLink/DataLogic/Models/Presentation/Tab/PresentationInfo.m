//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PresentationInfo.h"
#import "SharedMembers.h"

@implementation PresentationInfo


- (id) init
{
    
    m_bSelected = false;
    _m_widgets = [[NSMutableArray alloc] init];
 
     __id = @"";
     _creatorRole = @"";
     _name = @"";
    ___v = [NSNumber numberWithInt:0];
 	_gDriveAssetsFolderId = @"";
    _tagBindings = [[NSArray alloc] init];
//    @property (nonatomic, strong) NSDictionary*     parameters;
    _children = [[NSArray alloc] init];
    _parents = [[NSArray alloc] init];
    
    _des = @"";
    
    _creator = @"";
    _creatorName = @"";
    _reimbursementRate = [NSNumber numberWithInt:0];
    
    _isTemplate = [NSNumber numberWithBool:false];
    _IsNewPresentation = [NSNumber numberWithBool:false];
    
    _titleView = [NSNumber numberWithBool:false];
    _lastUpdatedView = [NSNumber numberWithBool:false];
    _generatingSinceView = [NSNumber numberWithBool:false];
    
    _systemSizeView = [NSNumber numberWithBool:false];
    _systemSize = [NSNumber numberWithFloat:0.0f];
    _webBox = @"";
    _createdDate = @"";
    _Longitude = @"";
    _Logo = @"";
    _Latitude = @"";
    _awsAssetsFolderName = @"";
    _duration = [NSNumber numberWithInt:0];
    _awsAssetsKeyPrefix = @"";

    
    
    return  self;
}


- (void) getPresentationDic
{
    msgDic = @{
        @"_id": self._id,
        @"creatorRole": self.creatorRole,
        @"name": self.name,
        @"__v": self.__v,
        @"gDriveAssetsFolderId": self.gDriveAssetsFolderId,
        @"tagBindings": self.tagBindings,
        @"parameters": self.parameters,
        @"children": self.children,
        @"parents": self.parents,        
        @"description": self.des,
        @"creator": self.creator,
        @"creatorName": self.creatorName,
        @"reimbursementRate": self.reimbursementRate,
        @"isTemplate": self.isTemplate,
        @"IsNewPresentation": self.IsNewPresentation,
        @"titleView": self.titleView,
        @"lastUpdatedView": self.lastUpdatedView,
        @"generatingSinceView": self.generatingSinceView,
        @"systemSizeView": self.systemSizeView,
        @"systemSize": self.systemSize,
        @"webBox": self.webBox,
        @"createdDate": self.createdDate,
        @"Longitude": self.Longitude,
        @"Logo": self.Logo,
        @"Latitude": self.Latitude,
        @"awsAssetsFolderName":self.awsAssetsFolderName
    };
}


@end
