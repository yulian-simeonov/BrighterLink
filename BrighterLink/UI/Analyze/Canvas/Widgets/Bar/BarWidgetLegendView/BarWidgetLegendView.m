//
//  BarWidgetLegendView.m
//  BrighterLink
//
//  Created by Andriy on 12/11/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "BarWidgetLegendView.h"

#import "SharedMembers.h"

@interface BarWidgetLegendView ()

@property (nonatomic, assign) UIScrollView *svMain;

@property (nonatomic, retain) NSMutableArray *arySegments;

@end

@implementation BarWidgetLegendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    if (self = [super init])
    {
        [self _init];
    }
    
    return self;
}

- (void) layoutSubviews
{
    self.svMain.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self reloadLegend];
}

- (void) _init
{
    UIScrollView *svMain = [[UIScrollView alloc] init];
    svMain.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self addSubview:svMain];
    self.svMain = svMain;
    svMain = nil;
}

- (void) setSegmentList:(NSArray *)arySegments
{
    self.arySegments = nil;
    self.arySegments = [[NSMutableArray alloc] initWithCapacity:arySegments.count];
    
    for (int n = 0 ; n < arySegments.count ; n ++) {
        
        NSString *segmentName = [arySegments objectAtIndex:n];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:segmentName, SEGMENT_NAME, [NSNumber numberWithBool:YES], SEGMENT_STATE, nil];
        
        [self.arySegments addObject:dic];
    }
    
    [self reloadLegend];
}

- (void) reloadLegend
{
    NSArray *subviews = self.svMain.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.svMain.frame.size.width, self.svMain.frame.size.height);
    
    float pos = 0;
    float colorCircleSize = 10; float gap = 10;
    for (int index = 0 ; index < self.arySegments.count ; index ++) {
        
        NSDictionary *segment = [self.arySegments objectAtIndex:index];
        
        NSString *segmentName = [segment objectForKey:SEGMENT_NAME];
        BOOL state = [[segment objectForKey:SEGMENT_STATE] boolValue];
        
        UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, view.frame.size.height)];
        segmentView.tag = index;
        
        UIView *viewColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, colorCircleSize, colorCircleSize)];
        
        if(state)
        {
            viewColor.backgroundColor = [[SharedMembers sharedInstance] getSegmentColorWithIndex:index];
        }
        else
        {
            viewColor.backgroundColor = [UIColor whiteColor];
            viewColor.layer.borderWidth = 1.0f;
            viewColor.layer.borderColor = [[SharedMembers sharedInstance] getSegmentColorWithIndex:index].CGColor;
        }

        viewColor.layer.cornerRadius = colorCircleSize / 2;
        viewColor.center = CGPointMake(colorCircleSize / 2, segmentView.frame.size.height / 2);
        
        [segmentView addSubview:viewColor];
        viewColor = nil;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, segmentView.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12.0f];
        
        label.text = segmentName;
        [label sizeToFit];
        
        label.frame = CGRectMake(colorCircleSize + 2, (segmentView.frame.size.height - label.frame.size.height) / 2, label.frame.size.width, label.frame.size.height);
        
        [segmentView addSubview:label];
        
        float segmentViewWidth = label.frame.origin.x + label.frame.size.width;
        
        label = nil;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSegment:)];
        [segmentView addGestureRecognizer:tapGesture];
        tapGesture = nil;
        
        segmentView.frame = CGRectMake(pos, 0, segmentViewWidth, view.frame.size.height);
        
        [view addSubview:segmentView];
        segmentView = nil;
        
        pos += (segmentViewWidth + gap);
    }
    
    float viewPos = MAX(0, self.svMain.frame.size.width - pos);
    
    view.frame = CGRectMake(viewPos, 0, pos, self.svMain.frame.size.height);
    
    [self.svMain addSubview:view];
    view = nil;
    
    self.svMain.contentSize = CGSizeMake(pos, self.svMain.frame.size.height);
}

- (void) tapSegment:(UIGestureRecognizer *)gesture
{
    NSInteger index = gesture.view.tag;
    
    NSMutableDictionary *segment = [self.arySegments objectAtIndex:index];
    
    BOOL state = [[segment objectForKey:SEGMENT_STATE] boolValue];
    
    [segment setValue:[NSNumber numberWithBool:!state] forKey:SEGMENT_STATE];
    
    BOOL isShowSegment = NO;
    for (NSMutableDictionary *segment in self.arySegments) {
        
        isShowSegment = [[segment objectForKey:SEGMENT_STATE] boolValue];
        
        if(isShowSegment) break;
    }
    
    if(!isShowSegment)
    {
        for (NSMutableDictionary *segment in self.arySegments) {
            
            [segment setValue:[NSNumber numberWithBool:YES] forKey:SEGMENT_STATE];
        }
    }
    
    [self.delegate updatedSegmentStateData:self.arySegments];
    
    [self reloadLegend];
}

@end
