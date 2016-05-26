//
//  BarWidgetAxisView.m
//  BrighterLink
//
//  Created by Andriy on 12/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "BarWidgetAxisView.h"

#import "BarWidgetGraphView.h"

#define METRIC_LABEL_WIDTH 20

#define Y_LABEL_WIDTH 50
#define X_LABEL_WIDTH 60

#define X_LABEL_INTERVAL_MIN 30

#define MIN_ONE_BAR_WIDTH 50

#define DYNAMIC_VIEW_TAG 1000

#define NUMBER_OF_ROW 4

#define FONT_SIZE 12

#define DegreesToRadians(x) ((x) * M_PI / - 180.0)

#define LINE_COLOR [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]

@interface BarWidgetAxisView()
{
    float _xLabelRegionHeight;
}

@end

@implementation BarWidgetAxisView

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

- (void) _init
{
    _maxY = 20;
    _xLabelRegionHeight = X_LABEL_WIDTH;
    
    CGSize size = self.frame.size;
    
    float width = size.width - (METRIC_LABEL_WIDTH + Y_LABEL_WIDTH);
    
    UILabel *lblMetric = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, METRIC_LABEL_WIDTH)];
    lblMetric.textColor = [UIColor blackColor];
    lblMetric.textAlignment = NSTextAlignmentCenter;
    lblMetric.font = [UIFont systemFontOfSize:14.0f];
    lblMetric.text = @"Metric";
    
    [self addSubview:lblMetric];
    self.lblMetric = lblMetric;
    lblMetric = nil;
    
    self.lblMetric.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
    
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.frame = CGRectMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH, 0, width, size.height);
    scrollview.backgroundColor = [UIColor clearColor];
    scrollview.clipsToBounds = NO;
    
    [self addSubview:scrollview];
    self.svContent = scrollview;
    scrollview = nil;
    
    BarWidgetGraphView *graphView = [[BarWidgetGraphView alloc] init];
    graphView.backgroundColor = [UIColor clearColor];
    graphView.frame = CGRectMake(0, 0, self.svContent.frame.size.width, self.svContent.frame.size.height);
    
    [self.svContent addSubview:graphView];
    
    self.graphView = graphView;
    graphView = nil;
}

- (void) layoutSubviews
{
    CGSize size = self.frame.size;
    
    float width = size.width - (METRIC_LABEL_WIDTH + Y_LABEL_WIDTH);
    
    self.lblMetric.frame = CGRectMake(0, 0, METRIC_LABEL_WIDTH, size.height);
    self.svContent.frame = CGRectMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH, 0, width, size.height);
    
    [self reloadDynmicSubview];
}

- (void) reloadDynmicSubview
{
    if(self.aryXLabels == nil) return;
    
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        if(subview.tag == DYNAMIC_VIEW_TAG)
        {
            [subview removeFromSuperview];
        }
    }
    
    [self drawGrid];
    
    [self drawYLabels];
    [self drawXLabels];
}

- (void) drawGrid
{
    CGSize size = self.frame.size;
    
    UIView *axisY = [[UIView alloc] init];
    axisY.tag = DYNAMIC_VIEW_TAG;
    axisY.frame = CGRectMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH, 0, 1, size.height - _xLabelRegionHeight);
    axisY.backgroundColor = [UIColor blackColor];
    
    [self addSubview:axisY];
    axisY = nil;
    
    UIView *axisX = [[UIView alloc] init];
    axisX.tag = DYNAMIC_VIEW_TAG;
    axisX.frame = CGRectMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH,
                             size.height - _xLabelRegionHeight,
                             size.width - (METRIC_LABEL_WIDTH + Y_LABEL_WIDTH),
                             1);
    
    axisX.backgroundColor = LINE_COLOR;
    
    [self addSubview:axisX];
    axisX = nil;
}

- (void) drawXLabels
{
    NSArray *subviews = [self.svContent subviews];
    for (UIView *subview in subviews) {
        if(subview.tag == DYNAMIC_VIEW_TAG)
        {
            [subview removeFromSuperview];
        }
    }
    
    CGSize size = self.frame.size;
    
    float width = size.width - (METRIC_LABEL_WIDTH + Y_LABEL_WIDTH);
    
    //float oneBarWidth = MAX(MIN_ONE_BAR_WIDTH, width / (self.aryXLabels.count + 1));
    float oneBarWidth = width / (self.aryXLabels.count + 1);
    
    int skipCount = 1;
    if(oneBarWidth > 0) skipCount = (int)(X_LABEL_INTERVAL_MIN / oneBarWidth) + 1;
    
    float xLabelRegionHeight = _xLabelRegionHeight;
    
    for (int n = 0 ; n < self.aryXLabels.count; n ++) {
        
        if(n % skipCount != 0) continue;
        
        UILabel *label = [self createAxisLabel:CGRectMake(0, 0, oneBarWidth, 20.0f) label:[self.aryXLabels objectAtIndex:n]];
        label.tag = DYNAMIC_VIEW_TAG;
        
        [label sizeToFit];
        
        float diff = label.frame.size.width / (2 * 1.414);
        
        label.center = CGPointMake((n + 1) * oneBarWidth - diff, size.height - _xLabelRegionHeight + diff + 5);
        
        if(label.frame.origin.x < 0)
        {
            label = nil;
            continue;
        }
        
        label.transform = CGAffineTransformMakeRotation(DegreesToRadians(45));
        [self.svContent addSubview:label];
        
        UIView *line = [self createLineView:LINE_COLOR];
        line.tag = DYNAMIC_VIEW_TAG;
        line.frame = CGRectMake((n + 1) * oneBarWidth, 0, 1, size.height - _xLabelRegionHeight);
        [self.svContent addSubview:line];
        
        float xLabelHeight = label.frame.size.width / 1.414 + 20;
        
        if(xLabelHeight > xLabelRegionHeight) xLabelRegionHeight = xLabelHeight;
        
        label = nil;
        line = nil;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height - _xLabelRegionHeight + xLabelRegionHeight);
    _xLabelRegionHeight = xLabelRegionHeight;
    
//    self.svContent.contentSize = CGSizeMake(oneBarWidth * (self.aryXLabels.count + 1), self.svContent.frame.size.height);
    self.graphView.frame = CGRectMake(0, 0, CGRectGetWidth(self.svContent.frame), CGRectGetHeight(self.svContent.frame) - _xLabelRegionHeight);
    [self.graphView setOneBarWidth:oneBarWidth];
    
    [self bringSubviewToFront:self.svContent];
    [self.svContent bringSubviewToFront:self.graphView];
}

- (void) drawYLabels
{
    int intervalY = (int)(self.maxY / NUMBER_OF_ROW);
    
    NSString *intervalString = [NSString stringWithFormat:@"%d", (int)self.maxY];
    int length = (int)intervalString.length;
    
    if(length > 2) length = length - 2;
    else length = 0;
    
    intervalY = intervalY / pow(10, length);
    intervalY = pow(10, length) * intervalY;
    
    CGSize size = self.frame.size;
    float scale = (size.height - _xLabelRegionHeight) / self.maxY;
    
    float basePosY = size.height - _xLabelRegionHeight;
    float intervalYBasedOnView = intervalY * scale;
    
    UILabel *label = [self createAxisLabel:CGRectMake(0, 0, Y_LABEL_WIDTH, 14.0f) label:[self getAxisLabelWithFloat:0.0f]];
    label.tag = DYNAMIC_VIEW_TAG;
    label.center = CGPointMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH / 2, basePosY);
    [self addSubview:label];
    label = nil;
    
    UIView *line = [self createLineView:LINE_COLOR];
    line.tag = DYNAMIC_VIEW_TAG;
    line.frame = CGRectMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH, basePosY, size.width - (METRIC_LABEL_WIDTH + Y_LABEL_WIDTH), 1);
    [self addSubview:line];
    line = nil;
    
    label = [self createAxisLabel:CGRectMake(0, 0, Y_LABEL_WIDTH, 14.0f) label:[self getAxisLabelWithFloat:self.maxY]];
    label.tag = DYNAMIC_VIEW_TAG;
    label.center = CGPointMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH / 2, 0);
    [self addSubview:label];
    label = nil;
    
    line = [self createLineView:LINE_COLOR];
    line.tag = DYNAMIC_VIEW_TAG;
    line.frame = CGRectMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH, 0, size.width - (METRIC_LABEL_WIDTH + Y_LABEL_WIDTH), 1);
    [self addSubview:line];
    line = nil;
    
    for (int n = 0 ; n < NUMBER_OF_ROW; n ++) {
        
        basePosY -= intervalYBasedOnView;
        
        if(basePosY < 15.0f) continue;
        
        float value = intervalY * (n + 1);
        
        label = [self createAxisLabel:CGRectMake(0, 0, Y_LABEL_WIDTH, 14.0f) label:[self getAxisLabelWithFloat:value]];
        label.tag = DYNAMIC_VIEW_TAG;
        label.center = CGPointMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH / 2, basePosY);
        [self addSubview:label];
        label = nil;
        
        line = [self createLineView:[UIColor lightGrayColor]];
        line.tag = DYNAMIC_VIEW_TAG;
        line.frame = CGRectMake(METRIC_LABEL_WIDTH + Y_LABEL_WIDTH, basePosY, size.width - (METRIC_LABEL_WIDTH + Y_LABEL_WIDTH), 1);
        [self addSubview:line];
        line = nil;
    }
    
}

- (UILabel *)createAxisLabel:(CGRect)frame label:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:FONT_SIZE];
    label.text = text;
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

- (UIView *)createLineView:(UIColor *)color
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    
    return line;
}

- (NSString *)getAxisLabelWithFloat:(float)value
{
    return [NSString stringWithFormat:@"%.1f", value];
}

- (void) setMaxY:(float)maxY
{
    _maxY = maxY;
    
    self.graphView.maxValue = _maxY;
    
    [self reloadDynmicSubview];
}

- (void) setAryXLabels:(NSArray *)aryXLabels
{
    _aryXLabels = aryXLabels;
    
    [self reloadDynmicSubview];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate scrolledGraph];
}

@end
