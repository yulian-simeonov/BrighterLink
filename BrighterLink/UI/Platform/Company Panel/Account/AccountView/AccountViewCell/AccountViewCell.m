//
//  AccountViewCell.m
//  BrighterLink
//
//  Created by mobile master on 11/7/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AccountViewCell.h"

@implementation AccountViewCell

-(void)SetAccount:(Account*)account
{
    [lbl_name setText:account.name];
    m_account = account;
}

-(IBAction)OnDetail:(id)sender
{
    if ([_delegate respondsToSelector:@selector(SelectedAccount:)])
        [_delegate performSelector:@selector(SelectedAccount:) withObject:m_account];
}

-(IBAction)OnSaleForce:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:m_account.sfdcAccountURL]];
}
@end
