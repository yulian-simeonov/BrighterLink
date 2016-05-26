//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EnergyDetailView.h"

#import "SharedMembers.h"

@interface EnergyDetailView()

@end

@implementation EnergyDetailView


NSString * imgNames[] = {
    @"/bl-bv-management/assets/img/cars.png",
    
    @"/bl-bv-management/assets/img/tons.png",
    
    @"/bl-bv-management/assets/img/gallons.png",
    
    @"/bl-bv-management/assets/img/tanker.png",
    
    @"/bl-bv-management/assets/img/energy-home.png",
    
    @"/bl-bv-management/assets/img/electricity-home.png",
    
    @"/bl-bv-management/assets/img/railcars.png",
    
    @"/bl-bv-management/assets/img/barrels.png",
    
    @"/bl-bv-management/assets/img/propane.png",
    
    @"/bl-bv-management/assets/img/coal.png",
    
    @"/bl-bv-management/assets/img/tree.png",
    
    @"/bl-bv-management/assets/img/acres.png",
    
    @"/bl-bv-management/assets/img/acres-corpland.png",
};

- (void) awakeFromNib
{
    [self setInfo];
}

- (void) setInfo
{
    //Energy
    bOrientation = false;
    bType = false;
    bEnegyData = false;
    bCO2 = false;
    bGreenHouse = false;
    
    dataOrientaion =  @[@"Horizontal", @"Vertical"];
    NSMutableArray* data9 = [[NSMutableArray alloc] init];
    m_ComboOrientation = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_engergy_orientation.frame.origin.x, _m_img_engergy_orientation.frame.origin.y + _m_img_engergy_orientation.frame.size.height, _m_img_engergy_orientation.frame.size.width, 100)];
    [m_ComboOrientation setDelegate:self];
    
    for( int i = 0; i < [dataOrientaion count]; i++ )
        [ data9 addObject:@{@"text" : dataOrientaion[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboOrientation UpdateData:data9];
    [self addSubview:m_ComboOrientation];
    
    
    dataEnergyType =  @[@"Cars Removed", @"Waste Recycled", @"Gallons Gas Saved", @"Tanker Gas Saved", @"Energy Homes Generated", @"Electricity Homes Generated", @"Coal Elimanated", @"Oil Unneeded", @"Propane Cylinders", @"Plants Idled", @"Seedling Grown", @"Forests Preserved", @"Forests Conversion Prevented"];
    NSMutableArray* data10 = [[NSMutableArray alloc] init];
    m_ComboEnergyType = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_engergy_type.frame.origin.x, _m_img_engergy_type.frame.origin.y + _m_img_engergy_type.frame.size.height, _m_img_engergy_type.frame.size.width, 100)];
    [m_ComboEnergyType setDelegate:self];
    
    for( int i = 0; i < [dataEnergyType count]; i++ )
        [ data10 addObject:@{@"text" : dataEnergyType[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboEnergyType UpdateData:data10];
    [self addSubview:m_ComboEnergyType];
    
    dataEnergyDateRange =  @[@"Day", @"3 Days", @"Week", @"Month", @"Year", @"All", @"-- Custom --" ];
    NSMutableArray* data11 = [[NSMutableArray alloc] init];
    m_ComboEnergyDateRange = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_engergy_dateRange.frame.origin.x, _m_img_engergy_dateRange.frame.origin.y + _m_img_engergy_dateRange.frame.size.height, _m_img_engergy_dateRange.frame.size.width, 100)];
    [m_ComboEnergyDateRange setDelegate:self];
    
    for( int i = 0; i < [dataEnergyDateRange count]; i++ )
        [ data11 addObject:@{@"text" : dataEnergyDateRange[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboEnergyDateRange UpdateData:data11];
    [self addSubview:m_ComboEnergyDateRange];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    
    bEnegyData = false; bOrientation = false; bType = false;
    
    if( [control isEqual: m_ComboOrientation])
    {
        [_m_txtEnergy_Orientation setText: [obj objectForKey:@"text"]];
        info.param.widgetEnergyOrientation = _m_txtEnergy_Orientation.text;
    }
    else if ( [control isEqual: m_ComboEnergyType] ){
        [_m_txtEnergy_Type setText: [obj objectForKey:@"text"]];
        info.param.widgetEnergyType = _m_txtEnergy_Type.text;
        NSString * sType  = _m_txtEnergy_Type.text;
     
        if ( [sType isEqualToString:@"Cars Removed"] ) {
            info.param.backgroundImage = imgNames[0];
        }
        else if ( [sType isEqualToString: @"Waste Recycled"] )
        {
            info.param.backgroundImage = imgNames[1];
        }
        else  if ( [sType isEqualToString:@"Gallons Gas Saved"])
        {
            info.param.backgroundImage = imgNames[2];
        }
        else if ( [sType isEqualToString:@"Tanker Gas Saved"] )
        {
            info.param.backgroundImage = imgNames[3];
        }
        else if ( [sType isEqualToString:@"Energy Homes Generated"])
        {
            info.param.backgroundImage = imgNames[4];
        }
        else if ( [sType isEqualToString:@"Electricity Homes Generated"])
        {
            info.param.backgroundImage = imgNames[5];
        }else if ( [sType isEqualToString:@"Coal Elimanated"]){
            info.param.backgroundImage = imgNames[6];
        }else if ( [sType isEqualToString:@"Oil Unneeded"]){
            info.param.backgroundImage = imgNames[7];
        }else if ( [sType isEqualToString: @"Propane Cylinders" ]){
            info.param.backgroundImage = imgNames[8];
        }else if ( [sType isEqualToString: @"Plants Idled"]){
            info.param.backgroundImage = imgNames[9];
        }else if ( [sType isEqualToString: @"Seedling Grown"]){
            info.param.backgroundImage = imgNames[10];
        }else if ( [sType isEqualToString:@"Forests Preserved"]){
            info.param.backgroundImage = imgNames[11];
        }else if ( [sType isEqualToString:@"Forests Conversion Prevented"]){
            info.param.backgroundImage = imgNames[12];
        }
            
            
            
//        info.param.backgroundImage =
        
    }
    else if ( [control isEqual: m_ComboEnergyDateRange]){
        [_m_txtEnergy_DateRange setText: [obj objectForKey:@"text"] ];
        info.param.widgetEnergyDateRange = _m_txtEnergy_DateRange.text;
    }
    
    
}

//Energy
- (IBAction) on_pEnergy_Orientation:(id)sender
{
    bOrientation  = !bOrientation;
    
    if ( bOrientation ) {
        [m_ComboOrientation setHidden:false];
    }
    else
        [m_ComboOrientation setHidden:true];
    
}

- (IBAction) on_pEnergy_Type:(id)sender
{
    bType  = !bType;
    if ( bType ) {
        [m_ComboEnergyType setHidden:false];
    }
    else{
        [m_ComboEnergyType setHidden:true];
    }
    
}

- (IBAction) on_pEnergy_DateRange:(id)sender
{
    bEnegyData  = !bEnegyData;
    if ( bEnegyData ) {
        [m_ComboEnergyDateRange setHidden:false];
    }
    else{
        [m_ComboEnergyDateRange setHidden:true];
    }
}

- (IBAction) on_btnEnergy_CO2:(id)sender
{
    bCO2  = !bCO2;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bCO2 ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    }
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetEnergyCO2Kilograms = [NSNumber numberWithBool:bCO2];
}

- (IBAction) on_btnEnergy_Greenhouse:(id)sender
{
    bGreenHouse  = !bGreenHouse;
    UIButton * btn  = (UIButton*) sender;
    if ( bGreenHouse ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    }
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetEnergyGreenhouseKilograms = [NSNumber numberWithBool:bGreenHouse];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_ComboOrientation setHidden:true];
    [m_ComboEnergyType setHidden:true];
    [m_ComboEnergyDateRange setHidden: true];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

@end
