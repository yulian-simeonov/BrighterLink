//
//  MoreAssetsView.m
//  BrighterLink
//
//  Created by mobile on 11/23/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "MoreAssetsView.h"
#import "SharedMembers.h"
#import "SDWebImageManager.h"
#import "ViewAssetsView.h"

#define ThumbImgWidth 170

@implementation MoreAssetsView

+(MoreAssetsView*)ShowView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"MoreAssetsView" owner:self options:nil];
    MoreAssetsView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    vw.layer.zPosition = 20;
    [[SharedMembers sharedInstance].currentViewController.view addSubview:vw];
    return vw;
}

-(void)Initialize
{
    img_header.layer.cornerRadius = 8;
    m_filteredAssets = [[NSMutableArray alloc] init];
    [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, -768, vw_content.frame.size.width, vw_content.frame.size.height)];
    [UIView animateWithDuration:0.3f animations:^{
        [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, 0, vw_content.frame.size.width, vw_content.frame.size.height)];
    }];
    
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    [img_header addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouch:)];
    [self addGestureRecognizer:gesture];
}

-(IBAction)OnBack:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, -768, vw_content.frame.size.width, vw_content.frame.size.height)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)OnTouch:(UIGestureRecognizer*)gesture
{
    [self OnBack:nil];
}

-(void)Update:(NSMutableArray*)array assetType:(AssetsType)assetType accountId:(NSString*)accountId
{
    m_assets = array;
    m_assetType = assetType;
    if (m_assetType == GeneralAssets)
        [lbl_title setText:@"General Assets"];
    else
        [lbl_title setText:@"Account Assets"];
    m_selectedAccountId = accountId;
    for(NSDictionary* asset in m_assets)
    {
        [m_filteredAssets addObject:asset];
    }
    [self RefreshContentView];
}

-(void)RefreshContentView
{
    for(UIView* vw in vw_assets.subviews)
        [vw removeFromSuperview];
    for(int i = 0; i < 3; i++)
        m_lastPositions[i] = 0;
    [[SDWebImageManager sharedManager] cancelAll];
    for(int i = 0; i < m_filteredAssets.count; i++)
    {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[[m_filteredAssets objectAtIndex:i] objectForKey:@"thumbnailURL"]] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!image)
                return;
            float ratio = image.size.height / image.size.width;
            float thumbHeight = ThumbImgWidth * ratio;
            int idx = [self GetBestIndex];
            UIView* vwFrame = [[UIView alloc] initWithFrame:CGRectMake(15 + idx * (ThumbImgWidth + 30), m_lastPositions[idx] + 20, ThumbImgWidth, thumbHeight)];
            vwFrame.layer.cornerRadius = 4;
            vwFrame.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1].CGColor;
            vwFrame.layer.borderWidth = 1;
            vwFrame.tag = i;
            [vwFrame setBackgroundColor:[UIColor whiteColor]];
            
            UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnThumb:)];
            [vwFrame addGestureRecognizer:gesture];
            UILongPressGestureRecognizer* longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongTap:)];
            [vwFrame addGestureRecognizer:longTapGesture];
            
            UIImageView* imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ThumbImgWidth - 10, thumbHeight - 10)];
            [imgVw setImage:image];
            [vwFrame addSubview:imgVw];
            
            UIImageView* banner = [[UIImageView alloc] initWithFrame:CGRectMake(0, vwFrame.frame.size.height - 30, vwFrame.frame.size.width, 30)];
            [banner setAlpha:0.7f];
            [banner setBackgroundColor:[UIColor whiteColor]];
            [vwFrame addSubview:banner];
            
            UILabel* lbl_name = [[UILabel alloc] init];
            [lbl_name setText:[[m_filteredAssets objectAtIndex:i] objectForKey:@"title"]];
            [lbl_name setFont:[UIFont systemFontOfSize:12]];
            [lbl_name setTextColor:[UIColor blackColor]];
            CGSize size = [lbl_name sizeThatFits:CGSizeMake(vwFrame.frame.size.width - 10, 20)];
            if (size.width > vwFrame.frame.size.width - 10)
                size.width = vwFrame.frame.size.width - 10;
            [lbl_name setFrame:CGRectMake(vwFrame.frame.size.width - size.width - 5, vwFrame.frame.size.height - 22, size.width, size.height)];
            [vwFrame addSubview:lbl_name];
            
            m_lastPositions[idx] = m_lastPositions[idx] + thumbHeight + 30;
            [vw_assets addSubview:vwFrame];
            [vw_assets setContentSize:CGSizeMake(vw_assets.frame.size.width, [self GetLastHPosition] + 20)];
        }];
    }
}

-(void)OnThumb:(UIGestureRecognizer*)gesture
{
    NSDictionary* asset = [m_filteredAssets objectAtIndex:gesture.view.tag];
    ViewAssetsView* vw = [ViewAssetsView ShowView];
    [vw SetImageInfo:asset];
}

-(void)OnLongTap:(UIGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed)
        return;
    for(UIView* vw in [vw_assets.subviews copy])
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
    UIButton* btn_close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_close setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    btn_close.tag = gesture.view.tag;
    [btn_close addTarget:self action:@selector(OnRemoveAsset:) forControlEvents:UIControlEventTouchUpInside];
    btn_close.center = CGPointMake(gesture.view.frame.origin.x + gesture.view.frame.size.width - 5, gesture.view.frame.origin.y + 5);
    [vw_assets addSubview:btn_close];
}

-(void)OnRemoveAsset:(UIButton*)btn
{
    NSDictionary* asset = [m_filteredAssets objectAtIndex:btn.tag];
    [JSWaiter ShowWaiter:vw_assets title:@"Removing..." type:0];
    if (m_assetType == GeneralAssets)
    {
        [[SharedMembers sharedInstance].webManager DeleteGeneralAsset:[asset objectForKey:@"id"] success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [m_assets removeObject:asset];
            [m_filteredAssets removeObject:asset];
            [self RefreshContentView];
            [_delegate RefreshContentView];
        } failure:nil];
    }
    else
    {
        [[SharedMembers sharedInstance].webManager DeleteAccountAsset:[asset objectForKey:@"id"] accountId:m_selectedAccountId success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [m_assets removeObject:asset];
            [m_filteredAssets removeObject:asset];
            [self RefreshContentView];
            [_delegate RefreshContentView];
        } failure:nil];
    }
}

-(int)GetBestIndex
{
    float min = 99999999;
    int idx = 0;
    for(int i = 0; i < 3; i++)
    {
        if (m_lastPositions[i] < min)
        {
            min = m_lastPositions[i];
            idx = i;
        }
    }
    return idx;
}

-(float)GetLastHPosition
{
    float max = 0;
    for(int i = 0; i < 3; i++)
    {
        if (m_lastPositions[i] > max)
            max = m_lastPositions[i];
    }
    return max;
}

-(IBAction)OnTextChanged:(UITextField*)sender
{
    [m_filteredAssets removeAllObjects];
    if (sender.text.length > 0)
    {
        for(NSDictionary* asset in m_assets)
        {
            if ([[asset objectForKey:@"title"] rangeOfString:sender.text].location != NSNotFound)
            {
                [m_filteredAssets addObject:asset];
            }
        }
    }
    else
    {
        for(NSDictionary* asset in m_assets)
            [m_filteredAssets addObject:asset];
    }
    [self RefreshContentView];
}
@end
