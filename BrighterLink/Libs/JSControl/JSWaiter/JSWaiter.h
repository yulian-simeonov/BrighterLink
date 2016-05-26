//
//  JSWaiter.h
//  PhotoSauce
//
//  Created by NOVNUS LLC on 1/7/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef enum : NSUInteger {
    WaitingWithBG = 0,
    WaitingWithoutBG,
    ProgressWithBG,
    ProgressWithoutBG
} WaiterType;

@interface JSWaiter : NSObject<MBProgressHUDDelegate>
{

}

+(void)ShowWaiter:(UIView*)vw title:(NSString*)text type:(WaiterType)typ;
+(void)HideWaiter;
+(void)SetProgress:(float)perent;
@end
