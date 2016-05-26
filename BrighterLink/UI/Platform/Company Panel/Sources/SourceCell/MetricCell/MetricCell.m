//
//  MetricCell.m
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "MetricCell.h"
#import "SourcesView.h"

@implementation MetricCell

-(void)SetTagData:(Tag*)tg
{
    m_tag = tg;
    [lbl_name setText:tg.name];
}

-(IBAction)OnSelect:(id)sender
{
    [_delegate DidSelectRowWithObject:m_tag];
}
@end
