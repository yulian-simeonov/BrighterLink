//
//  BarWidgetGraphView.m
//  BrighterLink
//
//  Created by Andriy on 12/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "BarWidgetGraphView.h"

#import "SharedMembers.h"

@implementation BarWidgetGraphView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize size = self.frame.size;
    
    float barWidth = self.oneBarWidth * 0.7f;
    float segBarWidth = barWidth / self.aryDatas.count;
    
    for (int segment = 0 ; segment < self.aryDatas.count ; segment ++) {
        
        NSDictionary *dic = [self.aryDatas objectAtIndex:segment];
        
        UIColor *color = [dic objectForKey:@"color"];
        NSArray *segmentData = [dic objectForKey:@"value"];
        
        for (int index = 0; index < segmentData.count; index ++) {
            
            NSNumber *value = [segmentData objectAtIndex:index];
            
            double dValue = [value doubleValue];
            
            float barHeight = size.height * dValue / self.maxValue;
            
            CGRect rt = CGRectMake((index + 1) * self.oneBarWidth - barWidth / 2 + segBarWidth * segment, size.height - barHeight, segBarWidth, barHeight);
            
            [self drawBarWithContext:context rect:rt color:color];
        }
    }
}

- (void)drawBarWithContext:(CGContextRef)ctx rect:(CGRect) rect color:(UIColor *)color
{
    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    
    CGContextAddRect(ctx, rect);

    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void) setGraphDatas:(NSMutableArray *)aryDatas
{
    self.aryDatas = aryDatas;
    
    [self setNeedsDisplay];
}

- (void) setOneBarWidth:(float)oneBarWidth
{
    _oneBarWidth = oneBarWidth;
    
    [self setNeedsDisplay];
}

- (int) getSegmentIndexWithPoint:(CGPoint)point index:(int *)graphIndex
{
    CGSize size = self.frame.size;
    
    float barWidth = self.oneBarWidth * 0.7f;
    float segBarWidth = barWidth / self.aryDatas.count;
    
    for (int segment = 0 ; segment < self.aryDatas.count ; segment ++) {
        
        NSDictionary *dic = [self.aryDatas objectAtIndex:segment];
        
        NSArray *segmentData = [dic objectForKey:@"value"];
        
        for (int index = 0; index < segmentData.count; index ++) {
            
            NSNumber *value = [segmentData objectAtIndex:index];
            
            double dValue = [value doubleValue];
            
            float barHeight = size.height * dValue / self.maxValue;
            
            CGRect rt = CGRectMake((index + 1) * self.oneBarWidth - barWidth / 2 + segBarWidth * segment, size.height - barHeight, segBarWidth, barHeight);
            
            if(CGRectContainsPoint(rt, point))
            {
                *graphIndex = index;
                
                return segment;
            }
        }
    }
    
    return -1;
}

- (void) showDetailInfo:(int)segment index:(int)index point:(CGPoint)point
{
    if(self.aryDatas.count <= segment) return;
    
    NSDictionary *segmentInfo = [self.aryDatas objectAtIndex:0];
    NSArray *segmentData = [segmentInfo objectForKey:@"value"];
    
    if(segmentData.count <= index) return;
    
    NSDictionary *dic = [self.aryDatas objectAtIndex:segment];
    
    NSString *name = [dic objectForKey:@"name"];
    
    [self.delegate showGraphDetailInfo:self segment:name index:index point:point];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint posHere = [touch locationInView:self];
    
    int index = 0;
    int segment = [self getSegmentIndexWithPoint:posHere index:&index];
    
    if(segment != -1)
        [self showDetailInfo:segment index:index point:posHere];
    else
        [self.delegate hideGraphDetailInfo:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchPos = [touch locationInView:self.superview];
    if (CGRectContainsPoint(self.frame, touchPos))
    {
        CGPoint posHere = [touch locationInView:self];

        int index = 0;
        int segment = [self getSegmentIndexWithPoint:posHere index:&index];
        
        if(segment != -1)
            [self showDetailInfo:segment index:index point:posHere];
        else
            [self.delegate hideGraphDetailInfo:self];
    }
    else
    {

        [self.delegate hideGraphDetailInfo:self];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate hideGraphDetailInfo:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate hideGraphDetailInfo:self];
}

@end
