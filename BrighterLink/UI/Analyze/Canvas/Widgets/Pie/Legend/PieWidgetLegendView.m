//
//  PieWidgetLegendView.m
//  BrighterLink
//
//  Created by mobile on 12/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PieWidgetLegendView.h"
#import "PieWidgetView.h"

@implementation PieWidgetLegendView

-(id)init
{
    if (self = [super init])
    {
        m_whiteSpots = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)UpdateData:(NSArray*)data hiddenData:(NSArray*)hiddenData
{
    for(UIView* vw in self.subviews)
        [vw removeFromSuperview];
    [m_whiteSpots removeAllObjects];
    m_data = data;
    float rowHeight = 20;
    for(int i = 0; i < data.count; i++)
    {
        if ([[[data objectAtIndex:i] objectForKey:@"text"] isEqual:[NSNull null]])
            continue;
        UIImageView* spot = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * rowHeight + 5, 10, 10)];
        [spot setBackgroundColor:[[data objectAtIndex:i] objectForKey:@"color"]];
        
        spot.layer.cornerRadius = spot.frame.size.width / 2;
        [self addSubview:spot];
        
        UIImageView* whiteSpot = [[UIImageView alloc] initWithFrame:CGRectMake(1, i * rowHeight + 6, 8, 8)];
        [whiteSpot setBackgroundColor:[UIColor whiteColor]];
        whiteSpot.layer.cornerRadius = whiteSpot.frame.size.width / 2;
        if (![hiddenData containsObject:[[data objectAtIndex:i] objectForKey:@"text"]])
            [whiteSpot setHidden:YES];
        [self addSubview:whiteSpot];
        [m_whiteSpots addObject:whiteSpot];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, i * rowHeight, 0, rowHeight)];
        [lbl setText:[[data objectAtIndex:i] objectForKey:@"text"]];
        [lbl setFont:[UIFont boldSystemFontOfSize:12]];
        [lbl sizeToFit];
        lbl.center = CGPointMake(lbl.center.x, 10 + i * rowHeight);
        [self addSubview:lbl];
        
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * rowHeight, [self GetLabelMaxSize:data].width + 15, rowHeight)];
        [btn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = i;
    }
    [self setFrame:CGRectMake(self.superview.frame.size.width - 200, self.frame.origin.y, [self GetLabelMaxSize:data].width + 15, rowHeight * data.count)];
}

-(void)OnClick:(UIButton*)btn
{
    UIImageView* whiteSpot = [m_whiteSpots objectAtIndex:btn.tag];
    [whiteSpot setHidden:!whiteSpot.hidden];
    [_delegate SetVisibiityGraphData:[[m_data objectAtIndex:btn.tag] objectForKey:@"text"] show:whiteSpot.hidden];
}

-(CGSize)GetLabelMaxSize:(NSArray*)data
{
    NSString* maxTxt = @"";
    for(int i = 0; i < data.count; i++)
    {
        NSString* txt = [[data objectAtIndex:i] objectForKey:@"text"];
        if ([txt isEqual:[NSNull null]])
            continue;
        if(txt.length > maxTxt.length)
            maxTxt = txt;
    }
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setFont:[UIFont boldSystemFontOfSize:12]];
    [lbl setText:maxTxt];
    [lbl sizeToFit];
    return CGSizeMake(lbl.frame.size.width, lbl.frame.size.height) ;
}
@end
