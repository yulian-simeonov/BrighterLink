//
//  AddSensorView.h
//  BrighterLink
//
//  Created by mobile master on 11/18/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "Tag.h"

@class RelatedDataSourcesView;
@interface AddSensorView : UIView<JSComboDelegate>
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
}
@property (nonatomic, weak) Tag* parentTag;
@property (nonatomic, weak) RelatedDataSourcesView* relatedSourceView;
+(AddSensorView*)ShowView:(UIView*)parentView;
@end
