//
//  UploadPhoto.m
//  BrighterLink
//
//  Created by mobile master on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "UploadPhotoView.h"
#import "SharedMembers.h"
//#import "UIImagePickerController+NonRotating.h"
#import "NavigationBarView.h"

@implementation UploadPhotoView

+(UploadPhotoView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UploadPhotoView" owner:self options:nil];
    UploadPhotoView* vw = [nib objectAtIndex:0];
    vw.center = CGPointMake(512, vw.frame.size.height / 2 + 40);
    vw.layer.zPosition = 15;
    [vw Initialize];
    vw.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:vw action:@selector(OnTapOutside:)];
    [parentView addGestureRecognizer:vw.tapGesture];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_camera.layer.borderWidth = 1;
    btn_camera.layer.borderColor = btn_camera.titleLabel.textColor.CGColor;
    
    btn_gallery.layer.borderWidth = 1;
    btn_gallery.layer.borderColor = btn_gallery.titleLabel.textColor.CGColor;
    
    btn_save.layer.borderWidth = 1;
    btn_save.layer.borderColor = btn_save.titleLabel.textColor.CGColor;
    
    btn_cancel.layer.borderWidth = 1;
    btn_cancel.layer.borderColor = btn_cancel.titleLabel.textColor.CGColor;
    
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(-5, 5);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
//    UIRotationGestureRecognizer* rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
//    [rotationRecognizer setDelegate:self];
//    [vw_gesture addGestureRecognizer:rotationRecognizer];

    vw_cropper.layer.borderColor = [UIColor whiteColor].CGColor;
    vw_cropper.layer.borderWidth = 2;
    
    img_photo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    img_photo.layer.borderWidth = 1;
    
    [btn_save setHidden:YES];
    vw_cropper = [[SPUserResizableView alloc] initWithFrame:img_crop.frame];
    vw_cropper.contentView = img_crop;
    vw_cropper.delegate = self;
    [vw_cropper showEditingHandles];
    [vw_gesture addSubview:vw_cropper];
}

-(IBAction)OnGallery:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIPopoverController* popoverController=[[UIPopoverController alloc] initWithContentViewController:picker];
    [popoverController presentPopoverFromRect:CGRectMake(512, 384, 1, 1) inView:[SharedMembers sharedInstance].currentViewController.view permittedArrowDirections:0 animated:YES];
}

-(IBAction)OnCapture:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [[SharedMembers sharedInstance].currentViewController presentViewController:picker animated:YES completion:nil];
}

-(IBAction)OnClose:(id)sender
{
    [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    [self removeFromSuperview];
}

-(IBAction)OnUpload:(id)sender
{
    [SharedMembers ShowGlobalWaiter:@"Uploading..." type:0];
    [[SharedMembers sharedInstance].webManager UploadUserPicture:UIImagePNGRepresentation(img_preview.image) success:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [[SharedMembers sharedInstance].userInfo setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
        [[SharedMembers sharedInstance].navigationBar Refresh];
        [_delegate Refresh];
        [self OnClose:nil];
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        [JSWaiter HideWaiter];
        if (errorOp.responseJSON)
        {
            if ([[errorOp.responseJSON objectForKey:@"message"] isEqualToString:@"INCORRECT_SESSION"])
            {
                [[SharedMembers sharedInstance].currentViewController.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[errorOp.responseJSON objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
        else
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
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
        [self SetNewPhoto:image];
        [btn_save setHidden:NO];
    }
}

-(void)SetNewPhoto:(UIImage*)image
{
    [img_photo setTransform:CGAffineTransformIdentity];
    [img_photo setImage:[SharedMembers fixOrientation:image]];
    lastRotation = 0;
    firstX = 0;
    firstY = 0;
    m_scale = 1;
    [self UpdateCropImage];
}

-(void)UpdateCropImage
{
    if (!img_photo.image)
        return;
    [img_crop setImage:[SharedMembers CaptureBackground:img_photo inRect:CGRectMake(vw_cropper.frame.origin.x, vw_cropper.frame.origin.y, img_crop.frame.size.width, img_crop.frame.size.height) withScale:1.0f]];
    [img_preview setImage:img_crop.image];
}

-(void)move:(id)sender {
    [vw_gesture bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:vw_gesture];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);

    [[sender view] setCenter:translatedPoint];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        CGFloat finalX = translatedPoint.x + (0*[(UIPanGestureRecognizer*)sender velocityInView:vw_cropper].x);
        CGFloat finalY = translatedPoint.y + (0*[(UIPanGestureRecognizer*)sender velocityInView:vw_cropper].y);
        
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
    }
    if (vw_cropper.frame.origin.x < 0)
        vw_cropper.frame = CGRectMake(0, vw_cropper.frame.origin.y, vw_cropper.frame.size.width, vw_cropper.frame.size.height);
    if (vw_cropper.frame.origin.y < 0)
        vw_cropper.frame = CGRectMake(vw_cropper.frame.origin.x, 0, vw_cropper.frame.size.width, vw_cropper.frame.size.height);
    if (vw_cropper.frame.origin.x > vw_gesture.frame.size.width - vw_cropper.frame.size.width)
        vw_cropper.frame = CGRectMake(vw_gesture.frame.size.width - vw_cropper.frame.size.width, vw_cropper.frame.origin.y, vw_cropper.frame.size.width, vw_cropper.frame.size.height);
    if (vw_cropper.frame.origin.y > vw_gesture.frame.size.height - vw_cropper.frame.size.height)
        vw_cropper.frame = CGRectMake(vw_cropper.frame.origin.x, vw_gesture.frame.size.height - vw_cropper.frame.size.height, vw_cropper.frame.size.width, vw_cropper.frame.size.height);
    [self UpdateCropImage];
}

-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = img_photo.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [img_photo setTransform:newTransform];
    
    lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    [self UpdateCropImage];
}

- (void)userResizableViewEditing:(SPUserResizableView *)userResizableView
{
    [self UpdateCropImage];
}

-(void)OnTapOutside:(UITapGestureRecognizer*)gesture
{
    if (CGRectContainsPoint(self.frame, [gesture locationInView:gesture.view]))
        return;
    [self OnClose:nil];
}
@end

