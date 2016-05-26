//
//  PresentViewController.m
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PresentViewController.h"
#import "NavigationBarView.h"
#import "SharedMembers.h"

#import "PresentTabView.h"
#import "PresentDrawView.h"


#import "LineCell.h"
#import "EditorCell.h"

#import "UIViewController+CWPopup.h"
#import "JSWaiter.h"

#import "PresentationInfo.h"
#import "EditorInfo.h"
#import "PresentationTemplates.h"
#import "Timeline.h"
#import "TimelineData.h"
#import "PWidgetInfo.h"
#import "SDWebImageManager.h"

#import "UserInfo.h"
#import "AddEditorView.h"
#import "EditorCell.h"


#define TAB_VIEW_WIDTH  300
#define DRAW_VIEW_WIDTH 672
#define DRAW_VIEW_HEIGT 633
#define DRAW_VIEW_POS_X   330
#define DRAW_VIEW_POS_Y   132

#define WIDGET_BTN_WIDTH  188
#define WIDGET_BTN_HEIGHT  65

@interface PresentViewController ()<CISnapshotVCDelegate, SharePresentViewDelegate, PresentTabDelegate, PresentDrawDelegate, WeatherDelegate, EditDelegate>

@property (nonatomic, assign) IBOutlet PresentTabView *vTab;
@property (nonatomic, assign) IBOutlet PresentDrawView *vDraw;

@property (nonatomic, assign) IBOutlet UIView *viewStatusBar;

@end

@implementation PresentViewController


NSString * imgEnergyName[] = {
    @"/bl-bv-management/assets/img/vertical-cars.png",
    
    @"/bl-bv-management/assets/img/tons.png",
    
    @"/bl-bv-management/assets/img/gallons.png",
    
    @"/bl-bv-management/assets/img/tanker.png",
    
    @"/bl-bv-management/assets/img/energy-home.png",
    
    @"/bl-bv-management/assets/img/electricity-home.png",
    
    @"/bl-bv-management/assets/img/railcars.png",
    
    @"/bl-bv-management/assets/img/barrels.png",
    
    @"/bl-bv-management/assets/img/propane.png",
    
    @"/bl-bv-management/assets/img/coal.png",
    
    @"/bl-bv-management/assets/img/tree.png",
    
    @"/bl-bv-management/assets/img/acres.png",
    
    @"/bl-bv-management/assets/img/acres-corpland.png",
};


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SharedMembers sharedInstance].currentViewController = self;
    [NavigationBarView AddNavigationBar:self.view];
    
    NSArray* nib1 = [[NSBundle mainBundle] loadNibNamed:@"PresentDrawView" owner:self options:nil];
    self.vDraw = [nib1 objectAtIndex:0];
    
    [self.view addSubview:self.vDraw];
    self.vDraw->parent = self;
    
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"PresentTabView" owner:self options:nil];
    self.vTab = [nib objectAtIndex:0];
    [self.view addSubview:self.vTab];
    
    [self updateUI];
    
    _presentationDetailVC = [[PresentationDetailView alloc] initWithNibName:@"PresentationDetailView" bundle:nil];
    [_presentationDetailVC setDelegate:self];
    
    _shareVC = [[SharePresentView alloc] initWithNibName:@"SharePresentView" bundle:nil];
    [_shareVC setDelegate:self];
    
    _widgetDetailView = [[WidgetDetailView alloc] initWithNibName:@"WidgetDetailView" bundle:nil];
    [_widgetDetailView setDelegate:self];
    
    [_vDraw setDelegate:self];
    
    
    bPalyPresentation = false;  bCreative = false; m_nSelectedWidget = -1;
    [_vTab setDelegate:self];
    
    m_vTemp = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WIDGET_BTN_WIDTH, WIDGET_BTN_HEIGHT)];
    [m_vTemp setBackgroundColor: [UIColor clearColor]];
    UIImageView * imgTemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDGET_BTN_WIDTH, WIDGET_BTN_HEIGHT)];
    [imgTemp setImage:[UIImage imageNamed:@"btn_weather.png"]];
    [m_vTemp addSubview: imgTemp];
    
    m_nCurTime = 0.0f;
    
//    m_ComboFullScreenMode =  [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_play.frame.origin.x , _m_img_play.frame.origin.y  + _m_img_play.frame.size.height, _m_img_play.frame.size.width , 100)];
//    [m_ComboFullScreenMode setDelegate:self];
//    
//    NSMutableArray* accounts = [[NSMutableArray alloc] init];
//    [accounts addObject:@{@"id" : @"", @"text" : @"Full Screen", @"sfdcAccountId" : @""}];
//    [m_ComboFullScreenMode UpdateData:accounts];
//    [self.view addSubview: m_ComboFullScreenMode];
//    [m_ComboFullScreenMode setHidden:true];
    
    [_m_btnFullScreen setHidden:true];
    
    
    [self GetDataFromServer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showProgress:)
                                                 name:@"ShowProgress"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideProgress:)
                                                 name:@"HideProgress"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAddEditor:)
                                                 name:@"ShowAddEditor"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(confrimEditor:)
                                                 name:@"ConfrimEditor"
                                               object:nil];
}

- (void) showProgress:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    [JSWaiter ShowWaiter:self.view title:@"" type:0];
}

- (void) hideProgress:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    [JSWaiter HideWaiter];
}

- (void) showAddEditor:(NSNotification *) notification
{
    NSDictionary * dic =  notification.userInfo;
    
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddEditorView" owner:self options:nil];
    AddEditorView * m_vEditor = [nib objectAtIndex:0];
    
    int index  = ((NSString*)[dic objectForKey:@"INDEX"]).intValue;
    [m_vEditor setInfo: [dic objectForKey:@"USER_ID"] Email:[dic objectForKey:@"USER_EMAIL"] Name:[dic objectForKey:@"USER_NAME"] Index: index picture:[dic objectForKey:@"PICTURE"]];
    
    [self.view addSubview: m_vEditor];
    m_vEditor.layer.zPosition  = 100;
    [m_vEditor setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}

- (void) confrimEditor:(NSNotification *) notification
{
    [self setPresentationName];
}

- (void) updateUI
{
    self.vTab.frame = CGRectMake(0, 20, TAB_VIEW_WIDTH, CGRectGetHeight(self.view.frame));
    self.vDraw.frame = CGRectMake(1024 - DRAW_VIEW_WIDTH, 20 + DRAW_VIEW_POS_Y, DRAW_VIEW_WIDTH, DRAW_VIEW_HEIGT);
    [self.view bringSubviewToFront:self.viewStatusBar];
}

- (void) GetAllPresentation
{
    
    [[SharedMembers sharedInstance].webManager GetAllPresentations:^(MKNetworkOperation *networkOperation) {
        
        [[SharedMembers sharedInstance].arrAllPresentations removeAllObjects];
        NSArray * arr = [networkOperation.responseJSON objectForKey:@"message"];
        for( int i = 0; i < [arr count]; i++ ){
            PresentationInfo * info = [[PresentationInfo alloc] init];
            [info setDictionary: arr[i]];
            [[SharedMembers sharedInstance].arrAllPresentations addObject:info];
        }
        
        [_vTab setRefresh];
        
        PresentationInfo *firstItem = (PresentationInfo*)[[SharedMembers sharedInstance].arrAllPresentations lastObject];
        [[SharedMembers sharedInstance].webManager GetPresentation: firstItem._id   success:^(MKNetworkOperation *networkOperation) {
            NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            PresentationInfo * curPresentation = [SharedMembers sharedInstance].curPresent;
            [curPresentation setDictionary:dic];
            curPresentation.des = [dic objectForKey:@"description"];
            
            [[SharedMembers sharedInstance].webManager GetWidgets:firstItem._id success:^(MKNetworkOperation *networkOperation) {
                
                NSArray * arr = [networkOperation.responseJSON objectForKey:@"message"];
                for ( NSDictionary * dic in arr ) {
                    PWidgetInfo * info = [[PWidgetInfo alloc] init];
                    [info setDictionary: dic];
                    NSDictionary * paramDic  = [dic objectForKey:@"parameters"];
                    [info.param setDictionary: paramDic];
                    
                    [self GetParamDic:info param:paramDic];
                    ////////////
                    
                    [curPresentation.m_widgets addObject: info];
                }
                [self GetPresentation: firstItem._id ];
            } failure:^(MKNetworkOperation *errorOp, NSError *error) {
                
            }];
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
}

- (void) GetLastUpdatedPresentation
{
    [[SharedMembers sharedInstance].webManager GetLastUpdatedPresentation:^(MKNetworkOperation *networkOperation) {
        NSDictionary * dic = networkOperation.responseJSON;
        [SharedMembers sharedInstance].lastUpdatedPresentationId = [dic objectForKey:@"message"];

        NSString * presentationId  = [SharedMembers sharedInstance].lastUpdatedPresentationId;
        [self GetEditors:presentationId];
        
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
    
}

- (void) GetEditors:(NSString*) presentationId
{
        [[SharedMembers sharedInstance].webManager GetPresentationEditors: presentationId success:^(MKNetworkOperation *networkOperation) {
            
            [[SharedMembers sharedInstance].arrEditors removeAllObjects];
        [[SharedMembers sharedInstance].arrEditorUsers removeAllObjects];
        
            NSArray * arr = [networkOperation.responseJSON objectForKey:@"message"];
            for( int i = 0; i < [arr count]; i++ ){
                EditorInfo * info = [[EditorInfo alloc] init];
                [info setDictionary: arr[i]];
            info->m_bAdded = true;
                [[SharedMembers sharedInstance].arrEditors addObject:info];
            }
        
        
        [[SharedMembers sharedInstance].webManager SearchUsersForEditing:nil success:^(MKNetworkOperation *networkOperation) {
            
            NSLog(@"%@", networkOperation.responseJSON);
            
            NSArray * arrUsers = [networkOperation.responseJSON objectForKey:@"message"];
            
            for ( int i = 0; i < [arrUsers count]; i++ ) {
                
                EditorInfo * user  = [[EditorInfo alloc] init];
                [user setDictionary: [arrUsers objectAtIndex:i]];
                
//                if ( ![user.role isEqualToString:@"BP"] )
                {
                    
                    BOOL flag = false;
                    for ( int j = 0 ; j < [[SharedMembers sharedInstance].arrEditors count]; j++ ) {
                        EditorInfo * editor = [[SharedMembers sharedInstance].arrEditors objectAtIndex:j];
                        if ( [editor.name isEqualToString: user.name] ) {
                            flag  = true;
                            break;
                        }
                    }
                    
                    if ( !flag ) {
                        user->m_bAdded = false;
                        [[SharedMembers sharedInstance].arrEditors addObject:user];
                    }
                }
            }
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
        
        [_vTab setRefresh];
        
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
}

- (void) GetPresentationTemplates
{
    [[SharedMembers sharedInstance].webManager GetPresentationTemplates:^(MKNetworkOperation *networkOperation) {
        
        NSArray * arr = [networkOperation.responseJSON objectForKey:@"message"];
        for ( NSDictionary * dic in arr ) {
            PresentationTemplates *  info  = [[PresentationTemplates alloc] init];
            info.des = [dic objectForKey:@"description"];
            [info setDictionary: dic];
            [[SharedMembers sharedInstance].arrTemplates addObject: info];
        }
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        NSLog( @"fail" );
    }];
}

- (void) GetAvailableWidgets
{
    
    [[SharedMembers sharedInstance].webManager GetAvailableWidgets:^(MKNetworkOperation *networkOperation) {
        
        NSLog(@"%@", networkOperation.responseJSON);
        NSArray * arr = [networkOperation.responseJSON objectForKey:@"message"];
        for ( NSDictionary * dic in arr ) {
            PWidgetInfo * info = [[PWidgetInfo alloc] init];
            [info setDictionary: dic];
            NSDictionary * paramDic  = [dic objectForKey:@"parameters"];
            [info.param setDictionary: paramDic];
            [self GetParamDic:info param:paramDic];
            ////////////
            
            [[SharedMembers sharedInstance].arrAvailableWidgets addObject:info];
        }
        
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
}

- (void) GetDataFromServer
{
    [JSWaiter ShowWaiter:self.view title:@"" type:0];
    
    [self GetAllPresentation];
    [self GetLastUpdatedPresentation];
    [self GetPresentationTemplates];
    [self GetAvailableWidgets];
}

//==================================================
// CISnapshotVC Delegate Methods
//==================================================
#pragma mark- CISnapshotVC Delegate Methods
//==================================================
- (void)CISnapshotVCDidCloseButtonPressed:(PresentationDetailView *)popupVC
{
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            [self setPresentationName];
            PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
            [_vDraw.m_txt_Present_title setText: info.name];
        }];
    }
}

- (void) setPresentationName
{
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    
    for ( int  i = 0; i < [[SharedMembers sharedInstance].arrAllPresentations count]; i++ ) {
        PresentationInfo * present = [[SharedMembers sharedInstance].arrAllPresentations objectAtIndex:i];
        if ( [present._id isEqualToString: info._id] ) {
            present.name  = info.name;
            present.duration = info.duration;
        }
    }
    
    [_vTab setRefresh];
    [_m_PresentationName setText: info.name];
    [_vDraw setDuration: [info.duration intValue]];
//    [_vDraw.m_txt_Present_title setText: info.name];
}

- (void)SharePresentViewDidCloseButtonPressed:(SharePresentView*)popupVC
{
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)WeatherDidCloseButtonPressed:(WidgetDetailView *)popupVC;
{
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
        }];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark TAB BAR DELEGATE FUNCTIONS

- (void) onClickWidgetButtons:(int) idx Point:(CGPoint)pt
{
    m_nSelectedWidget = idx;
    
    for ( UIView * img in [m_vTemp subviews] ) {
        if ( [img isKindOfClass:[UIImageView class]] ) {
            
            switch ( idx ) {
                case 0:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_weather.png"]];
                    break;
                case 1:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_graph.png"]];
                    break;
                case 2:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_energy.png"]];
                    break;
                case 3:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_how.png"]];
                    break;
                case 4:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_iFrame.png"]];
                    break;
                case 5:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_image.png"]];
                    break;
                case 6:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_solar.png"]];
                    break;
                case 7:
                    [(UIImageView*)img  setImage:[UIImage imageNamed:@"btn_text.png"]];
                    break;
                    break;
                default:
                    break;
            }
            
        }
    }
    
    [self.view addSubview: m_vTemp];
    [m_vTemp setCenter: pt];
}

- (void) onMoveWidget:(CGPoint) pt
{
    [m_vTemp setCenter: pt];
}

- (void) onDropWidget:(CGPoint) pt
{
    CGPoint point  =  CGPointMake( pt.x-_vDraw.frame.origin.x, pt.y - _vDraw.frame.origin.y);
    [m_vTemp removeFromSuperview];
    WidgetStartInfo * startInfo = [_vDraw selectWidgetType: m_nSelectedWidget Point:point];
    [self createWidgetInfo: startInfo];
    m_nSelectedWidget = -1;
}

- (void) showWidgetEditView:(int) type mode:(int) nMode
{
    [self presentPopupViewController:_widgetDetailView type:true animated:YES completion:^(void) {
    }];
    [_widgetDetailView switchViews:type];
    [_widgetDetailView setMode: nMode];
}


- (void) onCancelWidget
{
    [m_vTemp removeFromSuperview];
    m_nSelectedWidget = -1;
}

- (void) createPresentation:(NSString*) name id:(NSString*)templateId
{
    [JSWaiter ShowWaiter:self.view title:@"Create Presentation" type:0];
    NSDictionary *dic = @{ @"name" : name,  @"templateId" : templateId };
    
    [[SharedMembers sharedInstance].webManager CreatePresentation: dic  success:^(MKNetworkOperation *networkOperation) {
//        [JSWaiter HideWaiter];
        [self      GetAllPresentation];
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        NSLog( @"fail" );
        [JSWaiter HideWaiter];
    }];
}

- (void) setCurTime:(float) curTime
{
    m_nCurTime  = curTime;
}

- (void) GetPresentation:(NSString*) presentationId
{
    [[SharedMembers sharedInstance].webManager GetPresentation: presentationId success:^(MKNetworkOperation *networkOperation) {
        NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
        PresentationInfo * curPresentation = [SharedMembers sharedInstance].curPresent;
        
        [curPresentation setDictionary:dic];
        curPresentation.des = [dic objectForKey:@"description"];
        [curPresentation.m_widgets removeAllObjects];
        
        [[SharedMembers sharedInstance].webManager GetWidgets:presentationId success:^(MKNetworkOperation *networkOperation) {
            
            NSArray * arr = [networkOperation.responseJSON objectForKey:@"message"];
            for ( NSDictionary * dic in arr ) {
                PWidgetInfo * info = [[PWidgetInfo alloc] init];
                [info setDictionary: dic];
                NSDictionary * paramDic  = [dic objectForKey:@"parameters"];
                [info.param setDictionary: paramDic];
                [self GetParamDic:info param:paramDic];
                ////////////
                
                [self GetWidgetPreviewDatas: curPresentation Widget:info];
                [curPresentation.m_widgets addObject: info];
            }
            
            [self GetPresentationTimeline:presentationId];
            [self GetEditors:presentationId];
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
        
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
}
                
- (void) GetParamDic:(PWidgetInfo*) info param:(NSDictionary*)paramDic
{
    NSDictionary * normal2Font = [paramDic objectForKey:@"normal2Font"];
    if ( normal2Font ) {
        [info.param.normal2Fnt setDictionary:normal2Font];
    }

    NSDictionary * normal1Font = [paramDic objectForKey:@"normal1Font"];
    if ( normal1Font ) {
        [info.param.normal1Fnt setDictionary:normal1Font];
    }

    NSDictionary * subHeaderFont = [paramDic objectForKey:@"subHeaderFont"];
    if( subHeaderFont )
        [info.param.subHeaderFnt setDictionary: subHeaderFont];

    NSDictionary * headerFont  = [paramDic objectForKey:@"headerFont"];
    if ( headerFont ) {
        [info.param.headerFnt setDictionary: headerFont];
    }

    NSDictionary * seventhColor = [paramDic objectForKey:@"seventhColor"];
    if ( seventhColor ) {
        [info.param.seventhClr setDictionary: seventhColor];
    }

    NSDictionary * sixthColor = [paramDic objectForKey:@"sixthColor"];
    if ( sixthColor ) {
        [info.param.sixthClr setDictionary: sixthColor];
    }

    NSDictionary * fifthColor = [paramDic objectForKey:@"fifthColor"];
    if ( fifthColor ) {
        [info.param.fifthClr setDictionary: fifthColor];
    }

    NSDictionary * fourthColor = [paramDic objectForKey:@"fourthColor"];
    if ( fourthColor ) {
        [info.param.fourthClr setDictionary: fourthColor];
    }

    NSDictionary * tertiaryColor  = [paramDic objectForKey:@"tertiaryColor"];
    if ( tertiaryColor ) {
        [info.param.tertiaryClr setDictionary: tertiaryColor];
    }

    NSDictionary * secondaryColor = [paramDic objectForKey:@"secondaryColor"];
    if ( secondaryColor ) {
        [info.param.secondaryClr setDictionary: secondaryColor];
    }

    NSDictionary * primaryColor = [paramDic objectForKey:@"primaryColor"];
    if ( primaryColor ) {
        [info.param.primaryClr setDictionary: primaryColor];
    }
}

- (void) setBgImgPath :(PWidgetInfo* ) widget
{
    NSString * sType  = widget.param.widgetEnergyType;
    if ( [sType isEqualToString:@"Cars Removed"] ) {
        widget.param.backgroundImage = imgEnergyName[0];
    }
    else if ( [sType isEqualToString: @"Waste Recycled"] )
    {
        widget.param.backgroundImage = imgEnergyName[1];
    }
    else  if ( [sType isEqualToString:@"Gallons Gas Saved"])
    {
        widget.param.backgroundImage = imgEnergyName[2];
    }
    else if ( [sType isEqualToString:@"Tanker Gas Saved"] )
    {
        widget.param.backgroundImage = imgEnergyName[3];
    }
    else if ( [sType isEqualToString:@"Energy Homes Generated"])
    {
        widget.param.backgroundImage = imgEnergyName[4];
    }
    else if ( [sType isEqualToString:@"Electricity Homes Generated"])
    {
        widget.param.backgroundImage = imgEnergyName[5];
    }else if ( [sType isEqualToString:@"Coal Elimanated"]){
        widget.param.backgroundImage = imgEnergyName[6];
    }else if ( [sType isEqualToString:@"Oil Unneeded"]){
        widget.param.backgroundImage = imgEnergyName[7];
    }else if ( [sType isEqualToString: @"Propane Cylinders" ]){
        widget.param.backgroundImage = imgEnergyName[8];
    }else if ( [sType isEqualToString: @"Plants Idled"]){
        widget.param.backgroundImage = imgEnergyName[9];
    }else if ( [sType isEqualToString: @"Seedling Grown"]){
        widget.param.backgroundImage = imgEnergyName[10];
    }else if ( [sType isEqualToString:@"Forests Preserved"]){
        widget.param.backgroundImage = imgEnergyName[11];
    }else if ( [sType isEqualToString:@"Forests Conversion Prevented"]){
        widget.param.backgroundImage = imgEnergyName[12];
    }
}

- (void) GetWidgetPreviewDatas:(PresentationInfo*) curPresentation Widget:(PWidgetInfo*) info
{
    NSString * name  = info.name;
    
    if ( [name isEqualToString:@"Graph"] ) {
        
        [[SharedMembers sharedInstance].webManager GetGraphWidget: curPresentation._id Object:info._id success:^(MKNetworkOperation *networkOperation)
         {
             
             NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
             GraphInfo *  graph  = [[GraphInfo alloc] init];
             [graph SetGraphInfoDic: dic];
             info->graph  = graph;
             
             [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: info.param.backgroundImage] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                 if (!image)
                     return;
             }];
            
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
    }
    else if ( [name isEqualToString:@"Weather"])
    {
        [[SharedMembers sharedInstance].webManager GetWeatherWidget: curPresentation._id success:^(MKNetworkOperation *networkOperation) {
            
            NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            WeatherInfo  * weather  = [[WeatherInfo alloc] init];
            NSDictionary * dicCurrent  = [dic objectForKey: @"currently"];
            [weather setDictionary: dicCurrent];
            NSDictionary * dicDaily  = [dic objectForKey: @"daily"];
            NSArray      * datas  = [dicDaily objectForKey:@"data"];
            for ( int i = 0; i < [datas count]; i++ ) {
                NSDictionary * dicData  = [datas objectAtIndex:i];
                WeatherDataInfo * weatherData  = [[WeatherDataInfo alloc] init];
                [weatherData setDictionary: dicData];
                [weather.data addObject: weatherData];
            }
            info->weather  = weather;
        
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
    }
    else if ( [name isEqualToString:@"Energy Equivalencies"]){

        [[SharedMembers sharedInstance].webManager GetEnergyWidget:curPresentation._id Object:info._id success:^(MKNetworkOperation *networkOperation) {
            
        NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            EnergyInfo *  energy  = [[EnergyInfo alloc] init];
            [energy setDictionary: dic];
            info->energy = energy;
            [self setBgImgPath:info];
            if ( info.param.backgroundImage ) {
                if ([info.param.backgroundImage containsString:@"http"]) {
        
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: info.param.backgroundImage] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (!image)
                            return;
                    }];
        
                }
            }else{
            
            }
                
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        }];
    }
    else if ( [name isEqualToString:@"Solar Generation"]){
        [[SharedMembers sharedInstance].webManager GetSolarWidget:curPresentation._id Object:info._id success:^(MKNetworkOperation *networkOperation) {
                
            NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
            SolarInfo * solar = [[SolarInfo alloc] init];
            [solar setDictionary:dic];
            info->solar  = solar;
                
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        }];
    }
    else if ( [name isEqualToString:@"Image"]){
                
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: info.param.widgetURL] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!image)
                return;
        }];
    }
    else if ( [name isEqualToString:@"TextArea"]){
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: info.param.backgroundImage] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!image)
                return;
        }];
    }
}
                
- (void) GetPresentation:(NSString*) presentationId time:(float) curTime
{
    m_nCurTime = curTime;
                
    [[SharedMembers sharedInstance].webManager GetPresentation: presentationId success:^(MKNetworkOperation *networkOperation) {
        NSDictionary * dic  = [networkOperation.responseJSON objectForKey:@"message"];
        PresentationInfo * curPresentation = [SharedMembers sharedInstance].curPresent;
                
        [curPresentation setDictionary:dic];
        curPresentation.des = [dic objectForKey:@"description"];
        [curPresentation.m_widgets removeAllObjects];
                
        [[SharedMembers sharedInstance].webManager GetWidgets:presentationId success:^(MKNetworkOperation *networkOperation) {
                
            NSArray * arr = [networkOperation.responseJSON objectForKey:@"message"];
            for ( NSDictionary * dic in arr ) {
                PWidgetInfo * info = [[PWidgetInfo alloc] init];
                [info setDictionary: dic];
                NSDictionary * paramDic  = [dic objectForKey:@"parameters"];
                [info.param setDictionary: paramDic];
                [self GetParamDic:info param:paramDic];
                ////////////
                
                [self GetWidgetPreviewDatas: curPresentation Widget:info];
                [curPresentation.m_widgets addObject: info];
            }
            
            [self GetPresentationTimeline:presentationId];
            [self GetEditors:presentationId];
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
        
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        
    }];
}

- (void) GetPresentationTimeline:(NSString*) presentationId
{
    [[SharedMembers sharedInstance].webManager GetPresentationTimeline:presentationId success:^(MKNetworkOperation *networkOperation)
     {
         
         NSDictionary * dic  = [[networkOperation.responseJSON objectForKey:@"message"] objectForKey:@"timeline"];
         NSArray * dates = [dic objectForKey:@"date"];
         
         NSMutableArray * temp = [[NSMutableArray alloc] init];
         for ( NSDictionary * data in dates ) {
             TimelineData * info = [[TimelineData alloc] init];
             [info setDictionary: data];
             [temp addObject: info];
         }
         
         PresentationInfo * cur = [SharedMembers sharedInstance].curPresent;
         for ( TimelineData * timeline in temp ) {
             NSString * timelineId = timeline.availableWidgetId;
             for ( PWidgetInfo * widget in cur.m_widgets ) {
                 NSString * widgetId  = widget.availableWidgetId;
                 if ( [timelineId isEqual: widgetId] ) {
                     widget.timeline  = timeline;
                 }
             }
         }
         
         
         [_m_PresentationName setText: cur.name];
         [_vDraw setPresentationInfo: m_nCurTime];
         [_vTab setRefresh];
         
         [JSWaiter HideWaiter];
     } failure:^(MKNetworkOperation *errorOp, NSError *error) {
         NSLog( @"%@", @"failed");
     }];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
*/


//Manage Ctrl
- (IBAction) onPresentDetail:(id)sender
{
    [self presentPopupViewController:_presentationDetailVC  type:true animated:YES completion:^(void) {
        [_presentationDetailVC setInfo];
    }];
}

- (IBAction) onClonePresent:(id)sender
{
    [JSWaiter ShowWaiter:self.view title:@"" type:0];
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    [[SharedMembers sharedInstance].webManager ClonePresentation:info._id success:^(MKNetworkOperation *networkOperation) {
        
        [self GetAllPresentation];
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        [JSWaiter HideWaiter];
    }];
}

- (IBAction) onSharePresent:(id)sender
{
    [self presentPopupViewController:_shareVC type:true animated:YES completion:^(void) {
    }];
}

- (IBAction) onPlayPresentation:(id)sender
{
    bPalyPresentation = !bPalyPresentation;
    
    if( bPalyPresentation )
        [_m_img_play setImage:[UIImage imageNamed:@"btn_stop_presentation.png"] ];
    else
        [_m_img_play setImage:[UIImage imageNamed:@"btn_play_presentation.png"] ];
         
    if ( bPalyPresentation ) {
        [_vDraw onPlayPresent];
        _vTab.userInteractionEnabled = false;
        [_vTab showMask:true];
    }
    else{
        [_vDraw onStopPresent];
        _vTab.userInteractionEnabled = true;
        [_vTab showMask:false];
    }
    
    
}

- (IBAction) onShowFullMode:(id)sender
{
    [_m_btnFullScreen setHidden:false];
}

- (IBAction) onPlayFullScreen:(id)sender
{
    NSArray* nib1 = [[NSBundle mainBundle] loadNibNamed:@"PresentFullScreenView" owner:self options:nil];
    self.presentationFullVC = [nib1 objectAtIndex:0];
    [self.presentationFullVC setFrame:CGRectMake(0, 0, 1024, 768)];
    self.presentationFullVC.layer.zPosition = 500;
    [self.view addSubview:self.presentationFullVC];
    [self.presentationFullVC setPresentationInfo:true];
    
    [_m_btnFullScreen setHidden:true];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    NSArray* nib1 = [[NSBundle mainBundle] loadNibNamed:@"PresentFullScreenView" owner:self options:nil];
    self.presentationFullVC = [nib1 objectAtIndex:0];
    [self.presentationFullVC setFrame:CGRectMake(0, 0, 1024, 768)];
    self.presentationFullVC.layer.zPosition = 500;
    [self.view addSubview:self.presentationFullVC];
    [self.presentationFullVC setPresentationInfo:true];
    [m_ComboFullScreenMode setHidden:true];
    
}

- (void) createWidgetInfo:(WidgetStartInfo*) startInfo
{
    for ( PWidgetInfo * widget in [SharedMembers sharedInstance].arrAvailableWidgets) {
        NSString *name  = widget.name;
        NSString *widgetName  = [self getName: m_nSelectedWidget];
        
        if ( [name isEqualToString:widgetName] ) {
            widget.param.rowPosition = [NSNumber numberWithInt: [startInfo.rowPos intValue]];
            widget.param.colPosition = [NSNumber numberWithInt: [startInfo.colPos intValue]];
            widget.param.startDate = startInfo.startPoint;
            m_nCurTime =  [startInfo.startPoint floatValue];
            widget.param.timelineRowPosition = [NSNumber numberWithInt: [self GetTimelineRowCount: m_nCurTime]];
            [widget setWidgetDictionary:false];
            
            [JSWaiter ShowWaiter:self.view title:@"" type:0];
            [[SharedMembers sharedInstance].webManager CreateWidget:widget->msgDic success:^(MKNetworkOperation *networkOperation) {
                
                PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
                [self GetPresentation: info._id];
                
            } failure:^(MKNetworkOperation *errorOp, NSError *error) {
                
            }];
            
        }
    }
}

// timeline :  Get rowCount  : Param.timelineRowCount
- (int) GetTimelineRowCount:(float) curTime
{
    int nRowCount  = 0;
    
    int startTime  = (curTime/10) * 10;
    int endTime    = startTime + 10;
    
    NSMutableArray * temp  = [[NSMutableArray alloc] init];
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    for ( PWidgetInfo * widget in info.m_widgets ) {
        
        NSString * startPoint  = widget.param.startDate;
        int  timeRowCount  = [widget.param.timelineRowPosition intValue];
        
        NSArray * arr  = [startPoint componentsSeparatedByString:@":"];
        NSString * min;         NSString * sec;
        
        if ( [startPoint isEqualToString:@""] ) {
            min = @"0"; sec = @"0";
        }
        else{
            min = arr[0];
            sec = arr[1];
        }
        int startPos  = min.intValue*60 + sec.intValue;
        
        if ( startPos >= startTime && endTime > startPos ) {
            [temp addObject:[NSNumber numberWithInt: timeRowCount]];
        }
    }
    
    int index = 0;
    BOOL flag  = false;
    
    if ( [temp count] == 0 ) {
        return 0;
    }
    
    while ( true ) {
        int nTotal = 0; flag  = false;
        for ( int i = 0; i < [temp count]; i++ ) {
            NSNumber *number = [temp objectAtIndex:i];
            int n = [number intValue];
            if ( n == index ) {
                flag  = true; index++;
                break;
            }
            nTotal = i;
        }
        
        if ( nTotal == [temp count]-1 && flag == false ) {
            return  index;
        }
    }
    
    
    return nRowCount;
}

-(NSString*) getName:(int) type
{
    NSString * str = @"";
    switch ( m_nSelectedWidget ) {
        case 0:
            str = @"Weather";
            break;
        case 1:
            str = @"Graph";
            break;
        case 2:
            str = @"Energy Equivalencies";
            break;
        case 3:
            str = @"How Does Solar Work";
            break;
        case 4:
            str = @"iFrame";
            break;
        case 5:
            str = @"Image";
            break;
        case 6:
            str = @"Solar Generation";
            break;
        case 7:
            str = @"TextArea";
            break;
    }
    
    return  str;
    
}


- (NSDictionary*) GetPresentationDic:(PresentationInfo*) info
{
    NSDictionary *  dic;
    [info getPresentationDic];
    dic  = info->msgDic;
    
    return  dic;
}

- (NSDictionary *) GetWidgetDic:(PWidgetInfo*) info
{
    NSDictionary * dic;
    
    [info setWidgetDictionary:false];
    dic  = info->msgDic;
    
    return  dic;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_ComboFullScreenMode setHidden:true];
}



@end
