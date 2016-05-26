//
//  CISnapshotVC.m
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import "ChooseAssetView.h"
#import "SharedMembers.h"
#import "AssetsInfo.h"
#import "PresentationInfo.h"
#import "SDWebImageManager.h"

#define BIG_BUTTON_Y        43
#define BIG_BUUTON_HEIGHT   53
#define SMALL_BUTTON_Y      54
#define SMALL_BUTTON_HEIGHT 42

@interface ChooseAssetView ()

@property (weak, nonatomic) IBOutlet UIImageView *snapshotIV;

@end

@implementation ChooseAssetView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _snapshotImage = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_m_scroll setContentSize:CGSizeMake( _m_scroll.frame.size.width, 500.f)];
    [self onPresent:nil];

    arrGeneralAssets = [[NSMutableArray alloc] init];
    arrAccountsAssets= [[NSMutableArray alloc] init];
    arrPresentationAssets = [[NSMutableArray alloc] init];
    
    m_nSelectIdx = 0;
}

- (void) refresh:(int) type
{
    for ( UIView * v in  [_m_scroll subviews] ) {
        if ( [v isKindOfClass:[UIImageView class]] ) {
            [v removeFromSuperview];
        }
    }
    
    _m_selectedAccountId = [SharedMembers sharedInstance].selectedAccountId;
    
    [JSWaiter ShowWaiter:self.view title:@"" type:0];
    m_nType  = type;
    
    [arrGeneralAssets removeAllObjects];
    [arrAccountsAssets removeAllObjects];
    [arrPresentationAssets removeAllObjects];
    
    nResponse = 0;
    int nTotal  = 3;
    
    if ( ![_m_selectedAccountId isEqualToString:@""] && _m_selectedAccountId != nil )
    {
        [[SharedMembers sharedInstance].webManager GetAccountAssets:_m_selectedAccountId keyword:@"*" success:^(MKNetworkOperation *networkOperation) {
            
            NSString * str =  @"Your Assets repository is being created, please wait...";
            if ( [networkOperation.responseString rangeOfString: str].location == NSNotFound ) {
                NSArray* assets = [networkOperation.responseJSON objectForKey:@"message"];
                for(NSDictionary* asset in assets)
                {
                    AssetsInfo * info = [[AssetsInfo alloc] init];
                    [info setDictionary:asset];
                    info._id  = [asset objectForKey:@"id"];
                    [arrAccountsAssets addObject:info];
                }
            }
            
            nResponse ++;
            if ( nResponse == nTotal ) {
                [JSWaiter HideWaiter];
                [self onPresent:nil];
            }
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            nResponse ++;
            if ( nResponse == nTotal ) {
                [JSWaiter HideWaiter];
                [self onPresent:nil];
            }
            
        }];
    }
    else{
        nTotal --;
    }
    
    [[SharedMembers sharedInstance].webManager GetGeneralAssets:@"*" success:^(MKNetworkOperation *networkOperation) {
        NSArray* assets = [networkOperation.responseJSON objectForKey:@"message"];
        for(NSDictionary* asset in assets)
        {
            AssetsInfo * info = [[AssetsInfo alloc] init];
            [info setDictionary: asset];
                    info._id  = [asset objectForKey:@"id"];
            [arrGeneralAssets addObject:info];
        }
    
        nResponse ++;
        
        if ( nResponse == nTotal ) {
            [JSWaiter HideWaiter];
            [self onPresent:nil];
        }
        
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        nResponse ++;
        if ( nResponse == nTotal ) {
            [JSWaiter HideWaiter];
            [self onPresent:nil];
        }

    }];
    
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    
    [[SharedMembers sharedInstance].webManager GetPresentationAssets: info._id keyword:@"*" success:^(MKNetworkOperation *networkOperation)
    {
        NSLog(@"%@", networkOperation.responseJSON);
        
        NSString * str =  @"Your Assets repository is being created, please wait...";
        if ( [networkOperation.responseString rangeOfString: str].location == NSNotFound ) {
            NSArray* assets = [networkOperation.responseJSON objectForKey:@"message"];
            for(NSDictionary* asset in assets)
            {
                AssetsInfo * info = [[AssetsInfo alloc] init];
                [info setDictionary:asset];
                    info._id  = [asset objectForKey:@"id"];
                [arrPresentationAssets addObject:info];
            }
            nResponse ++;
            if ( nResponse == nTotal ) {
                [JSWaiter HideWaiter];
                [self onPresent:nil];
            }

        }
        else{
            nResponse ++;
            if ( nResponse == nTotal ) {
                [JSWaiter HideWaiter];
                [self onPresent:nil];
            }

        }
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        nResponse ++;
        if ( nResponse == nTotal ) {
            [JSWaiter HideWaiter];
            [self onPresent:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    _snapshotIV.image = _snapshotImage;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    _snapshotImage = nil;
    _snapshotIV.image = nil;
}

- (IBAction)closeBtnPressed:(id)sender {
    id<ChooseAssetViewDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(ChooseAssetViewDidCloseButtonPressed:)]) {
        [strongDelegate ChooseAssetViewDidCloseButtonPressed:self];
    }
}

- (IBAction) onPresent:(id)sender
{

    [_m_btnPresent setBackgroundImage:[UIImage imageNamed:@"btn_choose_highlight.png"] forState:UIControlStateNormal];
    
    [_m_btnClient setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];

    [_m_btnGeneral setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];

    m_nSelectIdx = 0;
    [self setAssetsInfo:m_nSelectIdx];
}

- (IBAction) onClient:(id)sender
{

    [_m_btnPresent setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];
    
    [_m_btnClient setBackgroundImage:[UIImage imageNamed:@"btn_choose_highlight.png"] forState:UIControlStateNormal];
    
    [_m_btnGeneral setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];

    m_nSelectIdx = 1;
    [self setAssetsInfo:    m_nSelectIdx ];
}

- (IBAction) onGeneral:(id)sender
{

    [_m_btnPresent setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];
    
    [_m_btnClient setBackgroundImage:[UIImage imageNamed:@"btn_choose_normal.png"] forState:UIControlStateNormal];
    
    [_m_btnGeneral setBackgroundImage:[UIImage imageNamed:@"btn_choose_highlight.png"] forState:UIControlStateNormal];
    
    m_nSelectIdx = 2;
    [self setAssetsInfo:m_nSelectIdx];
}


- (void) setAssetsInfo:(int) type
{
    NSMutableArray * m_arr = [[NSMutableArray alloc] init];
    switch ( type ) {
        case 0:
            for ( int i = 0; i < [arrPresentationAssets count]; i++ ) {
                [m_arr addObject: [arrPresentationAssets objectAtIndex:i]];
            }
            break;
        case 1:
            for ( int i = 0; i < [arrAccountsAssets count]; i++ ) {
                [m_arr addObject: [arrAccountsAssets objectAtIndex:i]];
            }
            break;
        case 2:
            for ( int i = 0; i < [arrGeneralAssets count]; i++ ) {
                [m_arr addObject: [arrGeneralAssets objectAtIndex:i]];
            }
            break;
        default:
            break;
    }
    
    float oriX = 55.f;
    float oriY = 20.f;
    float size = 120.f;
    float step = 6.f;
    
    for ( UIView * v in  [_m_scroll subviews] ) {
//        if ( [v isKindOfClass:[UIImageView class]] ) {
            [v removeFromSuperview];
//        }
    }
    
    if (  ([m_arr count] / 4 + 1) * 130 > 370 )
    {
        [_m_scroll setContentSize:CGSizeMake( _m_scroll.frame.size.width,  ([m_arr count] / 4 + 1) * 130  )];
    }else{
        [_m_scroll setContentSize:CGSizeMake( _m_scroll.frame.size.width,  370)];
    }
    
    for ( int i = 0; i < [m_arr count]; i++ ) {
        AssetsInfo * info = [m_arr objectAtIndex:i];
        int col = i % 4;
        int row = i / 4;
       
        UIView  * containView  = [[UIView alloc] initWithFrame:CGRectMake( oriX + (size + step) * col, oriY + (size + step) * row, size, size)];
        [containView setBackgroundColor:[UIColor clearColor]];
        containView.tag = i;
        
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnThumb:)];
        [containView addGestureRecognizer:gesture];
        
        if (type == PGeneralAssets && [[SharedMembers sharedInstance].userInfo.role isEqualToString:@"BP"])
        {
            UILongPressGestureRecognizer* longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongTap:)];
            [containView addGestureRecognizer:longTapGesture];
        }
        else if(type == PAccountAssets && ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"BP"] ||
                                                 [[SharedMembers sharedInstance].userInfo.role isEqualToString:@"Admin"]))
        {
            UILongPressGestureRecognizer* longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongTap:)];
            [containView addGestureRecognizer:longTapGesture];
        }
        else if ( type == PresentationAssets )
        {
            UILongPressGestureRecognizer* longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongTap:)];
            [containView addGestureRecognizer:longTapGesture];
        }
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, size, size)];
        UIActivityIndicatorView * waiter = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [waiter setHidden:true];
      
        [imgView setBackgroundColor:[UIColor lightGrayColor]];
        
        if ( info->image == nil ) {
            
            waiter.center = containView.center;
            [waiter startAnimating];
            [waiter setHidden:false];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString: info.thumbnailURL] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (!image)
                    return;
                [imgView setImage:image];
                info->image = image;
                    [waiter stopAnimating]; [waiter setHidden: true];
            }];
        }
        else{
            [imgView setImage:info->image];
        }
        
        [containView addSubview: imgView];
        [containView addSubview: waiter];
        
        [_m_scroll addSubview: containView];
        [_m_scroll addSubview: waiter];
    }
    
}

-(void)OnThumb:(UIGestureRecognizer*)gesture
{
    int tag = gesture.view.tag;
    NSString * str  = @"";
    switch ( m_nSelectIdx) {
        case 0:
        {
            AssetsInfo * info = [arrPresentationAssets objectAtIndex:tag];
            str = info.sourceCDNURL;
        }
            break;
        case 1:
        {
            AssetsInfo * info = [arrAccountsAssets objectAtIndex:tag];
            str = info.sourceCDNURL;
        }
            break;
        case 2:
        {
            AssetsInfo * info = [arrGeneralAssets objectAtIndex:tag];
            str = info.sourceCDNURL;
        }
            break;
        default:
            break;
    }
    
    if ( m_nType  == 0 ) // presentationDetail
    {
        PresentationInfo * presentation = [SharedMembers sharedInstance].curPresent;
        presentation.Logo  = str;
    }
    else if ( m_nType == 1 ) // widget detail
    {
        PWidgetInfo * widgt = [SharedMembers sharedInstance].curWidget;
        widgt.param.widgetURL  = str;
    }
    else if( m_nType == 2 ){
        [SharedMembers sharedInstance].imgUrl = str;
    }
    
    id<ChooseAssetViewDelegate> Delegate = self.delegate;
    [Delegate ChooseAssetViewDidCloseButtonPressed:self];
    
}

-(void)OnLongTap:(UIGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed)
        return;
    
    for(UIView* vw in [_m_scroll.subviews copy])
    {
        if ([vw isKindOfClass:[UIButton class]])
        {
            if (vw.tag == gesture.view.tag)
            {
                [vw removeFromSuperview];
                return;
            }
        }
    }
    UIButton* btn_close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn_close setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
    btn_close.tag = gesture.view.tag;
    [btn_close addTarget:self action:@selector(OnRemoveAsset:) forControlEvents:UIControlEventTouchUpInside];
    btn_close.center = CGPointMake(gesture.view.frame.origin.x + gesture.view.frame.size.width -10, gesture.view.frame.origin.y  + 10);
    [_m_scroll addSubview:btn_close];
}


-(void)OnRemoveAsset:(UIButton*)btn
{
    AssetsInfo* asset;
    
    switch ( m_nSelectIdx) {
        case 0:
        {
            asset = [arrPresentationAssets objectAtIndex: btn.tag];
        }
            break;
        case 1:
        {
            asset = [arrAccountsAssets objectAtIndex:btn.tag];
        }
            break;
        case 2:
        {
            asset = [arrGeneralAssets objectAtIndex:btn.tag];
        }
            break;
        default:
            break;
    }
    
    [JSWaiter ShowWaiter:self.view title:@"Removing..." type:0];
    if (m_nSelectIdx == PGeneralAssets)
    {
        [[SharedMembers sharedInstance].webManager DeleteGeneralAsset: asset._id success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            
            [arrGeneralAssets removeObjectAtIndex: btn.tag];
            [self setAssetsInfo: PGeneralAssets];
            
        } failure:nil];
    }
    else if( m_nSelectIdx == PAccountAssets)
    {
        [[SharedMembers sharedInstance].webManager DeleteAccountAsset:asset._id accountId:_m_selectedAccountId success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            
            [arrAccountsAssets removeObjectAtIndex: btn.tag];
            [self setAssetsInfo: PAccountAssets];
            
        } failure:nil];
    }
    else {
        
        PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
        
        [[SharedMembers sharedInstance].webManager DeletePresentationAsset:asset._id presentationId:info._id success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [arrPresentationAssets removeObjectAtIndex: btn.tag];
            [self setAssetsInfo: PresentationAssets];
            
        } failure:nil];
    }
    
}

/*
- (void) onClick:(id) sender
{
    UIButton * btn = (UIButton*) sender;
    int tag = btn.tag;
    NSString * str  = @"";
    switch ( m_nSelectIdx) {
        case 0:
        {
            AssetsInfo * info = [arrPresentationAssets objectAtIndex:tag];
            str = info.sourceCDNURL;
        }
            break;
        case 1:
        {
            AssetsInfo * info = [arrAccountsAssets objectAtIndex:tag];
            str = info.sourceCDNURL;
        }
            break;
        case 2:
        {
            AssetsInfo * info = [arrGeneralAssets objectAtIndex:tag];
            str = info.sourceCDNURL;
        }
            break;
        default:
            break;
    }
    
    if ( m_nType  == 0 ) // presentationDetail
    {
        PresentationInfo * presentation = [SharedMembers sharedInstance].curPresent;
        presentation.Logo  = str;
    }
    else if ( m_nType == 1 ) // widget detail
    {
        PWidgetInfo * widgt = [SharedMembers sharedInstance].curWidget;
        widgt.param.widgetURL  = str;
    }
    else if( m_nType == 2 ){
        [SharedMembers sharedInstance].imgUrl = str;
    }
    
    id<ChooseAssetViewDelegate> Delegate = self.delegate;
    [Delegate ChooseAssetViewDidCloseButtonPressed:self];
    
}
*/
@end
