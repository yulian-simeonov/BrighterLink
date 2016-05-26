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





@interface EnergyDetailView : UIView<JSComboDelegate>
{
    NSArray * dataOrientaion;
    NSArray * dataEnergyType;
    NSArray * dataEnergyDateRange;
    
    //energy
    JSCombo * m_ComboOrientation;
    JSCombo * m_ComboEnergyType;
    JSCombo * m_ComboEnergyDateRange;

    // Energy
    BOOL bOrientation;
    BOOL bType;
    BOOL bEnegyData;
    BOOL bCO2;
    BOOL bGreenHouse;
}

//Energy Items

@property (nonatomic, weak) IBOutlet UITextField  * m_txtEnergy_Orientation;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_engergy_orientation;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtEnergy_Type;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_engergy_type;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtEnergy_DateRange;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_engergy_dateRange;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnCO2;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnGreenhouse;

- (IBAction) on_pEnergy_Orientation:(id)sender;
- (IBAction) on_pEnergy_Type:(id)sender;
- (IBAction) on_pEnergy_DateRange:(id)sender;
- (IBAction) on_btnEnergy_CO2:(id)sender;
- (IBAction) on_btnEnergy_Greenhouse:(id)sender;


@end
