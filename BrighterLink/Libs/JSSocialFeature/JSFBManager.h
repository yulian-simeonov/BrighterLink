//
//  JSFBManager.h
//  PhotoSauce
//
//  Created by NOVNUS LLC on 1/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "JSWaiter.h"

@protocol JSFBManagerDelegate <NSObject>
@optional
-(void)CompletedMyInfo:(NSDictionary*)myInfo;
-(void)CompletedMyFriends:(NSArray*)friends;
-(void)OpendSession:(BOOL)success;
-(void)CompletedImageShare:(BOOL)flag;
-(void)CompletedLocationShare:(NSString*)errorMSg;
-(void)Shared;
-(void)Failed;
@end

@interface JSFBManager : NSObject
{
    NSString*       m_filePath;
    NSString*      m_message;
}

@property (nonatomic, weak) id<JSFBManagerDelegate> delegate;
- (void)PostOnWall:(NSString*)message imageUrl:(NSString*)imgUrl caption:(NSString*)title appLink:(NSString*)link;
-(void)ShareImage:(UIImage*)img;
-(void)ShareText:(NSString*)message;
@end
