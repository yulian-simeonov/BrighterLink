//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SolarDetailView.h"

#import "SharedMembers.h"

@interface SolarDetailView()

@end

@implementation SolarDetailView

- (void) awakeFromNib
{
    [self setInfo];
}

- (void) setInfo
{
    //Solar
    bSolarCurrent = false;
    bSolarkWh = false;
    bSolarReimbursement = false;
    bSolarDataRange = false;
    bSolarOrientation = false;
    
    dataSolarDateRange = @[@"Day", @"3 Days", @"Week", @"Month", @"Year", @"All", @"-- Custom -- "];
    
    NSMutableArray* data13 = [[NSMutableArray alloc] init];
    m_ComboSolarDateRange = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_solar_dataRange.frame.origin.x, _m_img_solar_dataRange.frame.origin.y + _m_img_solar_dataRange.frame.size.height, _m_img_solar_dataRange.frame.size.width, 100)];
    [m_ComboSolarDateRange setDelegate:self];
    
    for( int i = 0; i < [dataSolarDateRange count]; i++ )
        [ data13 addObject:@{@"text" : dataSolarDateRange[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboSolarDateRange UpdateData:data13];
    [self addSubview:m_ComboSolarDateRange];
    
    
    dataSolarOrientation = @[@"Horizontal", @"Vertical"];
    NSMutableArray* data14 = [[NSMutableArray alloc] init];
    m_ComboSolarOrientation = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_solar_oritentation.frame.origin.x, _m_img_solar_oritentation.frame.origin.y + _m_img_solar_oritentation.frame.size.height, _m_img_solar_oritentation.frame.size.width, 100)];
    [m_ComboSolarOrientation setDelegate:self];
    
    for( int i = 0; i < [dataSolarOrientation count]; i++ )
        [ data14 addObject:@{@"text" : dataSolarOrientation[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboSolarOrientation UpdateData:data14];
    [self addSubview:m_ComboSolarOrientation];
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    
    if ( [control isEqual: m_ComboSolarDateRange]) {
        [_m_txtVSolar_DataRange setText:[obj objectForKey:@"text"]];
        info.param.widgetSolarGenerationDateRange = _m_txtVSolar_DataRange.text;
    }
    else if ( [control isEqual: m_ComboSolarOrientation] ){
        [_m_txtVSolar_Orientation setText:[obj objectForKey:@"text"]];
        info.param.widgetSolarGenerationOrientation = _m_txtVSolar_Orientation.text;
    }
}

//Solar
-(IBAction) on_btnSolar_Current:(id)sender
{
    bSolarCurrent = !bSolarCurrent;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bSolarCurrent ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    }
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetSolarGenerationCurrent = [NSNumber numberWithBool:bSolarCurrent];
}

-(IBAction) on_btnSolar_kWh:(id)sender
{
    bSolarkWh = !bSolarkWh;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bSolarkWh ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    }
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetSolarGenerationkWh = [NSNumber numberWithBool:bSolarkWh];
}

-(IBAction) on_btnSolar_Reimbursement:(id)sender
{
    bSolarReimbursement = !bSolarReimbursement;
    
    UIButton * btn  = (UIButton*) sender;
    if ( bSolarReimbursement ) {
        [btn setImage:[UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:[UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    }
    PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
    info.param.widgetSolarGenerationReimbursement = [NSNumber numberWithBool: bSolarReimbursement];
}

-(IBAction) on_pSolar_DataRange:(id)sender
{
    bSolarDataRange = !bSolarDataRange;
    
    if ( bSolarDataRange ) {
        [m_ComboSolarDateRange setHidden:false];
    }
    else{
        [m_ComboSolarDateRange setHidden:true];
    }
}

-(IBAction) on_pSolar_Orientation:(id)sender
{
    bSolarOrientation = !bSolarOrientation;
    if ( bSolarOrientation ) {
        [m_ComboSolarOrientation setHidden:false];
    }
    else{
        [m_ComboSolarOrientation setHidden:true];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [m_ComboSolarOrientation setHidden: true];
     [m_ComboSolarDateRange setHidden: true];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

@end
