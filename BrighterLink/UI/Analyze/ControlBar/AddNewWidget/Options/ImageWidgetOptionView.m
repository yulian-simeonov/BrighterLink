//
//  ImageWidgetOptionView.m
//  BrighterLink
//
//  Created by apple developer on 1/2/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import "ImageWidgetOptionView.h"

@implementation ImageWidgetOptionView

-(void)awakeFromNib
{
    [super awakeFromNib];
    btn_addImage.layer.borderWidth = 1;
    btn_addImage.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    txt_info.layer.borderWidth = 1;
    txt_info.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    vwDrilldown.layer.borderColor = [UIColor colorWithRed:147.0f / 255.0f green:147.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f].CGColor;
    vwDrilldown.layer.borderWidth = 1.0f;
    vwDrilldown.layer.cornerRadius = 3.0f;
    m_bSetImage = NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIActionSheet *actionSheet = nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Drilldown" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.tag = DROP_DRILLDOWN;
    [self addDashboardButtonsToActionSheet:actionSheet];
    [actionSheet showInView:_delegate];
    
    return NO;
}

- (void) addDashboardButtonsToActionSheet:(UIActionSheet *)actionsheet
{
    for (CollectionInfo *collection in [SharedMembers sharedInstance].aryCollections) {
        
        for (DashboardInfo *dashboard in collection.aryDashboards) {
            
            [actionsheet addButtonWithTitle:dashboard.title];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    txtDrilldown.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    [_delegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
}

-(BOOL)AddWidget:(NSString*)title dashboardId:(NSString*)dashboardId
{
    if (!m_bSetImage)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please choose the image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    [JSWaiter ShowWaiter:[SharedMembers sharedInstance].currentViewController.view title:@"Uploading Image" type:0];
    NSData* data = UIImageJPEGRepresentation(img_image.image, 1);
    [[SharedMembers sharedInstance].webManager UploadWidgetImage:data dashboardId:dashboardId success:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        NSLog(@"%@", networkOperation.responseJSON);
        NSString* url = [[networkOperation.responseJSON objectForKey:@"message"] objectForKey:@"sourceCDNURL"];
        WidgetInfo* wgInfo = [[WidgetInfo alloc] initWithTitle:title showTitle:YES type:WIDGET_IMAGE];
        wgInfo.imageUrl = url;
        [self.delegate.delegate addNewWidget:wgInfo];
    } failure:nil];
    return YES;
}

-(IBAction)OnChangeImage:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Select" message:@"Please select your option" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Gallery", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[SharedMembers sharedInstance].currentViewController presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIPopoverController* popoverController=[[UIPopoverController alloc] initWithContentViewController:picker];
        [popoverController presentPopoverFromRect:CGRectMake(512, 384, 1, 1) inView:[SharedMembers sharedInstance].currentViewController.view permittedArrowDirections:0 animated:YES];
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
        UIImage* image = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData* data = UIImageJPEGRepresentation(image, 1);
        [lbl_size setText:[NSString stringWithFormat:@"%db", data.length]];
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSString *imageName = [imagePath lastPathComponent];
        [txt_info setText:[NSString stringWithFormat:@"  %@", [imageName lowercaseString]]];
        
        m_bSetImage = YES;
        [img_image setImage:[SharedMembers fixOrientation:image]];
    }
}
@end
