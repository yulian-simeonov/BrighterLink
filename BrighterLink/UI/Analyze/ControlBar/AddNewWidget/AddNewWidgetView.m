//
//  AddNewWidgetView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddNewWidgetView.h"

#import "WidgetInfo.h"

#import "SharedMembers.h"

#import "ImageWidgetOptionView.h"

typedef enum : NSUInteger {
    
    EQUI_ORIENTATION_VERTICAL,
    EQUI_ORIENTATION_HORIZONTAL,
    
} EQUIVALENCE_ORIENTATION;

#define MAX_COUNT_SLICES 5
NSString *slices[MAX_COUNT_SLICES] = {@"5", @"10", @"20", @"25", @"50" };

#define MAX_COUNT_EQUI_TYPES 13
NSString *equivalenceTypes[MAX_COUNT_EQUI_TYPES] = {@"Cars Removed", @"Waste Recycled", @"Gallons Gas Saved", @"Tanker Gas Saved", @"Energy Homes Generated", @"Electricity Homes Generated", @"Coal Eliminated", @"Oil Unneeded", @"Propane Cylinders", @"Plants Idled", @"Seedling Grown", @"Forests Preserved", @"Forests Conversion Prevented"};

#define MAX_COUNT_KPI_METHOD 5
NSString *kpiSummaryMethod[MAX_COUNT_KPI_METHOD] = {@"Total", @"Average", @"Count", @"Maximum", @"Minimum"};

@interface AddNewWidgetView()
{
    BOOL _showTitle;
    
    //------------timeline------------
    
    NSInteger _selectedTimelineMetricsIndex;
    NSInteger _selectedTimelineGroupDimentionIndex;
    NSInteger _selectedTimelineCompareMetricsIndex;
    
    //------------timeline------------
    
    //------------pie------------
    
    NSInteger _selectedPieMetricsIndex;
    NSInteger _selectedPieGroupDimentionIndex;
    NSInteger _selectedPieSliceCountIndex;
    
    //------------pie------------
    
    //------------bar------------
    
    NSInteger _selectedBarMetricsIndex;
    NSInteger _selectedBarGroupDimensionIndex;
    NSInteger _selectedBarPivotDimensionIndex;
    
    //------------bar------------
    
    //------------table------------
    
    NSInteger _selectedTableMetricsIndex;
    NSInteger _selectedTableExtraMetricsIndex;
    NSInteger _selectedTableGroupDimensionIndex;
    NSInteger _selectedTableShowRows;
    
    //------------table------------
    
    //------------equivalence------------
    
    NSInteger _selectedEquivalenceMetricsIndex;
    NSInteger _selectedEquivalenceOrientation;
    NSInteger _selectedEquivalenceTypeIndex;
    
    BOOL _isShowAllTime;
    BOOL _isCO2AvoidedInKilograms;
    BOOL _isGreenhouseEmissionsInKilograms;
    
    //------------equivalence------------
    
    //------------kpi------------
    
    NSInteger _selectedKpiMethodIndex;
    NSInteger _selectedKpiMetricsIndex;
    NSInteger _selectedKpiCompareMetricsIndex;
    
    //------------kpi------------
    
    NSInteger _selectedDashboardIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *ivBackground;

@property (nonatomic, assign) IBOutlet UIView *viewMain;

@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

@property (nonatomic, assign) IBOutlet UIView *viewWidgetTitle;
@property (nonatomic, assign) IBOutlet UITextField *txtWidgetTitle;

@property (nonatomic, assign) IBOutlet UIButton *btnShowWidgetTitle;

@property (nonatomic, assign) IBOutlet UIButton *btnTimeline;
@property (nonatomic, assign) IBOutlet UIButton *btnPie;
@property (nonatomic, assign) IBOutlet UIButton *btnBar;
@property (nonatomic, assign) IBOutlet UIButton *btnTable;
@property (nonatomic, assign) IBOutlet UIButton *btnImage;
@property (nonatomic, assign) IBOutlet UIButton *btnEquvalencies;
@property (nonatomic, assign) IBOutlet UIButton *btnKPI;

@property (nonatomic, assign) IBOutlet UIButton *btnAddWidget;
@property (nonatomic, assign) IBOutlet UIButton *btnCancel;

//-----------timeline-------------------------
@property (nonatomic, assign) IBOutlet UIView *viewTimelineOptions;

@property (nonatomic, assign) IBOutlet UIView *viewTimelineMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtTimelineMetric;

@property (nonatomic, assign) IBOutlet UIView *viewTimelineCompare;
@property (nonatomic, assign) IBOutlet UITextField *txtTimelineCompare;

@property (nonatomic, assign) IBOutlet UIView *viewTimelineGroupDimention;
@property (nonatomic, assign) IBOutlet UITextField *txtTimelineGroupDimention;

@property (nonatomic, assign) IBOutlet UIView *viewTimelineDrilldown;
@property (nonatomic, assign) IBOutlet UITextField *txtTimelineDrilldown;
//-----------timeline-------------------------

//-----------pie-------------------------
@property (nonatomic, assign) IBOutlet UIView *viewPieOptions;

@property (nonatomic, assign) IBOutlet UIView *viewPieMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtPieMetric;

@property (nonatomic, assign) IBOutlet UIView *viewPieGroupDimention;
@property (nonatomic, assign) IBOutlet UITextField *txtPieGroupDimention;

@property (nonatomic, assign) IBOutlet UIView *viewPieSliceCount;
@property (nonatomic, assign) IBOutlet UITextField *txtPieSliceCount;

@property (nonatomic, assign) IBOutlet UIView *viewPieDrilldown;
@property (nonatomic, assign) IBOutlet UITextField *txtPieDrilldown;
//-----------pie-------------------------

//-----------bar-------------------------
@property (nonatomic, assign) IBOutlet UIView *viewBarOptions;

@property (nonatomic, assign) IBOutlet UIView *viewBarMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtBarMetric;

@property (nonatomic, assign) IBOutlet UIView *viewBarGroupDimension;
@property (nonatomic, assign) IBOutlet UITextField *txtBarGroupDimension;

@property (nonatomic, assign) IBOutlet UIView *viewBarPivotDimension;
@property (nonatomic, assign) IBOutlet UITextField *txtBarPivotDimension;

@property (nonatomic, assign) IBOutlet UIView *viewBarDrilldown;
@property (nonatomic, assign) IBOutlet UITextField *txtBarDrilldown;
//-----------bar-------------------------

//-----------table-------------------------
@property (nonatomic, assign) IBOutlet UIView *viewTableOptions;

@property (nonatomic, assign) IBOutlet UIButton *btnTableExtraMetric;
@property (nonatomic, assign) IBOutlet UIButton *btnTableRemoveMetric;

@property (nonatomic, assign) IBOutlet UIView *viewTableMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtTableMetric;

@property (nonatomic, assign) IBOutlet UIView *viewTableExtraMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtTableExtraMetric;

@property (nonatomic, assign) IBOutlet UIView *viewTableGroupDimension;
@property (nonatomic, assign) IBOutlet UITextField *txtTableGroupDimension;

@property (nonatomic, assign) IBOutlet UIView *viewTableRows;
@property (nonatomic, assign) IBOutlet UITextField *txtTableRow;

@property (nonatomic, assign) IBOutlet UIView *viewTableDrilldown;
@property (nonatomic, assign) IBOutlet UITextField *txtTableDrilldown;
//-----------table-------------------------

//-----------equivalence-------------------------
@property (nonatomic, assign) IBOutlet UIView *viewEquivalenceOptions;

@property (nonatomic, assign) IBOutlet UIView *viewEquivalenceMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtEquivalenceMetric;

@property (nonatomic, assign) IBOutlet UIView *viewEquivalenceOrientation;
@property (nonatomic, assign) IBOutlet UITextField *txtEquivalenceOrientation;

@property (nonatomic, assign) IBOutlet UIView *viewEquivalenceType;
@property (nonatomic, assign) IBOutlet UITextField *txtEquivalenceType;

@property (nonatomic, assign) IBOutlet UIButton *btnShowAllTime;
@property (nonatomic, assign) IBOutlet UIButton *btnShowAllTime1;

@property (nonatomic, assign) IBOutlet UIButton *btnCO2AvoidedInKilograms;
@property (nonatomic, assign) IBOutlet UIButton *btnCO2AvoidedInKilograms1;

@property (nonatomic, assign) IBOutlet UIButton *btnGreenhouseEmissionsInKilograms;
@property (nonatomic, assign) IBOutlet UIButton *btnGreenhouseEmissionsInKilograms1;

@property (nonatomic, assign) IBOutlet UIView *viewEquivalenceDrilldown;
@property (nonatomic, assign) IBOutlet UITextField *txtEquivalenceDrilldown;
//-----------equivalance end-------------

//-----------kpi-------------------------
@property (nonatomic, assign) IBOutlet UIView *viewKPIOptions;

@property (nonatomic, assign) IBOutlet UIView *viewKPISummaryMethod;
@property (nonatomic, assign) IBOutlet UITextField *txtKPISummaryMethod;

@property (nonatomic, assign) IBOutlet UIView *viewKPIMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtKPIMetric;

@property (nonatomic, assign) IBOutlet UIView *viewKPILabel;
@property (nonatomic, assign) IBOutlet UITextField *txtKPILabel;

@property (nonatomic, assign) IBOutlet UIView *viewKPICompareMetric;
@property (nonatomic, assign) IBOutlet UITextField *txtKPICompareMetric;

@property (nonatomic, assign) IBOutlet UIView *viewKPICompareLabel;
@property (nonatomic, assign) IBOutlet UITextField *txtKPICompareLabel;
//-----------kpi-------------------------

@property (nonatomic, weak) ImageWidgetOptionView *vwImageWidgetOption;

@property (nonatomic, assign) NSInteger widgetType;

@property (nonatomic, retain) NSDictionary *widget;

@end

@implementation AddNewWidgetView

- (void) awakeFromNib
{
    self.widgetType = WIDGET_TIMELINE;
    
    _showTitle = YES;
    
    _selectedTimelineMetricsIndex = NSNotFound;
    _selectedTimelineCompareMetricsIndex = NSNotFound;
    _selectedTimelineGroupDimentionIndex = NSNotFound;
    
    _selectedPieMetricsIndex = NSNotFound;
    _selectedPieGroupDimentionIndex = NSNotFound;
    _selectedPieSliceCountIndex = NSNotFound;
    
    _selectedBarMetricsIndex = NSNotFound;
    _selectedBarGroupDimensionIndex = NSNotFound;
    _selectedBarPivotDimensionIndex = NSNotFound;
    
    _selectedTableMetricsIndex = NSNotFound;
    _selectedTableExtraMetricsIndex = NSNotFound;
    _selectedTableGroupDimensionIndex = NSNotFound;
    _selectedTableShowRows = NSNotFound;
    
    _selectedDashboardIndex = NSNotFound;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackground)];
    [self.ivBackground addGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    [self initView];
    
    [self updateUI];
}

- (void) initView
{
    self.viewMain.layer.borderColor = [UIColor colorWithRed:147.0f / 255.0f green:147.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f].CGColor;
    self.viewMain.layer.borderWidth = 1.0f;
    self.viewMain.layer.cornerRadius = 5.0f;
    self.viewMain.backgroundColor = [UIColor whiteColor];
    self.viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewMain.layer.shadowOpacity = 0.5f;
    self.viewMain.layer.shadowRadius = 3.0f;
    self.viewMain.layer.shadowOffset = CGSizeMake(-3, 3);
    
    self.viewWidgetTitle.layer.borderColor = [UIColor colorWithRed:147.0f / 255.0f green:147.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f].CGColor;
    self.viewWidgetTitle.layer.borderWidth = 1.0f;
    
    self.btnShowWidgetTitle.selected = _showTitle;
    
    [self setDropListFormatWithView:self.viewTimelineMetric];
    [self setDropListFormatWithView:self.viewTimelineCompare];
    [self setDropListFormatWithView:self.viewTimelineGroupDimention];
    [self setDropListFormatWithView:self.viewTimelineDrilldown];
    
    [self setDropListFormatWithView:self.viewPieMetric];
    [self setDropListFormatWithView:self.viewPieGroupDimention];
    [self setDropListFormatWithView:self.viewPieSliceCount];
    [self setDropListFormatWithView:self.viewPieDrilldown];
    
    [self setDropListFormatWithView:self.viewBarMetric];
    [self setDropListFormatWithView:self.viewBarGroupDimension];
    [self setDropListFormatWithView:self.viewBarPivotDimension];
    [self setDropListFormatWithView:self.viewBarDrilldown];
    
    [self setDropListFormatWithView:self.viewTableMetric];
    [self setDropListFormatWithView:self.viewTableExtraMetric];
    [self setDropListFormatWithView:self.viewTableGroupDimension];
    [self setDropListFormatWithView:self.viewTableRows];
    [self setDropListFormatWithView:self.viewTableDrilldown];
    
    [self setDropListFormatWithView:self.viewEquivalenceMetric];
    [self setDropListFormatWithView:self.viewEquivalenceOrientation];
    [self setDropListFormatWithView:self.viewEquivalenceType];
    [self setDropListFormatWithView:self.viewEquivalenceDrilldown];
    
    self.viewTableExtraMetric.hidden = YES;
    self.btnTableRemoveMetric.hidden = YES;
    self.btnTableExtraMetric.hidden = NO;
    
    self.btnAddWidget.layer.borderColor = [UIColor colorWithRed:25.0f / 255.0f green:171.0f / 255.0f blue:96.0f / 255.0f alpha:1.0f].CGColor;
    self.btnAddWidget.layer.borderWidth = 1.0f;
    self.btnAddWidget.layer.cornerRadius = 3.0f;
    
    self.btnCancel.layer.borderColor = [UIColor colorWithRed:51.0f / 255.0f green:137.0f / 255.0f blue:191.0f / 255.0f alpha:1.0f].CGColor;
    self.btnCancel.layer.borderWidth = 1.0f;
    self.btnCancel.layer.cornerRadius = 3.0f;
    
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"ImageWidgetOptionView" owner:self options:nil];
    self.vwImageWidgetOption = [nib objectAtIndex:0];
    [self.viewMain addSubview:self.vwImageWidgetOption];
    [self.vwImageWidgetOption setFrame:CGRectMake(0, 320, self.vwImageWidgetOption.frame.size.width, self.vwImageWidgetOption.frame.size.height)];
    [self.vwImageWidgetOption setHidden:YES];
    [self.vwImageWidgetOption setDelegate:self];
    
    [self bringSubviewToFront:self.viewMain];
}

- (void) setDropListFormatWithView:(UIView *)view
{
    view.layer.borderColor = [UIColor colorWithRed:147.0f / 255.0f green:147.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 3.0f;
}

- (void) onTapBackground
{
    [self onCancel:nil];
}

- (void) setWidgetId:(NSString *)widgetId
{
    _widgetId = widgetId;
    
    self.widget = [[[SharedMembers sharedInstance] getWidgetInfoWithId:_widgetId] objectForKey:@"widget"];
    
    NSLog(@"%@", self.widget);
    
    if(self.widget == nil) return;
    
    self.lblTitle.text = @"Update a Widget";
    [self.btnAddWidget setTitle:@"Update Widget" forState:UIControlStateNormal];
    
    [self loadWidgetDatas];
}

- (void) loadWidgetDatas
{
    self.txtWidgetTitle.text = [self.widget objectForKey:@"title"];
    
    _showTitle = [[self.widget objectForKey:@"titleShow"] boolValue];
    
    NSString *type = [self.widget objectForKey:@"type"];
    
    self.widgetType = [WidgetInfo getWidgetTypeIndexWithString:type];
    
    if(self.widgetType == WIDGET_TIMELINE)
    {
        [self loadTimelineWidget];
    }
    else if(self.widgetType == WIDGET_PIE)
    {
        [self loadPieWidget];
    }
    else if(self.widgetType == WIDGET_BAR)
    {
        [self loadBarWidget];
    }
    else if(self.widgetType == WIDGET_TABLE)
    {
        [self loadTableWidget];
    }
    else if(self.widgetType == WIDGET_EQUIVALENCIES)
    {
        [self loadEquivalenceWidget];
    }
    else if(self.widgetType == WIDGET_KPI)
    {
        [self loadKpiWidget];
    }
    
    [self updateUI];
}

- (void) loadTimelineWidget
{
    NSDictionary *metric = [self.widget objectForKey:@"metric"];
    
    if(metric != nil && [metric isKindOfClass:[NSDictionary class]])
    {
        NSString *metricId = [metric objectForKey:@"_id"];
        
        _selectedTimelineMetricsIndex = [self getMetricsIndexWithId:metricId];
        self.txtTimelineMetric.text = [metric objectForKey:@"name"];
    }
    else
    {
        _selectedTimelineMetricsIndex = NSNotFound;
        self.txtTimelineMetric.text = @"";
    }
    
    NSDictionary *compareMetric = [self.widget objectForKey:@"compareMetric"];
    
    if(compareMetric != nil && [compareMetric isKindOfClass:[NSDictionary class]])
    {
        NSString *compareMetricId = [compareMetric objectForKey:@"_id"];
        
        _selectedTimelineCompareMetricsIndex = [self getMetricsIndexWithId:compareMetricId];
        self.txtTimelineCompare.text = [compareMetric objectForKey:@"name"];
    }
    else
    {
        _selectedTimelineCompareMetricsIndex = NSNotFound;
        self.txtTimelineCompare.text = @"";
    }
    
    NSString *groupDimension = [self.widget objectForKey:@"groupDimension"];
    
    if([groupDimension isKindOfClass:[NSString class]] && groupDimension.length > 0)
    {
        _selectedTimelineGroupDimentionIndex = NSNotFound;
        self.txtTimelineGroupDimention.text = @"";
        for (int n = 0 ; n < [SharedMembers sharedInstance].aryGroupDimentions.count ; n ++) {
            NSDictionary *dimension = [[SharedMembers sharedInstance].aryGroupDimentions objectAtIndex:n];
            
            NSString *value = [dimension objectForKey:@"value"];
            if([value isEqualToString:groupDimension])
            {
                _selectedTimelineGroupDimentionIndex = n;
                self.txtTimelineGroupDimention.text = groupDimension;
                
                break;
            }
        }
    }
    else{
        _selectedTimelineGroupDimentionIndex = NSNotFound;
        self.txtTimelineGroupDimention.text = @"";
    }
}

- (void) loadPieWidget
{
    NSDictionary *metric = [self.widget objectForKey:@"metric"];
    
    if(metric != nil && [metric isKindOfClass:[NSDictionary class]])
    {
        NSString *metricId = [metric objectForKey:@"_id"];
        
        _selectedPieMetricsIndex = [self getMetricsIndexWithId:metricId];
        self.txtPieMetric.text = [metric objectForKey:@"name"];
    }
    else
    {
        _selectedPieMetricsIndex = NSNotFound;
        self.txtPieMetric.text = @"";
    }
    
    NSString *groupDimension = [self.widget objectForKey:@"groupDimension"];
    
    if([groupDimension isKindOfClass:[NSString class]] && groupDimension.length > 0)
    {
        _selectedPieGroupDimentionIndex = NSNotFound;
        self.txtPieGroupDimention.text = @"";
        for (int n = 0 ; n < [SharedMembers sharedInstance].aryGroupDimentions.count ; n ++) {
            NSDictionary *dimension = [[SharedMembers sharedInstance].aryGroupDimentions objectAtIndex:n];
            
            NSString *value = [dimension objectForKey:@"value"];
            if([value isEqualToString:groupDimension])
            {
                _selectedPieGroupDimentionIndex = n;
                self.txtPieGroupDimention.text = groupDimension;
                
                break;
            }
        }
    }
    else{
        _selectedPieGroupDimentionIndex = NSNotFound;
        self.txtPieGroupDimention.text = @"";
    }
    
    int slices_ = [[self.widget objectForKey:@"showUpTo"] intValue];
    
    _selectedPieSliceCountIndex = NSNotFound;
    self.txtPieSliceCount.text = @"";
    if(slices > 0)
    {
        for (int n = 0 ; n < MAX_COUNT_SLICES; n ++) {
            if([slices[n] intValue] == slices_)
            {
                _selectedPieSliceCountIndex = n;
                
                NSString *value = [NSString stringWithFormat:@"%@ slices", slices[n]];
                self.txtPieSliceCount.text = value;
                
                break;
            }
        }
    }
}

- (void) loadBarWidget
{
    NSDictionary *metric = [self.widget objectForKey:@"metric"];
    
    if(metric != nil && [metric isKindOfClass:[NSDictionary class]])
    {
        NSString *metricId = [metric objectForKey:@"_id"];
        
        _selectedBarMetricsIndex = [self getMetricsIndexWithId:metricId];
        
        if(_selectedBarMetricsIndex == NSNotFound)
        {
            self.txtBarMetric.text = @"";
        }
        else
        {
            self.txtBarMetric.text = [metric objectForKey:@"name"];
        }
    }
    else
    {
        _selectedBarMetricsIndex = NSNotFound;
        self.txtBarMetric.text = @"";
    }
    
    NSString *groupDimension = [self.widget objectForKey:@"groupDimension"];
    
    if([groupDimension isKindOfClass:[NSString class]] && groupDimension.length > 0)
    {
        _selectedBarGroupDimensionIndex = NSNotFound;
        self.txtBarGroupDimension.text = @"";
        for (int n = 0 ; n < [SharedMembers sharedInstance].aryGroupDimentions.count ; n ++) {
            NSDictionary *dimension = [[SharedMembers sharedInstance].aryGroupDimentions objectAtIndex:n];
            
            NSString *value = [dimension objectForKey:@"value"];
            if([value isEqualToString:groupDimension])
            {
                _selectedBarGroupDimensionIndex = n;
                self.txtBarGroupDimension.text = groupDimension;
                
                break;
            }
        }
    }
    else{
        _selectedBarGroupDimensionIndex = NSNotFound;
        self.txtBarGroupDimension.text = @"";
    }
    
    NSString *pivotDimension = [self.widget objectForKey:@"pivotDimension"];
    
    if([pivotDimension isKindOfClass:[NSString class]] && pivotDimension.length > 0)
    {
        NSArray *aryPivotDimension = @[@"day", @"hour", @"minute"];
        
        _selectedBarPivotDimensionIndex = [aryPivotDimension indexOfObject:pivotDimension];
        self.txtBarPivotDimension.text = [pivotDimension capitalizedString];
    }
    else{
        _selectedBarPivotDimensionIndex = NSNotFound;
        self.txtBarPivotDimension.text = @"";
    }
}

- (void) loadTableWidget
{
    NSDictionary *metric = [self.widget objectForKey:@"metric"];
    
    if(metric != nil && [metric isKindOfClass:[NSDictionary class]])
    {
        NSString *metricId = [metric objectForKey:@"_id"];
        
        _selectedTableMetricsIndex = [self getMetricsIndexWithId:metricId];
        self.txtTableMetric.text = [metric objectForKey:@"name"];
    }
    else
    {
        _selectedTableMetricsIndex = NSNotFound;
        self.txtTableMetric.text = @"";
    }
    
    NSDictionary *compareMetric = [self.widget objectForKey:@"compareMetric"];
    
    if(compareMetric != nil && [compareMetric isKindOfClass:[NSDictionary class]])
    {
        NSString *compareMetricId = [compareMetric objectForKey:@"_id"];
        
        _selectedTableExtraMetricsIndex = [self getMetricsIndexWithId:compareMetricId];
        self.txtTableExtraMetric.text = [compareMetric objectForKey:@"name"];
    }
    else
    {
        _selectedTableExtraMetricsIndex = NSNotFound;
        self.txtTableExtraMetric.text = @"";
    }

    NSString *groupDimension = [self.widget objectForKey:@"groupDimension"];
    
    if([groupDimension isKindOfClass:[NSString class]] && groupDimension.length > 0)
    {
        _selectedTableGroupDimensionIndex = NSNotFound;
        self.txtTableGroupDimension.text = @"";
        for (int n = 0 ; n < [SharedMembers sharedInstance].aryGroupDimentions.count ; n ++) {
            NSDictionary *dimension = [[SharedMembers sharedInstance].aryGroupDimentions objectAtIndex:n];
            
            NSString *value = [dimension objectForKey:@"value"];
            if([value isEqualToString:groupDimension])
            {
                _selectedTableGroupDimensionIndex = n;
                self.txtTableGroupDimension.text = groupDimension;
                
                break;
            }
        }
    }
    else{
        _selectedTableGroupDimensionIndex = NSNotFound;
        self.txtTableGroupDimension.text = @"";
    }
    
    int rowsPerTable = [[self.widget objectForKey:@"rowsPerTable"] intValue];
    
    if(rowsPerTable > 0)
    {
        _selectedTableShowRows = rowsPerTable / 5;
        self.txtTableRow.text = [NSString stringWithFormat:@"%d Rows", (int)_selectedTableShowRows * 5];
    }
    else{
        _selectedTableShowRows = NSNotFound;
        self.txtTableRow.text = @"";
    }
}

- (void) loadEquivalenceWidget
{
    NSDictionary *metric = [self.widget objectForKey:@"metric"];
    
    if(metric != nil && [metric isKindOfClass:[NSDictionary class]])
    {
        NSString *metricId = [metric objectForKey:@"_id"];
        
        _selectedEquivalenceMetricsIndex = [self getMetricsIndexWithId:metricId];
        self.txtEquivalenceMetric.text = [metric objectForKey:@"name"];
    }
    else
    {
        _selectedTableMetricsIndex = NSNotFound;
        self.txtEquivalenceMetric.text = @"";
    }
    
    NSString *orientation = [self.widget objectForKey:@"orientation"];
    
    if([orientation isKindOfClass:[NSString class]])
    {
        if([orientation isEqualToString:@"vertical"])
        {
            _selectedEquivalenceOrientation = EQUI_ORIENTATION_VERTICAL;
            self.txtEquivalenceOrientation.text = @"Vertical";
        }
        else if([orientation isEqualToString:@"horizontal"])
        {
            _selectedEquivalenceOrientation = EQUI_ORIENTATION_HORIZONTAL;
            self.txtEquivalenceOrientation.text = @"Horizontal";
        }
        else
        {
            _selectedEquivalenceOrientation = NSNotFound;
            self.txtEquivalenceOrientation.text = @"";
        }
    }
    else{
        _selectedEquivalenceOrientation = NSNotFound;
        self.txtEquivalenceOrientation.text = @"";
    }
    
    NSString *equivType = [self.widget objectForKey:@"equivType"];
    
    if([equivType isKindOfClass:[NSString class]])
    {
        _selectedEquivalenceTypeIndex = NSNotFound;
        self.txtEquivalenceType.text = @"";
        
        for (int n = 0 ; n < MAX_COUNT_EQUI_TYPES; n ++) {
            if([equivType isEqualToString:equivalenceTypes[n]])
            {
                _selectedEquivalenceTypeIndex = n;
                self.txtEquivalenceType.text = equivType;
            }
        }
    }
    else{
        _selectedEquivalenceTypeIndex = NSNotFound;
        self.txtEquivalenceType.text = @"";
    }
    
    _isShowAllTime = [[self.widget objectForKey:@"showAllTime"] boolValue];
    self.btnShowAllTime.selected = _isShowAllTime;
    
    _isCO2AvoidedInKilograms = [[self.widget objectForKey:@"co2Kilograms"] boolValue];
    self.btnCO2AvoidedInKilograms.selected = _isCO2AvoidedInKilograms;
    
    _isGreenhouseEmissionsInKilograms = [[self.widget objectForKey:@"greenhouseKilograms"] boolValue];
    self.btnGreenhouseEmissionsInKilograms.selected = _isGreenhouseEmissionsInKilograms;
}

- (void) loadKpiWidget
{
    NSString *summmaryMethod = [self.widget objectForKey:@"summaryMethod"];
    
    _selectedKpiMethodIndex = NSNotFound;
    self.txtKPISummaryMethod.text = @"";
    
    if([summmaryMethod isKindOfClass:[NSString class]])
    {
        for (int n = 0 ; n < MAX_COUNT_KPI_METHOD; n ++) {
            
            if([summmaryMethod isEqualToString:kpiSummaryMethod[n]])
            {
                _selectedKpiMethodIndex = n;
                self.txtKPISummaryMethod.text = kpiSummaryMethod[n];
                
                break;
            }
        }
    }
    
    NSDictionary *metric = [self.widget objectForKey:@"metric"];
    
    if(metric != nil && [metric isKindOfClass:[NSDictionary class]])
    {
        NSString *metricId = [metric objectForKey:@"_id"];
        
        _selectedKpiMetricsIndex = [self getMetricsIndexWithId:metricId];
        self.txtKPIMetric.text = [metric objectForKey:@"name"];
    }
    else
    {
        _selectedKpiMetricsIndex = NSNotFound;
        self.txtKPIMetric.text = @"";
    }
    
    NSDictionary *compareMetric = [self.widget objectForKey:@"compareMetric"];
    
    if(compareMetric != nil && [compareMetric isKindOfClass:[NSDictionary class]])
    {
        NSString *metricId = [compareMetric objectForKey:@"_id"];
        
        _selectedKpiCompareMetricsIndex = [self getMetricsIndexWithId:metricId];
        self.txtKPICompareMetric.text = [compareMetric objectForKey:@"name"];
    }
    else
    {
        _selectedKpiCompareMetricsIndex = NSNotFound;
        self.txtKPICompareMetric.text = @"";
    }
    
    
    NSString *label = [self.widget objectForKey:@"label"];
    
    if([label isKindOfClass:[NSString class]])
    {
        self.txtKPILabel.text = label;
    }
    else{
        self.txtKPILabel.text = @"";
    }
    
    NSString *compareLabel = [self.widget objectForKey:@"compareLabel"];
    
    if([compareLabel isKindOfClass:[NSString class]])
    {
        self.txtKPICompareLabel.text = compareLabel;
    }
    else{
        self.txtKPICompareLabel.text = @"";
    }
}

- (IBAction)onAddWidget:(id)sender
{
    NSString *title = self.txtWidgetTitle.text;
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    if(title.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input a valid widget's name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return ;
    }
    
    BOOL success = NO;
    if(self.widgetType == WIDGET_TIMELINE)
    {
        success = [self addTimelineWidget:title];
    }
    else if(self.widgetType == WIDGET_PIE)
    {
        success = [self addPieWidget:title];
    }
    else if(self.widgetType == WIDGET_BAR)
    {
        success = [self addBarWidget:title];
    }
    else if(self.widgetType == WIDGET_TABLE)
    {
        success = [self addTableWidget:title];
    }
    else if(self.widgetType == WIDGET_EQUIVALENCIES)
    {
        success = [self addEquivalenceWidget:title];
    }
    else if(self.widgetType == WIDGET_KPI)
    {
        success = [self addKpiWidget:title];
    }
    else if(self.widgetType == WIDGET_IMAGE)
    {
        DashboardInfo *dashboard = [self getDashboardWithButtonIndex:_selectedDashboardIndex];
        success = [self.vwImageWidgetOption AddWidget:title dashboardId:dashboard._id];
    }
    
    if(success == NO) return;
    
    [self removeFromSuperview];
}

- (BOOL) addTimelineWidget:(NSString *)title
{
    if(_selectedTimelineMetricsIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select metrics" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedTimelineGroupDimentionIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select Group Dimension." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    NSString *metricsId = [self getMetricsIdWithButtonIndex:_selectedTimelineMetricsIndex];
    NSString *compareMetricsId = [self getMetricsIdWithButtonIndex:_selectedTimelineCompareMetricsIndex];
    NSString *groupDimention = [self getGroupDimentionIdWithButtonIndex:_selectedTimelineGroupDimentionIndex];
    
    DashboardInfo *dashboard = [self getDashboardWithButtonIndex:_selectedDashboardIndex];
    
    WidgetInfo *widget = [[WidgetInfo alloc] initWithTitle:title showTitle:self.btnShowWidgetTitle.isSelected type:self.widgetType metric:metricsId compareWith:compareMetricsId dashboard:dashboard._id];
    
    widget.groupDimention = groupDimention;
    
    if(self.widget)
    {
        widget._id = [self.widget objectForKey:@"_id"];
    }
    
    [self.delegate addNewWidget:widget];
    
    return YES;
}

- (BOOL) addPieWidget:(NSString *)title
{
    if(_selectedPieMetricsIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select metrics" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedPieGroupDimentionIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select Group Dimension." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedPieSliceCountIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select nuber of slices." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    NSString *metricsId = [self getMetricsIdWithButtonIndex:_selectedPieMetricsIndex];
    NSString *groupDimention = [self getGroupDimentionIdWithButtonIndex:_selectedPieGroupDimentionIndex];
    int slices = [self getSliceWithButtonIndex:_selectedPieSliceCountIndex];
    
    DashboardInfo *dashboard = [self getDashboardWithButtonIndex:_selectedDashboardIndex];
    
    WidgetInfo *widget = [[WidgetInfo alloc] initWithTitle:title showTitle:self.btnShowWidgetTitle.isSelected type:self.widgetType];
    
    if(self.widget)
    {
        widget._id = [self.widget objectForKey:@"_id"];
    }
    
    widget.metric = metricsId;
    widget.groupDimention = groupDimention;
    widget.showUpTo = slices;
    
    widget.dashboardId = dashboard._id;
    
    [self.delegate addNewWidget:widget];
    
    return YES;
}

- (BOOL) addBarWidget:(NSString *)title
{
    if(_selectedBarMetricsIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select metrics" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedBarGroupDimensionIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select Group Dimension." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedBarPivotDimensionIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select pivot Dimension." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    NSString *metricsId = [self getMetricsIdWithButtonIndex:_selectedBarMetricsIndex];
    NSString *groupDimention = [self getGroupDimentionIdWithButtonIndex:_selectedBarGroupDimensionIndex];
    
    DashboardInfo *dashboard = [self getDashboardWithButtonIndex:_selectedDashboardIndex];
    
    WidgetInfo *widget = [[WidgetInfo alloc] initWithTitle:title showTitle:self.btnShowWidgetTitle.isSelected type:self.widgetType];
    
    if(self.widget)
    {
        widget._id = [self.widget objectForKey:@"_id"];
    }
    
    widget.metric = metricsId;
    widget.groupDimention = groupDimention;
    
    widget.dashboardId = dashboard._id;
    
    if(_selectedBarPivotDimensionIndex == 0)
    {
        widget.pivotDimention = @"day";
    }
    else if(_selectedBarPivotDimensionIndex == 1)
    {
        widget.pivotDimention = @"hour";
    }
    else if(_selectedBarPivotDimensionIndex == 1)
    {
        widget.pivotDimention = @"minute";
    }
    else
    {
        widget.pivotDimention = @"day";
    }
    
    [self.delegate addNewWidget:widget];
    
    return YES;
}

- (BOOL) addTableWidget:(NSString *)title
{
    if(_selectedTableMetricsIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select metrics" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedTableGroupDimensionIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select Group Dimension." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedTableShowRows == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select the number of rows." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    NSString *metricsId = [self getMetricsIdWithButtonIndex:_selectedTableMetricsIndex];
    NSString *groupDimention = [self getGroupDimentionIdWithButtonIndex:_selectedTableGroupDimensionIndex];
    
    DashboardInfo *dashboard = [self getDashboardWithButtonIndex:_selectedDashboardIndex];
    
    WidgetInfo *widget = [[WidgetInfo alloc] initWithTitle:title showTitle:self.btnShowWidgetTitle.isSelected type:self.widgetType];
    
    if(self.widget)
    {
        widget._id = [self.widget objectForKey:@"_id"];
    }
    
    widget.metric = metricsId;
    
    if(_selectedTableExtraMetricsIndex != NSNotFound)
    {
        NSString *extraMetricsId = [self getMetricsIdWithButtonIndex:_selectedTableExtraMetricsIndex];
        widget.metricCompareWith = extraMetricsId;
    }
    
    widget.groupDimention = groupDimention;
    
    int rows = 0;
    if(_selectedTableShowRows == NSNotFound) rows = 5;
    else rows = (int)(_selectedTableShowRows + 1) * 5;
    widget.rowsPerTable = rows;
    
    widget.dashboardId = dashboard._id;
    
    [self.delegate addNewWidget:widget];
    
    return YES;
}

- (BOOL) addEquivalenceWidget:(NSString *)title
{
    if(_selectedEquivalenceMetricsIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select metrics" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedEquivalenceOrientation == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select orientation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedEquivalenceTypeIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select type of widget." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    NSString *metricsId = [self getMetricsIdWithButtonIndex:_selectedEquivalenceMetricsIndex];
    NSString *equivType = [self getEquivalenceStringWithButtonIndex:_selectedEquivalenceTypeIndex];
    NSString *orientation = [self getOrientationWithButtonIndex:_selectedEquivalenceOrientation];
    
    DashboardInfo *dashboard = [self getDashboardWithButtonIndex:_selectedDashboardIndex];
    
    WidgetInfo *widget = [[WidgetInfo alloc] initWithTitle:title showTitle:self.btnShowWidgetTitle.isSelected type:self.widgetType];
    
    if(self.widget)
    {
        widget._id = [self.widget objectForKey:@"_id"];
    }
    
    widget.metric = metricsId;
    widget.dashboardId = dashboard._id;
    
    widget.orientation = orientation;
    widget.equivType = equivType;
    widget.showAllTime = _isShowAllTime;
    widget.co2Kilograms = _isCO2AvoidedInKilograms;
    widget.greenhouseKilograms = _isGreenhouseEmissionsInKilograms;
    
    [self.delegate addNewWidget:widget];
    
    return YES;
}

- (BOOL) addKpiWidget:(NSString *)title
{
    if(_selectedKpiMethodIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select summary method." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedKpiMetricsIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select metric." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(self.txtKPILabel.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input label." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(_selectedKpiCompareMetricsIndex == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select compare metric." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    if(self.txtKPILabel.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input compare label." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        alertView = nil;
        
        return NO;
    }
    
    NSString *metricsId = [self getMetricsIdWithButtonIndex:_selectedKpiMethodIndex];
    NSString *compareMetricsId = [self getMetricsIdWithButtonIndex:_selectedKpiCompareMetricsIndex];
    
    NSString *label = self.txtKPILabel.text;
    NSString *compareLabel = self.txtKPICompareLabel.text;
    
    DashboardInfo *dashboard = [self getDashboardWithButtonIndex:NSNotFound];
    
    WidgetInfo *widget = [[WidgetInfo alloc] initWithTitle:title showTitle:self.btnShowWidgetTitle.isSelected type:self.widgetType];
    
    if(self.widget)
    {
        widget._id = [self.widget objectForKey:@"_id"];
    }
    
    widget.summaryMethod = kpiSummaryMethod[_selectedKpiMethodIndex];
    
    widget.metric = metricsId;
    widget.metricCompareWith = compareMetricsId;
    
    widget.label = label;
    widget.compareLabel = compareLabel;
    
    widget.dashboardId = dashboard._id;
    
    [self.delegate addNewWidget:widget];
    
    return YES;
}

- (IBAction)onCancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)onSelectWidgetType:(id)sender
{
    if(self.widget != nil) return;
    
    NSInteger selectedWidgetType = ((UIButton *)sender).tag;
    
    if(self.widgetType == selectedWidgetType) return;
    
    self.widgetType = selectedWidgetType;
    
    [self updateUI];
}

- (IBAction)onShowTitle:(id)sender
{
    self.btnShowWidgetTitle.selected = !self.btnShowWidgetTitle.isSelected;
}

- (IBAction)onAddTableExtraMetric:(id)sender
{
    self.viewTableExtraMetric.hidden = NO;
    self.btnTableRemoveMetric.hidden = NO;
    
    self.btnTableExtraMetric.hidden = YES;
}

- (IBAction)onRemoveTableExtraMetric:(id)sender
{
    _selectedTableExtraMetricsIndex = NSNotFound;
    
    self.viewTableExtraMetric.hidden = YES;
    self.btnTableRemoveMetric.hidden = YES;
    
    self.btnTableExtraMetric.hidden = NO;
}

- (IBAction)onShowAllTime:(id)sender
{
    _isShowAllTime = !_isShowAllTime;
    
    self.btnShowAllTime.selected = _isShowAllTime;
}

- (IBAction)onCO2AvoidedInKilograms:(id)sender
{
    _isCO2AvoidedInKilograms = !_isCO2AvoidedInKilograms;
    
    self.btnCO2AvoidedInKilograms.selected = _isCO2AvoidedInKilograms;
}

- (IBAction)onGreenhouseEmissionsInKilograms:(id)sender
{
    _isGreenhouseEmissionsInKilograms = !_isGreenhouseEmissionsInKilograms;
    
    self.btnGreenhouseEmissionsInKilograms.selected = _isGreenhouseEmissionsInKilograms;
}

- (void) updateUI
{
    self.btnShowWidgetTitle.selected = _showTitle;
    
    self.btnTimeline.selected = (self.widgetType == WIDGET_TIMELINE);
    self.btnPie.selected = (self.widgetType == WIDGET_PIE);
    self.btnBar.selected = (self.widgetType == WIDGET_BAR);
    self.btnTable.selected = (self.widgetType == WIDGET_TABLE);
    self.btnImage.selected = (self.widgetType == WIDGET_IMAGE);
    self.btnEquvalencies.selected = (self.widgetType == WIDGET_EQUIVALENCIES);
    self.btnKPI.selected = (self.widgetType == WIDGET_KPI);
    
    self.viewTimelineOptions.hidden = !(self.widgetType == WIDGET_TIMELINE);
    self.viewPieOptions.hidden = !(self.widgetType == WIDGET_PIE);
    self.viewBarOptions.hidden = !(self.widgetType == WIDGET_BAR);
    self.viewTableOptions.hidden = !(self.widgetType == WIDGET_TABLE);
    self.viewEquivalenceOptions.hidden = !(self.widgetType == WIDGET_EQUIVALENCIES);
    self.viewKPIOptions.hidden = !(self.widgetType == WIDGET_KPI);
    self.vwImageWidgetOption.hidden = !(self.widgetType == WIDGET_IMAGE);
}

- (void) showDroplist:(UITextField *)textFiled
{
    UIActionSheet *actionSheet = nil;
    if(textFiled == self.txtTimelineMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_TIMELINE_METRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTimelineCompare)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Compare with" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_TIMELINE_COMPARE;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTimelineGroupDimention)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Group Dimension" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_TIMELINE_GROUPDIMENTION;
        [self addGroupDimentionsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTimelineDrilldown)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Dashboard" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_DRILLDOWN;
        
        [self addDashboardButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtPieMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_PIE_METRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtPieGroupDimention)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Group Dimension" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_PIE_GROUPDIMENTION;
        [self addGroupDimentionsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtPieSliceCount)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Slice Counts" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_PIE_SLICES;
        [self addSlicesButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtPieDrilldown)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Dashboard" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_DRILLDOWN;
        [self addDashboardButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtBarMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_BAR_METRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtBarGroupDimension)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Group Dimension" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_BAR_GROUPDIMENSION;
        [self addGroupDimentionsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtBarPivotDimension)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Pivot Dimension" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_BAR_PIVOTDIMENSION;
        [self addPivotDimensionsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtBarDrilldown)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Dashboard" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_DRILLDOWN;
        [self addDashboardButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTableMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_TABLE_METRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTableExtraMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_TABLE_EXTRA_METRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTableGroupDimension)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Group Dimension" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_TABLE_GROUPDIMENSION;
        [self addGroupDimentionsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTableRow)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Rows Per a Table" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_TABLE_SHOW_ROWS;
        [self addRowsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtTableDrilldown)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Dashboard" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_DRILLDOWN;
        [self addDashboardButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtEquivalenceMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_EQUI_METRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtEquivalenceOrientation)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Orientation" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_EQUI_ORIENTATION;
        [self addOrientationButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtEquivalenceType)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_EQUI_TYPE;
        [self addEquivalenceTypesToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtKPISummaryMethod)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Summary Method" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_KPI_SUMMARYMETHOD;
        [self addKPISummaryMethodToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtKPIMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_KPI_METRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtKPICompareMetric)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Compare Metric" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_KPI_COMPAREMETRIC;
        [self addMetricsButtonsToActionSheet:actionSheet];
    }
    else if(textFiled == self.txtEquivalenceDrilldown)
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Dashboard" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = DROP_DRILLDOWN;
        [self addDashboardButtonsToActionSheet:actionSheet];
    }
    
    [actionSheet showInView:self];
    actionSheet = nil;
}

- (NSArray *) getMetrics
{
    NSString *widgetTypeKey = @"";
    
    if(self.widgetType == WIDGET_TIMELINE)
        widgetTypeKey = @"Timeline";
    else if(self.widgetType == WIDGET_PIE)
        widgetTypeKey = @"Pie";
    else if(self.widgetType == WIDGET_BAR)
        widgetTypeKey = @"Bar";
    else if(self.widgetType == WIDGET_EQUIVALENCIES)
        widgetTypeKey = @"Equivalencies";
    else if(self.widgetType == WIDGET_IMAGE)
        widgetTypeKey = @"Image";
    else if(self.widgetType == WIDGET_TABLE)
        widgetTypeKey = @"Table";
    else if(self.widgetType == WIDGET_KPI)
        widgetTypeKey = @"Timeline";
    
    return [[SharedMembers sharedInstance].metrics objectForKey:widgetTypeKey];
}

- (void) addMetricsButtonsToActionSheet:(UIActionSheet *)actionsheet
{
    NSArray *metrics = [self getMetrics];
    
    for (NSMutableDictionary *metric in metrics) {
        
        NSString *title = [metric objectForKey:@"name"];
        
        [actionsheet addButtonWithTitle:title];
    }
}

- (NSString *) getMetricsIdWithButtonIndex:(NSInteger) index
{
    if(index == NSNotFound) return nil;
    
    NSArray *metrics = [self getMetrics];
    
    if(metrics.count <= index) return nil;
    
    NSMutableDictionary *metric = [metrics objectAtIndex:index];
        
    return [metric objectForKey:@"_id"];
}

- (NSInteger) getMetricsIndexWithId:(NSString *)metricId
{
    NSInteger metricIndex = 0;
    
    NSArray *metrics = [self getMetrics];
    for (NSMutableDictionary *metric in metrics) {
        
        NSString *metricId_ = [metric objectForKey:@"_id"];
        
        if([metricId_ isEqualToString:metricId])
            return metricIndex;
        
        metricIndex ++;
    }
    
    return NSNotFound;
}

- (void) addSlicesButtonsToActionSheet:(UIActionSheet *)actionsheet
{
    for (int n = 0 ; n < MAX_COUNT_SLICES ; n ++) {
        NSString *value = [NSString stringWithFormat:@"%@ slices", slices[n]];
        [actionsheet addButtonWithTitle:value];
    }
}

- (int) getSliceWithButtonIndex:(NSInteger) index
{
    if(index < 0 || index >= MAX_COUNT_SLICES)
        index = 0;
    
    return [slices[index] intValue];
}

- (void) addGroupDimentionsButtonsToActionSheet:(UIActionSheet *)actionsheet
{
    for (NSMutableDictionary *groupDimention in [SharedMembers sharedInstance].aryGroupDimentions) {
        
        NSString *value = [groupDimention objectForKey:@"value"];
        
        [actionsheet addButtonWithTitle:value];
    }
}

- (void) addPivotDimensionsButtonsToActionSheet:(UIActionSheet *)actionsheet
{
    [actionsheet addButtonWithTitle:@"Day"];
    [actionsheet addButtonWithTitle:@"Hour"];
    [actionsheet addButtonWithTitle:@"Minute"];
}

- (void) addRowsButtonsToActionSheet:(UIActionSheet *)actionsheet
{
    for (int n = 1 ; n < 5 ; n ++) {
        
        NSString *value = [NSString stringWithFormat:@"%d Rows", n * 5];
        
        [actionsheet addButtonWithTitle:value];
    }
}

- (NSString *) getGroupDimentionIdWithButtonIndex:(NSInteger) index
{
    if(index == NSNotFound) return nil;
    
    if([SharedMembers sharedInstance].aryGroupDimentions.count <= index) return nil;
    
    NSMutableDictionary *groupDimention = [[SharedMembers sharedInstance].aryGroupDimentions objectAtIndex:index];
    
    return [groupDimention objectForKey:@"value"];
}

- (void) addOrientationButtonsToActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet addButtonWithTitle:@"Vertical"];
    [actionSheet addButtonWithTitle:@"Horizontal"];
}

- (NSString *) getOrientationWithButtonIndex:(NSInteger)index
{
    if(index == 0)
        return @"vertical";
    
    return @"horizontal";
}

- (void) addEquivalenceTypesToActionSheet:(UIActionSheet *)actionSheet
{
    for (int n = 0 ; n < MAX_COUNT_EQUI_TYPES ; n ++) {
        
        [actionSheet addButtonWithTitle:equivalenceTypes[n]];
    }
}

- (NSString *) getEquivalenceStringWithButtonIndex:(NSInteger)index
{
    return equivalenceTypes[index];
}

- (void) addDashboardButtonsToActionSheet:(UIActionSheet *)actionsheet
{
    for (CollectionInfo *collection in [SharedMembers sharedInstance].aryCollections) {

        for (DashboardInfo *dashboard in collection.aryDashboards) {
            
            [actionsheet addButtonWithTitle:dashboard.title];
        }
    }
}

- (void) addKPISummaryMethodToActionSheet:(UIActionSheet *)actionSheet
{
    for (int n = 0 ; n < MAX_COUNT_KPI_METHOD ; n ++) {
        
        [actionSheet addButtonWithTitle:kpiSummaryMethod[n]];
    }
}

- (DashboardInfo *) getDashboardWithButtonIndex:(NSInteger) index
{
    if(index == NSNotFound) return [SharedMembers sharedInstance].currentDashboard;
    
    NSInteger count = 0;
    for (CollectionInfo *collection in [SharedMembers sharedInstance].aryCollections) {
        
        for (DashboardInfo *dashboard in collection.aryDashboards) {
            
            if(index == count)
                return dashboard;
            
            count ++;
        }
    }
    
    return nil;
}

- (void) hideDroplist
{
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.txtWidgetTitle != textField &&
       self.txtKPILabel != textField &&
       self.txtKPICompareLabel != textField)
    {
        [self showDroplist:textField];
        
        return NO;
    }
    
    return YES;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 0 || buttonIndex >= actionSheet.numberOfButtons) return;
    
    if(actionSheet.tag == DROP_TIMELINE_METRIC)
    {
        _selectedTimelineMetricsIndex = buttonIndex;
        
        self.txtTimelineMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_TIMELINE_COMPARE)
    {
        _selectedTimelineCompareMetricsIndex = buttonIndex;
        
        self.txtTimelineCompare.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_TIMELINE_GROUPDIMENTION)
    {
        _selectedTimelineGroupDimentionIndex = buttonIndex;
        
        self.txtTimelineGroupDimention.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_PIE_METRIC)
    {
        _selectedPieMetricsIndex = buttonIndex;
        
        self.txtPieMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_PIE_GROUPDIMENTION)
    {
        _selectedPieGroupDimentionIndex = buttonIndex;
        
        self.txtPieGroupDimention.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_PIE_SLICES)
    {
        _selectedPieSliceCountIndex = buttonIndex;
        
        self.txtPieSliceCount.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_BAR_METRIC)
    {
        _selectedBarMetricsIndex = buttonIndex;
        
        self.txtBarMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_BAR_GROUPDIMENSION)
    {
        _selectedBarGroupDimensionIndex = buttonIndex;
        
        self.txtBarGroupDimension.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_BAR_PIVOTDIMENSION)
    {
        _selectedBarPivotDimensionIndex = buttonIndex;
        
        self.txtBarPivotDimension.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_TABLE_METRIC)
    {
        _selectedTableMetricsIndex = buttonIndex;
        
        self.txtTableMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_TABLE_EXTRA_METRIC)
    {
        _selectedTableExtraMetricsIndex = buttonIndex;
        
        self.txtTableExtraMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_TABLE_GROUPDIMENSION)
    {
        _selectedTableGroupDimensionIndex = buttonIndex;
        
        self.txtTableGroupDimension.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_TABLE_SHOW_ROWS)
    {
        _selectedTableShowRows = buttonIndex;
        
        self.txtTableRow.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_EQUI_METRIC)
    {
        _selectedEquivalenceMetricsIndex = buttonIndex;
        
        self.txtEquivalenceMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_EQUI_ORIENTATION)
    {
        _selectedEquivalenceOrientation = buttonIndex;
        
        self.txtEquivalenceOrientation.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_EQUI_TYPE)
    {
        _selectedEquivalenceTypeIndex = buttonIndex;
        
        self.txtEquivalenceType.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_KPI_SUMMARYMETHOD)
    {
        _selectedKpiMethodIndex = buttonIndex;
        
        self.txtKPISummaryMethod.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_KPI_METRIC)
    {
        _selectedKpiMetricsIndex = buttonIndex;
        
        self.txtKPIMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_KPI_COMPAREMETRIC)
    {
        _selectedKpiCompareMetricsIndex = buttonIndex;
        
        self.txtKPICompareMetric.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    else if(actionSheet.tag == DROP_DRILLDOWN)
    {
        _selectedDashboardIndex = buttonIndex;
        
        self.txtTimelineDrilldown.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.txtPieDrilldown.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.txtBarDrilldown.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.txtTableDrilldown.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.txtEquivalenceDrilldown.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

@end
