//
//  AssetsView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AssetsView.h"
#import "SharedMembers.h"
#import "Account.h"
#import "SDWebImageManager.h"
#import "MoreAssetsView.h"
#import "ViewAssetsView.h"

#define ThumbImgWidth 75
@implementation AssetsView

+(AssetsView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AssetsView" owner:self options:nil];
    AssetsView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    m_filteredAssets = [[NSMutableArray alloc] init];
    m_assets = [[NSMutableArray alloc] init];
    
    m_selectedAccountId = nil;
    
    m_assetType = GeneralAssets;
    btn_generalAssets.layer.borderWidth = 1;
    btn_generalAssets.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    
    btn_accountAssets.layer.borderWidth = 1;
    btn_accountAssets.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    
    btn_upload.layer.borderWidth = 1;
    btn_upload.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    
    btn_moreAssets.layer.borderWidth = 1;
    btn_moreAssets.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
    
    img_searchBar.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1].CGColor;
    img_searchBar.layer.borderWidth = 1;
    img_searchBar.layer.cornerRadius = 4;
    
    cmb_account = [[JSCombo alloc] initWithFrame:CGRectMake(txt_account.frame.origin.x, txt_account.frame.origin.y, txt_account.frame.size.width, 100)];
    [cmb_account setDelegate:self];
    NSMutableArray* accounts = [[NSMutableArray alloc] init];
    for(Account* acnt in [SharedMembers sharedInstance].Accounts)
    {
        NSString * sfdc = @"";
        if ( acnt.sfdcAccountId != nil ) {
            sfdc = acnt.sfdcAccountId;
        }        
        [accounts addObject:@{@"id" : acnt._id, @"text" : acnt.name, @"sfdcAccountId" : sfdc}];
    }
    [cmb_account UpdateData:accounts];
    if (accounts.count > 0)
        [cmb_account setSelectedItem:[accounts objectAtIndex:0]];
    [self addSubview:cmb_account];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouch)];
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
    
    [self UpdateContentView];
}

-(void)OnTouch
{
    [cmb_account setHidden:YES];
}

-(void)UpdateContentView
{
    for(UIView* vw in vw_assets.subviews)
        [vw removeFromSuperview];
    for(int i = 0; i < 4; i++)
        m_lastPositions[i] = 0;
    [vw_assets setFrame:CGRectMake(vw_assets.frame.origin.x, vw_assets.frame.origin.y, vw_assets.frame.size.width, 1)];
    if (m_assetType == GeneralAssets)
    {
        if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"BP"])
            [btn_upload setHidden:NO];
        else
            [btn_upload setHidden:YES];
        btn_generalAssets.layer.borderWidth = 0;
        [btn_generalAssets setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        btn_accountAssets.layer.borderWidth = 1;
        [btn_accountAssets setBackgroundColor:[UIColor clearColor]];
        
        [lbl_account setHidden:YES];
        [txt_account setHidden:YES];
        [btn_account setHidden:YES];
        
        [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, txt_account.center.y, vw_content.frame.size.width, vw_content.frame.size.height)];
        
        [[SharedMembers sharedInstance].webManager GetGeneralAssets:@"*" success:^(MKNetworkOperation *networkOperation) {
            [m_filteredAssets removeAllObjects];
            [m_assets removeAllObjects];
            NSArray* assets = [networkOperation.responseJSON objectForKey:@"message"];
            for(NSDictionary* asset in assets)
            {
                [m_filteredAssets addObject:asset];
                [m_assets addObject:asset];
            }
            [self RefreshContentView];
        } failure:nil];
    }
    else
    {
        if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"BP"] ||
            [[SharedMembers sharedInstance].userInfo.role isEqualToString:@"Admin"])
            [btn_upload setHidden:NO];
        else
            [btn_upload setHidden:YES];
        btn_accountAssets.layer.borderWidth = 0;
        [btn_accountAssets setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

        btn_generalAssets.layer.borderWidth = 1;
        [btn_generalAssets setBackgroundColor:[UIColor clearColor]];

        [lbl_account setHidden:NO];
        [txt_account setHidden:NO];
        [btn_account setHidden:NO];

        [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, txt_account.center.y + 30, vw_content.frame.size.width, vw_content.frame.size.height)];

        [[SharedMembers sharedInstance].webManager GetAccountAssets:m_selectedAccountId keyword:@"*" success:^(MKNetworkOperation *networkOperation) {
            [m_filteredAssets removeAllObjects];
            [m_assets removeAllObjects];
            NSArray* assets = [networkOperation.responseJSON objectForKey:@"message"];
            for(NSDictionary* asset in assets)
            {
                [m_filteredAssets addObject:asset];
                [m_assets addObject:asset];
            }
            [self RefreshContentView];
        } failure:nil];
    }
    [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, vw_content.frame.origin.y, vw_content.frame.size.width, vw_assets.frame.origin.y + vw_assets.frame.size.height + 50)];
}

-(void)RefreshContentView
{
    for(UIView* vw in vw_assets.subviews)
        [vw removeFromSuperview];
    for(int i = 0; i < 4; i++)
        m_lastPositions[i] = 0;
    [[SDWebImageManager sharedManager] cancelAll];
    for(int i = 0; i < 8; i++)
    {
        if (m_filteredAssets.count <= i)
            return;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[[m_filteredAssets objectAtIndex:i] objectForKey:@"thumbnailURL"]] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!image)
                return;
            float ratio = image.size.height / image.size.width;
            float thumbHeight = ThumbImgWidth * ratio;
            int idx = [self GetBestIndex];
            UIView* vwFrame = [[UIView alloc] initWithFrame:CGRectMake(10 + idx * (ThumbImgWidth + 20), m_lastPositions[idx] + 20, ThumbImgWidth, thumbHeight)];
            vwFrame.layer.cornerRadius = 2;
            vwFrame.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1].CGColor;
            vwFrame.layer.borderWidth = 1;
            vwFrame.tag = i;
            UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnThumb:)];
            [vwFrame addGestureRecognizer:gesture];
            if (m_assetType == GeneralAssets && [[SharedMembers sharedInstance].userInfo.role isEqualToString:@"BP"])
            {
                UILongPressGestureRecognizer* longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongTap:)];
                [vwFrame addGestureRecognizer:longTapGesture];
            }
            else if(m_assetType == AccountAssets && ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"BP"] ||
                                                     [[SharedMembers sharedInstance].userInfo.role isEqualToString:@"Admin"]))
            {
                UILongPressGestureRecognizer* longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongTap:)];
                [vwFrame addGestureRecognizer:longTapGesture];
            }
            
            UIImageView* imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, ThumbImgWidth - 8, thumbHeight - 8)];
            [imgVw setImage:image];
            [vwFrame addSubview:imgVw];
            
            
            m_lastPositions[idx] = m_lastPositions[idx] + thumbHeight + 20;
            [vw_assets addSubview:vwFrame];
            if ([self GetLastHPosition] < 280)
                [vw_assets setFrame:CGRectMake(vw_assets.frame.origin.x, vw_assets.frame.origin.y, vw_assets.frame.size.width, [self GetLastHPosition])];
            else
                [vw_assets setFrame:CGRectMake(vw_assets.frame.origin.x, vw_assets.frame.origin.y, vw_assets.frame.size.width, 280)];
            [vw_assets setContentSize:CGSizeMake(vw_assets.frame.size.width, [self GetLastHPosition] + 20)];
            [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, vw_content.frame.origin.y, vw_content.frame.size.width, vw_assets.frame.origin.y + vw_assets.frame.size.height + 50)];
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
    UIButton* btn_close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
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
        } failure:nil];
    }
    else
    {
        [[SharedMembers sharedInstance].webManager DeleteAccountAsset:[asset objectForKey:@"id"] accountId:m_selectedAccountId success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [m_assets removeObject:asset];
            [m_filteredAssets removeObject:asset];
            [self RefreshContentView];
        } failure:nil];
    }
}

-(int)GetBestIndex
{
    float min = 99999999;
    int idx = 0;
    for(int i = 0; i < 4; i++)
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
    for(int i = 0; i < 4; i++)
    {
        if (m_lastPositions[i] > max)
            max = m_lastPositions[i];
    }
    return max;
}

-(IBAction)OnGeneralAssets:(id)sender
{
    m_assetType = GeneralAssets;
    [self UpdateContentView];
}

-(IBAction)OnAccountAssets:(id)sender
{
    m_assetType = AccountAssets;
    [self UpdateContentView];
}

-(IBAction)OnUploadAsset:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Option" message:@"Please select the option" delegate:self cancelButtonTitle:@"Gallery" otherButtonTitles:@"Camera", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIPopoverController* popoverController=[[UIPopoverController alloc] initWithContentViewController:picker];
        [popoverController presentPopoverFromRect:CGRectMake(512, 384, 1, 1) inView:[SharedMembers sharedInstance].currentViewController.view permittedArrowDirections:0 animated:YES];
    }
    else
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[SharedMembers sharedInstance].currentViewController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"])
    {
        //        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        //        NSString *imageName = [imagePath lastPathComponent];
        //        NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", [SharedMembers GetSavePath:@"upload"], imageName];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.jpg", [SharedMembers GetSavePath:@"upload"], [[NSUUID UUID] UUIDString]];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        UIImage* image = [SharedMembers fixOrientation:(UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
        [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
        NSDictionary *attributesDict=[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
        int fileSize = (int)[attributesDict fileSize];
        if (fileSize > 3 * 1024 * 1024)
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"File size should be less than 3MB." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        [lbl_message setText:@"Uploading..."];
        [SharedMembers ShowGlobalWaiter:@"Uploading..." type:2];
        if (m_assetType == GeneralAssets)
        {
            [[SharedMembers sharedInstance].webManager UploadGeneralAsset:filePath success:^(MKNetworkOperation *networkOperation) {
                [JSWaiter HideWaiter];
                [self UpdateContentView];
                [lbl_message setText:@"File was uploaded successfully."];
            } failure:^(MKNetworkOperation* networkOperation, NSError* error){
                [JSWaiter HideWaiter];
                [lbl_message setText:@"File uploading was failed."];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Uploading was failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } uploadProgress:^(double progress) {
                if (progress == 1)
                {
                    [JSWaiter HideWaiter];
                    [SharedMembers ShowGlobalWaiter:@"Processing..." type:0];
                }
                else
                    [JSWaiter SetProgress:progress];
            }];
        }
        else
        {
            [[SharedMembers sharedInstance].webManager UploadAccountAsset:m_selectedAccountId FilePath:filePath success:^(MKNetworkOperation *networkOperation) {
                [JSWaiter HideWaiter];
                [self UpdateContentView];
                [lbl_message setText:@"File was uploaded successfully."];
            } failure:^(MKNetworkOperation* networkOperation, NSError* error){
                [JSWaiter HideWaiter];
                [lbl_message setText:@"File uploading was failed."];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Uploading was failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } uploadProgress:^(double progress) {
                if (progress == 1)
                {
                    [JSWaiter HideWaiter];
                    [SharedMembers ShowGlobalWaiter:@"Processing..." type:0];
                }
                else
                    [JSWaiter SetProgress:progress];
            }];
        }
    }
}

-(IBAction)OnMoreAssets:(id)sender
{
    //    MoreAssetsView* vw = [MoreAssetsView ShowView];
    //    [vw setDelegate:self];
    //    [vw Update:m_assets assetType:m_assetType accountId:m_selectedAccountId];
}

-(IBAction)OnAccounts:(id)sender
{
    [cmb_account setHidden:NO];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    m_selectedAccountId = [obj objectForKey:@"id"];
    [txt_account setText:[obj objectForKey:@"text"]];
    [self UpdateContentView];
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
