//
//  UserProfileView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileView : UIView
{
    IBOutlet UILabel* lbl_username;
    IBOutlet UIImageView* img_avatar;
}
@property (nonatomic, strong) UIGestureRecognizer* tapGesture;
+(UserProfileView*)ShowUserProfileViewWithName:(UIView*)parentView xPos:(float)xPos;
-(void)Refresh;
@end
