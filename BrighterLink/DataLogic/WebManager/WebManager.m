//
//  WebManager.m
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

// Read the following link to know in more detail
// https://github.com/AFNetworking/AFNetworking

#import "WebManager.h"
#import "SharedMembers.h"

@implementation WebManager
-(id)init
{
    if (self = [super init])
    {
        m_apiURL = @"http://example.com/resources.json";
        m_engine = [[MKNetworkEngine alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [m_engine cancelAllOperations];
}

-(void)AsyncProcess:(Method)method parameters:(NSDictionary*)params success:(SuccessBlock)success failure:(ErrorBlock)failure isJSON:(BOOL)isJSON
{
    NSString* strMethod = @"GET";
    switch (method) {
        case GET:
            strMethod = @"GET";
            break;
        case POST:
            strMethod = @"POST";
            break;
        case PUT:
            strMethod = @"PUT";
            break;
        case PATCH:
            strMethod = @"PATCH";
            break;
        case DELETE:
            strMethod = @"DELETE";
            break;
        default:
            break;
    }
    if (params && [params isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"%@", [params jsonEncodedKeyValueString]);
    }
    
    NSArray *aryParams = nil;
    if([params isKindOfClass:[NSArray class]])
    {
        aryParams = (NSArray *)params;
        params = nil;
    }
    
    MKNetworkOperation* op = [[MKNetworkOperation alloc] initWithURLString:m_apiURL params:params httpMethod:strMethod];
    if (isJSON)
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    if ([SharedMembers sharedInstance].Token)
        [op setHeader:@"authorization" withValue:[SharedMembers sharedInstance].Token];
    
    if(aryParams != nil)
    {
        [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
            
            NSDictionary *dicParams = nil;
            
            if(aryParams.count > 0)dicParams = [aryParams objectAtIndex:0];
            
            NSString *postString = [NSString stringWithFormat:@"\[%@\]", [dicParams jsonEncodedKeyValueString]];
            
            return postString;
            
        } forType:@"application/json"];
    }

    [op addCompletionHandler:^(MKNetworkOperation* networkOperation){
//        if (networkOperation.responseJSON)
//        {
//            if (([[networkOperation.responseJSON objectForKey:@"message"] isKindOfClass:[NSDictionary class]] || [[networkOperation.responseJSON objectForKey:@"message"] isKindOfClass:[NSArray class]]) &&
//                [[networkOperation.responseJSON objectForKey:@"success"] intValue] == 1)
//            {
                success(networkOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (!failure)
            _ProcessError = YES;
        
        NSLog(@"%@", error);
        
        if (_ProcessError)
        {
            [JSWaiter HideWaiter];
           if (completedOperation.responseJSON)
           {
               if ([[completedOperation.responseJSON objectForKey:@"message"] isEqualToString:@"INCORRECT_SESSION"])
               {//                return;
//            }
//            else if([[networkOperation.responseJSON objectForKey:@"message"] isKindOfClass:[NSString class]] &&
//                    [[networkOperation.responseJSON objectForKey:@"success"] intValue] == 0)
//            {
//                [JSWaiter HideWaiter];
//                [[[UIAlertView alloc] initWithTitle:@"" message:[networkOperation.responseJSON objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                return;
//            }
//        }
//        NSLog(@"Invalid Format: %@", networkOperation.responseJSON);
//        [JSWaiter HideWaiter];
//        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Response Format" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

                   [[SharedMembers sharedInstance].currentViewController.navigationController popViewControllerAnimated:YES];
               }
               else
               {
                   [[[UIAlertView alloc] initWithTitle:@"Error" message:[completedOperation.responseJSON objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
               }
           }
           else
               [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        if (failure)
            failure(completedOperation, error);
    }];
    [m_engine enqueueOperation:op];
}

//############################################################# User define methods ############################################################

//------------------------------------- User -------------------------------------
-(void)Login:(NSString*)email password:(NSString*)password success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users/login", HostAddress];
    [self AsyncProcess:POST parameters:@{@"email" : email, @"password" : password, @"os" : @"iOS"} success:success failure:failure isJSON:NO];
}

-(void)SocialLogin:(NSString*)token nonce:(NSString*)nonce success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/sociallogin/mobile", HostAddress];
    [self AsyncProcess:POST parameters:@{@"connection_token" : token, @"nonce" : nonce} success:success failure:failure isJSON:YES];
}

-(void)TestSocialAPI:(NSString*)token nonce:(NSString*)nonce success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"https://brightergy.api.oneall.com/users/%@/contacts.json", token];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:YES];
}

-(void)CreateBP:(NSString*)secretKey userInfo:(NSDictionary*)userInfo success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/userapi/createbp", HostAddress];
    [self AsyncProcess:POST parameters:nil success:success failure:failure isJSON:YES];
}

-(void)CreateUser:(NSDictionary*)userObj sfdcAccount:(NSString*)sfdcAccountId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users", HostAddress];
    [self AsyncProcess:POST parameters:@{@"user" : userObj, @"sfdcAccountId" : sfdcAccountId} success:success failure:failure isJSON:YES];
}

-(void)DeleteUser:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/userapi/%@", HostAddress, userId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetMembers:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users/accounts", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetAllAdmins:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/userapi/admin", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetAppConfiguration:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/userapi/applications", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetEnphaseAuthURL:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/enphase/authurl", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetEnphaseInventory:(NSString*)systemID success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/enphase/inventory/%@", HostAddress, systemID];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetEnphaseSystems:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/enphase/systems", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetUserInfoById:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/userapi/id/%@", HostAddress, userId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)SearchUsers:(NSString*)searchKey success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/userapi/%@", HostAddress, searchKey];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)UpdateUserInfo:(NSDictionary*)param success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users/%@", HostAddress, [param objectForKey:@"_id"]];
    [self AsyncProcess:PUT parameters:@{@"user" : param} success:success failure:failure isJSON:YES];
}

//--------------------------------------------------------------------------------

//------------------------------------- Tags -------------------------------------
-(void)CheckTagDeletable:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/api/tag/deletable/%@", HostAddress, tagId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)CreateTag:(NSDictionary*)tagObj success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/tags", HostAddress];
    [self AsyncProcess:POST parameters:tagObj success:success failure:failure isJSON:YES];
}

-(void)CreateTagRule:(NSDictionary*)ruleObj success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/api/tagrule", HostAddress];
    [self AsyncProcess:POST parameters:ruleObj success:success failure:failure isJSON:YES];
}

-(void)DeleteTag:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/tags/%@", HostAddress, tagId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)DeleteTagRule:(NSString*)ruleId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/api/tagrule/%@", HostAddress, ruleId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)EditTag:(NSDictionary*)tagObj tagId:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/tags/%@", HostAddress, tagId];
    [self AsyncProcess:PUT parameters:tagObj success:success failure:failure isJSON:YES];
}

-(void)EditTagRule:(NSDictionary*)ruleObj ruleId:(NSString*)ruleId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/api/tagrule/%@", HostAddress, ruleId];
    [self AsyncProcess:PUT parameters:ruleObj success:success failure:failure isJSON:YES];
}

-(void)GetTagRules:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/api/tagrule", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetTagById:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/api/tag/%@", HostAddress, tagId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetUserTags:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users/%@/tags", HostAddress, userId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)UpdateAccessibleTag:(NSArray*)tags userID:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users/%@/tags", HostAddress, userId];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tags options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [jsonString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSRangeFromString([NSString stringWithFormat:@"0, %d", jsonString.length])];
    [self AsyncProcess:PUT parameters:@{@"accessibleTags" : tags} success:success failure:failure isJSON:YES];
}
//--------------------------------------------------------------------------------

//------------------------------------- Assets -----------------------------------
-(void)UploadUserPicture:(NSData*)fileData success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users/assets/userprofile", HostAddress];
    MKNetworkOperation* op = [[MKNetworkOperation alloc] initWithURLString:m_apiURL params:nil httpMethod:@"POST"];
    [op setHeader:@"authorization" withValue:[SharedMembers sharedInstance].Token];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", [SharedMembers GetSavePath:@"upload"], [[NSUUID UUID] UUIDString]];
    [fileData writeToFile:filePath atomically:YES];
    [op addFile:filePath forKey:@"assetsFile"];
    [op addCompletionHandler:success errorHandler:failure];
    [m_engine enqueueOperation:op];
}

-(void)UploadWidgetImage:(NSData*)fileData dashboardId:(NSString*)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/general/assets/dashboard/%@", HostAddress, dashboardId];
    MKNetworkOperation* op = [[MKNetworkOperation alloc] initWithURLString:m_apiURL params:nil httpMethod:@"POST"];
    [op setHeader:@"authorization" withValue:[SharedMembers sharedInstance].Token];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.jpg", [SharedMembers GetSavePath:@"upload"], [[NSUUID UUID] UUIDString]];
    [fileData writeToFile:filePath atomically:YES];
    [op addFile:filePath forKey:@"assetsFile"];
    [op addCompletionHandler:success errorHandler:failure];
    [m_engine enqueueOperation:op];
}

-(void)GetGeneralAssets:(NSString*)keyword success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/general/assets", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetAccountAssets:(NSString*)accountId keyword:(NSString*)keyword success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accounts/%@/assets", HostAddress, accountId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetPresentationAssets:(NSString*)presentationId keyword:(NSString*)keyword success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/general/assets/presentation/find/%@/%@", HostAddress, presentationId, keyword];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)UploadGeneralAsset:(NSString*)filePath success:(SuccessBlock)success failure:(ErrorBlock)failure uploadProgress:(MKNKProgressBlock)progress
{
    m_apiURL = [NSString stringWithFormat:@"%@/general/assets", HostAddress];
    MKNetworkOperation* op = [[MKNetworkOperation alloc] initWithURLString:m_apiURL params:nil httpMethod:@"POST"];
    
    [op setHeader:@"authorization" withValue:[SharedMembers sharedInstance].Token];
    [op addFile:filePath forKey:@"assetsFile"];
    [op onUploadProgressChanged:progress];
    [op addCompletionHandler:success errorHandler:failure];
    [m_engine enqueueOperation:op];
}

-(void)UploadAccountAsset:(NSString*)accountId FilePath:(NSString*)filePath success:(SuccessBlock)success failure:(ErrorBlock)failure uploadProgress:(MKNKProgressBlock)progress
{
    m_apiURL = [NSString stringWithFormat:@"%@/accounts/%@/assets", HostAddress, accountId];
    MKNetworkOperation* op = [[MKNetworkOperation alloc] initWithURLString:m_apiURL params:nil httpMethod:@"POST"];
    [op setHeader:@"authorization" withValue:[SharedMembers sharedInstance].Token];
    [op addFile:filePath forKey:@"assetsFile"];
    [op onUploadProgressChanged:progress];
    [op addCompletionHandler:success errorHandler:failure];
    [m_engine enqueueOperation:op];
}

-(void)UploadPresentationAsset:(NSString*)presentationId FilePath:(NSString*)filePath success:(SuccessBlock)success failure:(ErrorBlock)failure uploadProgress:(MKNKProgressBlock)progress
{
    
    m_apiURL = [NSString stringWithFormat:@"%@/general/assets/presentation/%@", HostAddress, presentationId];
    MKNetworkOperation* op = [[MKNetworkOperation alloc] initWithURLString:m_apiURL params:nil httpMethod:@"POST"];
    [op setHeader:@"authorization" withValue:[SharedMembers sharedInstance].Token];
    [op addFile:filePath forKey:@"assetsFile"];
    [op onUploadProgressChanged:progress];
    [op addCompletionHandler:success errorHandler:failure];
    [m_engine enqueueOperation:op];
    
}


-(void)DeleteGeneralAsset:(NSString*)assetId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/general/assets/%@", HostAddress, assetId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)DeleteAccountAsset:(NSString*)assetId accountId:(NSString*)accountId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accounts/%@/assets/%@", HostAddress, accountId, assetId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

- (void) DeletePresentationAsset:(NSString*) assetId presentationId:(NSString*)presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/general/assets/presentation/%@/%@", HostAddress, presentationId, assetId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

//--------------------------------------------------------------------------------

//------------------------------------- Accounts ---------------------------------
-(void)GetAllAccounts:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accounts", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:false isJSON:NO];
}

-(void)CreateAccount:(NSDictionary*)account member:(NSDictionary*)member success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accountapi/create", HostAddress];
    [self AsyncProcess:POST parameters:@{@"account" : account, @"user" : member} success:success failure:false isJSON:YES];
}

-(void)CreateAccountWithSF:(NSDictionary*)account member:(NSDictionary*)member success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accounts/createwithsf", HostAddress];
    [self AsyncProcess:POST parameters:@{@"account" : account, @"user" : member} success:success failure:false isJSON:YES];
}

-(void)UpdateAccount:(NSDictionary*)account success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accounts/%@", HostAddress, [account objectForKey:@"_id"]];
    [self AsyncProcess:PUT parameters:@{@"account" : account} success:success failure:failure isJSON:YES];
}

-(void)VerifyAccountCName:(NSString*)cName success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accountapi/verifycname/%@", HostAddress, cName];
    [self AsyncProcess:GET parameters:nil success:success failure:false isJSON:NO];
}

-(void)DeleteAccount:(NSString*)accountId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/accountapi/del/%@", HostAddress, accountId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:false isJSON:NO];
}

-(void)ResetPassword:(NSString*)email success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users/password/%@", HostAddress, email];
    [self AsyncProcess:POST parameters:nil success:success failure:failure isJSON:NO];
}

//--------------------------------------------------------------------------------

//------------------------------------- Others -----------------------------------
-(void)GetDevices:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/collection/nodes", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:false isJSON:NO];
}

-(void)GetManufacturers:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/collection/scopes", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:false isJSON:NO];
}

-(void)GetSFDCAccounts:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/salesforce/accounts", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:false isJSON:NO];
}

-(void)GetUtilityProviders:(NSString*)findNameMask success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/salesforce/utilityproviders/%@", HostAddress, findNameMask];
    [self AsyncProcess:GET parameters:nil success:success failure:false isJSON:NO];
}

//------------------------------------- Dashboard --------------------------------

-(void)GetAllDashboards:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards", HostAddress];

    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)CreateDashboard:(NSDictionary *)dashboardObj success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards", HostAddress];

    [self AsyncProcess:POST parameters:dashboardObj success:success failure:failure isJSON:YES];
}

-(void)UpdateDashboard:(NSString *)dashboardId param:(NSDictionary *)dashboardObj success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@", HostAddress, dashboardId];
    
    [self AsyncProcess:PUT parameters:dashboardObj success:success failure:failure isJSON:YES];
}

-(void)DeleteDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@", HostAddress, dashboardId];

    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@", HostAddress, dashboardId];

    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetMetricsInDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/metrics", HostAddress, dashboardId];

    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetAllSegmentsInDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/tags/segments", HostAddress, dashboardId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)DeleteSegmentInDashboard:(NSString *)dashboardId segment:(NSString *)segment success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/tags/segments/%@", HostAddress, dashboardId, segment];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)AddNewSegmentInDashboard:(NSString *)dashboardId param:(NSArray *)param success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/tags/segments", HostAddress, dashboardId];
    [self AsyncProcess:POST parameters:param success:success failure:failure isJSON:YES];
}

-(void)UpdateSegmentInDashboard:(NSString *)dashboardId param:(NSArray *)param success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/tags/segments", HostAddress, dashboardId];
    [self AsyncProcess:PUT parameters:param success:success failure:failure isJSON:YES];
}

-(void)AddNewWidget:(NSString *)dashboardId param:(NSDictionary *)param success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/widgets", HostAddress, dashboardId];
    [self AsyncProcess:POST parameters:param success:success failure:failure isJSON:YES];
}

-(void)UpdateNewWidget:(NSString *)dashboardId widgetId:(NSString *)widgetId param:(NSDictionary *)param success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/widgets/%@", HostAddress, dashboardId, widgetId];
    [self AsyncProcess:PUT parameters:param success:success failure:failure isJSON:YES];
}

-(void)DeleteWidget:(NSString *)dashboardId widget:(NSString *)widgetId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/widgets/%@", HostAddress, dashboardId, widgetId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetDashboardWidgetDatas:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/widgets", HostAddress, dashboardId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetDashboardWidgetDatas:(NSString *)dashboardId widgetId:(NSString *)widgetId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/analyze/dashboards/%@/widgets/%@/widgetdata", HostAddress, dashboardId, widgetId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

//--------------------------------------------------------------------------------

//##############################################################################################################################################

//--------------------------------------------------------------------------------


///Presentations

-(void)GetAllPresentations:(SuccessBlock)success failure:(ErrorBlock)failure
{
//    m_apiURL = [NSString stringWithFormat:@"%@/userapi/presentations", HostAddress];
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)CreateWidget:(NSDictionary*)widgetObj success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/widgets", HostAddress];
    [self AsyncProcess:POST parameters:widgetObj success:success failure:failure isJSON:YES];
}

-(void)DeleteWidget:(NSString*) widgetId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/widgets/%@", HostAddress, widgetId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}


-(void)GetAvailableWidgets:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/widgets/available", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetEnergyWidget:(NSString*) presentationId Object:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/widgets/energyequivalencies/%@", HostAddress,presentationId, objectId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetGraphWidget:(NSString*) presentationId Object:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/widgets/graph/%@", HostAddress, presentationId, objectId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetSolarWidget:(NSString*) presentationId Object:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/widgets/solargeneration/%@", HostAddress, presentationId, objectId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}
-(void)GetWeatherWidget:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/widgets/weatherdata", HostAddress, objectId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}
-(void)GetWidgets:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/widgets", HostAddress, presentationId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}
-(void)AddTagBinding:(NSDictionary*) tagBinding present:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/tags", HostAddress, presentationId];
    [self AsyncProcess:POST parameters:tagBinding success:success failure:failure isJSON:YES];
}

-(void)ClonePresentation:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/clone/%@", HostAddress, presentationId];
    [self AsyncProcess:POST parameters:nil success:success failure:failure isJSON:NO];
}

//hb  ???
-(void)CreatePresentation:(NSDictionary*) obj success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations", HostAddress];
    [self AsyncProcess:POST parameters:obj success:success failure:failure isJSON:YES];
}


-(void)DeletePresentation:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@", HostAddress, presentationId];
    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
}

-(void)EditPresentation:(NSString*) presentationId param:(NSDictionary*) object success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@", HostAddress, presentationId];
    [self AsyncProcess:PUT parameters:object success:success failure:failure isJSON:YES];
}

-(void)GetLastUpdatedPresentation:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/last", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetPresentationEditors:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/editors", HostAddress, presentationId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetPresentationTimeline:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/timeline", HostAddress, presentationId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetPresentation:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@", HostAddress, presentationId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetPresentationEnergyData:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/energydata", HostAddress, presentationId];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

-(void)GetPresentationTemplates:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/templates", HostAddress];
    [self AsyncProcess:GET parameters:nil success:success failure:failure isJSON:NO];
}

//-(void)RemoveTagbinding:(NSString*) tagBindingId present:(NSString*) presentationId  success:(SuccessBlock)success failure:(ErrorBlock)failure
//{
//    m_apiURL = [NSString stringWithFormat:@"%@/bv/presentationapi/tags/%@/%@", HostAddress, tagBindingId, presentationId];
//    [self AsyncProcess:DELETE parameters:nil success:success failure:failure isJSON:NO];
//}

- (void) CreatePresentationLinkEmail: (NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/notifications/email/presentationlink", HostAddress];
    [self AsyncProcess:POST parameters:dic success:success failure:failure isJSON:YES];
    
}


- (void) UpdateWidget:(NSString*) widgetId param:(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/widgets/%@", HostAddress, widgetId];
    [self AsyncProcess:PUT parameters:dic success:success failure:failure isJSON:YES];
}


//// hb add

- (void) SearchUsersForEditing :(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/users?searchKey=all_data", HostAddress];
    [self AsyncProcess:GET parameters:dic success:success failure:failure isJSON:YES];
}

- (void) DeleteEditors:(NSString*) presentationId param :(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/editors", HostAddress, presentationId];
    [self AsyncProcess:DELETE parameters:dic success:success failure:failure isJSON:YES];
}

- (void) AddEditors:(NSString*) presentationId param :(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    m_apiURL = [NSString stringWithFormat:@"%@/present/presentations/%@/editors", HostAddress, presentationId];
    [self AsyncProcess:POST parameters:dic success:success failure:failure isJSON:YES];
}

@end
