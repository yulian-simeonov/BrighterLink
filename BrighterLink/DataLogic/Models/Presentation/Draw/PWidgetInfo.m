//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PWidgetInfo.h"
#import "SharedMembers.h"
#import "PresentationInfo.h"


@implementation PWidgetInfo


- (id) init{
    
    _param = [[Parameter alloc] init];
    _timeline = [[TimelineData alloc] init];
    
    ___v =  [NSNumber numberWithInt:0];
    __id  = @"";
    _availableWidgetId = @"";
    _icon = @"";
    _name = @"";

    energy = nil;
    graph  = nil;
    solar  = nil;
    weather = nil;
    img_Image = nil;
    img_TextAreaImage = nil;
    
    return  self;
}


- (void) setWidgetDictionary:(BOOL) flag
{
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    [info getPresentationDic];
    
    NSDictionary * paramDic = [_param GetParamDic];
    
    if ( !flag ) {
        msgDic = @{
                   
                   @"__v" : self.__v,
                   @"presentation" :  info->msgDic,
                   @"availableWidgetId" : self._id,
                   @"parameters" :  paramDic,
                   @"icon" : self.icon,
                   @"name" : self.name,
                   };
    }
    else
    {
        msgDic = @{
                   @"_id" : self._id,
                   @"presentation" :  info->msgDic,
                   @"availableWidgetId" : self.availableWidgetId,
                   @"parameters" : paramDic,
                   @"icon" : self.icon,
                   @"name" : self.name,
                   @"__v" : self.__v
                   };

    }
    
    
}



@end
