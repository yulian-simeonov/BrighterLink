//
//  TimelineWidgetLegendView.m
//  BrighterLink
//
//  Created by mobile on 11/27/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TimelineWidgetLegendView.h"
#import "SharedMembers.h"
#import "TimelineWidgetView.h"
#import "TimelineWidgetFullScreenView.h"

@implementation TimelineWidgetLegendView
-(id)init
{
    if (self = [super init])
    {
        m_whiteSpots = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)UpdateData:(NSArray*)data
{
    for(UIView* vw in self.subviews)
        [vw removeFromSuperview];
    [m_whiteSpots removeAllObjects];
    m_data = data;
    float rowHeight = 20;
    float frameWidth = [self GetLabelMaxSize:data].width;
    for(int i = 0; i < data.count; i++)
    {
        UIImageView* spot = [[UIImageView alloc] initWithFrame:CGRectMake(5, i * rowHeight + 10, 10, 10)];
        [spot setBackgroundColor:[[SharedMembers sharedInstance].arySegmentColors objectAtIndex:i]];
        spot.layer.cornerRadius = spot.frame.size.width / 2;
        [self addSubview:spot];
        
        UIImageView* whiteSpot = [[UIImageView alloc] initWithFrame:CGRectMake(6, i * rowHeight + 11, 8, 8)];
        [whiteSpot setBackgroundColor:[UIColor whiteColor]];
        whiteSpot.layer.cornerRadius = whiteSpot.frame.size.width / 2;
        [whiteSpot setHidden:YES];
        [self addSubview:whiteSpot];
        [m_whiteSpots addObject:whiteSpot];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, i * rowHeight, 0, rowHeight)];
        [lbl setText:[data objectAtIndex:i]];
        [lbl setFont:[UIFont boldSystemFontOfSize:12]];
        [lbl sizeToFit];
        lbl.center = CGPointMake(lbl.center.x, 15 + i * rowHeight);
        [self addSubview:lbl];
        
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * rowHeight, 200, rowHeight)];
        [btn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = i;
        
    }
    [self setFrame:CGRectMake(self.superview.frame.size.width - frameWidth, WIDGET_TITLEBAR_HEIGHT, frameWidth, rowHeight * data.count + 10)];
}

-(void)OnClick:(UIButton*)btn
{
    UIImageView* whiteSpot = [m_whiteSpots objectAtIndex:btn.tag];
    [whiteSpot setHidden:!whiteSpot.hidden];
    [_delegate SetVisibiityGraphData:[m_data objectAtIndex:btn.tag] show:whiteSpot.hidden];
}

-(CGSize)GetLabelMaxSize:(NSArray*)data
{
    NSString* maxTxt = @"";
    for(int i = 0; i < data.count; i++)
    {
        NSString* txt = [data objectAtIndex:i];
        if(txt.length > maxTxt.length)
            maxTxt = txt;
    }
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setFont:[UIFont boldSystemFontOfSize:12]];
    [lbl setText:maxTxt];
    [lbl sizeToFit];
    return CGSizeMake(lbl.frame.size.width + 25, lbl.frame.size.height) ;
}
@end
