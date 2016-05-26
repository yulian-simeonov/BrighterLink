//
//  AnalyzeViewController.m
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AnalyzeViewController.h"

#import "DashboardPanelView.h"

#import "NavigationBarView.h"
#import "CreateDashboardView.h"
#import "ControlBar.h"
#import "DateRangeAndDashInfoPanel.h"
#import "CanvasView.h"

#import "WidgetView.h"

#import "DashboardInfoView.h"
#import "LayoutView.h"

#import "DateRangeView.h"
#import "AddNewWidgetView.h"

#import "AddSourceAndGroupView.h"

#import "SharedMembers.h"

#import "JSWaiter.h"
#import "WebManager.h"

#define DASHBOAD_WIDTH 300
#define CONTROLBAR_HEIGHT 140
#define DATERANGEPANEL_HEIGHT 80

@interface AnalyzeViewController ()<DashboardPanelViewDelegate,
                                    CreateDashboardViewDelegate,
                                    ControlBarDelegate,
                                    CanvasViewDelegate,
                                    AddNewWidgetViewDelegate,
                                    DateRangeAndDashInfoPanelDelegate,
                                    DashboardInfoViewDelegate,
                                    LayoutViewDelegate,
                                    AddSourceAndGroupViewDelegate>
{
    WidgetView *_fullWidgetView;
    UIView *_parentViewOfFullWidgetView;
    CGRect _rtOriginalOfFullWidgetView;
    
    UIColor *_colorBeforeExpand;
}

@property (nonatomic, assign) IBOutlet DashboardPanelView *dashboardPanel;

@property (nonatomic, assign) IBOutlet ControlBar *controlBar;

@property (nonatomic, assign) DateRangeAndDashInfoPanel *dateRangeAndDashboardInfoPanel;

@property (nonatomic, assign) IBOutlet UIView *viewStatusBar;

@property (nonatomic, assign) IBOutlet UIView *viewRightPanel;

@property (nonatomic, assign) IBOutlet CanvasView *canvas;

@end

@implementation AnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DashboardPanelView" owner:self options:nil];
    self.dashboardPanel = [nib objectAtIndex:0];
    self.dashboardPanel.delegate = self;
    
    [self.view addSubview:self.dashboardPanel];
    
    //---------------------------------------------------------------
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"ControlBar" owner:self options:nil];
    self.controlBar = [nib objectAtIndex:0];
    self.controlBar.delegate = self;
    
    [self.viewRightPanel addSubview:self.controlBar];
    
    //---------------------------------------------------------------
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"DateRangeAndDashInfoPanel" owner:self options:nil];
    self.dateRangeAndDashboardInfoPanel = [nib objectAtIndex:0];
    self.dateRangeAndDashboardInfoPanel.delegate = self;
    
    [self.viewRightPanel addSubview:self.dateRangeAndDashboardInfoPanel];
    
    //---------------------------------------------------------------
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"CanvasView" owner:self options:nil];
    self.canvas = [nib objectAtIndex:0];
    self.canvas.delegate = self;
    
    [self.viewRightPanel addSubview:self.canvas];
    
    //---------------------------------------------------------------
    
    [SharedMembers sharedInstance].currentViewController = self;
    [NavigationBarView AddNavigationBar:self.view];
    
    [self updateUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAnotherDashboard) name:NOTIFICATION_SELECTED_DASHBOARD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentDashboard) name:NOTIFICATION_UPDATED_DATERANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:NOTIFICATION_ADDED_WIDGET object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if([SharedMembers sharedInstance].currentDashboard == nil)
    {
        [self setInitialDashboard];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) setInitialDashboard
{
    DashboardInfo *initialDashboard = [self getInitialDashboard];
    
    if(initialDashboard != nil)
    {
        [SharedMembers sharedInstance].currentDashboard = initialDashboard;
        
        [self.dashboardPanel _update];
        
        [[SharedMembers sharedInstance] updateCurrentDashboard:initialDashboard];
    }
}

- (DashboardInfo *) getInitialDashboard
{
    DashboardInfo *initialDashboard = nil;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *selectedDashboardId = [prefs objectForKey:KEY_SELECTED_DASHBOARD_ID];
    
    if(selectedDashboardId != nil)
    {
        initialDashboard = [[SharedMembers sharedInstance] getDashboardWithId:selectedDashboardId];
    }

    if(initialDashboard == nil)
    {
        if([SharedMembers sharedInstance].aryCollections.count > 0)
        {
            CollectionInfo *collection = [[SharedMembers sharedInstance].aryCollections objectAtIndex:0];
            
            if(collection.aryDashboards.count > 0)
            {
                initialDashboard = [collection.aryDashboards objectAtIndex:0];
            }
        }
    }
    
    return initialDashboard;
}

- (void) updateUI
{
    self.dashboardPanel.frame = CGRectMake(0, 0, DASHBOAD_WIDTH, CGRectGetHeight(self.view.frame));
    self.controlBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.viewRightPanel.frame), CONTROLBAR_HEIGHT);
    self.dateRangeAndDashboardInfoPanel.frame = CGRectMake(0, CGRectGetHeight(self.controlBar.frame), CGRectGetWidth(self.viewRightPanel.frame), DATERANGEPANEL_HEIGHT);
    
    self.viewRightPanel.frame = CGRectMake(DASHBOAD_WIDTH, 0, CGRectGetWidth(self.view.frame) - DASHBOAD_WIDTH, CGRectGetHeight(self.view.frame));
    
    float pos = self.dateRangeAndDashboardInfoPanel.frame.origin.y + CGRectGetHeight(self.dateRangeAndDashboardInfoPanel.frame);
    
    self.canvas.frame = CGRectMake(0,
                                   pos,
                                   CGRectGetWidth(self.viewRightPanel.frame),
                                   CGRectGetHeight(self.viewRightPanel.frame) - pos);
    
    [self.view bringSubviewToFront:self.viewStatusBar];
}

- (void) reloadDatas
{
    [self.dashboardPanel _update];
    [self.dateRangeAndDashboardInfoPanel _update];
    [self.controlBar _update];
    
    [self.canvas updateCanvasWithType:[SharedMembers sharedInstance].currentDashboard.type];
}

- (void) showAddNewWidgetView:(NSString *)widgetId
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddNewWidgetView" owner:self options:nil];
    AddNewWidgetView *addNewWidgetView = [nib objectAtIndex:0];
    addNewWidgetView.delegate = self;
    
    [self.view addSubview:addNewWidgetView];
    
    addNewWidgetView.widgetId = widgetId;
    
    [self.view bringSubviewToFront:addNewWidgetView];
}

- (void) showDateRangePopview
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DateRangeView" owner:self options:nil];
    DateRangeView *dateRangeView = [nib objectAtIndex:0];
    
    [self.view addSubview:dateRangeView];
    
    dateRangeView.viewMain.frame =
    CGRectMake(CGRectGetWidth(self.view.frame) - CGRectGetWidth(dateRangeView.viewMain.frame) - 15,
               self.dateRangeAndDashboardInfoPanel.frame.origin.y + CGRectGetHeight(self.dateRangeAndDashboardInfoPanel.frame) - 10,
               CGRectGetWidth(dateRangeView.viewMain.frame),
               CGRectGetHeight(dateRangeView.viewMain.frame));
    
    [self.view bringSubviewToFront:dateRangeView];
}

- (void) showAddNewSourcePopup:(SegmentInfo *)segment
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddSourceAndGroupView" owner:self options:nil];
    AddSourceAndGroupView *addSourceView = [nib objectAtIndex:0];
    addSourceView.segment = segment;
    addSourceView.delegate = self;
    
    [self.view addSubview:addSourceView];
    
    [self.view bringSubviewToFront:addSourceView];
}

- (void) showEditLayoutPopup
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"LayoutView" owner:self options:nil];
    LayoutView *editLayoutView = [nib objectAtIndex:0];
    editLayoutView.delegate = self;
    
    [self.view addSubview:editLayoutView];
    [editLayoutView setLayoutType:[SharedMembers sharedInstance].currentDashboard.type];
    
    [self.view bringSubviewToFront:editLayoutView];
}

- (void) showDashboardInfoView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DashboardInfoView" owner:self options:nil];
    DashboardInfoView *dashboardInfoView = [nib objectAtIndex:0];
    dashboardInfoView.delegate = self;
    
    [self.view addSubview:dashboardInfoView];
    
    [self.view bringSubviewToFront:dashboardInfoView];
}

- (void) onCreateNewDashboard:(id)object
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CreateDashboardView" owner:self options:nil];
    CreateDashboardView *createDashboardView = [nib objectAtIndex:0];
    createDashboardView.delegate = self;
    
    if([object isKindOfClass:[CollectionInfo class]])
    {
        createDashboardView.collection = object;
    }
    else if([object isKindOfClass:[DashboardInfo class]])
    {
        createDashboardView.dashboard = object;
    }
        
    createDashboardView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    
    [self.view addSubview:createDashboardView];
}

- (void) updateCurrentDashboard
{
    [self reqUpdateDashboard:[SharedMembers sharedInstance].currentDashboard];
}

- (void) addedNewWidget
{
    [SharedMembers sharedInstance].currentDashboard.updated = false;
    
    [self reqMetrics:[SharedMembers sharedInstance].currentDashboard];
}

#pragma mark Notification Functions

- (void) selectedAnotherDashboard
{
    [self.dashboardPanel _update];
    
    [SharedMembers sharedInstance].metrics = nil;
    
    [self reqMetrics:[SharedMembers sharedInstance].currentDashboard];
}

#pragma mark ControlBarDelegate

- (void) addNewWidget
{
    [self showAddNewWidgetView:nil];
}

- (void) editLayout
{
    [self showEditLayoutPopup];
}

- (void) editCurrentDashboard
{
    [self onCreateNewDashboard:[SharedMembers sharedInstance].currentDashboard];
}

- (void) deleteCurrentDashboard
{
    [self reqDeleteDashboard:[SharedMembers sharedInstance].currentDashboard];
}

- (void) addNewSource
{
    [self showAddNewSourcePopup:nil];
}

- (void) editSource:(SegmentInfo *)segment
{
    [self showAddNewSourcePopup:segment];
}

#pragma mark DateRangeAndDashboardInfoPanelDelegate

- (void) tappedDashboardInfo
{
    [self showDashboardInfoView];
}

- (void) tappedRangeDate
{
    [self showDateRangePopview];
}

#pragma mark DashboardPanelViewDelegate

- (void) createNewDashboard
{
    [self onCreateNewDashboard:nil];
}

- (void) editDashboard:(DashboardInfo *)dashboard
{
    [self onCreateNewDashboard:dashboard];
}

#pragma mark CreateDashboardViewDelegate

- (void) createNewDashboardWith:(DashboardInfo *)dashboard
{
    [self reqCreateDashboard:dashboard];
}

- (void) updateDashboard:(DashboardInfo *)dashboard
{
    [self reqUpdateDashboard:dashboard];
}

#pragma mark AddNewWidgetViewDelegate

- (void) addNewWidget:(WidgetInfo *)newWidget
{
    if(newWidget._id != nil && [newWidget._id isKindOfClass:[NSString class]] && newWidget._id.length > 0)
    {
        [[SharedMembers sharedInstance] removeWidgetGraphicData:newWidget._id];
        
        [self reqUpdateWidget:newWidget];
    }
    else
        [self reqAddWidget:newWidget];
}

#pragma mark DashboardInfoViewDelegate

- (void) createNewDashboardWithCollection:(CollectionInfo *)collection
{
    [self onCreateNewDashboard:collection];
}

#pragma mark AddSourceAndGroupViewDelegate

- (void) addNewSegment:(SegmentInfo *)segment
{
    [self reqAddSegment:[SharedMembers sharedInstance].currentDashboard segment:segment];
}

- (void) updateSegment:(SegmentInfo *)segment
{
    [self reqUpdateSegment:[SharedMembers sharedInstance].currentDashboard segment:segment];
}

- (void) deleteSegment:(SegmentInfo *)segment
{
    [self reqDeleteSegment:[SharedMembers sharedInstance].currentDashboard segment:segment];
}

#pragma mark LayoutViewDelegate

- (void) changedLayoutType:(NSInteger) type
{
    [SharedMembers sharedInstance].currentDashboard.type = type;
    
    [self updateCurrentDashboard];
}


#pragma mark CanvasViewDelegate

- (void) deleteWidgetWithId:(NSString *)widgetId
{
    BOOL isExist = [[SharedMembers sharedInstance] hasWidgetOnCurrentDashboardWithId:widgetId];
    
    if(isExist)
    {
        [self reqDeleteWidget:[SharedMembers sharedInstance].currentDashboard widgetId:widgetId];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no this widget on current dashboard.Please refresh the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        alertView = nil;
    }
}

- (void) editWidgetWithId:(NSString *)widgetId
{
    [self showAddNewWidgetView:widgetId];
}

- (void) expandWidgetView:(WidgetView *)view
{
    _colorBeforeExpand = view.backgroundColor;
    
    _fullWidgetView = view;
    _fullWidgetView.backgroundColor = [UIColor whiteColor];
    _parentViewOfFullWidgetView = view.superview;
    _rtOriginalOfFullWidgetView = view.frame;
    
    CGPoint pt = view.center;
    CGPoint pt_ = [self.view convertPoint:pt fromView:_parentViewOfFullWidgetView];
    
    [view removeFromSuperview];
    
    UIView *newParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    newParentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
    newParentView.layer.zPosition = 100.0f;
    
    [newParentView addSubview:view];
    view.center = pt_;
    
    [self.view addSubview:newParentView];
    [self.view bringSubviewToFront:newParentView];
    
    newParentView = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        view.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.8, self.view.frame.size.height * 0.8);
        view.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        
    } completion:^(BOOL finished) {
        
        [view showCompressButton:self];
    }];
}

- (void) compressFullWidgetView
{
    UIView *parentView = _fullWidgetView.superview;
    parentView.backgroundColor = [UIColor clearColor];
    
    [_fullWidgetView hideCompressButton];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        CGPoint pt = [self.view convertPoint:_rtOriginalOfFullWidgetView.origin fromView:_parentViewOfFullWidgetView];
        
        _fullWidgetView.frame = CGRectMake(pt.x, pt.y, _rtOriginalOfFullWidgetView.size.width, _rtOriginalOfFullWidgetView.size.height);

    } completion:^(BOOL finished) {
        
        [_fullWidgetView removeFromSuperview];
        [parentView removeFromSuperview];
        
        _fullWidgetView.frame = _rtOriginalOfFullWidgetView;
        [_parentViewOfFullWidgetView addSubview:_fullWidgetView];
        
        _fullWidgetView.backgroundColor = _colorBeforeExpand;
        
        _fullWidgetView = nil;
        _parentViewOfFullWidgetView = nil;
        _rtOriginalOfFullWidgetView = CGRectZero;

    }];
}

#pragma mark api request

- (void) reqCreateDashboard:(DashboardInfo *)dashboard
{
    NSDictionary *layout = @{ @"selectedStyle"  : [NSNumber numberWithInteger:dashboard.type],
                              @"widgets"        : @{ @"column0" : @[],
                                                     @"column1": @[]} };
    
    NSDictionary *dashboardInfo = nil; NSString *message = @"";
    if(dashboard._id != nil)
    {
        [self reqUpdateDashboard:dashboard];
        
        return;
    }
    else
    {
        dashboardInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       dashboard.title,             @"title",
                                       @[dashboard.collectionName], @"collections",
                                       [dashboard getDateStringForRequest:YES compare:NO],@"startDate",
                                       [dashboard getDateStringForRequest:NO compare:NO], @"endDate",
                                       layout,                      @"layout",
                                       nil];
        
        message = @"Creating...";
    }
    
    dashboard = nil;

    [JSWaiter ShowWaiter:self.view title:message type:0];
    
    [[SharedMembers sharedInstance].webManager CreateDashboard:dashboardInfo success:^(MKNetworkOperation *operation)
     {
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             id dashboard = [operation.responseJSON objectForKey:@"message"];
             
             if([dashboard isKindOfClass:[NSDictionary class]])
             {
                 DashboardInfo *_dashboard = [[DashboardInfo alloc] initWithDictionary:dashboard];
                 
                 [[SharedMembers sharedInstance] updateDashboard:_dashboard];
                 _dashboard = nil;
             }
         }
         else
         {
             NSString *message = [operation.responseJSON objectForKey:@"message"];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [alertView show];
             alertView = nil;
         }
         
     } failure:nil];
}

- (void) reqUpdateDashboard:(DashboardInfo *)dashboard
{
    NSDictionary *layout = @{ @"selectedStyle"  : [NSNumber numberWithInteger:dashboard.type],
                              @"widgets"        : @{ @"column0" : @[],
                                                     @"column1": @[]} };
    
    NSDictionary *dashboardInfo = nil; NSString *message = @"";
    if(dashboard._id != nil)
    {
        dashboardInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                         dashboard._id,                @"_id",
                         dashboard.title,             @"title",
                         @[dashboard.collectionName], @"collections",
                         [dashboard getDateStringForRequest:YES compare:NO],@"startDate",
                         [dashboard getDateStringForRequest:NO compare:NO], @"endDate",
                         [dashboard getDateStringForRequest:YES compare:YES],@"compareStartDate",
                         [dashboard getDateStringForRequest:NO compare:YES], @"compareEndDate",
                         layout,                      @"layout",
                         dashboard.widgets,          @"widgets",
                         nil];
        
        message = @"Updating...";
    }
    else
    {
        [self reqCreateDashboard:dashboard];
        
        return;
    }
    
    NSLog(@"%@", dashboardInfo);
    
    [JSWaiter ShowWaiter:self.view title:message type:0];
    
    [[SharedMembers sharedInstance].webManager UpdateDashboard:dashboard._id param:dashboardInfo success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             id dashboard = [operation.responseJSON objectForKey:@"message"];
             
             NSLog(@"%@", dashboard);
             
             if([dashboard isKindOfClass:[NSDictionary class]])
             {
                 DashboardInfo *_dashboard = [[DashboardInfo alloc] initWithDictionary:dashboard];
                 
                 [[SharedMembers sharedInstance] updateDashboard:_dashboard];
                 _dashboard = nil;
             }
         }
         else
         {
             NSString *message = [operation.responseJSON objectForKey:@"message"];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [alertView show];
             alertView = nil;
         }
         
     } failure:nil];
}

- (void) reqDeleteDashboard:(DashboardInfo *)dashboard
{
    [JSWaiter ShowWaiter:self.view title:@"Deleting..." type:0];
    
    [[SharedMembers sharedInstance].webManager DeleteDashboard:dashboard._id success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             [[SharedMembers sharedInstance] deleteCurrentDashboard];
         }
         else
         {
             NSString *message = [operation.responseJSON objectForKey:@"message"];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [alertView show];
             alertView = nil;
         }
         
     } failure:nil];
}

- (void) reqDashboard:(DashboardInfo *)dashboard
{
    if(dashboard.updated)
    {
        //[self reqWidgetDatas:dashboard];
        [self reloadDatas];
        
        return;
    }
    
    [JSWaiter ShowWaiter:self.view title:@"Initialize..." type:0];
    
    [SharedMembers sharedInstance].webManager.ProcessError = NO;
    [[SharedMembers sharedInstance].webManager GetDashboard:dashboard._id success:^(MKNetworkOperation *operation)
     {
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             NSDictionary *fullDashboard = [operation.responseJSON objectForKey:@"message"];
             
             [dashboard updateDashboard:fullDashboard];
             
             //[self reqWidgetDatas:dashboard];
             [self reloadDatas];
         }
         else
         {
             NSString *message = [operation.responseJSON objectForKey:@"message"];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [alertView show];
             alertView = nil;
         }
         
     } failure:^(MKNetworkOperation *operation, NSError *error)
     {
         [JSWaiter HideWaiter];
         
         //[self reqWidgetDatas:dashboard];
         [self reloadDatas];
     }];
}

- (void) reqMetrics:(DashboardInfo *)dashboard
{
    [JSWaiter ShowWaiter:self.view title:@"Initialize..." type:0];
    
    [SharedMembers sharedInstance].webManager.ProcessError = NO;
    [[SharedMembers sharedInstance].webManager GetMetricsInDashboard:dashboard._id success:^(MKNetworkOperation *operation)
     {
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             id metrics = [operation.responseJSON objectForKey:@"message"];
             
             NSLog(@"%@", metrics);
             
             if([metrics isKindOfClass:[NSDictionary class]])
             {
                 [SharedMembers sharedInstance].metrics = metrics;
             }
         }
         
         [self reqDashboard:dashboard];
         
     } failure:^(MKNetworkOperation *operation, NSError *error)
     {
         [JSWaiter HideWaiter];
         
         [self reqDashboard:dashboard];
     }];
}

- (void) reqSegments:(DashboardInfo *)dashboard
{
    [SharedMembers sharedInstance].webManager.ProcessError = NO;
    [[SharedMembers sharedInstance].webManager GetAllSegmentsInDashboard:dashboard._id success:^(MKNetworkOperation *operation)
     {
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             id segments = [operation.responseJSON objectForKey:@"message"];
             
             if([segments isKindOfClass:[NSArray class]])
             {
                 [[SharedMembers sharedInstance] updateSegmentsForCurrentDashboard:segments];
             }
         }
         
         //[self reqWidgetDatas:dashboard];
         [self reloadDatas];
         
     } failure:^(MKNetworkOperation *operation, NSError *error)
     {
         //[self reqWidgetDatas:dashboard];
         [self reloadDatas];
     }];
}

- (void) reqDeleteSegment:(DashboardInfo *)dashboard segment:(SegmentInfo *)segment
{
    [JSWaiter ShowWaiter:self.view title:@"Deleting..." type:0];
    
    [[SharedMembers sharedInstance].webManager DeleteSegmentInDashboard:dashboard._id segment:segment._id success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             [dashboard.segments removeObject:segment];
             
             [self reloadDatas];
         }
         
     } failure:nil];
}

- (void) reqAddSegment:(DashboardInfo *)dashboard segment:(SegmentInfo *)segment
{
    NSArray *param = @[ @{@"name" : segment.name,
                          @"tagBindings" : segment.tagBindings}];
    
    NSLog(@"%@", param);
    
    [JSWaiter ShowWaiter:self.view title:@"Adding..." type:0];

    [[SharedMembers sharedInstance].webManager AddNewSegmentInDashboard:dashboard._id param:param success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             NSDictionary *dashboard = [operation.responseJSON objectForKey:@"message"];
             
             [[SharedMembers sharedInstance].currentDashboard updateDashboard:dashboard];
             
             [self reloadDatas];
         }
         
     } failure:nil];
}

- (void) reqUpdateSegment:(DashboardInfo *)dashboard segment:(SegmentInfo *)segment
{
    NSArray *param = @[ @{@"id" : segment._id,
                          @"name" : segment.name,
                          @"tagBindings" : segment.tagBindings}];
    
    NSLog(@"%@", param);
    
    [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
    
    [[SharedMembers sharedInstance].webManager UpdateSegmentInDashboard:dashboard._id param:param success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             NSDictionary *dashboard = [operation.responseJSON objectForKey:@"message"];
             
             [[SharedMembers sharedInstance].currentDashboard updateDashboard:dashboard];
             
             [self reloadDatas];
         }
         
     } failure:nil];
}

- (void) reqAddWidget:(WidgetInfo *) widget
{
    NSDictionary *param = [widget getRequestParam];
    
    NSString *dashboadId = [param objectForKey:@"drillDown"];
    
    if(dashboadId == nil || ![dashboadId isKindOfClass:[NSString class]] || dashboadId.length == 0)
    {
        dashboadId = [SharedMembers sharedInstance].currentDashboard._id;
    }
    
    NSLog(@"%@", param);
    
    [JSWaiter ShowWaiter:self.view title:@"Adding..." type:0];
    
    [[SharedMembers sharedInstance].webManager AddNewWidget:dashboadId param:param success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             [self addedNewWidget];
         }
         
     } failure:nil];
}

- (void) reqUpdateWidget:(WidgetInfo *) widget
{
    NSDictionary *param = [widget getRequestParam];
    
    NSString *dashboadId = [param objectForKey:@"drillDown"];
    
    if(dashboadId == nil || ![dashboadId isKindOfClass:[NSString class]] || dashboadId.length == 0)
    {
        dashboadId = [SharedMembers sharedInstance].currentDashboard._id;
    }
    
    NSString *widgetId = widget._id;
    
    NSLog(@"%@", param);
    
    [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
    
    [[SharedMembers sharedInstance].webManager UpdateNewWidget:dashboadId widgetId:widgetId param:param success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             [self addedNewWidget];
         }
         
     } failure:nil];
}

- (void) reqDeleteWidget:(DashboardInfo *)dashboard widgetId:(NSString *)widgetId
{
    [JSWaiter ShowWaiter:self.view title:@"Deleting..." type:0];
    
    [[SharedMembers sharedInstance].webManager DeleteWidget:dashboard._id widget:widgetId success:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             BOOL isRemoved = [[SharedMembers sharedInstance] removeWidgetOnCurrentDashboardWithId:widgetId];
             
             if(isRemoved)
             {
                 [self reloadDatas];
             }
         }
         
     } failure:nil];
}

- (void) reqWidgetDatas:(DashboardInfo *) dashboard
{
    [JSWaiter ShowWaiter:self.view title:@"Initialize..." type:0];
    
    [SharedMembers sharedInstance].aryWidgetDatas = nil;
    [JSWaiter ShowWaiter:self.view title:@"Loading..." type:0];
    [[SharedMembers sharedInstance].webManager GetDashboardWidgetDatas:dashboard._id success:^(MKNetworkOperation *operation)
     {
         [JSWaiter HideWaiter];
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             [SharedMembers sharedInstance].aryWidgetDatas = [operation.responseJSON objectForKey:@"message"];
         }
         
         [self reloadDatas];
         
     } failure:^(MKNetworkOperation *operation, NSError *error)
     {
         [JSWaiter HideWaiter];
         
         [self reloadDatas];
     }];
}

@end
