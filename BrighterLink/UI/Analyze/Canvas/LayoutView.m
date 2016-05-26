//
//  LayoutView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "LayoutView.h"

#import "CanvasView.h"
#import "LayoutOneTypeView.h"

@interface LayoutView()<LayoutOneTypeViewDelegate>
{

}

@property (nonatomic, assign) IBOutlet UIView *viewMain;

@property (nonatomic, assign) IBOutlet UIButton *btnSave;

@end

@implementation LayoutView

- (void) awakeFromNib
{
    [self initView];
}

- (void) initView
{
    self.btnSave.layer.cornerRadius = 3.0f;
    self.btnSave.clipsToBounds = YES;
    self.btnSave.backgroundColor = [UIColor whiteColor];
    self.btnSave.layer.borderColor = [UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f].CGColor;
    self.btnSave.layer.borderWidth = 1.0f;
    
    [self bringSubviewToFront:self.viewMain];
    
    float gap = 20; float interval = 10; float top = 60;
    float width = (self.viewMain.frame.size.width - 2 * gap - 2 * interval ) / 3;
    float height = (290 - 2 * gap - interval ) / 2;
    
    for (int n = CanvasType1 ; n <= CanvasType6 ; n ++) {
        
        int row = (n - 1) / 3;
        int col = (n - 1) % 3;
        
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"LayoutOneTypeView" owner:self options:nil];
        LayoutOneTypeView *layoutTypeView = [nib objectAtIndex:0];
        layoutTypeView.tag = n;
        layoutTypeView.frame = CGRectMake(gap + (width + interval) * col,
                                          top + gap + (height + interval) * row,
                                          width,
                                          height);
        
        layoutTypeView.delegate = self;
        
        [self.viewMain addSubview:layoutTypeView];
        [layoutTypeView setCanvasType:n];
    }
}

- (IBAction)onSave:(id)sender
{
    [self.delegate changedLayoutType:self.layoutType];
    
    [self removeFromSuperview];
}

- (void) setLayoutType:(NSInteger)layoutType
{
    _layoutType = layoutType;
    
    [self updateUI];
}

- (void) updateUI
{
    for (int n = CanvasType1 ; n <= CanvasType6 ; n ++) {

        LayoutOneTypeView *layoutTypeView = (LayoutOneTypeView *)[self.viewMain viewWithTag:n];
        
        layoutTypeView.selected = n == self.layoutType;
    }
}

#pragma mark LayoutOneTypeViewDelegate

- (void) selectLayoutType:(NSInteger) type
{
    [self setLayoutType:type];
}

@end
