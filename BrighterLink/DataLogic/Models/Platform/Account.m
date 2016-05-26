//
//  Account.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "Account.h"
#import "SharedMembers.h"

@implementation Account
-(void)AddNewAccount:(UserInfo*)member success:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock
{
    [[SharedMembers sharedInstance].webManager CreateAccountWithSF:[self getDictionary] member:[member getDictionary] success:^(MKNetworkOperation *networkOperation) {
        [self setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
        successBlock(networkOperation);
    } failure:nil];
}

-(void)UpdateAccount:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock
{
    [[SharedMembers sharedInstance].webManager UpdateAccount:[self getDictionary] success:^(MKNetworkOperation *networkOperation){
        [self setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
        successBlock(networkOperation);
    } failure:errorBlock];
}
@end
