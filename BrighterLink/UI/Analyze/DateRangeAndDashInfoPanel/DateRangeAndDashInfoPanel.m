//
//  DateRangeAndDashInfoPanel.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DateRangeAndDashInfoPanel.h"

#import "SharedMembers.h"

@interface DateRangeAndDashInfoPanel()

@property (nonatomic, assign) IBOutlet UIView *viewDashboardInfo;

@property (nonatomic, assign) IBOutlet UILabel *lblDashboardTitle;

@property (nonatomic, assign) IBOutlet UIView *viewRangeDate;

@property (nonatomic, assign) IBOutlet UILabel *lblRangeDate;
@property (nonatomic, assign) IBOutlet UILabel *lblCompareRangeDate;

@end

@implementation DateRangeAndDashInfoPanel

- (void) awakeFromNib
{
    [self initView];
}

- (void) initView
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.viewDashboardInfo.layer.borderColor = [UIColor colorWithRed:206.0f / 255.0f green:207.0f / 255.0f blue:226.0f / 255.0f alpha:1.0f].CGColor;
    self.viewDashboardInfo.layer.borderWidth = 1;
    self.viewDashboardInfo.layer.cornerRadius = 3;
    self.viewDashboardInfo.clipsToBounds = YES;

    UITapGestureRecognizer *tapGesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDashbaordInfo)];
    [self.viewDashboardInfo addGestureRecognizer:tapGesture0];
    tapGesture0 = nil;
    
    self.viewRangeDate.layer.borderColor = [UIColor colorWithRed:206.0f / 255.0f green:207.0f / 255.0f blue:226.0f / 255.0f alpha:1.0f].CGColor;
    self.viewRangeDate.layer.borderWidth = 1;
    self.viewRangeDate.layer.cornerRadius = 3;
    self.viewRangeDate.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRangeDate)];
    [self.viewRangeDate addGestureRecognizer:tapGesture1];
    tapGesture1 = nil;
}

- (void) tapDashbaordInfo
{
    [self.delegate tappedDashboardInfo];
}

- (void) tapRangeDate
{
    [self.delegate tappedRangeDate];
}

- (void) _update
{
    self.lblDashboardTitle.text = [SharedMembers sharedInstance].currentDashboard.title;
    
    [self reloadDatas];
}

- (void) reloadDatas
{
    DashboardInfo *currentDashboard = [SharedMembers sharedInstance].currentDashboard;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    
    NSString *startDate = [dateFormatter stringFromDate:currentDashboard.startDate];
    NSString *endDate = [dateFormatter stringFromDate:currentDashboard.endDate];
    
    self.lblRangeDate.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
    
    self.lblCompareRangeDate.hidden = ! currentDashboard.useCompare;
    
    if(currentDashboard.useCompare)
    {
        NSString *startCompareDate = [dateFormatter stringFromDate:currentDashboard.compareStartDate];
        NSString *endCompareDate = [dateFormatter stringFromDate:currentDashboard.compareEndDate];
        
        self.lblCompareRangeDate.text = [NSString stringWithFormat:@"Compare to: %@ - %@", startCompareDate, endCompareDate];
    }
}

@end
