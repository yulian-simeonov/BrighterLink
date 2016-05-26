//
//  AddSourceView.m
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddSourceView.h"
#import "Tag.h"
#import "SourcesView.h"
#import "RelatedDataSourcesView.h"

@implementation AddSourceView

+(AddSourceView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddSourceView" owner:self options:nil];
    AddSourceView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    [vw_facility setFrame:CGRectMake(vw_facility.frame.origin.x, 120, vw_facility.frame.size.width, vw_facility.frame.size.height)];
    [vw_datalogger setFrame:CGRectMake(vw_datalogger.frame.origin.x, 120, vw_datalogger.frame.size.width, vw_datalogger.frame.size.height)];
    [vw_sensor setFrame:CGRectMake(vw_sensor.frame.origin.x, 120, vw_sensor.frame.size.width, vw_sensor.frame.size.height)];
    [vw_metric setFrame:CGRectMake(vw_metric.frame.origin.x, 120, vw_metric.frame.size.width, vw_metric.frame.size.height)];
    
    btn_update.layer.cornerRadius = 5;

    cmb_tagType = [[JSCombo alloc] initWithFrame:CGRectMake(txt_tagType.frame.origin.x, txt_tagType.frame.origin.y, txt_tagType.frame.size.width, 100)];
    [cmb_tagType setDelegate:self];
    [cmb_tagType UpdateData:@[@{@"text" : @"Facility"}, @{@"text" : @"Scope"}, @{@"text" : @"Node"}, @{@"text" : @"Metric"}]];
    [cmb_tagType setSelectedItem:@{@"text" : @"Facility"}];
    [self addSubview:cmb_tagType];
    
    [self SelectTagType:@"Facility"];
    
    cmb_parent = [[JSCombo alloc] initWithFrame:CGRectMake(txt_tagType.frame.origin.x, vw_datalogger.frame.origin.y, txt_dParent.frame.size.width, 100)];
    [cmb_parent setDelegate:self];
    [self addSubview:cmb_parent];
    
    cmb_manufacturer = [[JSCombo alloc] initWithFrame:CGRectMake(vw_datalogger.frame.origin.x + txt_dManufacturer.frame.origin.x, vw_datalogger.frame.origin.y + txt_dManufacturer.frame.origin.y, txt_dManufacturer.frame.size.width, 100)];
    [cmb_manufacturer setDelegate:self];
    NSMutableArray* manufacturers = [[NSMutableArray alloc] init];
    for(NSDictionary* item in [SharedMembers sharedInstance].Manufacturers)
        [manufacturers addObject:@{@"text" : [item objectForKey:@"name"], @"id" : [item objectForKey:@"_id"]}];
    [cmb_manufacturer UpdateData:manufacturers];
    [self addSubview:cmb_manufacturer];
    
    cmb_device = [[JSCombo alloc] initWithFrame:CGRectMake(vw_datalogger.frame.origin.x + txt_dDevice.frame.origin.x, vw_datalogger.frame.origin.y + txt_dDevice.frame.origin.y, txt_dDevice.frame.size.width, 100)];
    [cmb_device setDelegate:self];
    NSMutableArray* devices = [[NSMutableArray alloc] init];
    for(NSDictionary* item in [SharedMembers sharedInstance].Devices)
        [devices addObject:@{@"text" : [item objectForKey:@"name"], @"id" : [item objectForKey:@"_id"]}];
    [cmb_device UpdateData:devices];
    [self addSubview:cmb_device];
    
    cmb_interval = [[JSCombo alloc] initWithFrame:CGRectMake(vw_datalogger.frame.origin.x + txt_dInterval.frame.origin.x, vw_datalogger.frame.origin.y + txt_dInterval.frame.origin.y, txt_dInterval.frame.size.width, 100)];
    [cmb_interval setDelegate:self];
    [cmb_interval UpdateData:@[@{@"text" : @"Hourly"}, @{@"text" : @"Daily"}, @{@"text" : @"Weekly"}, @{@"text" : @"Monthly"}, @{@"text" : @"Yearly"}]];
    [self addSubview:cmb_interval];
    
    cmb_dAccessMethod = [[JSCombo alloc] initWithFrame:CGRectMake(txt_dAccessMethod.frame.origin.x, txt_dAccessMethod.frame.origin.y, txt_dAccessMethod.frame.size.width, 100)];
    [cmb_dAccessMethod setDelegate:self];
    [cmb_dAccessMethod UpdateData:@[@{@"text" : @"Push to FTP"}, @{@"text" : @"Push to URI"}, @{@"text" : @"Download from FTP"}, @{@"text" : @"Download from URI"}]];
    [vw_datalogger addSubview:cmb_dAccessMethod];
    
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
    [vw_metric addSubview:cmb_mMetric];
    
    cmb_mSummeryMethod = [[JSCombo alloc] initWithFrame:CGRectMake(txt_mSummaryMethod.frame.origin.x, txt_mSummaryMethod.frame.origin.y, txt_mSummaryMethod.frame.size.width, 100)];
    [cmb_mSummeryMethod setDelegate:self];
    [cmb_mSummeryMethod UpdateData:@[@{@"text" : @"Total"}, @{@"text" : @"Average"}, @{@"text" : @"Count"}]];
    [cmb_mSummeryMethod setSelectedItem:@{@"text" : @"Total"}];
    [vw_metric addSubview:cmb_mSummeryMethod];
    
    cmb_mMetricType = [[JSCombo alloc] initWithFrame:CGRectMake(txt_mMetricType.frame.origin.x, txt_mMetricType.frame.origin.y, txt_mMetricType.frame.size.width, 100)];
    [cmb_mMetricType setDelegate:self];
    [cmb_mMetricType UpdateData:@[@{@"text" : @"Datafeed"}, @{@"text" : @"Calculated"}]];
    [cmb_mMetricType setSelectedItem:@{@"text" : @"Datafeed"}];
    [vw_metric addSubview:cmb_mMetricType];
    
    m_parentTags = [[NSMutableArray alloc] init];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideAllCombo)];
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(void)SetParents
{
    [m_parentTags removeAllObjects];
    for(Tag* tg in [SharedMembers sharedInstance].RootTags)
    {
        [self CheckTag:tg ary:m_parentTags];
    }
    if (m_parentTags.count == 0)
        return;
    NSMutableArray* comboData = [[NSMutableArray alloc] init];
    for(Tag* tg in m_parentTags)
        [comboData addObject:@{@"text" : tg.name, @"object" : tg}];
    [cmb_parent UpdateData:comboData];
    [cmb_parent setSelectedItem:[comboData objectAtIndex:0]];
}

-(void)CheckTag:(Tag*)tg ary:(NSMutableArray*)ary
{
    if (([tg.tagType isEqualToString:@"Facility"] && [txt_tagType.text isEqualToString:@"Scope"]) ||
        ([tg.tagType isEqualToString:@"Scope"] && [txt_tagType.text isEqualToString:@"Node"]) ||
        ([tg.tagType isEqualToString:@"Node"] && [txt_tagType.text isEqualToString:@"Metric"]))
    {
        [ary addObject:tg];
    }
    for(Tag* tgItem in tg.childrenTags)
    {
        [self CheckTag:tgItem ary:ary];
    }
}

-(void)SelectTagType:(NSString*)type
{
    if ([txt_tagType.text isEqualToString:type])
        return;
    [txt_tagType setText:type];
    [vw_facility setHidden:YES];
    [vw_datalogger setHidden:YES];
    [vw_sensor setHidden:YES];
    [vw_metric setHidden:YES];
    m_parentTag = nil;
    m_manufacturerId = nil;
    m_deviceId = nil;
    m_interval = nil;
    [cmb_parent setSelectedItem:nil];
    [cmb_manufacturer setSelectedItem:nil];
    [cmb_device setSelectedItem:nil];
    [cmb_interval setSelectedItem:nil];
    
    if ([type isEqualToString:@"Facility"])
    {
        vw_content = vw_facility;
        [vw_facility setHidden:NO];
        [btn_update setTitle:@"Add Facility" forState:UIControlStateNormal];
    }
    else if ([type isEqualToString:@"Scope"])
    {
        [cmb_dAccessMethod setSelectedItem:nil];
        vw_content = vw_datalogger;
        [vw_datalogger setHidden:NO];
        [btn_update setTitle:@"Add Scope" forState:UIControlStateNormal];
    }
    else if ([type isEqualToString:@"Node"])
    {
        vw_content = vw_sensor;
        [vw_sensor setHidden:NO];
        [btn_update setTitle:@"Add Node" forState:UIControlStateNormal];
    }
    else if ([type isEqualToString:@"Metric"])
    {
        
        vw_content = vw_metric;
        [vw_metric setHidden:NO];
        [btn_update setTitle:@"Add Metric" forState:UIControlStateNormal];
    }
    [self SetParents];
    vw_bottom.center = CGPointMake(vw_bottom.center.x, vw_bottom.frame.size.height / 2 + vw_content.frame.origin.y + vw_content.frame.size.height + 30);
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    if ([control isEqual:cmb_tagType])
    {
        [self SelectTagType:[obj objectForKey:@"text"]];
    }
    else if ([control isEqual:cmb_parent])
    {
        m_parentTag = [obj objectForKey:@"object"];
        if ([txt_tagType.text isEqualToString:@"Scope"])
        {
            [txt_dParent setText:m_parentTag.name];
        }
        else if ([txt_tagType.text isEqualToString:@"Node"])
        {
            [txt_sParent setText:m_parentTag.name];
        }
        else if ([txt_tagType.text isEqualToString:@"Metric"])
        {
            [txt_mParent setText:m_parentTag.name];
        }
    }
    else if([control isEqual:cmb_manufacturer])
    {
        m_manufacturerId = [obj objectForKey:@"id"];
        if ([txt_tagType.text isEqualToString:@"Scope"])
        {
            [txt_dManufacturer setText:[obj objectForKey:@"text"]];
        }
        else if ([txt_tagType.text isEqualToString:@"Node"])
        {
            [txt_sManufacturer setText:[obj objectForKey:@"text"]];
        }
    }
    else if([control isEqual:cmb_device])
    {
        m_deviceId = [obj objectForKey:@"id"];
        if ([txt_tagType.text isEqualToString:@"Scope"])
        {
            [txt_dDevice setText:[obj objectForKey:@"text"]];
        }
        else if ([txt_tagType.text isEqualToString:@"Node"])
        {
            [txt_sDevice setText:[obj objectForKey:@"text"]];
        }
    }
    else if([control isEqual:cmb_interval])
    {
        m_interval = [obj objectForKey:@"text"];
        if ([txt_tagType.text isEqualToString:@"Scope"])
        {
            [txt_dInterval setText:[obj objectForKey:@"text"]];
        }
        else if ([txt_tagType.text isEqualToString:@"Node"])
        {
            [txt_sInterval setText:[obj objectForKey:@"text"]];
        }
    }
    else if ([control isEqual:cmb_dAccessMethod])
    {
        [txt_dAccessMethod setText:[obj objectForKey:@"text"]];
    }
    else if([control isEqual:cmb_mMetric])
    {
        [txt_mMetric setText:[obj objectForKey:@"text"]];
        if ([txt_mMetric.text isEqualToString:@"--Custom--"])
        {
            [vw_metric setFrame:CGRectMake(vw_metric.frame.origin.x, vw_metric.frame.origin.y, vw_metric.frame.size.width, txt_mMetricName.frame.origin.y + txt_mMetricName.frame.size.height)];
        }
        else
        {
            [vw_metric setFrame:CGRectMake(vw_metric.frame.origin.x, vw_metric.frame.origin.y, vw_metric.frame.size.width, txt_mFomula.frame.origin.y + txt_mFomula.frame.size.height)];
        }
        vw_bottom.center = CGPointMake(vw_bottom.center.x, vw_bottom.frame.size.height / 2 + vw_content.frame.origin.y + vw_content.frame.size.height + 30);
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

-(void)HideAllCombo
{
    [cmb_dAccessMethod setHidden:YES];
    [cmb_device setHidden:YES];
    [cmb_interval setHidden:YES];
    [cmb_manufacturer setHidden:YES];
    [cmb_mMetric setHidden:YES];
    [cmb_mMetricType setHidden:YES];
    [cmb_mSummeryMethod setHidden:YES];
    [cmb_parent setHidden:YES];
    [cmb_tagType setHidden:YES];
}

-(IBAction)OnSelectTagType:(id)sender
{
    [self HideAllCombo];
    [cmb_tagType setHidden:NO];
}

-(IBAction)OnParent:(id)sender
{
    [self HideAllCombo];
    [cmb_parent setHidden:NO];
}

-(IBAction)OnManufacturer:(id)sender
{
    [self HideAllCombo];
    [cmb_manufacturer setHidden:NO];
}

-(IBAction)OnDevice:(id)sender
{
    [self HideAllCombo];
    [cmb_device setHidden:NO];
}

-(IBAction)OnInterval:(id)sender
{
    [self HideAllCombo];
    [cmb_interval setHidden:NO];
}

-(IBAction)OnAccessMethod:(id)sender
{
    [self HideAllCombo];
    [cmb_dAccessMethod setHidden:NO];
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
    Tag* tg = [[Tag alloc] init];
    if ([txt_tagType.text isEqualToString:@"Facility"])
    {
        tg.tagType = txt_tagType.text;
        if(txt_fName.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        tg.name = txt_fName.text;
        NSArray* address = [txt_fAddress.text componentsSeparatedByString:@"\n"];
        if (address.count > 0)
            tg.street = [address objectAtIndex:0];
        if (address.count > 1)
            tg.city = [address objectAtIndex:1];
        if (address.count > 2)
            tg.state = [address objectAtIndex:2];
        if (address.count > 3)
            tg.country = [address objectAtIndex:3];
        tg.utilityProvider = txt_fUtilityProvider.text;
        tg.taxID = txt_fTaxId.text;
        tg.utilityAccounts = [txt_fUtilityAccount.text componentsSeparatedByString:@","];
        
    }
    else if([txt_tagType.text isEqualToString:@"Scope"])
    {
        tg.tagType = txt_tagType.text;
        if(txt_dName.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        tg.name = txt_dName.text;
        tg.parents = @[@{@"id" : m_parentTag._id, @"tagType" : m_parentTag.tagType}];
        tg.manufacturer = txt_dManufacturer.text;
        tg.accessMethod = txt_dAccessMethod.text;
        tg.device = txt_dDevice.text;
        tg.deviceID = txt_dDeviceId.text;
        tg.interval = txt_dInterval.text;
        tg.latitude = [NSNumber numberWithFloat:[txt_dLatitude.text floatValue]];
        tg.longitude = [NSNumber numberWithFloat:[txt_dLongitude.text floatValue]];
        tg.weatherStation  = txt_dWeatherStation.text;
    }
    else if([txt_tagType.text isEqualToString:@"Node"])
    {
        tg.tagType = txt_tagType.text;
        if(txt_sName.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        tg.name = txt_sName.text;
        tg.parents = @[@{@"id" : m_parentTag._id, @"tagType" : m_parentTag.tagType}];
        tg.manufacturer = txt_sManufacturer.text;
        tg.device = txt_sDevice.text;
        tg.deviceID = txt_sDeviceId.text;
        tg.sensorTarget = txt_sSensorTarget.text;
        tg.interval = txt_sInterval.text;
        tg.latitude = [NSNumber numberWithFloat:[txt_sLatitude.text floatValue]];
        tg.longitude = [NSNumber numberWithFloat:[txt_sLongitude.text floatValue]];
        tg.weatherStation  = txt_sWeatherStation.text;
    }
    else if([txt_tagType.text isEqualToString:@"Metric"])
    {
        if(txt_mMetric.text.length == 0)
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the metric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        tg.tagType = txt_tagType.text;
        tg.parents = @[@{@"id" : m_parentTag._id, @"tagType" : m_parentTag.tagType}];
        tg.metric = txt_mMetric.text;
        tg.name = tg.metric;
        tg.summaryMethod = txt_mSummaryMethod.text;
        tg.metricType = txt_mMetricType.text;
        if ([tg.metric isEqualToString:@"--Custom--"])
            tg.name = txt_mMetricName.text;
        if ([tg.metricType isEqualToString:@"Datafeed"])
            tg.metricID = txt_mMetricId.text;
        else
            tg.formula = txt_mFomula.text;
    }
    [JSWaiter ShowWaiter:self title:@"Creating new tag" type:0];
    [tg AddNewTag:^(MKNetworkOperation *networkOperation) {
        if (!m_parentTag)
            [[SharedMembers sharedInstance].RootTags addObject:tg];
        else
        {
            if (!m_parentTag.childrenTags)
                m_parentTag.childrenTags = [[NSMutableArray alloc] init];
            [m_parentTag.childrenTags addObject:tg];
        }
        [JSWaiter HideWaiter];
        if (_sourceView)
            [_sourceView ReloadData];
        [self OnBack:nil];
    } failed:nil];
}
@end
