//
//  WebManager.h
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"

#define HostAddress @"https://blmobile.brightergy.com/v1"

typedef enum : NSUInteger {
    GET = 0,
    POST,
    PUT,
    PATCH,
    DELETE
} Method;

@interface WebManager : NSObject
{
    MKNetworkEngine* m_engine;
    NSString* m_apiURL;
}

typedef void (^SuccessBlock)(MKNetworkOperation* networkOperation);
typedef void (^ErrorBlock)(MKNetworkOperation *errorOp, NSError* error);

@property (nonatomic) BOOL ProcessError;
//############################################################# User define methods ############################################################

//------------------------------------- User -------------------------------------
-(void)Login:(NSString*)email password:(NSString*)password success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreateBP:(NSString*)secretKey userInfo:(NSDictionary*)userInfo success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreateUser:(NSDictionary*)userObj sfdcAccount:(NSString*)sfdcAccountId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreateAccountWithSF:(NSDictionary*)account member:(NSDictionary*)member success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteUser:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetMembers:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetAllAdmins:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetAppConfiguration:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetEnphaseAuthURL:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetEnphaseInventory:(NSString*)systemID success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetEnphaseSystems:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)SearchUsers:(NSString*)searchKey success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetUserInfoById:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)UpdateUserInfo:(NSDictionary*)param success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)SocialLogin:(NSString*)token nonce:(NSString*)nonce success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)TestSocialAPI:(NSString*)token nonce:(NSString*)nonce success:(SuccessBlock)success failure:(ErrorBlock)failure;
//--------------------------------------------------------------------------------

//------------------------------------- Tags -------------------------------------
-(void)CheckTagDeletable:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreateTag:(NSDictionary*)tagObj success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreateTagRule:(NSDictionary*)ruleObj success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteTag:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteTagRule:(NSString*)ruleId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)EditTag:(NSDictionary*)tagObj tagId:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)EditTagRule:(NSDictionary*)ruleObj ruleId:(NSString*)ruleId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetTagRules:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetTagById:(NSString*)tagId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetUserTags:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)UpdateAccessibleTag:(NSArray*)tags userID:(NSString*)userId success:(SuccessBlock)success failure:(ErrorBlock)failure;
//--------------------------------------------------------------------------------

//------------------------------------- Assets -----------------------------------
-(void)UploadUserPicture:(NSData*)fileData success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)UploadWidgetImage:(NSData*)fileData dashboardId:(NSString*)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetGeneralAssets:(NSString*)keyword success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetAccountAssets:(NSString*)accountId keyword:(NSString*)keyword success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetPresentationAssets:(NSString*)presentationId keyword:(NSString*)keyword success:(SuccessBlock)success failure:(ErrorBlock)failure;


-(void)UploadGeneralAsset:(NSString*)filePath success:(SuccessBlock)success failure:(ErrorBlock)failure uploadProgress:(MKNKProgressBlock)progress;
-(void)UploadAccountAsset:(NSString*)accountId FilePath:(NSString*)filePath success:(SuccessBlock)success failure:(ErrorBlock)failure uploadProgress:(MKNKProgressBlock)progress;
-(void)UploadPresentationAsset:(NSString*)presentationId FilePath:(NSString*)filePath success:(SuccessBlock)success failure:(ErrorBlock)failure uploadProgress:(MKNKProgressBlock)progress;


-(void)DeleteGeneralAsset:(NSString*)assetId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteAccountAsset:(NSString*)assetId accountId:(NSString*)accountId success:(SuccessBlock)success failure:(ErrorBlock)failure;
//--------------------------------------------------------------------------------

//------------------------------------- Accounts ---------------------------------
-(void)CreateAccount:(NSDictionary*)account member:(NSDictionary*)member success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetAllAccounts:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)UpdateAccount:(NSDictionary*)account success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)VerifyAccountCName:(NSString*)cName success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteAccount:(NSString*)accountId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)ResetPassword:(NSString*)email success:(SuccessBlock)success failure:(ErrorBlock)failure;
//--------------------------------------------------------------------------------

//------------------------------------- Others -----------------------------------
-(void)GetDevices:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetManufacturers:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetSFDCAccounts:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetUtilityProviders:(NSString*)findNameMask success:(SuccessBlock)success failure:(ErrorBlock)failure;
//--------------------------------------------------------------------------------


//------------------------------------- Analyze -----------------------------------
-(void)GetAllDashboards:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreateDashboard:(NSDictionary *)dashboardObj success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)UpdateDashboard:(NSString *)dashboardId param:(NSDictionary *)dashboardObj success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetMetricsInDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetAllSegmentsInDashboard:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteSegmentInDashboard:(NSString *)dashboardId segment:(NSString *)segment success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)AddNewSegmentInDashboard:(NSString *)dashboardId param:(NSArray *)param success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)UpdateSegmentInDashboard:(NSString *)dashboardId param:(NSArray *)param success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)AddNewWidget:(NSString *)dashboardId param:(NSDictionary *)param success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)UpdateNewWidget:(NSString *)dashboardId widgetId:(NSString *)widgetId param:(NSDictionary *)param success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteWidget:(NSString *)dashboardId widget:(NSString *)widgetId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetDashboardWidgetDatas:(NSString *)dashboardId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetDashboardWidgetDatas:(NSString *)dashboardId widgetId:(NSString *)widgetId success:(SuccessBlock)success failure:(ErrorBlock)failure;
//--------------------------------------------------------------------------------

//------------------------------------- Presentation -----------------------------------
-(void)GetAllPresentations:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreateWidget:(NSDictionary*)widgetObj success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeleteWidget:(NSString*) widgetId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetAvailableWidgets:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetEnergyWidget:(NSString*) presentationId Object:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetGraphWidget:(NSString*) presentationId Object:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetSolarWidget:(NSString*) presentationId Object:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetWeatherWidget:(NSString*) objectId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetWidgets:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)AddTagBinding:(NSDictionary*) tagBinding present:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)ClonePresentation:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)CreatePresentation:(NSDictionary*) obj success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)DeletePresentation:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)EditPresentation:(NSString*) presentationId param:(NSDictionary*) object success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetLastUpdatedPresentation:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetPresentationEditors:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetPresentationTimeline:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetPresentation:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetPresentationEnergyData:(NSString*) presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)GetPresentationTemplates:(SuccessBlock)success failure:(ErrorBlock)failure;
-(void)RemoveTagbinding:(NSString*) tagBindingId present:(NSString*) presentationId  success:(SuccessBlock)success failure:(ErrorBlock)failure;

- (void) CreatePresentationLinkEmail: (NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure;
- (void) UpdateWidget:(NSString*) widgetId param:(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure;

- (void) DeletePresentationAsset:(NSString*) assetId presentationId:(NSString*)presentationId success:(SuccessBlock)success failure:(ErrorBlock)failure;


- (void) SearchUsersForEditing :(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure;
- (void) DeleteEditors:(NSString*) presentationId param :(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure;
- (void) AddEditors:(NSString*) presentationId param :(NSDictionary*) dic success:(SuccessBlock)success failure:(ErrorBlock)failure;

@end
