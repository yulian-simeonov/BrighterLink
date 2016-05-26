//
//  SharedMembers.h
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebManager.h"
#import "DBManager.h"
#import "JSWaiter.h"
#import "NSObject+KJSerializer.h"

#import "UserInfo.h"
#import "Tag.h"
#import "TagRule.h"
#import "CollectionInfo.h"
#import "DashboardInfo.h"
#import "Timeline.h"
#import "PresentationInfo.h"
#import "PWidgetInfo.h"
#import "WidgetInfo.h"
#import "SegmentInfo.h"
#import "DashboardCreator.h"

#define NOTIFICATION_SELECTED_DASHBOARD @"notification_selected_dashboard"
#define NOTIFICATION_UPDATED_DATERANGE @"notification_updated_daterange"
#define NOTIFICATION_ADDED_WIDGET @"notification_added_widget"

#define KEY_SELECTED_DASHBOARD_ID @"key_selected_dashboard_id"

#define IS_TEST YES

@class NavigationBarView;
@interface SharedMembers : NSObject
{
@public
    NSString* m_appNames[8];
}

@property (nonatomic, strong) WebManager* webManager;
@property (nonatomic, weak) UIViewController* currentViewController;
@property (nonatomic, weak) UIViewController* loginViewController;
@property (nonatomic, strong) UIViewController* analyzerViewController;
@property (nonatomic, strong) UIViewController* presentViewController;
@property (nonatomic, strong) UIImage* img_screenShot;
@property (nonatomic, weak) NavigationBarView* navigationBar;
//########################################################### Properties ########################################################################

//#################################################################
//-------------------------- Dashboard ----------------------------

@property (nonatomic, retain) NSMutableArray *aryCollections;

@property (nonatomic, retain) DashboardInfo *currentDashboard;

@property (nonatomic, retain) NSDictionary *metrics;

@property (nonatomic, retain) NSArray *aryGroupDimentions;

@property (nonatomic, retain) NSArray *arySegmentColors;

@property (nonatomic, retain) NSMutableArray *aryWidgetDatas;

- (void) addNewDashboard:(DashboardInfo *)dashboard select:(BOOL) isSelect;
- (void) updateDashboard:(DashboardInfo *)dashboard;

- (DashboardInfo *) getDashboardWithId:(NSString *)dashboardId;

- (void) deleteCurrentDashboard;

- (void) updateCurrentDashboard:(DashboardInfo *)dashboard;

- (void) updateSegmentsForCurrentDashboard:(NSArray *)segments;

- (BOOL) hasWidgetOnCurrentDashboardWithId:(NSString *)widgetId;
- (BOOL) removeWidgetOnCurrentDashboardWithId:(NSString *)widgetId;

- (NSDictionary *) getWidgetInfoWithId:(NSString *)widgetId;

- (void) addWidgetGraphicData:(NSString *)widgetId data:(NSDictionary *)graphicData;
- (void) removeWidgetGraphicData:(NSString *)widgetId;
- (NSDictionary *) getWidgetGraphicData:(NSString *)widgetId;

- (UIColor *) getSegmentColorWithIndex:(NSInteger )index;

//--------**********-------- Dashboard ---------**********------
//#################################################################

//----------------------------------- Platform Members --------------------------------------
@property (nonatomic, strong) UserInfo*             userInfo;
@property (nonatomic, strong) NSString*             Token;
@property (nonatomic, strong) NSMutableArray*       Members;
@property (nonatomic, strong) NSMutableArray*       Accounts;
@property (nonatomic, strong) NSMutableArray*       RootTags;
@property (nonatomic, strong) NSMutableArray*       Devices;
@property (nonatomic, strong) NSMutableArray*       Manufacturers;
@property (nonatomic, strong) NSMutableArray*       SFDCAccounts;
@property (nonatomic, strong) NSMutableArray*       UtilityProviders;
//*******************************************************************************************

//###############################################################################################################################################

//########################################################### Methods ########################################################################
+(SharedMembers*)sharedInstance;
+(void)ShowGlobalWaiter:(NSString*)title  type:(WaiterType)type;

+ (UIImage *)fixOrientation:(UIImage*)srcImg;
+(UIImage*)CaptureBackground:(UIView*)view inRect:(CGRect)inRect withScale:(CGFloat)scale;
+ (BOOL)validateEmailWithString:(NSString*)checkString;
+(NSString*)GetSavePath:(NSString*)dirName;

// 2014-11-03T20:11:52.929Z
+(NSDate *) getDateWithString:(NSString *)string;

//###############################################################################################################################################

//--------**********-------- Presentation ---------**********------
//#################################################################

@property (nonatomic, retain) NSMutableArray * arrAllPresentations;
@property (nonatomic, retain) NSMutableArray * arrEditors;
@property (nonatomic, retain) NSMutableArray * arrTemplates;
@property (nonatomic, retain) NSMutableArray * arrAvailableWidgets;
@property (nonatomic, retain) NSMutableArray * arrEditorUsers;

@property (nonatomic, retain) PresentationInfo * curPresent;
@property (nonatomic, retain) PWidgetInfo      * curWidget;

@property (nonatomic, strong) NSString * lastUpdatedPresentationId;
@property (nonatomic, strong) Timeline * timeline;

@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, strong) NSString * selectedAccountId;





@end
