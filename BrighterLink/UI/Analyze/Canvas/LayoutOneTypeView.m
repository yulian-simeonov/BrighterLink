//
//  LayoutOneTypeView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "LayoutOneTypeView.h"

#import "CanvasView.h"

@interface LayoutOneTypeView()
{

}

@property (nonatomic, assign) IBOutlet UILabel *label1;
@property (nonatomic, assign) IBOutlet UILabel *label2;
@property (nonatomic, assign) IBOutlet UILabel *label3;
@property (nonatomic, assign) IBOutlet UILabel *label4;

@end

@implementation LayoutOneTypeView

- (void) awakeFromNib
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
    
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

- (void) initView
{

}

- (void) setCanvasType:(NSInteger)type
{
    self.type = type;
    
    [self updateUI];
}

- (void) setSelected:(BOOL)selected
{
    _selected = selected;
    
    [self updateUI];
}

- (void) updateUI
{
    UIColor *selectedColor = [UIColor colorWithRed:29.0f / 255.0f green:200.0f / 255.0f blue:113.0f / 255.0f alpha:1.0f];
    UIColor *normalColor = [UIColor colorWithRed:236.0f / 255.0f green:240.0f / 255.0f blue:241.0f / 255.0f alpha:1.0f];
    
    UIColor *color = self.selected ? selectedColor : normalColor;
    
    self.layer.cornerRadius = 2.0f;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 2.0f;
    self.clipsToBounds = YES;
    
    switch (self.type) {
        case CanvasType1:
        {
            self.label1.text = @"100%";
            self.label1.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            self.label2.text = @"";
            self.label2.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            self.label3.text = @"";
            self.label3.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            self.label4.text = @"";
            self.label4.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }
            break;
            
        case CanvasType2:
        {
            self.label1.text = @"50%";
            self.label1.center = CGPointMake(self.frame.size.width * 0.25, self.frame.size.height / 2);
            
            self.label2.text = @"50%";
            self.label2.center = CGPointMake(self.frame.size.width * 0.75, self.frame.size.height / 2);
            
            self.label3.text = @"";
            self.label3.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            self.label4.text = @"";
            self.label4.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }
            break;
            
        case CanvasType3:
        {
            self.label1.text = @"25%";
            self.label1.center = CGPointMake(self.frame.size.width / 8, self.frame.size.height / 2);
            
            self.label2.text = @"25%";
            self.label2.center = CGPointMake(self.frame.size.width * 3 / 8, self.frame.size.height / 2);
            
            self.label3.text = @"25%";
            self.label3.center = CGPointMake(self.frame.size.width * 5 / 8, self.frame.size.height / 2);
            
            self.label4.text = @"25%";
            self.label4.center = CGPointMake(self.frame.size.width * 7 / 8, self.frame.size.height / 2);
        }
            break;
            
        case CanvasType4:
        {
            self.label1.text = @"25%";
            self.label1.center = CGPointMake(self.frame.size.width / 8, self.frame.size.height / 2);
            
            self.label2.text = @"75%";
            self.label2.center = CGPointMake(self.frame.size.width * 5 / 8, self.frame.size.height / 2);
            
            self.label3.text = @"";
            self.label3.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            self.label4.text = @"";
            self.label4.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }
            break;
            
        case CanvasType5:
        {
            self.label1.text = @"25%";
            self.label1.center = CGPointMake(self.frame.size.width / 8, self.frame.size.height / 2);
            
            self.label2.text = @"50%";
            self.label2.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            self.label3.text = @"25%";
            self.label3.center = CGPointMake(self.frame.size.width * 7 / 8, self.frame.size.height / 2);
            
            self.label4.text = @"";
            self.label4.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }
            break;
            
        case CanvasType6:
        {
            self.label1.text = @"75%";
            self.label1.center = CGPointMake(self.frame.size.width * 3 / 8, self.frame.size.height / 2);
            
            self.label2.text = @"25%";
            self.label2.center = CGPointMake(self.frame.size.width * 7 / 8, self.frame.size.height / 2);
            
            self.label3.text = @"";
            self.label3.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            self.label4.text = @"";
            self.label4.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

- (void) tapSelf
{
    [self.delegate selectLayoutType:self.type];
}

- (void)drawRect:(CGRect)rect {
    
    UIColor *selectedColor = [UIColor colorWithRed:29.0f / 255.0f green:200.0f / 255.0f blue:113.0f / 255.0f alpha:1.0f];
    UIColor *normalColor = [UIColor colorWithRed:236.0f / 255.0f green:240.0f / 255.0f blue:241.0f / 255.0f alpha:1.0f];
    
    UIColor *color = self.selected ? selectedColor : normalColor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGFloat dashArray[] = {2, 2};
    
    CGContextSetLineDash(context, 2, dashArray, 2);
    
    float top = 20;
    float barheight = self.frame.size.height - 2 * top;
    
    float width = self.frame.size.width;
    
    switch (self.type) {
        case CanvasType1:
        {
            
        }
            break;
            
        case CanvasType2:
        {
            CGContextMoveToPoint(context, width / 2 , top);
            CGContextAddLineToPoint(context, width / 2, top + barheight);
            CGContextStrokePath(context);
        }
            break;
            
        case CanvasType3:
        {
            CGContextMoveToPoint(context, width / 4 , top);
            CGContextAddLineToPoint(context, width / 4, top + barheight);
            CGContextStrokePath(context);
            
            CGContextMoveToPoint(context, width / 2 , top);
            CGContextAddLineToPoint(context, width / 2, top + barheight);
            CGContextStrokePath(context);
            
            CGContextMoveToPoint(context, width * 3 / 4 , top);
            CGContextAddLineToPoint(context, width * 3 / 4, top + barheight);
            CGContextStrokePath(context);
        }
            break;
            
        case CanvasType4:
        {
            CGContextMoveToPoint(context, width / 4 , top);
            CGContextAddLineToPoint(context, width / 4, top + barheight);
            CGContextStrokePath(context);
        }
            break;
            
        case CanvasType5:
        {
            CGContextMoveToPoint(context, width / 4 , top);
            CGContextAddLineToPoint(context, width / 4, top + barheight);
            CGContextStrokePath(context);
            
            CGContextMoveToPoint(context, width * 3 / 4 , top);
            CGContextAddLineToPoint(context, width * 3 / 4, top + barheight);
            CGContextStrokePath(context);
        }
            break;
            
        case CanvasType6:
        {
            CGContextMoveToPoint(context, width * 3 / 4 , top);
            CGContextAddLineToPoint(context, width * 3 / 4, top + barheight);
            CGContextStrokePath(context);
        }
            break;
            
        default:
            break;
    }
}

@end
