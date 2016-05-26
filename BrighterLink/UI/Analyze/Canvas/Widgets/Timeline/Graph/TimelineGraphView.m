//
//  TimelineGraphView.m
//  BrighterLink
//
//  Created by mobile on 11/26/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TimelineGraphView.h"
#import "TimelineWidgetView.h"
#import "TimelineWidgetFullScreenView.h"
#import "SharedMembers.h"

@implementation TimelineGraphView

+(TimelineGraphView*)ShowGraphic:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TimelineGraphView" owner:parentView options:nil];
    TimelineGraphView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    kGraphTop = 0;
    kCircleRadius = 3;
    kOffsetX = 0;
    kOffsetY = 0;
    m_topPoints = [[NSMutableArray alloc] init];
    img_line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    [img_line setHidden:YES];
    [img_line setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:img_line];
}

-(void)drawRect:(CGRect)rect
{
    if (!m_lines)
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawLineGraphWithContext:context];
    
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, kGraphHeight);
    CGContextMoveToPoint(context, kDefaultGraphWidth, 0);
    CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphHeight);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // How many lines?
    int howMany = (kDefaultGraphWidth - kOffsetX) / kStepX;
    
    // Here the lines go
    for (int i = 0; i < howMany; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * kLineStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kLineStepX, kGraphBottom);
    }
    
    int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kLineStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kLineStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kLineStepY);
    }
    
    CGContextStrokePath(context);
}

- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    int maxGraphHeight = kGraphHeight - kOffsetY;
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:255.0f / 255.0f green:243.0f / 255.0f blue:250.0f / 255.0f alpha:1].CGColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * [[m_topPoints objectAtIndex:0] floatValue]);
    for (int i = 1; i < m_topPoints.count; i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i, kGraphHeight - maxGraphHeight * [[m_topPoints objectAtIndex:i] floatValue]);
    }
    CGContextAddLineToPoint(ctx, kOffsetX + (m_topPoints.count - 1), kGraphHeight);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    int colorIdx = 0;
    for(NSDictionary* item in m_lines)
    {
        NSArray* line = [item objectForKey:@"data"];
        if (line.count < 2)
            continue;
        UIColor* color = [[SharedMembers sharedInstance].arySegmentColors objectAtIndex:[[item objectForKey:@"color"] intValue]];
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
        
        int maxGraphHeight = kGraphHeight - kOffsetY;
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * [[line objectAtIndex:0] floatValue]);
        
        for (int i = 1; i < line.count; i++)
        {
            CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * [[line objectAtIndex:i] floatValue]);
        }
        
        CGContextDrawPath(ctx, kCGPathStroke);
        ////////////////////////////////////////////////////////////CGContextSetFillColorWithColor(ctx, [color CGColor]);
        for (int i = 0; i < line.count; i++)
        {
            float x = kOffsetX + i * kStepX;
            float y = kGraphHeight - maxGraphHeight * [[line objectAtIndex:i] floatValue];
            CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            CGContextAddEllipseInRect(ctx, rect);
        }
        CGContextDrawPath(ctx, kCGPathFillStroke);//////////////////////////////////////////
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////
        colorIdx++;
    }
}

-(void)UpdateGraph:(int)xLength yLength:(float)yLength data:(NSArray*)data
{
    m_lines = data;
    kGraphHeight = self.frame.size.height;
    [img_line setFrame:CGRectMake(img_line.frame.origin.x, img_line.frame.origin.y, img_line.frame.size.width, self.frame.size.height)];
    kDefaultGraphWidth = self.frame.size.width;
    kStepY = kGraphHeight / yLength;
    kLineStepX = kDefaultGraphWidth / xLength;
    kLineStepY = kGraphHeight / yLength;
    kGraphBottom = kGraphHeight;
    
    [m_topPoints removeAllObjects];
    NSMutableArray* tmpAry = [[NSMutableArray alloc] init];
    int maxCount = 0;
    for(int j = 0; j < m_lines.count; j++)
    {
        NSArray* points = [[m_lines objectAtIndex:j] objectForKey:@"data"];
        if (points.count < 2)
            continue;
        if (maxCount < points.count)
            maxCount = points.count;
        for(int i = 0; i < points.count - 1; i++)
        {
            CGPoint firstPos = CGPointMake(kDefaultGraphWidth / (points.count - 1) * i, [[points objectAtIndex:i] floatValue] * kGraphHeight);
            CGPoint secondPos = CGPointMake(kDefaultGraphWidth / (points.count - 1) * (i + 1), [[points objectAtIndex:i + 1] floatValue] * kGraphHeight);
            NSArray* formula = [self GetFormula:firstPos secondPos:secondPos];
            for(int k = firstPos.x; k < secondPos.x; k++)
            {
                CGPoint pos = CGPointMake(k, [self GetY:[[formula objectAtIndex:0] floatValue] offset:[[formula objectAtIndex:1] floatValue] x:k]);
                [tmpAry addObject:[NSValue valueWithCGPoint:pos]];
            }
        }
    }
    kStepX = kDefaultGraphWidth / (maxCount - 1);
    for(int i = 0; i < kDefaultGraphWidth; i++)
    {
        float topY = 0;
        for(NSValue* value in tmpAry)
        {
            CGPoint pos = [value CGPointValue];
            if (pos.x == i && pos.y > topY)
            {
                topY = pos.y;
            }
        }
        [m_topPoints addObject:[NSNumber numberWithFloat:topY / kGraphHeight]];
    }
    [self setNeedsDisplay];
}

-(float)GetY:(float)ratio offset:(float)offset x:(float)x
{
    return x * ratio + offset;
}

-(NSArray*)GetFormula:(CGPoint)first secondPos:(CGPoint)secondPos
{
    float ratio = (secondPos.y - first.y) / (secondPos.x - first.x);
    float offset = secondPos.y - ratio * secondPos.x;
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:ratio], [NSNumber numberWithFloat:offset], nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [img_line setHidden:NO];
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [touch locationInView:self.superview];
    CGPoint posHere = [touch locationInView:self];
    int value = (posHere.x + kStepX / 2) / kStepX;
    img_line.center = CGPointMake(value * kStepX, img_line.center.y);
    [_delegate Captured:touchPos offset:value];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [img_line setHidden:NO];
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [touch locationInView:self.superview];
    if (CGRectContainsPoint(self.frame, touchPos))
    {
        CGPoint posHere = [touch locationInView:self];
        int value = (posHere.x + kStepX / 2) / kStepX;
        img_line.center = CGPointMake(value * kStepX, img_line.center.y);
        [_delegate TouchMoved:touchPos offset:value];
    }
    else
    {
        [img_line setHidden:YES];
        [_delegate Released];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [img_line setHidden:YES];
    [_delegate Released];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [img_line setHidden:YES];
    [_delegate Released];
}
@end
