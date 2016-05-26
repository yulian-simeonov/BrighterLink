//
//  EditMetricView.m
//  BrighterLink
//
//  Created by mobile master on 11/18/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EditMetricView.h"
#import "RelatedDataSourcesView.h"
#import "SourcesView.h"

@implementation EditMetricView

+(EditMetricView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EditMetricView" owner:self options:nil];
    EditMetricView* vw = [nib objectAtIndex:0];
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

-(void)UpdateWithData:(Tag*)tag
{
    m_tag = tag;
    [txt_mMetric setText:m_tag.metric];
    [txt_mMetricType setText:m_tag.metricType];
    if ([m_tag.metric isEqualToString:@"--Custom--"])
        [txt_mMetricName setText:m_tag.name];
    else
    {
        [txt_mMetricName setHidden:YES];
        [lbl_mMetricName setHidden:YES];
    }
    if ([m_tag.metricType isEqualToString:@"Datafeed"])
    {
        txt_mMetricId.text = m_tag.metricID;
        [txt_mFomula setHidden:YES];
    }
    else
    {
        [lbl_mMetricID setText:@"Formula"];
        [txt_mFomula setText:m_tag.formula];
        [txt_mFomula setHidden:NO];
        [txt_mMetricId setHidden:YES];
    }
}

-(IBAction)OnBack:(id)sender
{
    if (_relatedSourceView)
        [_relatedSourceView setHidden:NO];
    if (_sourceView)
        [_sourceView RestoreSearchType];
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

-(IBAction)OnUpdateTag:(id)sender
{
    if(txt_mMetric.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the metric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    m_tag.metric = txt_mMetric.text;
    m_tag.name = m_tag.metric;
    m_tag.metricType = txt_mMetricType.text;
    if ([m_tag.metric isEqualToString:@"--Custom--"])
        m_tag.name = txt_mMetricName.text;
    if ([m_tag.metricType isEqualToString:@"Datafeed"])
        m_tag.metricID = txt_mMetricId.text;
    else
        m_tag.formula = txt_mFomula.text;
    [JSWaiter ShowWaiter:self title:@"Updating..." type:0];
    [m_tag UpdateTag:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [self OnBack:nil];
        if (_relatedSourceView)
            [_relatedSourceView Refresh];
        if (_sourceView)
            [_sourceView ReloadData];
    } failed:nil];
}
@end
