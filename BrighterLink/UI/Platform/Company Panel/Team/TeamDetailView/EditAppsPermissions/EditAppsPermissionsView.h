//
//  EditAppsPermissionsView.h
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface EditAppsPermissionsView : UIView
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIButton* btn_save;
    IBOutlet UIImageView* img_home;
    IBOutletCollection(UIButton) NSArray* btn_activites;
    int m_selectedApp;
    BOOL m_bActiveApps[8];
    UserInfo* m_userInfo;
    NSMutableArray* m_arySelectedApps;
}
+(EditAppsPermissionsView*)ShowView:(UIView*)parentView;
-(void)SetUserInfo:(UserInfo*)userInfo;
@end
