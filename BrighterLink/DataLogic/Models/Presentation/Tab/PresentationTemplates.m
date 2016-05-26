//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PresentationTemplates.h"
#import "SharedMembers.h"

@implementation PresentationTemplates

- (id) init
{
    _IsNewPresentation = [NSNumber numberWithBool:false];
    _Latitude = [NSNumber numberWithDouble:0];
    _Logo = @"";
    _Longitude = [NSNumber numberWithDouble:0];
    ___v  = [NSNumber numberWithInt:0];
    __id  = @"";
    _awsAssetsKeyPrefix = @"";
    _createdDate = @"";
    _creator = @"";
    _creatorName = @"";
    _creatorRole = @"";
    _des = @"";
    _gDriveAssetsFolderId = @"";
    _generatingSinceView = [NSNumber numberWithBool:false];
    _isTemplate = [NSNumber numberWithBool:false];
    _lastUpdatedView = [NSNumber numberWithBool: false];
    _name = @"";
    
    _reimbursementRate = @"";
    _systemSize = @"";
    _systemSizeView = [NSNumber numberWithDouble:0];
//    _tagBindings = [];
    _titleView = [NSNumber numberWithBool:false];
    _webBox = @"";

    
    return  self;
}


@end
