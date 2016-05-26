//
//  ControlBar.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "ControlBar.h"

#import "SharedMembers.h"

#import "SourceColorIconView.h"

@interface ControlBar()

@property (nonatomic, assign) IBOutlet UIScrollView *svSources;

@end

@implementation ControlBar

- (void) awakeFromNib
{
    [self initView];
}

- (void) initView
{
    [self reloadSources];
}

- (void) reloadSources
{
    NSArray *arySubViews = self.svSources.subviews;
    for (UIView *subview in arySubViews) {
        [subview removeFromSuperview];
    }
    
    NSArray *segments = [SharedMembers sharedInstance].currentDashboard.segments;
    NSInteger count = segments.count;
    
    float sourceHeight = 32; float gap = 10;
    float pos = gap;
    for (int n = 0 ; n < count; n ++) {
        
        SegmentInfo *segment = [segments objectAtIndex:n];
        
        NSString *title = segment.name;
    
        UIButton *button = [self createSourceButton:CGSizeMake(300, sourceHeight) title:title];
        button.tag = n;
        button.center = CGPointMake(pos + button.frame.size.width / 2, CGRectGetHeight(self.svSources.frame) / 2);
        
        [self.svSources addSubview:button];
        
        UIColor *symbolColor = [[SharedMembers sharedInstance].arySegmentColors objectAtIndex:n];
        UIColor *bannerColor = [UIColor colorWithRed:192.0f / 255.0f green:192.0f / 255.0f blue:192.0f / 255.0f alpha:1.0f];
        
        SourceColorIconView *iconView = [[SourceColorIconView alloc] initWithSymbolColor:symbolColor banner:bannerColor width:4];
        iconView.backgroundColor = [UIColor clearColor];
        [iconView setNeedsDisplay];
        
        iconView.center = CGPointMake(button.frame.origin.x + 16, CGRectGetHeight(self.svSources.frame) / 2);
        
        [self.svSources addSubview:iconView];
        iconView = nil;
        
        pos += button.frame.size.width + gap;
        
        button = nil;
    }
    
    UIButton *button = [self createAddSourceButton];
    
    pos += gap;
    
    button.center = CGPointMake(pos + button.frame.size.width / 2, CGRectGetHeight(self.svSources.frame) / 2);
    
    [self.svSources addSubview:button];
    
    CGSize size = CGSizeMake(button.frame.origin.x + button.frame.size.width * 2, self.svSources.frame.size.height);
    self.svSources.contentSize = size;
    
    button = nil;
}

- (UIButton *) createAddSourceButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [button setImage:[UIImage imageNamed:@"analyze_btn_add1"] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [button addTarget:self action:@selector(onAddNewSource:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [button setTitleColor:[UIColor colorWithRed:46.0f / 255.0f green:153.0f / 255.0f blue:216.0f / 255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 3;
    button.layer.borderColor = [UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f].CGColor;
    button.layer.borderWidth = 1;
    
    return button;
}

- (UIButton *) createSourceButton:(CGSize)size title:(NSString *)title
{
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];

    title = [NSString stringWithFormat:@"        %@", title];
    CGSize szTitle = [title sizeWithFont:font constrainedToSize:CGSizeMake(200, size.height)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, szTitle.width + 30, size.height)];
    [button addTarget:self action:@selector(onEditSource:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"dashboard_icon_source"] forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 3;
    button.layer.borderColor = [UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f].CGColor;
    button.layer.borderWidth = 1;
    
    return button;
}

- (IBAction)onAddNewSource:(id)sender
{
    [self.delegate addNewSource];
}

- (IBAction)onEditSource:(id)sender
{
    NSInteger index = ((UIButton *)sender).tag;
    
    if(index >= [SharedMembers sharedInstance].currentDashboard.segments.count)
        return;
    
    SegmentInfo *segment = [[SharedMembers sharedInstance].currentDashboard.segments objectAtIndex:index];
    
    [self.delegate editSource:segment];
}

- (IBAction)onAddNewWidget:(id)sender
{
    [self.delegate addNewWidget];
}

- (IBAction)onLayout:(id)sender
{
    [self.delegate editLayout];
}

- (IBAction)onDelete:(id)sender
{
    [self.delegate deleteCurrentDashboard];
}

- (IBAction)onEdit:(id)sender
{
    [self.delegate editCurrentDashboard];
}

- (void) _update
{
    self.lblTitle.text = [SharedMembers sharedInstance].currentDashboard.title;
    
    [self reloadSources];
}

@end
