//
//  EditSensorView.m
//  BrighterLink
//
//  Created by mobile master on 11/10/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EditSensorView.h"

@implementation EditSensorView

+(EditSensorView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EditSensorView" owner:self options:nil];
    EditSensorView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    cmb_manufacturer = [[JSCombo alloc] initWithFrame:CGRectMake(txt_sManufacturer.frame.origin.x, txt_sManufacturer.frame.origin.y, txt_sManufacturer.frame.size.width, 100)];
    [cmb_manufacturer setDelegate:self];
    NSMutableArray* manufacturers = [[NSMutableArray alloc] init];
    for(NSDictionary* item in [SharedMembers sharedInstance].Manufacturers)
        [manufacturers addObject:@{@"text" : [item objectForKey:@"name"], @"id" : [item objectForKey:@"_id"]}];
    [cmb_manufacturer UpdateData:manufacturers];
    [self addSubview:cmb_manufacturer];
    
    cmb_device = [[JSCombo alloc] initWithFrame:CGRectMake(txt_sDevice.frame.origin.x, txt_sDevice.frame.origin.y, txt_sDevice.frame.size.width, 100)];
    [cmb_device setDelegate:self];
    NSMutableArray* devices = [[NSMutableArray alloc] init];
    for(NSDictionary* item in [SharedMembers sharedInstance].Devices)
        [devices addObject:@{@"text" : [item objectForKey:@"name"], @"id" : [item objectForKey:@"_id"]}];
    [cmb_device UpdateData:devices];
    [self addSubview:cmb_device];
    
    cmb_interval = [[JSCombo alloc] initWithFrame:CGRectMake(txt_sInterval.frame.origin.x, txt_sInterval.frame.origin.y, txt_sInterval.frame.size.width, 100)];
    [cmb_interval setDelegate:self];
    [cmb_interval UpdateData:@[@{@"text" : @"Hourly"}, @{@"text" : @"Daily"}, @{@"text" : @"Weekly"}, @{@"text" : @"Monthly"}, @{@"text" : @"Yearly"}]];
    [self addSubview:cmb_interval];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideAllCombo)];
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
}

-(void)UpdateWithData:(Tag*)tag
{
    m_tag = tag;
    [txt_sName setText:m_tag.name];
    [txt_sManufacturer setText:m_tag.manufacturer];
    [txt_sDevice setText:m_tag.device];
    [txt_sDeviceId setText:m_tag.deviceID];
    [txt_sSensorTarget setText:m_tag.sensorTarget];
    [txt_sInterval setText:m_tag.interval];
    [txt_sLatitude setText:[NSString stringWithFormat:@"%.4f", m_tag.latitude.floatValue]];
    [txt_sLongitude setText:[NSString stringWithFormat:@"%.4f", m_tag.longitude.floatValue]];
    [txt_sWeatherStation setText:m_tag.weatherStation];
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(void)HideAllCombo
{
    [cmb_device setHidden:YES];
    [cmb_interval setHidden:YES];
    [cmb_manufacturer setHidden:YES];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    if([control isEqual:cmb_manufacturer])
    {
        m_manufacturerId = [obj objectForKey:@"id"];
        [txt_sManufacturer setText:[obj objectForKey:@"text"]];
    }
    else if([control isEqual:cmb_device])
    {
        m_deviceId = [obj objectForKey:@"id"];
        [txt_sDevice setText:[obj objectForKey:@"text"]];
    }
    else if([control isEqual:cmb_interval])
    {
        m_interval = [obj objectForKey:@"text"];
        [txt_sInterval setText:[obj objectForKey:@"text"]];
    }
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

-(IBAction)OnUpdate:(id)sender
{
    if(txt_sName.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    m_tag.name = txt_sName.text;
    m_tag.manufacturer = txt_sManufacturer.text;
    m_tag.device = txt_sDevice.text;
    m_tag.deviceID = txt_sDeviceId.text;
    m_tag.sensorTarget = txt_sSensorTarget.text;
    m_tag.interval = txt_sInterval.text;
    m_tag.latitude = [NSNumber numberWithFloat:[txt_sLatitude.text floatValue]];
    m_tag.longitude = [NSNumber numberWithFloat:[txt_sLongitude.text floatValue]];
    m_tag.weatherStation  = txt_sWeatherStation.text;
    
    [JSWaiter ShowWaiter:self title:@"Updating..." type:0];
    [m_tag UpdateTag:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [self OnBack:nil];
        [_delegate SetTagData:m_tag];
    } failed:nil];
}
@end
