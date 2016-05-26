//
//  UploadPhoto.h
//  BrighterLink
//
//  Created by mobile master on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileSettingView.h"
#import "SPUserResizableView.h"

@interface UploadPhotoView : UIView<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, SPUserResizableViewDelegate>
{
    IBOutlet UIButton* btn_camera;
    IBOutlet UIButton* btn_gallery;
    IBOutlet UIButton* btn_save;
    IBOutlet UIButton* btn_cancel;
    
    IBOutlet UIView* vw_gesture;
    IBOutlet UIImageView* img_photo;
    IBOutlet UIImageView* img_crop;
    IBOutlet UIImageView* img_preview;
    CGFloat firstX;
    CGFloat firstY;
    CGFloat lastRotation;
    CGFloat m_scale;
    SPUserResizableView* vw_cropper;
}
@property (nonatomic, strong) UIGestureRecognizer* tapGesture;
@property (nonatomic, weak) ProfileSettingView* delegate;
+(UploadPhotoView*)ShowView:(UIView*)parentView;
@end
