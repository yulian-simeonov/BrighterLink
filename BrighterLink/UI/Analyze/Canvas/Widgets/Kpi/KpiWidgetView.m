//
//  KpiWidgetView.m
//  BrighterLink
//
//  Created by Andriy on 2/4/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import "KpiWidgetView.h"

#define KPI_WIDGET_HEIGHT 170

#define KPI_METHOD_HEIGHT 40
#define KPI_METRIC_HEIGHT 20
#define KPI_COMPAREMETRIC_HEIGHT 12

@interface KpiWidgetView()

@property (nonatomic, assign) UILabel *lblSummaryMethod;

@property (nonatomic, assign) UILabel *lblMetricLabel;
@property (nonatomic, assign) UILabel *lblMetricValue;
@property (nonatomic, assign) UILabel *lblLabel;

@property (nonatomic, assign) UILabel *lblCompareMetricLabel;
@property (nonatomic, assign) UILabel *lblCompareMetricValue;
@property (nonatomic, assign) UILabel *lblCompareLabel;

@end

@implementation KpiWidgetView

- (id) initWithParent:(UIView *)parent
{
    if (self = [super init])
    {
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor colorWithRed:255.0f / 255.0f green:254.0f / 255.0f blue:215.0f / 255.0f alpha:1.0f];
        self.layer.cornerRadius = 5;
        self.frame = CGRectMake(0, 0, parent.frame.size.width, 200);
        
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, szWidget.width, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    self.lblSummaryMethod = label;
    label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, szWidget.width, 30)];
    label.textColor = [UIColor colorWithRed:121.0f / 255.0f green:121.0f / 255.0f blue:121.0f / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"metric: ";
    [label sizeToFit];
    
    [self addSubview:label];
    self.lblMetricLabel = label;
    label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, szWidget.width, 30)];
    label.textColor = [UIColor colorWithRed:255.0f / 255.0f green:106.0f / 255.0f blue:0.0f / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    self.lblMetricValue = label;
    label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, szWidget.width, 30)];
    label.textColor = [UIColor colorWithRed:121.0f / 255.0f green:121.0f / 255.0f blue:121.0f / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    self.lblLabel = label;
    label = nil;
    
    //-------- compare -----------
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, szWidget.width, 30)];
    label.textColor = [UIColor colorWithRed:203.0f / 255.0f green:202.0f / 255.0f blue:202.0f / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"compare: ";
    [label sizeToFit];
    
    [self addSubview:label];
    self.lblCompareMetricLabel = label;
    label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, szWidget.width, 30)];
    label.textColor = [UIColor colorWithRed:251.0f / 255.0f green:54.0f / 255.0f blue:159.0f / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    self.lblCompareMetricValue = label;
    label = nil;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, szWidget.width, 30)];
    label.textColor = [UIColor colorWithRed:203.0f / 255.0f green:202.0f / 255.0f blue:202.0f / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    self.lblCompareLabel = label;
    label = nil;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self updateUI];
}

-(void)UpdateWidget
{
    [super UpdateWidget];
    
    NSLog(@"%@", self.WgComparisionData);
    
    [self updateUI];
}

- (void) updateUI
{
    float width = CGRectGetWidth(self.frame);
    
    ////////////////
    
    float pos = WIDGET_TITLEBAR_HEIGHT;
    
    NSString *summaryMethod = [self.WgInfo objectForKey:@"summaryMethod"];
    self.lblSummaryMethod.text = summaryMethod;
    self.lblSummaryMethod.frame = CGRectMake(0, pos, width, KPI_METHOD_HEIGHT);
    
    ////////////////
    
    pos += KPI_METHOD_HEIGHT;
    
    NSString *label = [self.WgInfo objectForKey:@"label"];
    self.lblMetricLabel.text = [NSString stringWithFormat:@"%@: ", label];
    [self.lblMetricLabel sizeToFit];
    
    NSDictionary *primaryDateRangeData = [self.WgComparisionData objectForKey:@"primaryDateRange"];
    NSDictionary *primaryMetricData = [primaryDateRangeData objectForKey:@"primaryMetric"];
    
    NSString *metricValue = [NSString stringWithFormat:@"%@", [primaryMetricData objectForKey:@"value"]];
    
    float metricValue_ = [metricValue floatValue];
    
    self.lblMetricValue.text = [NSString stringWithFormat:@"%.2f", metricValue_];
    [self.lblMetricValue sizeToFit];
    
    float metricWidth = self.lblMetricLabel.frame.size.width + self.lblMetricValue.frame.size.width;
    
    float xPos = (width - metricWidth) / 2;
    self.lblMetricLabel.frame = CGRectMake(xPos, pos, self.lblMetricLabel.frame.size.width, KPI_METRIC_HEIGHT);
    xPos += self.lblMetricLabel.frame.size.width;
    self.lblMetricValue.frame = CGRectMake(xPos, pos, self.lblMetricValue.frame.size.width, KPI_METRIC_HEIGHT);
    
    ////////////////
    
    pos += KPI_METRIC_HEIGHT;
    
    NSDictionary *metric = [self.WgInfo objectForKey:@"metric"];
    
    NSString *metricName = [metric objectForKey:@"name"];
    self.lblLabel.text = metricName;
    self.lblLabel.frame = CGRectMake(0, pos, width, KPI_METRIC_HEIGHT);
    
    ////////////////
    
    pos += KPI_METRIC_HEIGHT + 6;
    
    NSString *compareMetricLabel = [self.WgInfo objectForKey:@"compareLabel"];
    self.lblCompareMetricLabel.text = [NSString stringWithFormat:@"%@: ", compareMetricLabel];
    [self.lblCompareMetricLabel sizeToFit];
    
    NSDictionary *compareMetricData = [primaryDateRangeData objectForKey:@"compareMetric"];
    
    metricValue = [NSString stringWithFormat:@"%@", [compareMetricData objectForKey:@"value"]];
    
    metricValue_ = [metricValue floatValue];
    
    self.lblCompareMetricValue.text = [NSString stringWithFormat:@"%.2f", metricValue_];
    [self.lblCompareMetricValue sizeToFit];
    
    metricWidth = self.lblCompareMetricLabel.frame.size.width + self.lblCompareMetricValue.frame.size.width;
    
    xPos = (width - metricWidth) / 2;
    self.lblCompareMetricLabel.frame = CGRectMake(xPos, pos, self.lblCompareMetricLabel.frame.size.width, KPI_COMPAREMETRIC_HEIGHT);
    xPos += self.lblCompareMetricLabel.frame.size.width;
    self.lblCompareMetricValue.frame = CGRectMake(xPos, pos, self.lblCompareMetricValue.frame.size.width, KPI_COMPAREMETRIC_HEIGHT);
    
    ////////////////
    
    pos += KPI_COMPAREMETRIC_HEIGHT;
    
    NSDictionary *compareMetric = [self.WgInfo objectForKey:@"compareMetric"];
    
    NSString *compareMetricName = [compareMetric objectForKey:@"name"];
    self.lblCompareLabel.text = compareMetricName;
    self.lblCompareLabel.frame = CGRectMake(0, pos, width, KPI_METRIC_HEIGHT);
    
    [self updateControlsWithShowableState];
    
    if(self.WgComparisionData != nil)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, KPI_WIDGET_HEIGHT);
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CANVAS object:nil];
    }
}

- (void) updateControlsWithShowableState
{
    self.lblSummaryMethod.hidden = self.WgComparisionData == nil;
    
    self.lblMetricLabel.hidden = self.WgComparisionData == nil;
    self.lblMetricValue.hidden = self.WgComparisionData == nil;
    self.lblLabel.hidden = self.WgComparisionData == nil;
    
    self.lblCompareMetricLabel.hidden = self.WgComparisionData == nil;
    self.lblCompareMetricValue.hidden = self.WgComparisionData == nil;
    self.lblCompareLabel.hidden = self.WgComparisionData == nil;
}

@end
