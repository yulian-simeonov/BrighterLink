//
//  LoginViewController.m
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "LoginViewController.h"
#import "SharedMembers.h"
#import "JSWaiter.h"
#import "WebManager.h"
#import "IQKeyboardManager.h"
#import "OpenIDView.h"
#import "SharedMembers.h"
#import "OAManager.h"

typedef enum : NSUInteger {
    SOCIAL_GOOGLE,
    SOCIAL_FACEBOOK,
    SOCIAL_TWITTER,
    
    SOCIAL_AMAZON,
    SOCIAL_YAHOO,
    SOCIAL_LIVE,
    
    SOCIAL_LINKEDIN,
    SOCIAL_GIT,
    SOCIAL_OPENID,
    
} SOCIAL_TYPE;

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UIView *viewMain;

@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtPwd;

@property (nonatomic, weak) IBOutlet UIButton *btnCheck;
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;

@property (nonatomic, weak) IBOutlet UILabel *lblOR;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SharedMembers sharedInstance].loginViewController = self;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self _initView];
    [vw_forgetPassword setHidden:YES];
    m_bLoginView = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) _initView
{
    self.viewMain.layer.cornerRadius = 5;
    self.viewMain.clipsToBounds = YES;
    
    self.lblOR.layer.cornerRadius = CGRectGetWidth(self.lblOR.frame) / 2;
    self.lblOR.layer.borderColor = [UIColor grayColor].CGColor;
    self.lblOR.layer.borderWidth = 1;
    
    self.btnLogin.layer.cornerRadius = 4;
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self.btnCheck setSelected:[prefs boolForKey:@"rememberMe"]];
    if ([prefs boolForKey:@"rememberMe"])
    {
        [self.txtEmail setText:[prefs objectForKey:@"email"]];
        [self.txtPwd setText:[prefs objectForKey:@"password"]];
    }
}

- (IBAction)onCheck:(id)sender
{
    BOOL checkState = self.btnCheck.isSelected;
    
    [self.btnCheck setSelected:!checkState];
}

- (IBAction)onLogin:(id)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    [self login];
}

-(int)GetAppIndex:(NSString*)appName
{
    if (!appName)
        return 0;
    for(int i = 0; i < 8; i++)
    {
        if ([[SharedMembers sharedInstance]->m_appNames[i] isEqualToString:appName])
            return i;
    }
    return 0;
}

- (IBAction)onForgotPwd:(id)sender
{
    m_bLoginView = !m_bLoginView;
    if (m_bLoginView)
    {
        [lbl_forgetPassword setText:@"Login with your email"];
        [vw_forgetPassword setHidden:YES];
    }
    else
    {
        [lbl_forgetPassword setText:@"Forget Password?"];
        [vw_forgetPassword setHidden:NO];
    }
}

-(IBAction)OnResetPassword:(id)sender
{
    if (txt_email.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please put your email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    [JSWaiter ShowWaiter:self.view title:@"Processing..." type:0];
    [[SharedMembers sharedInstance].webManager ResetPassword:txt_email.text success:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [self onForgotPwd:nil];
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } failure:nil];
}

- (IBAction)onLoginWithSocial:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    NSString* providerKey = @"";
    switch (tag) {
        case SOCIAL_GOOGLE:
            providerKey = @"google";
            break;
            
        case SOCIAL_FACEBOOK:
            providerKey = @"facebook";
            break;
            
        case SOCIAL_YAHOO:
            providerKey = @"yahoo";
            break;
            
        case SOCIAL_LINKEDIN:
            providerKey = @"linkedin";
            break;
            
        case SOCIAL_OPENID:
            providerKey = @"openid";
            break;
            
        case SOCIAL_TWITTER:
            providerKey = @"twitter";
            break;
            
        case SOCIAL_LIVE:
            providerKey = @"windowslive";
            break;
            
        case SOCIAL_AMAZON:
            providerKey = @"amazon";
            break;
            
        case SOCIAL_GIT:
            providerKey = @"github";
            break;
            
        default:
            break;
    }

//    if (tag == SOCIAL_OPENID){
//        [OpenIDView ShowView:[SharedMembers sharedInstance].loginViewController.view];
//        return;
//    }
//    else
        [self initiateLoginWithProvider:providerKey];
}

- (void)initiateLoginWithProvider:(NSString *)provider
{
    OALoginCallbackSuccess successHandler = ^(OAUser *user, BOOL newUser) {
        [JSWaiter ShowWaiter:self.view title:@"Login..." type:0];
        NSLog(@"%@", [[user getDictionary] jsonEncodedKeyValueString]);
        
//        [[SharedMembers sharedInstance].webManager TestSocialAPI:user.userToken nonce:nil success:^(MKNetworkOperation *networkOperation) {
//            NSLog(@"%@", networkOperation.responseJSON);
//        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
//            NSLog(@"%@", error.description);
//        }];
        
//        [[SharedMembers sharedInstance].userInfo SocialLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"connection_token"] nonce:[[NSUserDefaults standardUserDefaults] objectForKey:@"nonce"] success:^(MKNetworkOperation *networkOperation) {
//            [self reqAllDashboards];
//        } failed:nil];
    };
    
    [[OAManager sharedInstance] loginWithProvider:provider
                                          success:successHandler
                                          failure:^(NSError *error) {
                                              [JSWaiter HideWaiter];
                                              [self showErrorAlert:error];
                                          }];
}

- (void)showErrorAlert:(NSError *)error
{
    if (error.code == OA_ERROR_CANCELLED)
    {
        return;
    }
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", @"")
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] show];
}

- (void) gotoMainScreen
{
    if ([SharedMembers sharedInstance].userInfo.defaultApp)
    {
        if ([[SharedMembers sharedInstance].userInfo.defaultApp isEqualToString:@"BrighterView"])
        {
            [self gotoPresentScreen];
            
            return;
        }
    }
    
    [self gotoAnalyzeScreen];
}

- (void) gotoAnalyzeScreen
{
    [self performSegueWithIdentifier:@"analyze" sender:nil];
}

- (void) gotoPresentScreen
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* newViewController = [storyBoard instantiateViewControllerWithIdentifier:@"sb_present"];
    [self.navigationController pushViewController:newViewController animated:NO];
}

#pragma mark -
#pragma mark api request

- (void) login
{
    [JSWaiter ShowWaiter:self.view title:@"Login..." type:0];
    [[SharedMembers sharedInstance].userInfo login:_txtEmail.text password:_txtPwd.text success:^(MKNetworkOperation *operation) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:self.btnCheck.isSelected forKey:@"rememberMe"];
        [prefs setObject:_txtEmail.text forKey:@"email"];
        [prefs setObject:_txtPwd.text forKey:@"password"];
        [prefs synchronize];
        
        [self reqAllDashboards];
        
    } failed:^(MKNetworkOperation *operation, NSError *error) {
    }];
}

- (void) reqAllDashboards
{
    [[SharedMembers sharedInstance].webManager GetAllDashboards:^(MKNetworkOperation *operation)
     {
         NSLog(@"%@", operation.responseJSON);
         
         [JSWaiter HideWaiter];
         
         for(NSDictionary* item in [SharedMembers sharedInstance].userInfo.collections)
         {
             CollectionInfo* collection = [[CollectionInfo alloc] initWithTitle:[item objectForKey:@"text"]];
             [[SharedMembers sharedInstance].aryCollections addObject:collection];
         }
         
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             id dashboards = [operation.responseJSON objectForKey:@"message"];
             NSMutableArray* dashboardsInfo = [[NSMutableArray alloc] init];
             if([dashboards isKindOfClass:[NSDictionary class]])
             {
                 NSArray *keys = [dashboards allKeys];
                 for (NSString *key in keys) {
                     NSMutableArray *subdashboards = [dashboards objectForKey:key];
                     for (NSMutableDictionary *dashboard in subdashboards) {
                         DashboardInfo *dashboardInfo = [[DashboardInfo alloc] initWithDictionary:dashboard];
                         [dashboardsInfo addObject:dashboardInfo];                         
                     }
                 }
             }
             else
             {
                 for (NSMutableDictionary *dashboard in dashboards) {
                     DashboardInfo *dashboardInfo = [[DashboardInfo alloc] initWithDictionary:dashboard];
                     [dashboardsInfo addObject:dashboardInfo];
                 }
             }
             
             [[SharedMembers sharedInstance].aryCollections removeAllObjects];
             for(NSDictionary* item in [SharedMembers sharedInstance].userInfo.collections)
             {
                 CollectionInfo* collection = [[CollectionInfo alloc] initWithTitle:[item objectForKey:@"text"]];
                 [[SharedMembers sharedInstance].aryCollections addObject:collection];
             }
             
             BOOL changedOrder = NO;
             for(NSDictionary* item in [SharedMembers sharedInstance].userInfo.collections)
             {
                 BOOL hasCollectionInServer = NO;
                 for(DashboardInfo* dashboard in dashboardsInfo)
                 {
                     if ([dashboard.collectionName isEqualToString:[item objectForKey:@"text"]])
                     {
                         hasCollectionInServer = YES;
                         break;
                     }
                 }
                 if (!hasCollectionInServer)
                 {
                     changedOrder = YES;
                     for(CollectionInfo* collection in [[SharedMembers sharedInstance].aryCollections copy])
                     {
                         if ([collection.title isEqualToString:[item objectForKey:@"text"]])
                         {
                             [[SharedMembers sharedInstance].aryCollections removeObject:collection];
                         }
                     }
                 }
             }
             
             for(DashboardInfo* dashboard in dashboardsInfo)
             {
                 BOOL hasCollectionInLocal = NO;
                 for(NSDictionary* item in [SharedMembers sharedInstance].userInfo.collections)
                 {
                     if ([dashboard.collectionName isEqualToString:[item objectForKey:@"text"]])
                     {
                         hasCollectionInLocal = YES;
                         break;
                     }
                 }
                 if (!hasCollectionInLocal)
                 {
                     changedOrder = YES;
                     CollectionInfo* collection = [[CollectionInfo alloc] initWithTitle:dashboard.collectionName];
                     [[SharedMembers sharedInstance].aryCollections addObject:collection];
                 }
             }
             
             for(CollectionInfo* collection in [SharedMembers sharedInstance].aryCollections)
             {
                 for(NSDictionary* item in [SharedMembers sharedInstance].userInfo.collections)
                 {
                     if ([collection.title isEqualToString:[item objectForKey:@"text"]])
                     {
                         for(NSString* dashboardId in [item objectForKey:@"dashboards"])
                         {
                             BOOL hasDashboardInLocal = NO;
                             for(DashboardInfo* dashboard in [dashboardsInfo copy])
                             {
                                 if ([dashboard._id isEqualToString:dashboardId])
                                 {
                                     hasDashboardInLocal = YES;
                                     [[SharedMembers sharedInstance] addNewDashboard:dashboard select:NO];
                                     [dashboardsInfo removeObject:dashboard];
                                     break;
                                 }
                             }
                             if (!hasDashboardInLocal)
                                 changedOrder = YES;
                         }
                     }
                 }
                 
                 for(DashboardInfo* dashboard in [dashboardsInfo copy])
                 {
                     if ([dashboard.collectionName isEqualToString:collection.title])
                     {
                         [[SharedMembers sharedInstance] addNewDashboard:dashboard select:NO];
                         [dashboardsInfo removeObject:dashboard];
                         changedOrder = YES;
                     }
                 }
             }
             
             if (changedOrder)
             {
                 NSMutableArray* collections = [[NSMutableArray alloc] init];
                 for(CollectionInfo* collection in [SharedMembers sharedInstance].aryCollections)
                 {
                     if (collection.aryDashboards.count > 0)
                     {
                         NSMutableArray* dashboards = [[NSMutableArray alloc] init];
                         for(DashboardInfo* dashboard in collection.aryDashboards)
                             [dashboards addObject:dashboard._id];
                         [collections addObject:@{@"dashboards" : dashboards, @"text" : collection.title}];
                     }
                 }
                 [SharedMembers sharedInstance].userInfo.collections = collections;
                 [[SharedMembers sharedInstance].userInfo UpdateUserInfo:^(MKNetworkOperation *networkOperation) {
                        [self gotoMainScreen];
                 } failed:nil];
             }
             else
                 [self gotoMainScreen];
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Failed to get dashboard datas. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [alertView show];
             alertView = nil;
         }
         
     } failure:nil];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.txtEmail == textField)
    {
        [self.txtPwd becomeFirstResponder];
    }
    else if(self.txtPwd == textField)
    {
        [self.txtPwd resignFirstResponder];
    }
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}
@end
