//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWaiter.h"
#import "WebManager.h"
#import "JSCombo.h"



@interface SolarDetailView : UIView<JSComboDelegate>
{
    
    
    //Solar
    BOOL bSolarCurrent;
    BOOL bSolarkWh;
    BOOL bSolarReimbursement;
    BOOL bSolarDataRange;
    BOOL bSolarOrientation;
    
    NSArray * dataSolarOrientation;
    NSArray * dataSolarDateRange;
    JSCombo * m_ComboSolarOrientation;
    JSCombo * m_ComboSolarDateRange;

}



//Solar

@property (nonatomic, weak) IBOutlet UITextField  * m_txtVSolar_DataRange;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtVSolar_Orientation;

@property (nonatomic, weak) IBOutlet UIImageView  * m_img_solar_oritentation;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_solar_dataRange;

@property (nonatomic, weak) IBOutlet UIButton     * m_btnSolar_Current;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnSolar_kWh;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnSolar_Reimbursement;

-(IBAction) on_btnSolar_Current:(id)sender;
-(IBAction) on_btnSolar_kWh:(id)sender;
-(IBAction) on_btnSolar_Reimbursement:(id)sender;
-(IBAction) on_pSolar_DataRange:(id)sender;
-(IBAction) on_pSolar_Orientation:(id)sender;


@end
