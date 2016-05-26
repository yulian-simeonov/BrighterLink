//
//  AddDataLoggerView.h
//  BrighterLink
//
//  Created by mobile master on 11/18/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "Tag.h"

@class RelatedDataSourcesView;
@interface AddDataLoggerView : UIView<JSComboDelegate>
{
    IBOutlet UIButton* btn_back;
    
    JSCombo* cmb_manufacturer;
    JSCombo* cmb_device;
    JSCombo* cmb_interval;
    IBOutlet UITextField* txt_dName;
    IBOutlet UITextField* txt_dManufacturer;
    IBOutlet UITextField* txt_dDevice;
    IBOutlet UITextField* txt_dDeviceId;
    IBOutlet UITextField* txt_dAccessMethod;
    IBOutlet UITextField* txt_dInterval;
    IBOutlet UITextField* txt_dLatitude;
    IBOutlet UITextField* txt_dLongitude;
    IBOutlet UITextField* txt_dWeatherStation;
    JSCombo*    cmb_dAccessMethod;
    
    NSString* m_manufacturerId;
    NSString* m_deviceId;
    NSString* m_interval;
}
@property (nonatomic, weak) Tag* parentTag;
@property (nonatomic, weak) RelatedDataSourcesView* relatedSourceView;
+(AddDataLoggerView*)ShowView:(UIView*)parentView;
@end
