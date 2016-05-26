//
//  AddMetricView.m
//  BrighterLink
//
//  Created by mobile master on 11/18/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddMetricView.h"
#import "RelatedDataSourcesView.h"

@implementation AddMetricView

+(AddMetricView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddMetricView" owner:self options:nil];
    AddMetricView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;

    cmb_mMetric = [[JSCombo alloc] initWithFrame:CGRectMake(txt_mMetric.frame.origin.x, txt_mMetric.frame.origin.y, txt_mMetric.frame.size.width, 160)];
    [cmb_mMetric setDelegate:self];
    NSMutableArray* metrics = [[NSMutableArray alloc] init];
    [metrics addObject:@{@"text" : @"Watts(Power)"}];
    [metrics addObject:@{@"text" : @"Watt-Hours"}];
    [metrics addObject:@{@"text" : @"Max Watts"}];
    [metrics addObject:@{@"text" : @"Min Watts"}];
    [metrics addObject:@{@"text" : @"Irradiance"}];
    [metrics addObject:@{@"text" : @"Frequency"}];
    [metrics addObject:@{@"text" : @"Current"}];
    [metrics addObject:@{@"text" : @"Reactive Power"}];
    [metrics addObject:@{@"text" : @"Pressure"}];
    [metrics addObject:@{@"text" : @"Volumetric Flow"}];
    [metrics addObject:@{@"text" : @"Mass-Flow"}];
    [metrics addObject:@{@"text" : @"Resistance"}];
    [metrics addObject:@{@"text" : @"Apparent Power"}];
    [metrics addObject:@{@"text" : @"Total Harmonic Distortion"}];
    [metrics addObject:@{@"text" : @"Temperatur"}];
    [metrics addObject:@{@"text" : @"Voltage"}];
    [metrics addObject:@{@"text" : @"Numeric"}];
    [metrics addObject:@{@"text" : @"Monetary"}];
    [metrics addObject:@{@"text" : @"Angle"}];
    [metrics addObject:@{@"text" : @"Relative Humidity"}];
    [metrics addObject:@{@"text" : @"Speed"}];
    [metrics addObject:@{@"text" : @"--Custom--"}];
    [cmb_mMetric setSelectedItem:@{@"text" : @"Watts(Power)"}];
    [cmb_mMetric UpdateData:metrics];
    [self addSubview:cmb_mMetric];
    
    cmb_mSummeryMethod = [[JSCombo alloc] initWithFrame:CGRectMake(txt_mSummaryMethod.frame.origin.x, txt_mSummaryMethod.frame.origin.y, txt_mSummaryMethod.frame.size.width, 100)];
    [cmb_mSummeryMethod setDelegate:self];
    [cmb_mSummeryMethod UpdateData:@[@{@"text" : @"Total"}, @{@"text" : @"Average"}, @{@"text" : @"Count"}]];
    [cmb_mSummeryMethod setSelectedItem:@{@"text" : @"Total"}];
    [self addSubview:cmb_mSummeryMethod];
    
    cmb_mMetricType = [[JSCombo alloc] initWithFrame:CGRectMake(txt_mMetricType.frame.origin.x, txt_mMetricType.frame.origin.y, txt_mMetricType.frame.size.width, 100)];
    [cmb_mMetricType setDelegate:self];
    [cmb_mMetricType UpdateData:@[@{@"text" : @"Datafeed"}, @{@"text" : @"Calculated"}]];
    [cmb_mMetricType setSelectedItem:@{@"text" : @"Datafeed"}];
    [self addSubview:cmb_mMetricType];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideAllCombo)];
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(void)HideAllCombo
{
    [cmb_mMetric setHidden:YES];
    [cmb_mMetricType setHidden:YES];
    [cmb_mSummeryMethod setHidden:YES];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    if([control isEqual:cmb_mMetric])
    {
        [txt_mMetric setText:[obj objectForKey:@"text"]];
        if ([txt_mMetric.text isEqualToString:@"--Custom--"])
        {
            [txt_mMetricName setHidden:NO];
            [lbl_mMetricName setHidden:NO];
        }
        else
        {
            [txt_mMetricName setHidden:YES];
            [lbl_mMetricName setHidden:YES];
        }
    }
    else if([control isEqual:cmb_mSummeryMethod])
    {
        [txt_mSummaryMethod setText:[obj objectForKey:@"text"]];
    }
    else if([control isEqual:cmb_mMetricType])
    {
        [txt_mMetricType setText:[obj objectForKey:@"text"]];
        if ([txt_mMetricType.text isEqualToString:@"Calculated"])
        {
            [lbl_mMetricID setText:@"Formula"];
            [txt_mMetricId setHidden:YES];
            [txt_mFomula setHidden:NO];
        }
        else
        {
            [lbl_mMetricID setText:@"Metric ID"];
            [txt_mMetricId setHidden:NO];
            [txt_mFomula setHidden:YES];
        }
    }
}

-(IBAction)OnMetric:(id)sender
{
    [self HideAllCombo];
    [cmb_mMetric setHidden:NO];
}

-(IBAction)OnSummaryMethod:(id)sender
{
    [self HideAllCombo];
    [cmb_mSummeryMethod setHidden:NO];
}

-(IBAction)OnMetricType:(id)sender
{
    [self HideAllCombo];
    [cmb_mMetricType setHidden:NO];
}

-(IBAction)OnAddTag:(id)sender
{
    if(txt_mMetric.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the metric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if (txt_mMetricName.text.length == 0 && [txt_mMetric.text isEqualToString:@"--Custom--"])
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Metric name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    Tag* tg = [[Tag alloc] init];

    tg.tagType = @"Metric";
    tg.parents = @[@{@"id" : _parentTag._id, @"tagType" : _parentTag.tagType}];
    tg.summaryMethod = txt_mSummaryMethod.text;
    tg.name = txt_mMetric.text;
    tg.metricType = txt_mMetricType.text;
    tg.metricList = txt_mMetric.text;
    if ([tg.metric isEqualToString:@"--Custom--"])
        tg.name = txt_mMetricName.text;
    
    if ([tg.metricType isEqualToString:@"Datafeed"] && txt_mMetricId.text.length > 0)
        tg.metricID = txt_mMetricId.text;
    else if(txt_mFomula.text.length > 0)
        tg.formula = txt_mFomula.text;

    if ([tg.metricType isEqualToString:@"Calculated"])
        tg.metric = @"Custom";
    else
        tg.metric = @"Standard";
    
    [JSWaiter ShowWaiter:self title:@"Adding new metric" type:0];
    [tg AddNewTag:^(MKNetworkOperation *networkOperation) {
        if (!_parentTag.childrenTags)
            _parentTag.childrenTags = [[NSMutableArray alloc] init];
        [_parentTag.childrenTags addObject:tg];
        [JSWaiter HideWaiter];
        [_relatedSourceView UpdateData:_parentTag];
        [self OnBack:nil];
    } failed:nil];
}
@end
