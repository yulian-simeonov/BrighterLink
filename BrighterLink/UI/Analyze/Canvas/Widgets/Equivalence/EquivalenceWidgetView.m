//
//  EquivalenceWidgetView.m
//  BrighterLink
//
//  Created by Andriy on 1/6/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import "EquivalenceWidgetView.h"

#import "EquivalenceSegmentView.h"

#define EQUIVALENCE_CONTENT_GAP 5
#define EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT 20

@interface EquivalenceWidgetView()

@property (nonatomic, assign) UIView *viewShowAllTime;
@property (nonatomic, assign) UIScrollView *svMain;

@end

@implementation EquivalenceWidgetView

- (id) initWithParent:(UIView *)parent
{
    if (self = [super init])
    {
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor colorWithRed:211.0f / 255.0f green:238.0f / 255.0f blue:223.0f / 255.0f alpha:1.0f];
        self.layer.cornerRadius = 5;
        self.frame = CGRectMake(0, 0, parent.frame.size.width, [self getWidgetHeight]);
        
        [parent addSubview:self];
    }
    
    return self;
}

- (void) _init
{
    [super _init];
    
    [self initView];
}

- (void) initView
{
    CGSize szWidget = self.frame.size;
    
    [self createShowAllTimeView];
    
    float topPos = WIDGET_TITLEBAR_HEIGHT + EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(EQUIVALENCE_CONTENT_GAP, topPos, szWidget.width - EQUIVALENCE_CONTENT_GAP * 2, szWidget.height - topPos)];
    scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:scrollView];
    self.svMain = scrollView;
    scrollView = nil;
}

- (void) createShowAllTimeView
{
    float gap = 5;
    
    UIView *viewShowAllTime = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT, EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"analyze_icon_showalltime"];
    
    [viewShowAllTime addSubview:imageView];
    imageView = nil;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"DATA IS FOR ALL TIME";
    label.font = [UIFont systemFontOfSize:20.0f];
    label.textColor = [UIColor colorWithRed:0.0f / 255.0f green:133.0f / 255.0f blue:112.0f / 255.0f alpha:1.0f];
    
    [label sizeToFit];
    
    label.center = CGPointMake(EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT + gap + label.frame.size.width / 2, EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT / 2);
    
    [viewShowAllTime addSubview:label];
    
    viewShowAllTime.frame = CGRectMake(0, 0, EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT + label.frame.size.width + gap, EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT);
    
    viewShowAllTime.center = CGPointMake(self.frame.size.width / 2, WIDGET_TITLEBAR_HEIGHT + EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT / 2);
    
    [self addSubview:viewShowAllTime];
    self.viewShowAllTime = viewShowAllTime;
    viewShowAllTime = nil;
    label = nil;
}

- (float) getWidgetHeight
{
    return EQUIVALENCE_SEG_HEIGHT;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self updateUI];
}

-(void)UpdateWidget
{
    [super UpdateWidget];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self getWidgetHeight]);
    
    [self updateUI];
}

- (void) updateUI
{
    CGSize szWidget = self.frame.size;
    
    if(szWidget.height == WIDGET_TITLEBAR_HEIGHT) return; //in case of collapse
    
    BOOL showAllTime = [self showAllTime];
    
    float topPos = WIDGET_TITLEBAR_HEIGHT;
    if(showAllTime)
    {
        self.viewShowAllTime.hidden = NO;
        self.viewShowAllTime.center = CGPointMake(szWidget.width / 2, WIDGET_TITLEBAR_HEIGHT + EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT / 2);
        
        topPos = WIDGET_TITLEBAR_HEIGHT + EQUIVALENCE_WIDGET_SHOWALLTIME_HEIGHT;
    }
    else
    {
        self.viewShowAllTime.hidden = YES;
        
        topPos = WIDGET_TITLEBAR_HEIGHT;
    }
    
    self.svMain.frame = CGRectMake(EQUIVALENCE_CONTENT_GAP, topPos, szWidget.width - EQUIVALENCE_CONTENT_GAP * 2, szWidget.height - topPos);
    
    if(self.WgComparisionData != nil)
    {
        [self loadAllDatas];
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CANVAS object:nil];
}

- (void) loadAllDatas
{
    NSArray *subviews = self.svMain.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    NSMutableArray *aryEquivalenceDatas = [[NSMutableArray alloc] init];
    
    NSArray *aryPrimaryData = [self.WgComparisionData objectForKey:@"primaryDateRange"];
    
    for (int n = 0 ; n < aryPrimaryData.count; n ++) {
        
        NSDictionary *segmentData = [aryPrimaryData objectAtIndex:n];
        
        if(segmentData.allValues.count == 0) continue;
        
        NSArray *arySegmentData = [segmentData.allValues objectAtIndex:0];
        
        if(arySegmentData.count == 0) continue;
        
        NSDictionary *segmentPrimaryData = [arySegmentData objectAtIndex:0];
        
        if(segmentPrimaryData.allValues.count == 0) continue;
        
        NSDictionary *equivalenceData = [segmentPrimaryData.allValues objectAtIndex:0];
        
        [aryEquivalenceDatas addObject:equivalenceData];
    }
    
    float pos = 0; float width = 0 ; float height = 0;
    for (int n = 0 ; n < aryEquivalenceDatas.count; n ++) {
        
        NSDictionary *equivalenceData = [aryEquivalenceDatas objectAtIndex:n];
        
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EquivalenceSegmentView" owner:self options:nil];
        EquivalenceSegmentView *equivalenceSegmentView = [nib objectAtIndex:0];
        equivalenceSegmentView.clipsToBounds = YES;
        equivalenceSegmentView.backgroundColor = [UIColor clearColor];
        equivalenceSegmentView.frame = CGRectMake(0, 0, self.svMain.frame.size.width, 100);
        [equivalenceSegmentView setEquivalenceSegmentData:equivalenceData type:[self.WgInfo objectForKey:@"equivType"] co:[self showCO] green:[self showGreen] index:n];
        
        CGSize szView = equivalenceSegmentView.frame.size;
        
        CGPoint center = CGPointZero;
        if([self isVertical])
        {
            center = CGPointMake(self.svMain.frame.size.width / 2, pos + szView.height / 2);
            pos += szView.height;
            
            width = self.svMain.frame.size.width;
            height = pos;
        }
        else
        {
            center = CGPointMake(pos + szView.width / 2, szView.height / 2);
            pos += szView.width;
            
            width = pos;
            height = szView.height;
        }
        
        equivalenceSegmentView.center = center;
        
        [self.svMain addSubview:equivalenceSegmentView];
    }
    
    self.svMain.frame = CGRectMake(self.svMain.frame.origin.x, self.svMain.frame.origin.y, self.svMain.frame.size.width, height);
    self.svMain.contentSize = CGSizeMake(width, height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.svMain.frame.origin.y + self.svMain.frame.size.height);
}

- (BOOL) isVertical
{
    return YES;
    
    NSString *orientation = [self.WgInfo objectForKey:@"orientation"];
    
    BOOL isVer = [orientation isEqualToString:@"vertical"];
    
    return isVer;
}

- (BOOL) showCO
{
    BOOL showCOValue = [[self.WgInfo objectForKey:@"co2Kilograms"] boolValue];
    
    return showCOValue;
}

- (BOOL) showGreen
{
    BOOL showGreenValue = [[self.WgInfo objectForKey:@"greenhouseKilograms"] boolValue];
    
    return showGreenValue;
}

- (BOOL) showAllTime
{
    BOOL showAllTimeState = [[self.WgInfo objectForKey:@"showAllTime"] boolValue];
    
    return showAllTimeState;
}

@end
