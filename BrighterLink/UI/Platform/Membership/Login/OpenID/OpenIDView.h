//
//  OpenIDView.h
//  BrighterLink
//
//  Created by apple developer on 2/21/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenIDView : UIView
{
    IBOutlet UIImageView* img_bg;
    IBOutlet UIView* vw_content;
    IBOutlet UITextView* txt_url;
    IBOutlet UIButton* btn_login;
    
}
+(OpenIDView*)ShowView:(UIView*)parentView;
@end
