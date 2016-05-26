//
//  DateRangeView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "DateRangeView.h"

#import "SharedMembers.h"

#import "DSLCalendarDayView.h"
#import "DSLCalendarView.h"

@interface DateRangeView()<UIActionSheetDelegate, DSLCalendarViewDelegate>

@property (nonatomic, assign) IBOutlet DSLCalendarView *calendarView;

@property (nonatomic, assign) IBOutlet UIButton *btnRangeType;

@property (nonatomic, assign) IBOutlet UIButton *btnMainStartDate;
@property (nonatomic, assign) IBOutlet UIButton *btnMainEndDate;

@property (nonatomic, assign) IBOutlet UIButton *btnCompareCheck;

@property (nonatomic, assign) IBOutlet UIButton *btnCustomRangeType;

@property (nonatomic, assign) IBOutlet UIButton *btnCustomStartDate;
@property (nonatomic, assign) IBOutlet UIButton *btnCustomEndDate;

@property (nonatomic, assign) IBOutlet UIButton *btnApply;
@property (nonatomic, assign) IBOutlet UIButton *btnCancel;

@property (nonatomic, assign) IBOutlet UIView *tapView;
@property (nonatomic, assign) IBOutlet UIView *pickerDateView;
@property (nonatomic, assign) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) NSDate *mainStartDate;
@property (nonatomic, retain) NSDate *mainEndDate;

@property (nonatomic, retain) NSDate *customStartDate;
@property (nonatomic, retain) NSDate *customEndDate;

@property (nonatomic, retain) NSArray *aryTypes;

@property (nonatomic, assign) NSInteger mainRangeType;
@property (nonatomic, assign) NSInteger customRangeType;

@property (nonatomic, assign) BOOL isCustomRangeDate;


@end

@implementation DateRangeView

- (void) awakeFromNib
{
    self.aryTypes = [[NSArray alloc] initWithObjects:@"Custom", @"Last Seven Days", @"Current Week", @"Last Week", @"Last 30 Days", @"Current Month", @"Last Month", @"Current Year", @"Last Year", nil];
    
    self.mainRangeType = 0;
    self.customRangeType = 0;
    
    DashboardInfo *currentDashboard = [SharedMembers sharedInstance].currentDashboard;
    
    self.isCustomRangeDate = currentDashboard.useCompare;
    
    self.mainStartDate = currentDashboard.startDate;
    self.mainEndDate = currentDashboard.endDate;
    
    self.customStartDate = currentDashboard.compareStartDate;
    self.customEndDate = currentDashboard.compareEndDate;
    
    self.calendarView.delegate = self;
    
    [self initView];
    
    [self updateUI];
}

- (void) initView
{
    self.calendarView.showDayCalloutView = NO;
    
    self.viewMain.backgroundColor = [UIColor whiteColor];
    self.viewMain.layer.cornerRadius = 3;
    self.viewMain.layer.borderWidth = 1.0f;
    self.viewMain.layer.borderColor = [UIColor colorWithRed:221.0f / 255.0f green:221.0f / 255.0f blue:221.0f / 255.0f alpha:1.0f].CGColor;
    self.viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewMain.layer.shadowOpacity = 0.5f;
    self.viewMain.layer.shadowRadius = 3.0f;
    self.viewMain.layer.shadowOffset = CGSizeMake(-3, 3);
    
    [self setFormatWithButtn:self.btnRangeType];
    [self setFormatWithButtn:self.btnMainStartDate];
    [self setFormatWithButtn:self.btnMainEndDate];
    
    [self setFormatWithButtn:self.btnCustomRangeType];
    [self setFormatWithButtn:self.btnCustomStartDate];
    [self setFormatWithButtn:self.btnCustomEndDate];
    
    [self setFormatWithButtn:self.btnApply];
    [self setFormatWithButtn:self.btnCancel];
    
    self.pickerDateView.layer.cornerRadius = 5;
    self.pickerDateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pickerDateView.layer.borderWidth = 1;
    
    self.tapView.hidden = YES;
    self.pickerDateView.hidden = YES;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeSelectDate:) forControlEvents:UIControlEventValueChanged];
    
    [self.pickerDateView addSubview:datePicker];
    self.datePicker = datePicker;
    datePicker = nil;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutOfDatePicker)];
    [self.tapView addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

- (void) setFormatWithButtn:(UIButton *)button
{
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 3;
    button.layer.borderColor = [UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f].CGColor;
    button.layer.borderWidth = 1.0f;
}

- (IBAction)onSelectMainRangeType:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:self.aryTypes[RANGE_CUSTOM],
                                  self.aryTypes[RANGE_LAST_7_DAYS],
                                  self.aryTypes[RANGE_CURRENT_WEEK],
                                  self.aryTypes[RANGE_LAST_WEEK],
                                  self.aryTypes[RANGE_LAST_30_DAYS],
                                  self.aryTypes[RANGE_CURRENT_MONTH],
                                  self.aryTypes[RANGE_LAST_MONTH],
                                  self.aryTypes[RANGE_CURRENT_YEAR],
                                  self.aryTypes[RANGE_LAST_YEAR], nil];
    actionSheet.tag = 0;
    
    [actionSheet showInView:self];
    actionSheet = nil;
}

- (IBAction)onMainStartDate:(id)sender
{
    [self showDatePickerView:self.btnMainStartDate index:0];
}

- (IBAction)onMainEndDate:(id)sender
{
    [self showDatePickerView:self.btnMainEndDate index:1];
}

- (IBAction)onSelectCustomRangeType:(id)sender
{
    if(!self.isCustomRangeDate) return;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:self.aryTypes[RANGE_CUSTOM],
                                  self.aryTypes[RANGE_LAST_7_DAYS],
                                  self.aryTypes[RANGE_CURRENT_WEEK],
                                  self.aryTypes[RANGE_LAST_WEEK],
                                  self.aryTypes[RANGE_LAST_30_DAYS],
                                  self.aryTypes[RANGE_CURRENT_MONTH],
                                  self.aryTypes[RANGE_LAST_MONTH],
                                  self.aryTypes[RANGE_CURRENT_YEAR],
                                  self.aryTypes[RANGE_LAST_YEAR], nil];
    actionSheet.tag = 1;
    
    [actionSheet showInView:self];
    actionSheet = nil;
}

- (IBAction)onCustomStartDate:(id)sender
{
    [self showDatePickerView:self.btnCustomStartDate index:2];
}

- (IBAction)onCustomEndDate:(id)sender
{
    [self showDatePickerView:self.btnCustomEndDate index:3];
}

- (IBAction)onCheck:(id)sender
{
    self.isCustomRangeDate = !self.btnCompareCheck.isSelected;
    
    [self updateUI];
}

- (IBAction)onApplyButton:(id)sender
{
    DashboardInfo *currentDashboard =[ SharedMembers sharedInstance].currentDashboard;
    
    currentDashboard.startDate = [self getSelectedStringWithButton:self.btnMainStartDate];
    currentDashboard.endDate = [self getSelectedStringWithButton:self.btnMainEndDate];
    
    if(self.isCustomRangeDate)
    {
        currentDashboard.compareStartDate = [self getSelectedStringWithButton:self.btnCustomStartDate];
        currentDashboard.compareEndDate = [self getSelectedStringWithButton:self.btnCustomEndDate];
    }
    else
    {
        currentDashboard.compareStartDate = nil;
        currentDashboard.compareEndDate = nil;
    }
    
    currentDashboard.useCompare = self.isCustomRangeDate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATED_DATERANGE object:nil];
    
    [self removeFromSuperview];
}

- (IBAction)onCancelButton:(id)sender
{
    [self removeFromSuperview];
}

- (NSDate *) getSelectedStringWithButton:(UIButton *)button
{
    NSString *title = button.titleLabel.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    NSDate *date = [dateFormatter dateFromString:title];
    
    return date;
}

- (void) updateUI
{
    self.btnCompareCheck.selected = self.isCustomRangeDate;
    
    self.btnCustomRangeType.enabled = self.isCustomRangeDate;
    self.btnCustomStartDate.enabled = self.isCustomRangeDate;
    self.btnCustomEndDate.enabled = self.isCustomRangeDate;
    
    [self.btnRangeType setTitle:self.aryTypes[self.mainRangeType] forState:UIControlStateNormal];
    [self.btnCustomRangeType setTitle:self.aryTypes[self.customRangeType] forState:UIControlStateNormal];
    
    if(self.mainRangeType == RANGE_CUSTOM)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        
        NSString *startDate = [dateFormatter stringFromDate:self.mainStartDate];
        
        [self.btnMainStartDate setTitle:startDate forState:UIControlStateNormal];
        
        NSString *endDate = [dateFormatter stringFromDate:self.mainEndDate];
        
        [self.btnMainEndDate setTitle:endDate forState:UIControlStateNormal];
    }
    else if(self.mainRangeType > 0)
    {
        NSString *startDate = [self getDateWithRangeType:self.mainRangeType isStart:YES];
        
        [self.btnMainStartDate setTitle:startDate forState:UIControlStateNormal];
        
        NSString *endDate = [self getDateWithRangeType:self.mainRangeType isStart:NO];
        
        [self.btnMainEndDate setTitle:endDate forState:UIControlStateNormal];
    }
    
    if(self.customRangeType == RANGE_CUSTOM)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        
        NSString *startDate = [dateFormatter stringFromDate:self.customStartDate];
        
        [self.btnCustomStartDate setTitle:startDate forState:UIControlStateNormal];
        
        NSString *endDate = [dateFormatter stringFromDate:self.customEndDate];
        
        [self.btnCustomEndDate setTitle:endDate forState:UIControlStateNormal];
    }
    else if(self.customRangeType > 0)
    {
        NSString *startDate = [self getDateWithRangeType:self.customRangeType isStart:YES];
        
        [self.btnCustomStartDate setTitle:startDate forState:UIControlStateNormal];
        
        NSString *endDate = [self getDateWithRangeType:self.customRangeType isStart:NO];
        
        [self.btnCustomEndDate setTitle:endDate forState:UIControlStateNormal];
    }
    
    NSDateComponents *fromTimeComponents = [self.mainStartDate dslCalendarView_dayWithCalendar:self.calendarView.visibleMonth.calendar];
    
    NSDateComponents *toTimeComponents = [self.mainEndDate dslCalendarView_dayWithCalendar:self.calendarView.visibleMonth.calendar];
    
    DSLCalendarRange *calendarRange = [[DSLCalendarRange alloc] initWithStartDay:fromTimeComponents endDay:toTimeComponents];
    
    [self.calendarView setSelectedRange:calendarRange];
    [self.calendarView setVisibleMonth:fromTimeComponents animated:YES];
    
    calendarRange = nil;
}

- (NSString *) getDateWithRangeType:(NSInteger)rangeType isStart:(BOOL) isStartDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    NSDate *date = [NSDate date];
    
    if(isStartDate)
    {
        switch (rangeType) {
            case RANGE_CUSTOM:
                
                break;
                
            case RANGE_LAST_7_DAYS:
                date = [date dateByAddingTimeInterval:(- 6 * 24 * 3600)];
                break;
                
            case RANGE_CURRENT_WEEK:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitMonth  | NSCalendarUnitDay fromDate:[NSDate date]];
                
                NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
                
                [components setDay:([components day] - ((dayofweek) - 1))];
                
                date = [gregorian dateFromComponents:components];
            }
                break;
                
            case RANGE_LAST_WEEK:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitMonth  | NSCalendarUnitDay fromDate:[NSDate date]];
                
                NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
                
                [components setDay:([components day] - ((dayofweek) - 1))];
                
                NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
                
                date = [beginningOfWeek dateByAddingTimeInterval:(- 7 * 24 * 3600)];
            }
                break;
                
            case RANGE_LAST_30_DAYS:
                date = [date dateByAddingTimeInterval:(- 30 * 24 * 3600)];
                break;
                
            case RANGE_CURRENT_MONTH:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                
                [comp setDay:1];
                
                date = [gregorian dateFromComponents:comp];
            }
                break;
                
            case RANGE_LAST_MONTH:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                
                [comp setDay:1];
                
                NSInteger month = comp.month - 1;
                NSInteger year = comp.year;
                
                if(month < 1)
                {
                    month = 12;
                    year = year - 1;
                }
                
                [comp setMonth:month];
                [comp setYear:year];
                
                date = [gregorian dateFromComponents:comp];
            }
                break;
                
            case RANGE_CURRENT_YEAR:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                
                [comp setMonth:1];
                [comp setDay:1];

                date = [gregorian dateFromComponents:comp];
            }
                break;
                
            case RANGE_LAST_YEAR:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                
                NSInteger year = comp.year - 1;
                
                [comp setYear:year];
                [comp setMonth:1];
                [comp setDay:1];
                
                date = [gregorian dateFromComponents:comp];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (rangeType) {
            case RANGE_CUSTOM:
                
                break;
                
            case RANGE_LAST_7_DAYS:

                break;
                
            case RANGE_CURRENT_WEEK:

                break;
                
            case RANGE_LAST_WEEK:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitMonth  | NSCalendarUnitDay fromDate:[NSDate date]];
                
                NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
                
                [components setDay:([components day] - ((dayofweek) - 1))];
                
                NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
                
                date = [beginningOfWeek dateByAddingTimeInterval:(- 24 * 3600)];
                
            }
                break;
                
            case RANGE_LAST_30_DAYS:

                break;
                
            case RANGE_CURRENT_MONTH:

                break;
                
            case RANGE_LAST_MONTH:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                
                [comp setDay:1];
                
                NSDate *currentFirstDayOfMonth = [gregorian dateFromComponents:comp];
                date = [currentFirstDayOfMonth dateByAddingTimeInterval:(- 24 * 3600)];
                
            }
                break;
                
            case RANGE_CURRENT_YEAR:

                break;
                
            case RANGE_LAST_YEAR:
            {
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                
                NSInteger year = comp.year - 1;
                
                [comp setYear:year];
                [comp setMonth:12];
                [comp setDay:31];
                
                date = [gregorian dateFromComponents:comp];
            }
                break;
                
            default:
                break;
        }
    }
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    dateFormatter = nil;
    
    return dateString;
}

- (void) showDatePickerView:(UIButton *)button index:(int)index
{
    if(index == 0) // main start date
    {
        self.datePicker.maximumDate = self.mainEndDate;
        self.datePicker.minimumDate = nil;
        self.datePicker.date = self.mainStartDate;
    }
    else if(index == 1) // main end date
    {
        self.datePicker.maximumDate = nil;
        self.datePicker.minimumDate = self.mainStartDate;
        self.datePicker.date = self.mainEndDate;
    }
    else if(index == 2) // compare start date
    {
        if(self.customEndDate) self.datePicker.maximumDate = self.customEndDate;
        self.datePicker.minimumDate = nil;
        
        if(self.customStartDate) self.datePicker.date = self.customStartDate;
    }
    else if(index == 3) // compare end date
    {
        self.datePicker.maximumDate = nil;
        if(self.customStartDate) self.datePicker.minimumDate = self.customStartDate;
        if(self.customEndDate) self.datePicker.date = self.customEndDate;
    }
    
    self.tapView.hidden = NO;
    self.pickerDateView.hidden = NO;
    
    CGPoint pt = CGPointMake(self.viewMain.frame.origin.x + button.frame.origin.x + button.frame.size.width,
                             self.viewMain.frame.origin.y + button.frame.origin.y + button.frame.size.height);
    
    self.pickerDateView.tag = index;
    self.pickerDateView.frame = CGRectMake(pt.x - self.pickerDateView.frame.size.width, pt.y, self.pickerDateView.frame.size.width, self.pickerDateView.frame.size.height);
    
    
    
}

- (void) tapOutOfDatePicker
{
    self.tapView.hidden = YES;
    self.pickerDateView.hidden = YES;
}

- (IBAction)changeSelectDate:(id)sender
{
    NSInteger tag = self.pickerDateView.tag;
    
    if(tag == 0)
    {
        self.mainRangeType = 0;
        
        self.mainStartDate = self.datePicker.date;
    }
    else if(tag == 1)
    {
        self.mainRangeType = 0;
        
        self.mainEndDate = self.datePicker.date;
    }
    else if(tag == 2)
    {
        self.customRangeType = 0;
        
        self.customStartDate = self.datePicker.date;
    }
    else if(tag == 3)
    {
        self.customRangeType = 0;
        
        self.customEndDate = self.datePicker.date;
    }
    
    [self updateUI];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 0)
    {
        self.mainRangeType = buttonIndex;
    }
    else if(actionSheet.tag == 1)
    {
        self.customRangeType = buttonIndex;
    }
    
    [self updateUI];
}

#pragma mark DSLCalendarViewDelegate

- (void)calendarView:(DSLCalendarView*)calendarView didSelectRange:(DSLCalendarRange*)range
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.mainStartDate = [gregorian dateFromComponents:range.startDay];
    self.mainEndDate = [gregorian dateFromComponents:range.endDay];
    
    [self updateUI];
}

@end
