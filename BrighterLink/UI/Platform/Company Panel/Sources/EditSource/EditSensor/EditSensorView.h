//
//  EditSensorView.h
//  BrighterLink
//
//  Created by mobile master on 11/10/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "Tag.h"
#import "SensorDetailView.h"

@interface EditSensorView : UIView<JSComboDelegate>
{
    IBOutlet UIButton* btn_back;
    
    JSCombo* cmb_manufacturer;
    JSCombo* cmb_device;
    JSCombo* cmb_interval;
    
    IBOutlet UITextField* txt_sName;
    IBOutlet UITextField* txt_sManufacturer;
    IBOutlet UITextField* txt_sDevice;
    IBOutlet UITextField* txt_sDeviceId;
    IBOutlet UITextField* txt_sSensorTarget;
    IBOutlet UITextField* txt_sInterval;
    IBOutlet UITextField* txt_sLatitude;
    IBOutlet UITextField* txt_sLongitude;
    IBOutlet UITextField* txt_sWeatherStation;
    
    NSString* m_manufacturerId;
    NSString* m_deviceId;
    NSString* m_interval;
    
    Tag* m_tag;
}
@property (nonatomic, weak) SensorDetailView* delegate;
+(EditSensorView*)ShowView:(UIView*)parentView;
-(void)UpdateWithData:(Tag*)tag;
@end
