//
//  DataSourceTreeCell.m
//  BrighterLink
//
//  Created by mobile master on 11/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DataSourceTreeCell.h"
#import "Command.h"


@implementation DataSourceTreeCell

-(void)SetData:(Tag*)data level:(int)level expanded:(BOOL)expanded selected:(BOOL)selected
{
    m_data = data;
    [lbl_text setText:data.name];
    CGFloat left = 20 * level;
    CGRect contentFrame = vw_content.frame;
    contentFrame.origin.x = left;
    vw_content.frame = contentFrame;
    m_bExpanded = expanded;
    m_bSelected = selected;
    if (m_bSelected)
    {
        [img_eye setImage:[UIImage imageNamed:@"icon_eye.png"]];
        [img_eye setAlpha:1];
    }
    else
    {
        [img_eye setImage:[UIImage imageNamed:@"icon_add.png"]];
        [img_eye setAlpha:0.5f];
    }
    if ([data.tagType isEqualToString:@"Facility"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_facilities.png"] forState:UIControlStateNormal];
        [lbl_text setTextColor:[UIColor colorWithRed:142.0f/255.0f green:68.0f/255.0f blue:173.0f/255.0f alpha:1]];
        [lbl_text setFont:[UIFont systemFontOfSize:18]];
    }
    else if ([data.tagType isEqualToString:@"Scope"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_data_logger.png"] forState:UIControlStateNormal];
        [lbl_text setTextColor:[UIColor colorWithRed:230.0f/255.0f green:126.0f/255.0f blue:34.0f/255.0f alpha:1]];
        [lbl_text setFont:[UIFont systemFontOfSize:16]];
    }
    else if ([data.tagType isEqualToString:@"Node"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_sensor.png"] forState:UIControlStateNormal];
        [lbl_text setTextColor:[UIColor colorWithRed:39.0f/255.0f green:174.0f/255.0f blue:96.0f/255.0f alpha:1]];
        [lbl_text setFont:[UIFont systemFontOfSize:15]];
    }
    else if ([data.tagType isEqualToString:@"Metric"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_metric.png"] forState:UIControlStateNormal];
        [lbl_text setTextColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [lbl_text setFont:[UIFont systemFontOfSize:14]];
    }
    
    if (data.childrenTags.count > 0 && expanded)
    {
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(left + 15, 23, 1, 10)];
        [line setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line];
    }
    
    if (data->m_parent)
    {
        float lineHeight = 30;
        if([data->m_parent.childrenTags indexOfObject:data] == data->m_parent.childrenTags.count - 1)
            lineHeight = 15;
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(left - 5, 0, 1, lineHeight)];
        [line setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line];
        [self DrawParentLines:data->m_parent level:level - 1];
        
        UIView* line1 = [[UIView alloc] initWithFrame:CGRectMake(left - 5, 15, 12, 1)];
        [line1 setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line1];
    }
}

-(void)DrawParentLines:(Tag*)tg level:(int)deep
{
    if([tg->m_parent.childrenTags indexOfObject:tg] != tg->m_parent.childrenTags.count - 1)
    {
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(deep * 20 - 5, 0, 1, 30)];
        [line setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line];
    }
    if (tg->m_parent)
        [self DrawParentLines:tg->m_parent level:deep - 1];
}

-(void)SetDataForPresent:(Tag*)data level:(int)level expanded:(BOOL)expanded selected:(BOOL)selected cellWidth:(float)cellWidth
{
    m_data = data;
    [lbl_text setText:data.name];
    CGFloat left = 20 * level;
    CGRect contentFrame = vw_content.frame;
    contentFrame.origin.x = left;
    contentFrame.size.width = cellWidth - left;
    vw_content.frame = contentFrame;
    [btn_select setFrame:CGRectMake(30, btn_select.frame.origin.y, vw_content.frame.size.width - 30, btn_select.frame.size.height)];
    m_bExpanded = expanded;
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
            [lbl_text setFont:[UIFont boldSystemFontOfSize:14]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:230.0f/255.0f green:126.0f/255.0f blue:34.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:14]];
        }
    }
    else if ([data.tagType isEqualToString:@"Node"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_sensor.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:9.0f/255.0f green:144.0f/255.0f blue:66.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:13]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:39.0f/255.0f green:174.0f/255.0f blue:96.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:13]];
        }
    }
    else if ([data.tagType isEqualToString:@"Metric"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_metric.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:36.0f/255.0f green:109.0f/255.0f blue:172.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:12]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:12]];
        }
    }
    if (data->m_parent)
    {
        float lineHeight = 30;
        if([data->m_parent.childrenTags indexOfObject:data] == data->m_parent.childrenTags.count - 1)
            lineHeight = 15;
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(left - 5, 0, 1, lineHeight)];
        [line setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line];
        [self DrawParentLines:data->m_parent level:level - 1];
        
        UIView* line1 = [[UIView alloc] initWithFrame:CGRectMake(left - 5, 15, 12, 1)];
        [line1 setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line1];
    }
    
  
    
}


-(void)SetDataForPresent1:(Tag*)data level:(int)level expanded:(BOOL)expanded selected:(BOOL)selected cellWidth:(float)cellWidth
{
    
    m_data = data;
    [lbl_text setText:data.name];
    CGFloat left = 20 * level;
    CGRect contentFrame = vw_content.frame;
    contentFrame.origin.x = left;
    contentFrame.size.width = cellWidth - left;
    vw_content.frame = contentFrame;

    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, cellWidth, self.frame.size.height)];
    
    [btn_select setFrame:CGRectMake(30, btn_select.frame.origin.y, vw_content.frame.size.width - 30, btn_select.frame.size.height)];
    m_bExpanded = expanded;
    m_bSelected = selected;
    
    if ([data.tagType isEqualToString:@"Facility"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_facilities.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:112.0f/255.0f green:38.0f/255.0f blue:143.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:18]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:142.0f/255.0f green:68.0f/255.0f blue:173.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:18]];
        }
    }
    else if ([data.tagType isEqualToString:@"Scope"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_data_logger.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:200.0f/255.0f green:96.0f/255.0f blue:4.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:17]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:230.0f/255.0f green:126.0f/255.0f blue:34.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:17]];
        }
    }
    else if ([data.tagType isEqualToString:@"Node"])
    {
        [btn_icon setImage:[UIImage imageNamed:@"mark_sensor.png"] forState:UIControlStateNormal];
        if (m_bSelected)
        {
            [lbl_text setTextColor:[UIColor colorWithRed:9.0f/255.0f green:144.0f/255.0f blue:66.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont boldSystemFontOfSize:16]];
        }
        else
        {
            [lbl_text setTextColor:[UIColor colorWithRed:39.0f/255.0f green:174.0f/255.0f blue:96.0f/255.0f alpha:1]];
            [lbl_text setFont:[UIFont systemFontOfSize:16]];
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

    
    if (data->m_parent)
    {
        float lineHeight = 30;
        if([data->m_parent.childrenTags indexOfObject:data] == data->m_parent.childrenTags.count - 1)
            lineHeight = 15;
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(left - 5, 0, 1, lineHeight)];
        [line setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line];
        [self DrawParentLines:data->m_parent level:level - 1];
        
        UIView* line1 = [[UIView alloc] initWithFrame:CGRectMake(left - 5, 15, 12, 1)];
        [line1 setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f green:139.0f/255.0f blue:202.0f/255.0f alpha:1]];
        [self addSubview:line1];
    }
    

}


-(IBAction)OnCollaps:(id)sender
{
    if (m_bExpanded)
    {
        if ([_delegaate respondsToSelector:@selector(OnCollaps:object:)])
            [_delegaate OnCollaps:self object:m_data];
        m_bExpanded = NO;
    }
    else
    {
        if ([_delegaate respondsToSelector:@selector(OnExpand:object:)])
            [_delegaate OnExpand:self object:m_data];
        m_bExpanded = YES;
    }
}

-(IBAction)OnSelect:(id)sender
{
    if ([_delegaate respondsToSelector:@selector(OnSelect:object:)])
        [_delegaate OnSelect:self object:m_data];
}
@end
