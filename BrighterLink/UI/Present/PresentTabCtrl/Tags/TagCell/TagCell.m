//
//  TagCell.m
//  BrighterLink
//
//  Created by apple developer on 1/22/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import "TagCell.h"


@implementation TagCell

-(void)SetData:(Tag*)data selected:(BOOL)selected cellWidth:(float)cellWidth
{
    m_data = data;
    [lbl_text setText:data.name];
    CGRect contentFrame = vw_content.frame;
    contentFrame.size.width = cellWidth;
    vw_content.frame = contentFrame;
    [btn_select setFrame:CGRectMake(30, btn_select.frame.origin.y, vw_content.frame.size.width - 30, btn_select.frame.size.height)];

    m_bSelected = selected;
    
    if ([data.tagType isEqualToString:@"Facility"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_facilities.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:112.0f/255.0f green:38.0f/255.0f blue:143.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:15]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:142.0f/255.0f green:68.0f/255.0f blue:173.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:15]];
        }
    }
    else if ([data.tagType isEqualToString:@"Scope"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_data_logger.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:200.0f/255.0f green:96.0f/255.0f blue:4.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:15]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:230.0f/255.0f green:126.0f/255.0f blue:34.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:15]];
        }
    }
    else if ([data.tagType isEqualToString:@"Node"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_sensor.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:9.0f/255.0f green:144.0f/255.0f blue:66.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:15]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:39.0f/255.0f green:174.0f/255.0f blue:96.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:15]];
        }
    }
    else if ([data.tagType isEqualToString:@"Metric"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_metric.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:36.0f/255.0f green:109.0f/255.0f blue:172.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:15]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:15]];
        }
    }
    [lbl_text sizeToFit];
}

-(IBAction)OnSelect:(id)sender
{
    if ([_delegaate respondsToSelector:@selector(OnSelect:object:)])
        [_delegaate OnSelect:self object:m_data];
}
@end
