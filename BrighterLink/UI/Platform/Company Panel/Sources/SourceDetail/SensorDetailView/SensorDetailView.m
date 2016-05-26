//
//  SensorDetailView.m
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SensorDetailView.h"
#import "SourcesView.h"

@implementation SensorDetailView
+(SensorDetailView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SensorDetailView" owner:self options:nil];
    SensorDetailView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_edit.layer.borderWidth = 1;
    btn_edit.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
    {
        [btn_edit setHidden:YES];
        [btn_delete setHidden:YES];
    }
}

-(IBAction)OnEdit:(id)sender
{
    [_delegate OnEditSource:m_tag delegate:self];
}

-(void)SetTagData:(Tag*)tg
{
    m_tag = tg;
    [lbl_name setText:m_tag.name];
    [lbl_manufacturer setText:m_tag.manufacturer];
    [lbl_device setText:m_tag.device];
    [lbl_sensorTarget setText:m_tag.sensorTarget];
    [lbl_interval setText:m_tag.interval];
    [lbl_latitude setText:[NSString stringWithFormat:@"%.4f", m_tag.latitude.floatValue]];
    [lbl_longitude setText:[NSString stringWithFormat:@"%.4f", m_tag.longitude.floatValue]];
    [lbl_groups setText:nil];
    [lbl_weatherStation setText:m_tag.weatherStation];
    
    [btn_delete setHidden:NO];
    if (m_tag.childrenTags)
    {
        if (m_tag.childrenTags.count > 0)
            [btn_delete setHidden:YES];
    }
}

-(IBAction)OnDelete:(id)sender
{
    [JSWaiter ShowWaiter:_delegate title:@"Deleting..." type:0];
    [m_tag DeleteTag:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [_delegate OnBack:nil];
    } failed:nil];
}
@end
