//
//  PieChartView.m
//  BrighterLink
//
//  Created by mobile on 12/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PieChartView.h"
#import "AppDelegate.h"

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@implementation PieChartView

-(id)init
{
    if (self = [super init])
    {
        [self setFrame:CGRectMake(0, 0, PieRadius * 2 + PieChartOffset, PieRadius * 2 + PieChartOffset)];
        [self setBackgroundColor:[UIColor clearColor]];
        m_labels = [[NSMutableArray alloc] init];
        vw_legend = [[PieWidgetLegendView alloc] init];
        [vw_legend setDelegate:self];
        m_hiddenData = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!self.MetricData)
        return;
    
    m_totalValue = 0;
    UIColor* curColor = self.MetricColor;
    NSMutableArray* colors = [[NSMutableArray alloc] init];
    for(NSDictionary* metric in self.MetricData)
    {
        [colors addObject:curColor];
        double r, g, b;
        [curColor getRed:&r green:&g blue:&b alpha:nil];
        curColor = [UIColor colorWithRed:r - 0.1f green:g - 0.1f blue:b - 0.1f alpha:1];
        if ([m_hiddenData containsObject:[metric objectForKey:@"label"]])
            continue;
        m_totalValue += [[metric objectForKey:@"value"] floatValue];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    float curValue = 0;
    int idx = 0;
    for(NSDictionary* metric in self.MetricData)
    {
        curColor = [colors objectAtIndex:idx];
        if ([m_hiddenData containsObject:[metric objectForKey:@"label"]])
            continue;
        float fromAngle, toAngle;
        if (curValue == 0)
            fromAngle = 0;
        else
            fromAngle = curValue / m_totalValue * 360.0f;
        toAngle = (curValue + [[metric objectForKey:@"value"] floatValue]) / m_totalValue * 360.0f;
        fromAngle -= 90;
        toAngle -= 90;
        toAngle -= 1;
        CGContextSetLineWidth(context, PieLineWidth);
        CGContextSetStrokeColorWithColor(context, curColor.CGColor);
        CGContextAddArc(context, PieRadius + PieChartOffset / 2, PieRadius + PieChartOffset / 2 - 15, PieRadius, degreesToRadians(fromAngle), degreesToRadians(toAngle), 0);
        CGContextStrokePath(context);
        curValue += [[metric objectForKey:@"value"] floatValue];
        idx++;
    }
}

-(void)Refresh
{
    m_totalValue = 0;
    for(NSDictionary* metric in self.MetricData)
    {
        if ([m_hiddenData containsObject:[metric objectForKey:@"label"]])
            continue;
        m_totalValue += [[metric objectForKey:@"value"] floatValue];
    }
    for(UILabel* lbl in m_labels)
        [lbl removeFromSuperview];
    [m_labels removeAllObjects];
    [vw_legend removeFromSuperview];

    float curValue = 0;
    UIColor* color = self.MetricColor;
    NSMutableArray* legendData = [[NSMutableArray alloc] init];
    float bottom = PieRadius * 2 + PieChartOffset / 2 - 15;
    
    for(NSDictionary* metric in self.MetricData)
    {
        if (m_totalValue == 0)
            break;
        [legendData addObject:@{@"text" : [metric objectForKey:@"label"], @"color" : color}];
        if ([m_hiddenData containsObject:[metric objectForKey:@"label"]])
            continue;
        float fromAngle, toAngle;
        if (curValue == 0)
            fromAngle = 0;
        else
            fromAngle = curValue / m_totalValue * 360.0f;
        toAngle = (curValue + [[metric objectForKey:@"value"] floatValue]) / m_totalValue * 360.0f;
        fromAngle -= 90;
        toAngle -= 90;
        float lblAngle = (fromAngle + toAngle) / 2;
        UILabel* lbl = [[UILabel alloc] init];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        NSString* percent = @"%";
        [lbl setText:[NSString stringWithFormat:@"%d%@", (int)(([[metric objectForKey:@"value"] floatValue] / m_totalValue) * 100), percent]];
        [lbl sizeToFit];
        float outRadius = PieRadius + 7;
        CGPoint centerPos = CGPointMake(PieRadius + PieChartOffset / 2, PieRadius + PieChartOffset / 2 - 15);
        
        float deltaX, deltaY;
        deltaX = cosf(degreesToRadians(-lblAngle)) * outRadius;
        if (ABS(deltaX) < 0.0001f)
            deltaX = 0;
        if (deltaX > 0)
            deltaX += lbl.frame.size.width / 2;
        else if (deltaX < 0)
            deltaX -= lbl.frame.size.width / 2;
        deltaY = -sinf(degreesToRadians(-lblAngle)) * outRadius;
        if (deltaY > 0)
            deltaY += lbl.frame.size.height / 2;
        else if (deltaY < 0)
            deltaY -= lbl.frame.size.height / 2;
        centerPos = CGPointMake(centerPos.x + deltaX, centerPos.y + deltaY);
        lbl.center = centerPos;
        [self addSubview:lbl];
        [m_labels addObject:lbl];
        curValue += [[metric objectForKey:@"value"] floatValue];
        if (lbl.frame.size.height + lbl.frame.origin.y > bottom)
            bottom = lbl.frame.size.height + lbl.frame.origin.y;
        
        double r, g, b;
        [color getRed:&r green:&g blue:&b alpha:nil];
        color = [UIColor colorWithRed:r - 0.1f green:g - 0.1f blue:b - 0.1f alpha:1];
    }
    [vw_legend UpdateData:legendData hiddenData:m_hiddenData];
    vw_legend.center = CGPointMake(self.frame.size.width / 2, bottom + vw_legend.frame.size.height / 2 + 5);
    [self addSubview:vw_legend];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, PieRadius * 2 + PieChartOffset, vw_legend.frame.size.height + vw_legend.frame.origin.y + 5)];
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIView* rootView = app.window.rootViewController.view;
    
    UITouch* touch = [touches anyObject];
    CGPoint posHere = [touch locationInView:self];
    NSDictionary* metric = [self GetMetric:posHere];
    if (!metric)
        return;
    
    CGPoint pos = [touch locationInView:rootView];
    if (!vw_tooltip)
    {
        vw_tooltip = [[PieWidgetTooltipView alloc] init];
        [rootView addSubview:vw_tooltip];
    }
    [vw_tooltip UpdateData:[metric objectForKey:@"label"] value:[[metric objectForKey:@"value"] floatValue]];
    [vw_tooltip setCenter:CGPointMake(pos.x, pos.y - vw_tooltip.frame.size.height / 2 - 10)];
}

-(NSDictionary*)GetMetric:(CGPoint)pos
{
    NSDictionary* ret;
    float curValue = 0;
    for(NSDictionary* metric in self.MetricData)
    {
        if ([m_hiddenData containsObject:[metric objectForKey:@"label"]])
            continue;
        CGPoint centerPos = CGPointMake(PieRadius + PieChartOffset / 2, PieRadius + PieChartOffset / 2 - 15);
        float fromAngle, toAngle;
        if (curValue == 0)
            fromAngle = 0;
        else
            fromAngle = curValue / m_totalValue * 360.0f;
        toAngle = (curValue + [[metric objectForKey:@"value"] floatValue]) / m_totalValue * 360.0f;
        fromAngle -= 90;
        toAngle -= 90;
        
        float inRadius = PieRadius - PieLineWidth - 10;
        float outRadius = PieRadius + 10;
        float radius = sqrtf(powf(ABS(centerPos.x - pos.x), 2) + powf(ABS(centerPos.y - pos.y), 2));
        if (radius >= inRadius && radius <= outRadius)
        {
            float angle = 360 - GetAngle(pos.x - centerPos.x, centerPos.y - pos.y);
            if (angle > 270)
                angle = 270 - angle;
            if (angle >= fromAngle && angle <= toAngle)
            {
                ret = metric;
                break;
            }
        }
        curValue += [[metric objectForKey:@"value"] floatValue];
    }
    return ret;
}

float GetAngle(float x, float y)
{
    float bearingRadians = atan2f(y, x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingRadians > 0 ? bearingRadians : (2 * M_PI + bearingRadians)) * 360 / (2*M_PI);
    return bearingDegrees;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIView* rootView = app.window.rootViewController.view;
    UITouch* touch = [touches anyObject];
    CGPoint posHere = [touch locationInView:self];
    NSDictionary* metric = [self GetMetric:posHere];
    if (!metric)
        return;
    CGPoint pos = [touch locationInView:rootView];
    if (!vw_tooltip)
    {
        vw_tooltip = [[PieWidgetTooltipView alloc] init];
        [rootView addSubview:vw_tooltip];
    }
    [vw_tooltip UpdateData:[metric objectForKey:@"label"] value:[[metric objectForKey:@"value"] floatValue]];
    [vw_tooltip setCenter:CGPointMake(pos.x, pos.y - vw_tooltip.frame.size.height / 2 - 10)];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (vw_tooltip)
    {
        [vw_tooltip removeFromSuperview];
        vw_tooltip = nil;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (vw_tooltip)
    {
        [vw_tooltip removeFromSuperview];
        vw_tooltip = nil;
    }
}

-(void)SetVisibiityGraphData:(NSString*)name show:(BOOL)show
{
    if (show)
        [m_hiddenData removeObject:name];
    else
        [m_hiddenData addObject:name];
    [self Refresh];
}
@end
