//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "FrameDetailView.h"

#import "SharedMembers.h"

@interface FrameDetailView()

@end

@implementation FrameDetailView

- (void) awakeFromNib
{
    [_m_txtFrame_URL setDelegate:self];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetIFrameUrl = textField.text;
}

@end
