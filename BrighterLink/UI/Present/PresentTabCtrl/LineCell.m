//
//  LineCell.m
//  Lingua SA
//
//  Created by 陈玉亮 on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LineCell.h"
#import "AppDelegate.h"
#import "SharedMembers.h"


@interface LineCell ()
@end
@implementation LineCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void) setinfo:(NSString*) title Creator:(NSString*) creator Duration:(NSString*) duration
{
    [_m_title setText:title];
    [_m_creater setText:creator];
    [_m_duration setText:duration];
}

- (IBAction) onRemove:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Really Delete?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"YES", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
      
    }
    else{
        [[NSNotificationCenter defaultCenter]         postNotificationName:@"ShowProgress"         object:self];
        PresentationInfo * info = [[SharedMembers sharedInstance].arrAllPresentations objectAtIndex:index];
        _id  = info._id;
        
        [[SharedMembers sharedInstance].webManager DeletePresentation:info._id  success:^(MKNetworkOperation *networkOperation) {
            [[SharedMembers sharedInstance].arrAllPresentations removeObjectAtIndex:index];
            id<TableDelegate> Delegate = self.delegate;
            [Delegate onReloadData:_id Index:index];
       
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            [[NSNotificationCenter defaultCenter]         postNotificationName:@"HideProgress"         object:self];
        }];
    }
}

@end
