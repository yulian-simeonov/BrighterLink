//
//  AccountView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountView : UIView
{
    IBOutlet UIButton* btn_createAccount;
    IBOutlet UIImageView* img_searchBar;
    IBOutlet UITextField* txt_search;
    IBOutlet UITableView* tbl_accounts;
    NSMutableArray* m_filteredAccounts;
}
+(UIView*)ShowView:(UIView*)parentView;
-(void)SelectedAccount:(id)data;

-(void)Refresh;
@end
