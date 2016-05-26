//
//  NavigationBarView.h
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAppsView.h"

@interface NavigationBarView : UIView
{
    IBOutlet UILabel* lbl_username;
    IBOutlet UIButton* btn_apps;
    IBOutlet UIImageView* img_avatar;
@public
    __weak SelectAppsView* vw_apps;
}
@property (nonatomic, strong) UIGestureRecognizer* tapGesture;
+(NavigationBarView*)AddNavigationBar:(UIView*)parentView;
-(void)Refresh;
@end
