//
//  SourceColorIconView.m
//  BrighterLink
//
//  Created by Andriy on 11/19/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SourceColorIconView.h"

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees *  PI / 180; }

@implementation SourceColorIconView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithSymbolColor:(UIColor *)color banner:(UIColor *)bannerColor width:(int)bannerWidth
{
    
    self = [super initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (self) {
        
        self.symbolColor = color;
        self.bannerColor = bannerColor;
        
        self.bannerWidth = bannerWidth;
        
    }
    return self;
}

- (void) layoutSubviews
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGRect parentViewBounds = self.bounds;
    CGFloat x = CGRectGetWidth(parentViewBounds) / 2;
    CGFloat y = CGRectGetHeight(parentViewBounds) / 2;
    
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // define stroke color
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
    
    // define line width
    CGContextSetLineWidth(ctx, 4.0);
    
    
    // need some values to draw pie charts
    
    double fullangle = 360.0;
    
    double dStartAngle = 180.0;
    double dAngle = fullangle * 0.25;
    
    double fradius = self.frame.size.width / 2;
    
    CGContextSetFillColor(ctx, CGColorGetComponents( [self.bannerColor CGColor]));
    CGContextMoveToPoint(ctx, x, y);
    CGContextAddArc(ctx, x, y, fradius,  radians(dStartAngle), radians(dStartAngle + fullangle), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextSetFillColor(ctx, CGColorGetComponents( [self.symbolColor CGColor]));
    CGContextMoveToPoint(ctx, x, y);
    CGContextAddArc(ctx, x, y, fradius,  radians(dStartAngle), radians(dStartAngle + dAngle), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    fradius -= self.bannerWidth;
    
    CGContextSetFillColor(ctx, CGColorGetComponents( [[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.0f] CGColor]));
    CGContextMoveToPoint(ctx, x, y);
    CGContextAddArc(ctx, x, y, fradius,  radians(dStartAngle), radians(dStartAngle + fullangle), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
}

@end
