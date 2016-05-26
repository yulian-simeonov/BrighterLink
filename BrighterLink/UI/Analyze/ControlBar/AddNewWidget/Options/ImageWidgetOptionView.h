//
//  ImageWidgetOptionView.h
//  BrighterLink
//
//  Created by apple developer on 1/2/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddNewWidgetView.h"

@interface ImageWidgetOptionView : UIView<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView* img_image;
    IBOutlet UITextField* txt_info;
    IBOutlet UILabel* lbl_size;
    IBOutlet UIButton* btn_addImage;
    
   IBOutlet UIView *vwDrilldown;
   IBOutlet UITextField *txtDrilldown;
    
    BOOL m_bSetImage;
}

@property (nonatomic, strong) AddNewWidgetView* delegate;
-(BOOL)AddWidget:(NSString*)title dashboardId:(NSString*)dashboardId;
@end
