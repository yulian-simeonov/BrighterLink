//
//  AccountViewCell.h
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
@interface AccountViewCell : UITableViewCell
{
    Account* m_account;
    IBOutlet UILabel* lbl_name;
}
@property (nonatomic, weak) id delegate;
-(void)SetAccount:(Account*)account;
@end
