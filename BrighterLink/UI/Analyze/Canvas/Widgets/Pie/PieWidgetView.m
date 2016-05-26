//
//  PieWidgetView.m
//  BrighterLink
//
//  Created by mobile on 12/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PieWidgetView.h"
#import "SharedMembers.h"

@implementation PieWidgetView

+(PieWidgetView*)ShowPieWidget:(UIView*)parent
{
    PieWidgetView* vw = [[PieWidgetView alloc] init];
    [vw setFrame:CGRectMake(0, 0, parent.frame.size.width, PieRadius * 2 + 200)];
    [vw Initialize];
    [parent addSubview:vw];
    return vw;
}

-(void)Initialize
{
    m_pieCharts = [[NSMutableArray alloc] init];
}

-(void)UpdateWidget
{
    [super UpdateWidget];

    int sliceCount = [[self.WgInfo objectForKey:@"showUpTo"] intValue];
    for(NSDictionary* seg in [self.WgComparisionData objectForKey:@"primaryDateRange"])
    {
        NSMutableArray* metricData = [[NSMutableArray alloc] init];
        for(NSDictionary* item in seg.allValues.firstObject)
        {
            for(NSDictionary* metric in [[item objectForKey:@"primaryMetric"] objectForKey:@"data"])
            {
                [metricData addObject:metric];
            }
        }
        PieChartView* pieVw;
        for(PieChartView* vw in [m_pieCharts copy])
        {
            if ([vw.SegmentName isEqualToString:seg.allKeys.firstObject])
            {
                pieVw = vw;
                if (metricData.count == 0)
                {
                    [vw removeFromSuperview];
                    [m_pieCharts removeObject:vw];
                }
                break;
            }
        }
        if (metricData.count == 0)
            continue;
        
        NSDictionary* otherMetric;
        float otherTotal = 0;
        [self bubbleSort:metricData];
        if (metricData.count > sliceCount)
        {
            for(int i = sliceCount; i < metricData.count; i++)
            {
                NSDictionary* item = [metricData objectAtIndex:i];
                otherTotal += [[item objectForKey:@"value"] floatValue];
            }
            otherMetric = @{@"label" : @"Others", @"value" : [NSNumber numberWithFloat:otherTotal]};
            [metricData removeObjectsInRange:NSRangeFromString([NSString stringWithFormat:@"%d, %d", sliceCount, metricData.count - sliceCount])];
            [metricData addObject:otherMetric];
        }
        
        if (!pieVw)
        {
            pieVw = [[PieChartView alloc] init];
            [pieVw setSegmentName:seg.allKeys.firstObject];
            [self addSubview:pieVw];
            [m_pieCharts addObject:pieVw];
        }
        [pieVw setMetricData:metricData];
    }
    int col = self.frame.size.width / (PieRadius * 2 + PieChartOffset);
    if (col == 0)
        col = 1;
    int row = m_pieCharts.count / col;
    if (m_pieCharts.count % col > 0)
        row++;
    float unitWidth = self.frame.size.width / col;
    float frameHeight = WIDGET_TITLEBAR_HEIGHT;
    for (int i = 0; i < row; i++)
    {
        float maxHeight = 0;
        for (int j = 0; j < col; j++)
        {
            int idx = i * col + j;
            if (idx < m_pieCharts.count)
            {
                PieChartView* vw = [m_pieCharts objectAtIndex:idx];
                [vw setMetricColor:[[SharedMembers sharedInstance].arySegmentColors objectAtIndex:idx]];
                [vw setSliceCount:sliceCount];
                [vw Refresh];
                [vw setFrame:CGRectMake(j * unitWidth + (unitWidth - vw.frame.size.width) / 2, frameHeight, vw.frame.size.width, vw.frame.size.height)];
                if (vw.frame.size.height > maxHeight)
                    maxHeight = vw.frame.size.height;
            }
        }
        frameHeight += maxHeight;
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frameHeight + 15)];
}

-(void)bubbleSort:(NSMutableArray*)unsortedDataArray
{
    long count = unsortedDataArray.count;

    bool swapped = TRUE;
    while (swapped) {
        swapped = FALSE;
        for(int i = 1; i < count; i++)
        {
            NSDictionary* firstItem = [unsortedDataArray objectAtIndex:i - 1];
            NSDictionary* secondItem = [unsortedDataArray objectAtIndex:i];
            if ([[secondItem objectForKey:@"value"] floatValue] > [[firstItem objectForKey:@"value"] floatValue])
            {
                [unsortedDataArray exchangeObjectAtIndex:i - 1 withObjectAtIndex:i];
                swapped = TRUE;
            }
        }
    }
}
@end
