//
//  JSTwitterManager.h
//  PhotoSauce
//
//  Created by NOVNUS LLC on 1/16/13.
//  Copyright (c) 2013 NOVNUS LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>

@interface JSTwitterManager : NSObject
+(void)Upload:(NSString*)message FilePath:(NSString*)imgPath ParentViewController:(UIViewController*)parent;
@end
