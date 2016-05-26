//
//  EditDataLoggerView.h
//  BrighterLink
//
//  Created by mobile master on 11/10/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "Tag.h"
#import "DataLoggerDetailView.h"

@interface EditDataLoggerView : UIView<JSComboDelegate>
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
    Tag* m_tag;
}
@property (nonatomic, weak) DataLoggerDetailView* delegate;
+(EditDataLoggerView*)ShowView:(UIView*)parentView;
-(void)UpdateWithData:(Tag*)tag;
@end
