//
//  JSFBManager.m
//  PhotoSauce
//
//  Created by NOVNUS LLC on 1/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JSFBManager.h"
#import "AppDelegate.h"

@implementation JSFBManager

-(id)init
{
    if (self = [super init])
    {
        m_message = nil;
        m_filePath = nil;
    }
    return self;
}

-(void)dealloc
{
    
}

-(BOOL)CheckConnectedFB
{
    if (FBSession.activeSession.state == FBSessionStateOpen ||
        FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
        return true;
    else
        return false;
}

-(void)CloseSession
{
    [[FBSession activeSession] closeAndClearTokenInformation];
}

-(void)ShareText:(NSString*)message
{
    if ([self CheckConnectedFB])
    {
        if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
        {
            [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
             {
                if (!error)
                {
                    NSDictionary* params = @{@"message" : message};
                    FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                                 graphPath:@"/me/feed"
                                                                parameters:params
                                                                HTTPMethod:@"POST"];
                    
                    request.session = FBSession.activeSession;
                    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if (!error) {
                            // Link posted successfully to Facebook
                            if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                                [_delegate CompletedLocationShare:nil];
                        } else {
                            NSLog(@"%@", error.description);
                            if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                                [_delegate CompletedLocationShare:error.description];
                        }
                    }];
                }
                else
                {
                    if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                        [_delegate CompletedLocationShare:error.description];
                }
            }];
        }
        else
        {
            NSDictionary* params = @{@"message" : message};
            FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                         graphPath:@"/me/feed"
                                                        parameters:params
                                                        HTTPMethod:@"POST"];
            
            request.session = FBSession.activeSession;
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Link posted successfully to Facebook
                    if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                        [_delegate CompletedLocationShare:nil];
                } else {
                    NSLog(@"%@", error.description);
                    if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                        [_delegate CompletedLocationShare:error.description];
                }
            }];
        }
    }
    else
    {
        FBSession *session = [[FBSession alloc] init];
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session
        [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
                completionHandler:^(FBSession *session,
                                    FBSessionState status,
                                    NSError *error) {
                    if (status == FBSessionStateOpen)
                    {
                        if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
                        {
                            [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
                             {
                                 if (!error)
                                 {
                                     NSDictionary* params = @{@"message" : message};
                                     FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                                                  graphPath:@"/me/feed"
                                                                                 parameters:params
                                                                                 HTTPMethod:@"POST"];
                                     
                                     request.session = FBSession.activeSession;
                                     [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                         if (!error) {
                                             // Link posted successfully to Facebook
                                             if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                                                 [_delegate CompletedLocationShare:nil];
                                         } else {
                                             NSLog(@"%@", error.description);
                                             if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                                                 [_delegate CompletedLocationShare:error.description];
                                         }
                                     }];
                                 }
                                 else
                                 {
                                     if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                                         [_delegate CompletedLocationShare:error.description];
                                 }
                             }];
                        }
                        else
                        {
                            NSDictionary* params = @{@"message" : message};
                            FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                                         graphPath:@"/me/feed"
                                                                        parameters:params
                                                                        HTTPMethod:@"POST"];
                            
                            request.session = FBSession.activeSession;
                            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                if (!error) {
                                    // Link posted successfully to Facebook
                                    if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                                        [_delegate CompletedLocationShare:nil];
                                } else {
                                    NSLog(@"%@", error.description);
                                    if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                                        [_delegate CompletedLocationShare:error.description];
                                }
                            }];
                        }
                    }
                    if (error)
                    {
                        NSLog(@"%@", error.localizedDescription);
                        if ([_delegate respondsToSelector:@selector(CompletedLocationShare:)])
                            [_delegate CompletedLocationShare:error.description];
                    }
                }];
    }
}

-(void)ShareImage:(UIImage*)img
{
    if ([self CheckConnectedFB])
    {
        [self UploadImageToGallery:img];
    }
    else
    {
        // Initialize a session object
        FBSession *session = [[FBSession alloc] init];
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session
        [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
                completionHandler:^(FBSession *session,
                                    FBSessionState status,
                                    NSError *error) {
                    if (status == FBSessionStateOpen)
                    {
                        [self UploadImageToGallery:img];
                    }
                    if (error)
                    {
                        NSLog(@"%@", error.localizedDescription);
                        if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                            [_delegate CompletedImageShare:NO];
                    }
                }];
    }
}

-(void)UploadImageToGallery:(UIImage*)img
{
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:UIImagePNGRepresentation(img), @"picture", nil];
    FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                 graphPath:@"me/photos"
                                                parameters:param
                                                HTTPMethod:@"POST"];
    
    request.session = FBSession.activeSession;
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
            if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                [_delegate CompletedImageShare:NO];
        }
        else
        {
            FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                         graphPath:[NSString stringWithFormat:@"/%@", [result objectForKey:@"id"]]
                                                        parameters:nil
                                                        HTTPMethod:@"GET"];
            
            request.session = FBSession.activeSession;
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error)
                    [self PostOnWall:@"" imageUrl:[result objectForKey:@"source"]  caption:@"" appLink:[result objectForKey:@"link"]];
                else
                {
                    NSLog(@"%@", [FBSession activeSession].permissions);
                    NSLog(@"%@", error.localizedDescription);
                    if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                        [_delegate CompletedImageShare:NO];
                }
            }];
        }
    }];
}

- (void)PostOnWall:(NSString*)message imageUrl:(NSString*)imgUrl caption:(NSString*)title appLink:(NSString*)link
{
    if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
    {
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error)
        {
            if (!error)
            {
                NSDictionary* params = @{@"name" : title,
                                         @"caption" : title,
                                         @"description" : message,
                                         @"link" : link,
                                         @"picture" : imgUrl
                                         };
                FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                             graphPath:@"/me/feed"
                                                            parameters:params
                                                            HTTPMethod:@"POST"];
                request.session = FBSession.activeSession;
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // Link posted successfully to Facebook
                        if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                            [_delegate CompletedImageShare:YES];
                    } else {
                        NSLog(@"%@", error.description);
                        if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                            [_delegate CompletedImageShare:NO];
                    }
                }];
                
//                [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                                       parameters:params
//                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
//                 {
//                     if (error) {
//                         [APP HandleError:error];
//                     } else {
//                         if (result == FBWebDialogResultDialogNotCompleted) {
//                             // User canceled.
//                             NSLog(@"User cancelled.");
//                             if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
//                                 [_delegate CompletedImageShare:NO];
//                         } else {
//                             // Handle the publish feed callback
//                             NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                             
//                             if (![urlParams valueForKey:@"post_id"]) {
//                                 // User canceled.
//                                 NSLog(@"User cancelled.");
//                                 if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
//                                     [_delegate CompletedImageShare:NO];
//                             }
//                             else
//                             {
//                                 if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
//                                     [_delegate CompletedImageShare:YES];
//                             }
//                         }
//                     }
//                 }];
            }
            else
            {
                NSLog(@"%@", error.description);
                if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                    [_delegate CompletedImageShare:NO];
            }
        }];
    }
    else
    {
        NSDictionary* params = @{@"name" : title,
                                 @"caption" : title,
                                 @"description" : message,
                                 @"link" : link,
                                 @"picture" : imgUrl
                                 };
        FBRequest *request =[[FBRequest alloc] initWithSession:FBSession.activeSession
                                                     graphPath:@"/me/feed"
                                                    parameters:params
                                                    HTTPMethod:@"POST"];
        
        request.session = FBSession.activeSession;
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Link posted successfully to Facebook
                if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                    [_delegate CompletedImageShare:YES];
            } else {
                NSLog(@"%@", error.description);
                if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
                    [_delegate CompletedImageShare:NO];
            }
        }];
        
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
//         {
//             if (error) {
//                 [APP HandleError:error];
//             } else {
//                 if (result == FBWebDialogResultDialogNotCompleted) {
//                     // User canceled.
//                     NSLog(@"User cancelled.");
//                     if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
//                         [_delegate CompletedImageShare:NO];
//                 } else {
//                     // Handle the publish feed callback
//                     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                     
//                     if (![urlParams valueForKey:@"post_id"]) {
//                         // User canceled.
//                         NSLog(@"User cancelled.");
//                         if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
//                             [_delegate CompletedImageShare:NO];
//                     }
//                     else
//                     {
//                         if ([_delegate respondsToSelector:@selector(CompletedImageShare:)])
//                             [_delegate CompletedImageShare:YES];
//                     }
//                 }
//             }
//         }];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end
