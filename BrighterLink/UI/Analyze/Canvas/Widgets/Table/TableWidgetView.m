//
//  TableWidgetView.m
//  BrighterLink
//
//  Created by Andriy on 11/25/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TableWidgetView.h"

#import "SharedMembers.h"

#import "TablePageController.h"

#define TABLE_WIDGET_HEIGHT_PER_ROW  30
#define TABLE_WIDGET_HEIGHT_HEADER   60
#define TABLE_WIDGET_HEIGHT_BOTTOM   30

#define TABLE_WIDGET_WIDTH_DATE      120

#define TABLE_WIDGET_GAP             10

#define TABLE_WIDGET_DEFAULT_ROWS    10

#define TABLE_WIDGET_MINIUM_WIDTH    240

@interface TableWidgetView()<TablePageControllerDelegate>
{
    int _pageIndex;
    
    
}

@property (nonatomic, assign) UIView *viewHeaderBackground;
@property (nonatomic, assign) UILabel *lblDateHeader;

@property (nonatomic, assign) UIScrollView *svDates;
@property (nonatomic, assign) UIScrollView *svDatas;

@property (nonatomic, assign) TablePageController *pageController;

@property (nonatomic, retain) NSMutableArray *aryFilteredGraphData;
@property (nonatomic, retain) NSMutableArray *aryDates;

@end

@implementation TableWidgetView

- (id) initWithParent:(UIView *)parent
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, parent.frame.size.width, [self getWidgetHeight]);
        
        [parent addSubview:self];
    }
    
    return self;
}

- (void) _init
{
    [super _init];
    
    _pageIndex = 0;
    
    self.aryFilteredGraphData = nil;
    self.aryDates = [[NSMutableArray alloc] init];
    
    CGSize szWidget = self.frame.size;
    
    //------------- header background -----------------
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, WIDGET_TITLEBAR_HEIGHT, szWidget.width, TABLE_WIDGET_HEIGHT_HEADER)];
    view.backgroundColor = [UIColor colorWithRed:247.0f / 255.0f green:247.0f / 255.0f blue:247.0f / 255.0f alpha:1.0f];
    
    [self addSubview:view];
    self.viewHeaderBackground = view;
    view = nil;
    
    //------------- header background -----------------
    //------------- date label -----------------
    
    UILabel *labelDateHeader = [[UILabel alloc] initWithFrame:CGRectMake(TABLE_WIDGET_GAP, 0, TABLE_WIDGET_WIDTH_DATE, 20)];
    labelDateHeader.center = CGPointMake(TABLE_WIDGET_WIDTH_DATE / 2 + TABLE_WIDGET_GAP, self.viewHeaderBackground.frame.origin.y + TABLE_WIDGET_HEIGHT_HEADER * 3 / 4);
    labelDateHeader.backgroundColor = [UIColor clearColor];
    labelDateHeader.textColor = [UIColor blackColor];
    labelDateHeader.font = [UIFont boldSystemFontOfSize:14.0f];
    labelDateHeader.text = @"Date";
    labelDateHeader.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:labelDateHeader];
    self.lblDateHeader = labelDateHeader;
    labelDateHeader = nil;
    //------------- date label -----------------
    
    //------------- date rows -----------------
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,WIDGET_TITLEBAR_HEIGHT + TABLE_WIDGET_HEIGHT_HEADER, szWidget.width, [self getDataHeight])];
    scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:scrollView];
    self.svDates = scrollView;
    scrollView = nil;
    
    //------------- date rows -----------------
    
    //------------- data rows -----------------
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(TABLE_WIDGET_WIDTH_DATE, WIDGET_TITLEBAR_HEIGHT, szWidget.width - TABLE_WIDGET_WIDTH_DATE, [self getDataHeight] + TABLE_WIDGET_HEIGHT_HEADER)];
    scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:scrollView];
    self.svDatas = scrollView;
    scrollView = nil;
    
    //------------- data rows -----------------
    
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TablePageController" owner:self options:nil];
    TablePageController *pageController = [nib objectAtIndex:0];
    [self addSubview:pageController];
    self.pageController = pageController;
    self.pageController.delegate = self;
    
    self.pageController.center = CGPointMake(szWidget.width / 2, szWidget.height - TABLE_WIDGET_HEIGHT_BOTTOM / 2);
}

- (float) getWidgetHeight
{
    float height = WIDGET_TITLEBAR_HEIGHT + TABLE_WIDGET_HEIGHT_HEADER + [self getDataHeight] + TABLE_WIDGET_HEIGHT_BOTTOM;
    
    return height;
}

- (float) getDataHeight
{
    int rows = [self getRows];
    int dataCount = (int)self.aryDates.count;
    
    rows = MIN(rows, dataCount);
    
    return rows * TABLE_WIDGET_HEIGHT_PER_ROW;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self updateUI];
}

-(void)UpdateWidget
{
    [super UpdateWidget];
    
    _pageIndex = 0;
    
    [self prepareTableDatas];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self getWidgetHeight]);
    
    [self updateUI];
    
    [self.pageController updatePageIndex:_pageIndex max:[self getPageCount]];
}

- (void) updateUI
{
    CGSize szWidget = self.frame.size;
    
    self.viewHeaderBackground.frame = CGRectMake(0, WIDGET_TITLEBAR_HEIGHT, szWidget.width, TABLE_WIDGET_HEIGHT_HEADER);
    self.lblDateHeader.center = CGPointMake(TABLE_WIDGET_WIDTH_DATE / 2 + TABLE_WIDGET_GAP, self.viewHeaderBackground.frame.origin.y + TABLE_WIDGET_HEIGHT_HEADER * 3 / 4);
    self.svDates.frame = CGRectMake(0,WIDGET_TITLEBAR_HEIGHT + TABLE_WIDGET_HEIGHT_HEADER, szWidget.width, [self getDataHeight]);
    self.svDatas.frame = CGRectMake(TABLE_WIDGET_WIDTH_DATE,WIDGET_TITLEBAR_HEIGHT, szWidget.width - TABLE_WIDGET_WIDTH_DATE, [self getDataHeight] + TABLE_WIDGET_HEIGHT_HEADER);
    self.pageController.center = CGPointMake(szWidget.width / 2, szWidget.height - TABLE_WIDGET_HEIGHT_BOTTOM / 2);
    
    if(self.WgComparisionData != nil)
    {
        [self loadAllDatas];
    }
}

- (void) loadAllDatas
{
    [self loadDates];
    [self loadTableDatas];
}

- (void) prepareTableDatas
{
    [self.aryDates removeAllObjects];
    
    NSArray *primaryDateRange = [self.WgComparisionData objectForKey:@"primaryDateRange"];
    
    NSMutableArray *arySegmentNames = [[NSMutableArray alloc] init];
    
    for (int n = 0 ; n < primaryDateRange.count;  n++) {
        NSDictionary *segmentData = [primaryDateRange objectAtIndex:n];
        
        NSArray *metricDatas = [segmentData.allValues firstObject];
        NSString *segmentName = [segmentData.allKeys firstObject];
        
        [arySegmentNames addObject:segmentName];
        
        if(metricDatas.count > 0)
        {
            NSDictionary *primaryMetricDatas = [metricDatas objectAtIndex:0];
            NSDictionary *dicPrimaryMetricDatas = [primaryMetricDatas.allValues firstObject];
            NSArray *aryPrimaryMetricDatas = [dicPrimaryMetricDatas objectForKey:@"data"];
            
            for (NSDictionary *data in aryPrimaryMetricDatas) {
                
                NSString *label = [data objectForKey:@"label"];
                
                if(![self.aryDates containsObject:label])
                {
                    [self.aryDates addObject:label];
                }
            }
        }
    }
    
    NSMutableArray *aryGraphDatas = [[NSMutableArray alloc] init];
    for (int n = 0 ; n < primaryDateRange.count;  n++) {
        
        NSMutableArray *aryPrimaryGraphDatas = [[NSMutableArray alloc] init];
        NSMutableArray *aryCompareGraphDatas = [[NSMutableArray alloc] init];
        
        NSDictionary *segmentData = [primaryDateRange objectAtIndex:n];
        NSString *segmentName = [segmentData.allKeys firstObject];
        NSArray *metricDatas = [segmentData.allValues firstObject];
        
        if(metricDatas.count > 0)
        {
            NSDictionary *primaryMetricDatas = [metricDatas objectAtIndex:0];
            NSDictionary *dicPrimaryMetricDatas = [primaryMetricDatas.allValues firstObject];
            NSArray *aryPrimaryMetricDatas = [dicPrimaryMetricDatas objectForKey:@"data"];
            
            NSArray *aryCompareMetricDatas = nil;
            if(metricDatas.count > 1) {
                NSDictionary *compareMetricDatas = [metricDatas objectAtIndex:1];
                NSDictionary *dicCompareMetricDatas = [compareMetricDatas.allValues firstObject];
                aryCompareMetricDatas = [dicCompareMetricDatas objectForKey:@"data"];
            }
            
            for (NSString *label in self.aryDates) {
                
                // check primary metric data
                
                BOOL isExit = NO;
                for (NSDictionary *data in aryPrimaryMetricDatas) {
                    
                    NSString *label_ = [data objectForKey:@"label"];
                    
                    if([label isEqualToString:label_])
                    {
                        [aryPrimaryGraphDatas addObject:data];
                        
                        isExit = YES;
                        
                        break;
                    }
                }
                
                if(!isExit)
                {
                    NSDictionary *dic = @{@"date" : label, @"label" : label, @"value" : [NSNumber numberWithFloat:0]};
                    
                    [aryPrimaryGraphDatas addObject:dic];
                }
                
                // check compare metric data
                
                if(aryCompareMetricDatas != nil && aryCompareMetricDatas.count > 0) // if the compare metric datas exist
                {
                    BOOL isCompareExit = NO;
                    for (NSDictionary *data in aryCompareMetricDatas) {
                        
                        NSString *label_ = [data objectForKey:@"label"];
                        
                        if([label isEqualToString:label_])
                        {
                            [aryCompareGraphDatas addObject:data];
                            
                            isCompareExit = YES;
                            
                            break;
                        }
                    }
                    
                    if(!isCompareExit)
                    {
                        NSDictionary *dic = @{@"date" : label, @"label" : label, @"value" : [NSNumber numberWithFloat:0]};
                        
                        [aryCompareGraphDatas addObject:dic];
                    }
                }
            }
        }
        
        if(aryPrimaryGraphDatas.count > 0)
        {
            NSDictionary *dic = nil;
            
            if(aryCompareGraphDatas != nil)
            {
                dic = @{@"segment" : segmentName,
                        @"primary": aryPrimaryGraphDatas,
                        @"compare": aryCompareGraphDatas};
            }
            else
            {
                dic = @{@"segment" : segmentName,
                        @"primary": aryPrimaryGraphDatas,
                        @"compare": @[]};
            }
            
            [aryGraphDatas addObject:dic];
        }
        
        aryPrimaryGraphDatas = nil;
    }
    
    self.aryFilteredGraphData = aryGraphDatas;
    aryGraphDatas = nil;
}

- (void) loadDates
{
    NSArray *subviews = self.svDates.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    int rows = [self getRows];
    for (int n = 0 ; n < rows ; n ++) {
        
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(TABLE_WIDGET_GAP, 0, TABLE_WIDGET_WIDTH_DATE, 20)];
        labelDate.center = CGPointMake(TABLE_WIDGET_WIDTH_DATE / 2 + TABLE_WIDGET_GAP, n * TABLE_WIDGET_HEIGHT_PER_ROW + TABLE_WIDGET_HEIGHT_PER_ROW / 2);
        labelDate.backgroundColor = [UIColor clearColor];
        labelDate.textColor = [UIColor blackColor];
        labelDate.font = [UIFont systemFontOfSize:12.0f];
        labelDate.text = [self getDateLabel:n];
        labelDate.textAlignment = NSTextAlignmentLeft;
        
        [self.svDates addSubview:labelDate];
        labelDate = nil;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (n + 1) * TABLE_WIDGET_HEIGHT_PER_ROW, self.svDates.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:247.0f / 255.0f green:247.0f / 255.0f blue:247.0f / 255.0f alpha:1.0f];
        
        [self.svDates addSubview:line];
        line = nil;
    }
}

- (void) loadTableDatas
{
    NSArray *subviews = self.svDatas.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    int segmentCount = (int)self.aryFilteredGraphData.count;
    
    int noCompareMetric = [self hasCompareMetric] ? 0 : 1;
    
    float oneSegmentWidth = (self.svDatas.frame.size.width - TABLE_WIDGET_WIDTH_DATE) / segmentCount;
    oneSegmentWidth = MAX(oneSegmentWidth, TABLE_WIDGET_MINIUM_WIDTH / (noCompareMetric + 1));
    
    float pos = 0;
    for (int segmentIndex = 0 ; segmentIndex < segmentCount ; segmentIndex ++) {
        pos = segmentIndex * oneSegmentWidth;
        
        [self loadColumnDatas:pos width:oneSegmentWidth data:nil index:segmentIndex];
        
    }
    
    self.svDatas.contentSize = CGSizeMake(oneSegmentWidth * segmentCount, self.svDatas.frame.size.height);
}

- (void) loadColumnDatas:(float)pos width:(float)width data:(NSDictionary *)data index:(int)index
{
    [self loadColumnSegmentTitle:[self getSegmentName:index] pos:pos width:width];
    
    if([self hasCompareMetric])
    {
        UIColor *color1 = [[SharedMembers sharedInstance] getSegmentColorWithIndex:index * 2];
        UIColor *color2 = [[SharedMembers sharedInstance] getSegmentColorWithIndex:(index * 2 + 1)];
        
        [self loadColumnSegmentWithMetric:[self getPrimaryMetric] segment:index isCompare:NO color:color1 pos:pos width:width / 2];
        [self loadColumnSegmentWithMetric:[self getCompareMetric] segment:index isCompare:YES color:color2 pos:(pos + width / 2) width:width / 2];
    }
    else
    {
        UIColor *color = [[SharedMembers sharedInstance] getSegmentColorWithIndex:index];
        
        [self loadColumnSegmentWithMetric:[self getPrimaryMetric] segment:index isCompare:NO color:color pos:pos width:width];
    }
}

- (void) loadColumnSegmentTitle:(NSString *)segmentTitle pos:(float)pos width:(float)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pos, 0, width, TABLE_WIDGET_HEIGHT_HEADER / 2)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.text = segmentTitle;
    label.textAlignment = NSTextAlignmentLeft;
    
    [self.svDatas addSubview:label];
    label = nil;
}

- (void) loadColumnSegmentWithMetric:(NSString *)metricTitle segment:(int)segmentIndex isCompare:(BOOL)isCompare color:(UIColor *)color pos:(float)pos width:(float)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pos, TABLE_WIDGET_HEIGHT_HEADER / 2, width, TABLE_WIDGET_HEIGHT_HEADER / 2)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.text = metricTitle;
    label.textAlignment = NSTextAlignmentLeft;
    
    [self.svDatas addSubview:label];
    label = nil;
    
    int rows = [self getRows];
    for (int n = 0 ; n < rows ; n ++) {
        
        UILabel *labelData = [[UILabel alloc] initWithFrame:CGRectMake(pos, TABLE_WIDGET_HEIGHT_HEADER + n * TABLE_WIDGET_HEIGHT_PER_ROW, width, TABLE_WIDGET_HEIGHT_PER_ROW)];
        labelData.backgroundColor = [UIColor clearColor];
        labelData.textColor = color;
        labelData.font = [UIFont systemFontOfSize:12.0f];
        labelData.text = [self getDataValue:segmentIndex row:n compare:isCompare];
        labelData.textAlignment = NSTextAlignmentLeft;
        
        [self.svDatas addSubview:labelData];
        labelData = nil;
    }
}

- (int) getRows
{
    int rows = TABLE_WIDGET_DEFAULT_ROWS;
    if(self.WgInfo)
    {
        rows = [[self.WgInfo objectForKey:@"rowsPerTable"] intValue];
    }
    
    return rows;
}

- (int) getPageCount
{
    if(self.aryDates == nil) return 1;
    
    int rows = [self getRows];
    
    if(rows < 1) return 1;
    
    int pageCount = (int)self.aryDates.count / rows;
    
    return pageCount;
}

- (NSString *) getDateLabel:(int)row
{
    int rows = [self getRows];
    
    int index = _pageIndex * rows + row;
    
    NSString *label = @"";
    if(index < self.aryDates.count)
    {
        label = [self.aryDates objectAtIndex:index];
    }
    
    return label;
}

- (NSString *) getDataValue:(int)segment row:(int)row compare:(BOOL)isCompare
{
    if(self.aryFilteredGraphData == nil) return @"";
    
    NSString *value = @"";
    if(segment < self.aryFilteredGraphData.count)
    {
        NSDictionary *segmentData = [self.aryFilteredGraphData objectAtIndex:segment];
        
        NSArray *aryDatas = nil;
        
        if(isCompare)
            aryDatas = [segmentData objectForKey:@"compare"];
        else
            aryDatas = [segmentData objectForKey:@"primary"];
        
        if(aryDatas)
        {
            int rows = [self getRows];
            int index = _pageIndex * rows + row;
            
            if(index < aryDatas.count)
            {
                NSDictionary *data = [aryDatas objectAtIndex:index];
                value = [NSString stringWithFormat:@"%@", [data objectForKey:@"value"]];
            }
        }
    }
    
    return value;
}

- (BOOL) hasCompareMetric
{
    if(self.WgInfo == nil) return NO;
    
    NSDictionary *compareMetric = [self.WgInfo objectForKey:@"compareMetric"];
    
    if(![compareMetric isKindOfClass:[NSDictionary class]]) return NO;
    
    NSString *metricTitle = [compareMetric objectForKey:@"name"];
    
    if(metricTitle == nil || ![metricTitle isKindOfClass:[NSString class]]) return NO;
    
    return YES;
}

- (NSString *) getPrimaryMetric
{
    if(self.WgInfo == nil) return @"";
    
    NSDictionary *compareMetric = [self.WgInfo objectForKey:@"metric"];
    
    NSString *metricTitle = [compareMetric objectForKey:@"name"];
    
    return metricTitle;
}

- (NSString *) getCompareMetric
{
    if(![self hasCompareMetric]) return @"";
    
    NSDictionary *compareMetric = [self.WgInfo objectForKey:@"compareMetric"];
    
    NSString *metricTitle = [compareMetric objectForKey:@"name"];
    
    return metricTitle;
}

- (NSString *) getSegmentName:(int)index
{
    if(self.aryFilteredGraphData == nil) return @"";
    
    NSString *segmentName = @"";
    if(index < self.aryFilteredGraphData.count)
    {
        NSDictionary *segmentData = [self.aryFilteredGraphData objectAtIndex:index];
        
        segmentName = [segmentData objectForKey:@"segment"];
    }
    
    return segmentName;
}

#pragma mark TablePageControllerDelegate

- (void) previewPage
{
    if(_pageIndex == 0) return;
    
    _pageIndex --;
    
    _pageIndex = MAX(0, _pageIndex);
    
    [self.pageController updatePageIndex:_pageIndex max:[self getPageCount]];
    
    [self loadAllDatas];
}

- (void) nextPage
{
    if(_pageIndex == [self getPageCount] - 1) return;
    
    _pageIndex ++;
    
    _pageIndex = MIN([self getPageCount] - 1, _pageIndex);
    
    [self.pageController updatePageIndex:_pageIndex max:[self getPageCount]];
    
    [self loadAllDatas];
}

@end
