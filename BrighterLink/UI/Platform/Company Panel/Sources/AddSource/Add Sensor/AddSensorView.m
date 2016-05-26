//
//  AddSensorView.m
//  BrighterLink
//
//  Created by mobile master on 11/18/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "AddSensorView.h"
#import "SharedMembers.h"
#import "RelatedDataSourcesView.h"

@implementation AddSensorView

+(AddSensorView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"AddSensorView" owner:self options:nil];
    AddSensorView* vw = [nib objectAtIndex:0];
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

-(IBAction)OnAddTag:(id)sender
{
    Tag* tg = [[Tag alloc] init];
    tg.tagType = @"Node";
    if(txt_sName.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    tg.name = txt_sName.text;
    tg.parents = @[@{@"id" : _parentTag._id, @"tagType" : _parentTag.tagType}];
    tg.manufacturer = txt_sManufacturer.text;
    tg.device = txt_sDevice.text;
    tg.deviceID = txt_sDeviceId.text;
    tg.sensorTarget = txt_sSensorTarget.text;
    tg.interval = txt_sInterval.text;
    tg.latitude = [NSNumber numberWithFloat:[txt_sLatitude.text floatValue]];
    tg.longitude = [NSNumber numberWithFloat:[txt_sLongitude.text floatValue]];
    tg.weatherStation  = txt_sWeatherStation.text;

    [JSWaiter ShowWaiter:self title:@"Adding new Node" type:0];
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
