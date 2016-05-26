//
//  UserInfo.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "UserInfo.h"
#import "SharedMembers.h"
#import "Account.h"

@implementation UserInfo
-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)login:(NSString*)username password:(NSString*)password success:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock
{
    [SharedMembers sharedInstance].webManager.ProcessError = YES;
    [[SharedMembers sharedInstance].webManager Login:username password:password success:^(MKNetworkOperation *operation) {
        NSLog(@"%@", operation.responseJSON);
        [self setDictionary:[[operation.responseJSON objectForKey:@"message"] objectForKey:@"user"]];
        [[SharedMembers sharedInstance] setToken:[[operation.responseJSON objectForKey:@"message"] objectForKey:@"token"]];
        [self Preload:successBlock failed:failedBlock];
        
    } failure:failedBlock];
}

-(void)SocialLogin:(NSString*)token nonce:(NSString*)nonce success:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock
{
    [SharedMembers sharedInstance].webManager.ProcessError = YES;
    [[SharedMembers sharedInstance].webManager SocialLogin:token nonce:nonce success:^(MKNetworkOperation *networkOperation) {
        NSLog(@"%@", networkOperation.responseString);
        [self setDictionary:[[networkOperation.responseJSON objectForKey:@"message"] objectForKey:@"user"]];
        [[SharedMembers sharedInstance] setToken:[[networkOperation.responseJSON objectForKey:@"message"] objectForKey:@"token"]];
        [self Preload:successBlock failed:failedBlock];
    } failure:failedBlock];
}


-(void)Preload:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock
{
    [[SharedMembers sharedInstance].webManager GetMembers:^(MKNetworkOperation *networkOperation) {
        NSArray* members = [networkOperation.responseJSON objectForKey:@"message"];
        [[SharedMembers sharedInstance].Members removeAllObjects];
        for(NSDictionary* member in members)
        {
            UserInfo* user = [[UserInfo alloc] init];
            [user setDictionary:member];
            [[SharedMembers sharedInstance].Members addObject:user];
        }
        
        [[SharedMembers sharedInstance].webManager GetAllAccounts:^(MKNetworkOperation *networkOperation) {
            
            NSArray* accounts = [networkOperation.responseJSON objectForKey:@"message"];
            [[SharedMembers sharedInstance].Accounts removeAllObjects];
            for(NSDictionary* account in accounts)
            {
                Account* acnt = [[Account alloc] init];
                [acnt setDictionary:account];
                [[SharedMembers sharedInstance].Accounts addObject:acnt];
            }
            [[SharedMembers sharedInstance].webManager GetUserTags:__id success:^(MKNetworkOperation *networkOperation) {
                [[SharedMembers sharedInstance].RootTags removeAllObjects];
                for(NSDictionary* tag in [networkOperation.responseJSON objectForKey:@"message"])
                {
                    Tag* tg = [[Tag alloc] init];
                    [tg SetDataWithDictionary:tag parent:nil];
                    [[SharedMembers sharedInstance].RootTags addObject:tg];
                }
                [[SharedMembers sharedInstance].webManager GetDevices:^(MKNetworkOperation *networkOperation) {
                    [SharedMembers sharedInstance].Devices = [networkOperation.responseJSON objectForKey:@"message"];
                    [[SharedMembers sharedInstance].webManager GetManufacturers:^(MKNetworkOperation *networkOperation) {
                        [SharedMembers sharedInstance].Manufacturers = [networkOperation.responseJSON objectForKey:@"message"];
                        successBlock(networkOperation);
                    } failure:failedBlock];
                } failure:failedBlock];
                
            } failure:failedBlock];
        } failure:failedBlock];
    } failure:failedBlock];
}

-(void)UpdateUserInfo:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock
{
    [[SharedMembers sharedInstance].webManager UpdateUserInfo:[self getDictionary] success:^(MKNetworkOperation *networkOperation) {
        [self setDictionary:[[networkOperation.responseJSON objectForKey:@"message"] objectForKey:@"user"]];
        successBlock(networkOperation);
    } failure:failedBlock];
}

-(void)AddUser:(NSString*)sfdcAccountId success:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock
{
    [[SharedMembers sharedInstance].webManager CreateUser:[self getDictionary] sfdcAccount:sfdcAccountId success:^(MKNetworkOperation *networkOperation) {
        [self setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
        successBlock(networkOperation);
    } failure:nil];
}

-(void)DeleteUser:(SuccessBlock)successBlock failed:(ErrorBlock)failedBlock
{
    [[SharedMembers sharedInstance].webManager DeleteUser:self._id success:successBlock failure:failedBlock];
}
@end
