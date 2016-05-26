//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWaiter.h"
#import "WebManager.h"



@interface FrameDetailView : UIView<UITextFieldDelegate>
{
}

@property (nonatomic, weak) IBOutlet UITextField * m_txtFrame_URL;

@end
