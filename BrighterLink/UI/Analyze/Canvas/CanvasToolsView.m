//
//  CanvasToolsView.m
//  BrighterLink
//
//  Created by Andriy on 12/2/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "CanvasToolsView.h"

@interface CanvasToolsView()
{
    CGFloat firstX;
    CGFloat firstY;
}

@property (nonatomic, assign) IBOutlet UIImageView *ivMove;

@property (nonatomic, assign) BOOL isMinimized;

@end

@implementation CanvasToolsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.isMinimized = NO;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoveIcon:)];
    
    [self.ivMove addGestureRecognizer:panGesture];
    panGesture = nil;
    
    [self updateUI];
}

- (IBAction)onEdit:(id)sender
{
    [self.delegate editWidgetView:self];
}

- (IBAction)onTrash:(id)sender
{
    [self.delegate deleteWidgetView:self];
}

- (IBAction)onMinize:(id)sender
{
    if(self.isMinimized)
    {
        [self.delegate maxmizeCurrentWidgetView:self];
        
        self.isMinimized = NO;
    }
    else
    {
        [self.delegate minimizeCurrentWidgetView:self];
        
        self.isMinimized  = YES;
    }
    
    [self updateUI];
}

- (IBAction)onExpand:(id)sender
{
    [self.delegate expandWidgetView:self];
}

- (void)panMoveIcon:(UIGestureRecognizer *)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.ivMove];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        firstX = [self center].x;
        firstY = [self center].y;
        
        [self.delegate startDragWidgetView:self];
    }
    else if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged)
    {
        translatedPoint = CGPointMake(firstX + translatedPoint.x, firstY + translatedPoint.y);
        
        [self setCenter:translatedPoint];
        
        [self.delegate moveDragWidgetView:self];
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        [self.delegate stopDragWidgetView:self];
    }
}

- (void) setMinimizeState:(BOOL)isMinimized
{
    self.isMinimized = isMinimized;
    
    [self updateUI];
}

- (void) updateUI
{
    if(self.isMinimized)
    {
        [self.btnMinimize setImage:[UIImage imageNamed:@"analyze_icon_arrow_down"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnMinimize setImage:[UIImage imageNamed:@"analyze_icon_arrow_up"] forState:UIControlStateNormal];
    }
}

@end
