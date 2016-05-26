//
//  DataLoggerCell.m
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DataLoggerCell.h"
#import "SourcesView.h"

@implementation DataLoggerCell

-(void)SetTagData:(Tag*)tg
{
    m_tag = tg;
    [lbl_name setText:tg.name];
    if (tg.device.length > 0 && tg.deviceID.length > 0)
        [lbl_detail setText:[NSString stringWithFormat:@"%@, %@", tg.device, tg.deviceID]];
    else
        [lbl_detail setText:nil];
}

-(IBAction)OnSelect:(id)sender
{
    [_delegate DidSelectRowWithObject:m_tag];
}
@end
