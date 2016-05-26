//
//  TeamViewCell.h
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface TeamViewCell : UITableViewCell
{
    NSString* m_id;
    UserInfo* m_userInfo;
    
    IBOutlet UILabel* lbl_name;
    IBOutlet UILabel* lbl_email;
    IBOutlet UILabel* lbl_admin;
}
@property (nonatomic, weak) id delegate;
-(void)SetUserInfo:(UserInfo*)user;
@end
