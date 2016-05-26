//
//  EditDataLoggerView.m
//  BrighterLink
//
//  Created by mobile master on 11/10/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EditDataLoggerView.h"

@implementation EditDataLoggerView

+(EditDataLoggerView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EditDataLoggerView" owner:self options:nil];
    EditDataLoggerView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    cmb_manufacturer = [[JSCombo alloc] initWithFrame:CGRectMake(txt_dManufacturer.frame.origin.x, txt_dManufacturer.frame.origin.y, txt_dManufacturer.frame.size.width, 100)];
    [cmb_manufacturer setDelegate:self];
    NSMutableArray* manufacturers = [[NSMutableArray alloc] init];
    for(NSDictionary* item in [SharedMembers sharedInstance].Manufacturers)
        [manufacturers addObject:@{@"text" : [item objectForKey:@"name"], @"id" : [item objectForKey:@"_id"]}];
    [cmb_manufacturer UpdateData:manufacturers];
    [self addSubview:cmb_manufacturer];
    
    cmb_device = [[JSCombo alloc] initWithFrame:CGRectMake(txt_dDevice.frame.origin.x, txt_dDevice.frame.origin.y, txt_dDevice.frame.size.width, 100)];
    [cmb_device setDelegate:self];
    NSMutableArray* devices = [[NSMutableArray alloc] init];
    for(NSDictionary* item in [SharedMembers sharedInstance].Devices)
        [devices addObject:@{@"text" : [item objectForKey:@"name"], @"id" : [item objectForKey:@"_id"]}];
    [cmb_device UpdateData:devices];
    [self addSubview:cmb_device];
    
    cmb_interval = [[JSCombo alloc] initWithFrame:CGRectMake(txt_dInterval.frame.origin.x, txt_dInterval.frame.origin.y, txt_dInterval.frame.size.width, 100)];
    [cmb_interval setDelegate:self];
    [cmb_interval UpdateData:@[@{@"text" : @"Hourly"}, @{@"text" : @"Daily"}, @{@"text" : @"Weekly"}, @{@"text" : @"Monthly"}, @{@"text" : @"Yearly"}]];
    [self addSubview:cmb_interval];
    
    cmb_dAccessMethod = [[JSCombo alloc] initWithFrame:CGRectMake(txt_dAccessMethod.frame.origin.x, txt_dAccessMethod.frame.origin.y, txt_dAccessMethod.frame.size.width, 100)];
    [cmb_dAccessMethod setDelegate:self];
    [cmb_dAccessMethod UpdateData:@[@{@"text" : @"Push to FTP"}, @{@"text" : @"Push to URI"}, @{@"text" : @"Download from FTP"}, @{@"text" : @"Download from URI"}]];
    [self addSubview:cmb_dAccessMethod];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideAllCombo)];
    gesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:gesture];
}

-(void)UpdateWithData:(Tag*)tag
{
    m_tag = tag;
    [txt_dName setText:m_tag.name];
    [txt_dManufacturer setText:m_tag.manufacturer];
    [txt_dDevice setText:m_tag.device];
    [txt_dDeviceId setText:m_tag.deviceID];
    [txt_dAccessMethod setText:m_tag.accessMethod];
    [txt_dInterval setText:m_tag.interval];
    [txt_dLatitude setText:[NSString stringWithFormat:@"%.4f", m_tag.latitude.floatValue]];
    [txt_dLongitude setText:[NSString stringWithFormat:@"%.4f", m_tag.longitude.floatValue]];
    [txt_dWeatherStation setText:m_tag.weatherStation];
}

-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(void)HideAllCombo
{
    [cmb_dAccessMethod setHidden:YES];
    [cmb_device setHidden:YES];
    [cmb_interval setHidden:YES];
    [cmb_manufacturer setHidden:YES];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    if([control isEqual:cmb_manufacturer])
    {
        m_manufacturerId = [obj objectForKey:@"id"];
        [txt_dManufacturer setText:[obj objectForKey:@"text"]];
    }
    else if([control isEqual:cmb_device])
    {
        m_deviceId = [obj objectForKey:@"id"];
        [txt_dDevice setText:[obj objectForKey:@"text"]];
    }
    else if([control isEqual:cmb_interval])
    {
        m_interval = [obj objectForKey:@"text"];
        [txt_dInterval setText:[obj objectForKey:@"text"]];
    }
    else if ([control isEqual:cmb_dAccessMethod])
    {
        [txt_dAccessMethod setText:[obj objectForKey:@"text"]];
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

-(IBAction)OnAccessMethod:(id)sender
{
    [self HideAllCombo];
    [cmb_dAccessMethod setHidden:NO];
}

-(IBAction)OnUpdate:(id)sender
{
    if(txt_dName.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    m_tag.name = txt_dName.text;
    m_tag.manufacturer = txt_dManufacturer.text;
    m_tag.accessMethod = txt_dAccessMethod.text;
    m_tag.device = txt_dDevice.text;
    m_tag.deviceID = txt_dDeviceId.text;
    m_tag.interval = txt_dInterval.text;
    m_tag.latitude = [NSNumber numberWithFloat:[txt_dLatitude.text floatValue]];
    m_tag.longitude = [NSNumber numberWithFloat:[txt_dLongitude.text floatValue]];
    m_tag.weatherStation  = txt_dWeatherStation.text;
    [JSWaiter ShowWaiter:self title:@"Updating..." type:0];
    [m_tag UpdateTag:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [self OnBack:nil];
        [_delegate SetTagData:m_tag];
    } failed:nil];

}@end
