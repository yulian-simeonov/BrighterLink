//
//  ViewAssetsView.h
//  BrighterLink
//
//  Created by mobile on 11/23/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAssetsView : UIView
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIImageView* img_header;
    IBOutlet UILabel* lbl_name;
    IBOutlet UIImageView* img_frame;
    IBOutlet UIImageView* img_photo;
    IBOutlet UIView* vw_content;
}
+(ViewAssetsView*)ShowView;
-(void)SetImageInfo:(NSDictionary*)imgInfo;
@end
