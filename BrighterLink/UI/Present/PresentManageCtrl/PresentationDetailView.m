//
//  CISnapshotVC.m
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import "PresentationDetailView.h"
#import "UIViewController+CWPopup.h"
#import "PresentationInfo.h"
#import "SharedMembers.h"
#import "PresentationInfo.h"
#import "Account.h"

@interface PresentationDetailView ()<ChooseAssetViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *snapshotIV;

@end

@implementation PresentationDetailView

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
    bTemplate = false;
    bTitle = false;
    bSystemSize = false;
    bLastUpdated = false;
    
    m_nAssetType = 0; m_selectAssetId = @"";
    
    arrAdmin = [[NSMutableArray alloc] init];
    
    
    //temp code
    [arrAdmin addObject:@"Parkway School District"];
    [_m_picker setHidden:true];
    
    m_nSystemSize = 0;
    m_nReimbursement = 0;

    _assetVC = [[ChooseAssetView alloc] initWithNibName:@"ChooseAssetView" bundle:nil];
    [_assetVC setDelegate:self];
    
    _m_btn_cancel.layer.cornerRadius = 5.0f;
    _m_btn_save.layer.cornerRadius = 5.0f;
    
    _m_btn_choose_general.layer.cornerRadius  = 5.0f;
    _m_btn_choose_client.layer.cornerRadius  = 5.0f;
    _m_btn_choose_presentation.layer.cornerRadius = 5.0f;

    if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"BP"])
    {
        [_m_btn_choose_general setHidden:false];
        [_m_btn_choose_client setHidden:false];
        [_m_btn_choose_presentation setHidden:false];
        
        [_m_l_general_assets setHidden: false];
        [_m_l_client_assets setHidden: false];
        [_m_l_presentation_assets setHidden:false];
        
    }
    else if( [[SharedMembers sharedInstance].userInfo.role isEqualToString:@"Admin"])
    {
        [_m_btn_choose_general setHidden:true];
        [_m_btn_choose_client setHidden:false];
        [_m_btn_choose_presentation setHidden:false];

        [_m_l_general_assets setHidden: true];
        [_m_l_client_assets setHidden: false];
        [_m_l_presentation_assets setHidden:false];

    }
    else if ( [[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"] )
    {
        [_m_btn_choose_general setHidden:true];
        [_m_btn_choose_client setHidden:true];
        [_m_btn_choose_presentation setHidden:false];

        [_m_l_general_assets setHidden: true];
        [_m_l_client_assets setHidden: true];
        [_m_l_presentation_assets setHidden:false];
    
    }
    
    m_ComboAccounts = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_choose_account_bg.frame.origin.x, _m_img_choose_account_bg.frame.origin.y  + _m_img_choose_account_bg.frame.size.height, _m_img_choose_account_bg.frame.size.width, 100)];
    [m_ComboAccounts setDelegate:self];

    NSMutableArray* accounts = [[NSMutableArray alloc] init];
    for(Account* acnt in [SharedMembers sharedInstance].Accounts)
    {
        NSString * sfdc = @"";
        if ( acnt.sfdcAccountId != nil ) {
            sfdc = acnt.sfdcAccountId;
        }
        [accounts addObject:@{@"id" : acnt._id, @"text" : acnt.name, @"sfdcAccountId" : sfdc}];
    }
    [m_ComboAccounts UpdateData:accounts];
    
    [self.view addSubview: m_ComboAccounts];
    
    _m_txt_Name.tag = 1;   [_m_txt_Name setDelegate:self];
    _m_txt_Logo.tag = 2;   [_m_txt_Logo setDelegate:self];
    _m_txt_SystemSize.tag = 3;  [_m_txt_SystemSize setDelegate:self];
    _m_txt_Reimbursement.tag = 4; [_m_txt_Reimbursement setDelegate:self];
    _m_txt_ChooseAdmin.tag = 5; [_m_txt_ChooseAdmin setDelegate:self];
    
    [_m_txt_Description setDelegate:self];
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


- (void) setInfo{
    
    PresentationInfo *info  = [SharedMembers sharedInstance].curPresent;
    
    [_m_txt_Name setText: info.name];
    if ( ![info.des isKindOfClass:[NSNull class]] ) {
        [_m_txt_Description setText: info.des];
    }
    else{
        [_m_txt_Description setText:@""];
    }
    [_m_txt_Logo setText: info.Logo];
    
    
    float size = [info.systemSize floatValue];
    [_m_txt_SystemSize setText: [NSString stringWithFormat:@"%f", size]];
    size  = [info.reimbursementRate floatValue];
    [_m_txt_Reimbursement setText: [NSString stringWithFormat:@"%f", size]];
    
    BOOL bflag  = [info.isTemplate boolValue];
    
    bTemplate  = bflag;
    (bflag==true)? [_m_btn_template setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [_m_btn_template setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
    
    bflag = [info.titleView boolValue];
    bTitle = bflag;
    (bflag==true)? [_m_btn_title setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [_m_btn_title setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
    
    bflag = [info.systemSizeView boolValue];
    bSystemSize = bflag;
    (bflag==true)? [_m_btn_systemSize setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [_m_btn_systemSize setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
    
    bflag = [info.generatingSinceView boolValue];
    bGenerating = bflag;
    (bflag==true)? [_m_btn_generatingSince setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [_m_btn_generatingSince setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
    
    bflag = [info.lastUpdatedView boolValue];
    bLastUpdated = bflag;
    (bflag==true)? [_m_btn_lastUpdated setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [_m_btn_lastUpdated setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    [SharedMembers sharedInstance].selectedAccountId =  m_selectAssetId =   _assetVC.m_selectedAccountId = [obj objectForKey:@"id"];
    [_m_txt_ChooseAdmin setText:[obj objectForKey:@"text"]];
}

- (IBAction)closeBtnPressed:(id)sender {
    id<CISnapshotVCDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(CISnapshotVCDidCloseButtonPressed:)]) {
        [strongDelegate CISnapshotVCDidCloseButtonPressed:self];
    }
}

- (void)ChooseAssetViewDidCloseButtonPressed:(ChooseAssetView*)popupVC
{
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            PresentationInfo * info = [SharedMembers sharedInstance].curPresent;

            _m_txt_Logo.text = info.Logo;
            info.name = _m_txt_Name.text;
            
//            info.des = _m_txt_Description.text;
//            NSInteger systemSize =  [_m_txt_SystemSize.text integerValue];
//            info.systemSize = [NSNumber numberWithInt: systemSize ];
//            NSInteger reimbursement = [_m_txt_Reimbursement.text integerValue];
//            info.reimbursementRate = [NSNumber numberWithInt: reimbursement];
//            info.isTemplate = [NSNumber numberWithBool: bTemplate];
//            info.titleView  = [NSNumber numberWithBool: bTitle];
//            info.systemSizeView = [NSNumber numberWithBool: bSystemSize];
//            info.generatingSinceView = [NSNumber numberWithBool: bGenerating];
//            info.lastUpdatedView = [NSNumber numberWithBool:bLastUpdated];
        }];
    }
}

-(IBAction) onLogo:(id)sender
{    
    if( [_m_txt_ChooseAdmin isEqual:@""] )
        _assetVC.m_selectedAccountId = @"";
    
    [_assetVC refresh: 0];
    [self presentPopupViewController:_assetVC type:false animated:YES completion:nil];
}

-(IBAction) onTemplete:(id)sender
{
    bTemplate = !bTemplate;
    UIButton * btn  = (UIButton*) sender;
    
    (bTemplate==true)? [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    info.isTemplate = [NSNumber numberWithBool: bTemplate];
}

-(IBAction) onTitle:(id)sender
{
    bTitle = !bTitle;
    UIButton * btn  = (UIButton*) sender;
    
    (bTitle==true)? [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    info.titleView = [NSNumber numberWithBool: bTitle];
}

-(IBAction) onSystemSize:(id)sender
{
    bSystemSize = !bSystemSize;
    UIButton * btn  = (UIButton*) sender;
    
    (bSystemSize==true)? [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
    
    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
    info.systemSize = [NSNumber numberWithBool: bSystemSize];
}

-(IBAction) onGeneratingSince:(id)sender
{
    bGenerating = !bGenerating;
    UIButton * btn  = (UIButton*) sender;
    
    (bGenerating==true)? [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
 
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    info.generatingSinceView = [NSNumber numberWithBool: bGenerating];
}

-(IBAction) onLastUpdated:(id)sender
{
    bLastUpdated = !bLastUpdated;
    UIButton * btn  = (UIButton*) sender;
    
    (bLastUpdated==true)? [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal] :
    [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal] ;
 
    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
    info.lastUpdatedView = [NSNumber numberWithBool: bLastUpdated];
}

-(IBAction) onChooseGeneralFile:(id)sender
{
    m_nAssetType = 0;
        [[[UIAlertView alloc] initWithTitle:@"Choose File" message:@"" delegate:self cancelButtonTitle:@"Take a Photo" otherButtonTitles:@"Photo Gallery", nil] show];
}

-(IBAction) onChooseClientFile:(id)sender
{
    m_nAssetType = 1;
        [[[UIAlertView alloc] initWithTitle:@"Choose File" message:@"" delegate:self cancelButtonTitle:@"Take a Photo" otherButtonTitles:@"Photo Gallery", nil] show];
}

-(IBAction) onChoosePresentationFile:(id)sender
{
    m_nAssetType = 2;
        [[[UIAlertView alloc] initWithTitle:@"Choose File" message:@"" delegate:self cancelButtonTitle:@"Take a Photo" otherButtonTitles:@"Photo Gallery", nil] show];
}

-(IBAction) onChooseAdmin:(id)sender
{
    [m_ComboAccounts setHidden:false];
}

- (IBAction) onUpSystemSize:(id)sender
{
    NSString * str  = _m_txt_SystemSize.text;
    float val  = str.floatValue;
    val += 1.0f;
    [_m_txt_SystemSize setText:[NSString stringWithFormat:@"%f", val]];
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    info.systemSize = [NSNumber numberWithDouble: val];
}

- (IBAction) onDownSystemSize:(id)sender
{
    NSString * str  = _m_txt_SystemSize.text;
    float val  = str.floatValue;
    val -= 1.0f;
    if ( val < 0 ) {
        val = 0;
    }
    [_m_txt_SystemSize setText:[NSString stringWithFormat:@"%f", val]];
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    info.systemSize = [NSNumber numberWithDouble: val];
}

- (IBAction) onUpReimbursement:(id)sender
{
    NSString * str  = _m_txt_Reimbursement.text;
    float val = str.floatValue;
    val += 1.0f;
    [_m_txt_Reimbursement setText:[NSString stringWithFormat:@"%f", val]];
    
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    info.reimbursementRate = [NSNumber numberWithDouble: val];
}

- (IBAction) onDownReimbursement:(id)sender
{
    NSString * str  = _m_txt_Reimbursement.text;
    float val = str.floatValue;
    val -= 1.0f;
    if ( val < 0) {
        val  = 0;
    }
    [_m_txt_Reimbursement setText:[NSString stringWithFormat:@"%f", val]];
    
    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
    info.reimbursementRate = [NSNumber numberWithDouble:val];
}


#pragma MARK PICKER VIEW

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  [arrAdmin count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return  [arrAdmin objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_m_txt_ChooseAdmin setText: [arrAdmin objectAtIndex:row]];
    
    [pickerView setHidden:true];
}


#pragma mark ImagePicker

- (NSString*) getSavedThumbPhotoPath:(UIImage*)image nIDX:(int) nPos
{
    NSString* path = nil;
    
    NSString* file_name = [NSString stringWithFormat:@"%d.png", nPos];
    path = [[self getPhotoPath] stringByAppendingPathComponent:file_name];
    NSData* imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:path atomically:YES];
    
    return path;
}

- (NSString*) getSavedOriginPhotoPath:(UIImage*)image nIDX:(int) nPos
{
    NSString* path = nil;
    
    NSString* file_name = [NSString stringWithFormat:@"%d_org.png", nPos];
    path = [[self getPhotoPath] stringByAppendingPathComponent:file_name];
    NSData* imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:path atomically:YES];
    
    return path;
}

- (NSString*) getPhotoPath
{
    NSString* path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"photos"];
    [self ensureDirs:path];
    return path;
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void) ensureDirs:(NSString*)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
        return;
    }
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", [SharedMembers GetSavePath:@"upload"], [[NSUUID UUID] UUIDString]];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    UIImage* image = [SharedMembers fixOrientation:(UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    NSDictionary *attributesDict=[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
    int fileSize = (int)[attributesDict fileSize];
    if (fileSize > 3 * 1024 * 1024)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"File size should be less than 3MB." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    [SharedMembers ShowGlobalWaiter:@"Uploading..." type:2];
    if (m_nAssetType == 0)
    {
        [_m_l_general_assets setText:@"Uploading..."];
        [[SharedMembers sharedInstance].webManager UploadGeneralAsset:filePath success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [_m_l_general_assets setText:@"File was uploaded successfully."];
        } failure:^(MKNetworkOperation* networkOperation, NSError* error){
            [JSWaiter HideWaiter];
            [_m_l_general_assets setText:@"File uploading was failed."];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Uploading was failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
    else if( m_nAssetType == 1 )
    {
        if ( ![m_selectAssetId isEqualToString:@""] ) {
            
            [_m_l_client_assets setText: @"Uploading..."];
            [[SharedMembers sharedInstance].webManager UploadAccountAsset:m_selectAssetId FilePath:filePath success:^(MKNetworkOperation *networkOperation) {
                [JSWaiter HideWaiter];
                [_m_l_client_assets setText: @"File was uploaded successfully."];
            } failure:^(MKNetworkOperation* networkOperation, NSError* error){
                [JSWaiter HideWaiter];
                [_m_l_client_assets setText: @"File uploading was failed."];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown AWS assets key prefix." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
        else{
            [JSWaiter HideWaiter];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select Account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    else if( m_nAssetType == 2 )
    {
        PresentationInfo * present = [SharedMembers sharedInstance].curPresent;
        
        [_m_l_presentation_assets setText: @"Uploading..."];
        [[SharedMembers sharedInstance].webManager UploadPresentationAsset: present._id FilePath:filePath success:^(MKNetworkOperation *networkOperation) {
            [JSWaiter HideWaiter];
            [_m_l_presentation_assets setText: @"File was uploaded successfully."];
        } failure:^(MKNetworkOperation* networkOperation, NSError* error){
            [JSWaiter HideWaiter];
            [_m_l_presentation_assets setText: @"File uploading was failed."];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Uploading was failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
    alertView = nil;
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    if(buttonIndex == 1)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else if( buttonIndex == 0 )
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:picker animated:YES completion:nil];
}


- (IBAction) onSave:(id)sender
{
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    
    info.name = _m_txt_Name.text;
    info.des  = _m_txt_Description.text;
    info.Logo = _m_txt_Logo.text;
    
    info.systemSize = [NSNumber numberWithDouble: [_m_txt_SystemSize.text doubleValue]];
    info.reimbursementRate = [NSNumber numberWithDouble: [_m_txt_Reimbursement.text doubleValue]];
    info.isTemplate = [NSNumber numberWithBool: bTemplate];
    info.titleView = [NSNumber numberWithBool: bTitle];
    info.systemSizeView = [NSNumber numberWithBool: bSystemSize];
    info.generatingSinceView = [NSNumber numberWithBool: bGenerating];
    info.lastUpdatedView = [NSNumber numberWithBool:bLastUpdated];
    
    [info getPresentationDic];

    [JSWaiter ShowWaiter:self.view title:@"" type:0];
    [[SharedMembers sharedInstance].webManager EditPresentation:info._id param:info->msgDic success:^(MKNetworkOperation *networkOperation) {
        NSLog(@"%@", networkOperation.responseJSON);
        [JSWaiter HideWaiter];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success !"
//                                                        message:@"Saved Presentation Information"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
        
        id<CISnapshotVCDelegate> strongDelegate = self.delegate;
        
        if ([strongDelegate respondsToSelector:@selector(CISnapshotVCDidCloseButtonPressed:)]) {
            [strongDelegate CISnapshotVCDidCloseButtonPressed:self];
        }

        
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        NSLog(@"failed");
        [JSWaiter HideWaiter];
    }];
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    // the user clicked OK
//    if (buttonIndex == 0) {
//        
//    }
//    else{
//        id<CISnapshotVCDelegate> strongDelegate = self.delegate;
//        
//        if ([strongDelegate respondsToSelector:@selector(CISnapshotVCDidCloseButtonPressed:)]) {
//            [strongDelegate CISnapshotVCDidCloseButtonPressed:self];
//        }
//
//        
//    }
//}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    PresentationInfo  * info = [SharedMembers sharedInstance].curPresent;
    info.des = textView.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
    int tag  = textField.tag;
    
    switch ( tag ) {
        case 1:
//            info.name = textField.text;
            break;
        case 2:
            info.Logo = textField.text;
            break;
        case 3:
            info.systemSize = [NSNumber numberWithDouble: [textField.text doubleValue]];
            break;
        case 4:
            info.reimbursementRate = [NSNumber numberWithDouble: [textField.text doubleValue]];
            break;
        default:
            break;
    }
}
@end
