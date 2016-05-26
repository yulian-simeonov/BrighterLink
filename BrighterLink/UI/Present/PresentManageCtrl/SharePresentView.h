//
//  CISnapshotVC.h
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePresentViewDelegate;

@interface SharePresentView : UIViewController
{
}

@property (nonatomic, weak) id<SharePresentViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UITextField * m_lPresentLink;
@property (nonatomic, weak) IBOutlet UITextField * m_lEmail;

- (IBAction) onSend:(id)sender;


@end


@protocol SharePresentViewDelegate <NSObject>

- (void)SharePresentViewDidCloseButtonPressed:(SharePresentView *)popupVC;


@end