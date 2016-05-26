//
//  AddSourceView.h
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "Tag.h"

@class SourcesView;
@class RelatedDataSourcesView;

@interface AddSourceView : UIView<JSComboDelegate>
{
    IBOutlet UIButton* btn_back;
    IBOutlet UIButton* btn_update;
    IBOutlet UIView* vw_bottom;
    UIView* vw_content;
    IBOutlet UITextField* txt_tagType;
    IBOutlet UIView* vw_facility;
    IBOutlet UIView* vw_datalogger;
    IBOutlet UIView* vw_sensor;
    IBOutlet UIView* vw_metric;
    JSCombo* cmb_tagType;
    JSCombo* cmb_parent;
    JSCombo* cmb_manufacturer;
    JSCombo* cmb_device;
    JSCombo* cmb_interval;
    
    ///////////////////////// Facility controls ///////////////////////////////
    IBOutlet UITextField* txt_fName;
    IBOutlet UITextView* txt_fAddress;
    IBOutlet UITextField* txt_fUtilityProvider;
    IBOutlet UITextField* txt_fTaxId;
    IBOutlet UITextField* txt_fUtilityAccount;
    ///////////////////////////////////////////////////////////////////////////
    
    /////////////////////////// Data Logger Controls///////////////////////////
    IBOutlet UITextField* txt_dParent;
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
    ///////////////////////////////////////////////////////////////////////////
    
    //////////////////////////// Sensor Controls //////////////////////////////
    IBOutlet UITextField* txt_sParent;
    IBOutlet UITextField* txt_sName;
    IBOutlet UITextField* txt_sManufacturer;
    IBOutlet UITextField* txt_sDevice;
    IBOutlet UITextField* txt_sDeviceId;
    IBOutlet UITextField* txt_sSensorTarget;
    IBOutlet UITextField* txt_sInterval;
    IBOutlet UITextField* txt_sLatitude;
    IBOutlet UITextField* txt_sLongitude;
    IBOutlet UITextField* txt_sWeatherStation;
    ///////////////////////////////////////////////////////////////////////////
    
    //////////////////////////// Metric Controls //////////////////////////////
    IBOutlet UITextField* txt_mParent;
    IBOutlet UITextField* txt_mMetric;
    IBOutlet UITextField* txt_mSummaryMethod;
    IBOutlet UITextField* txt_mMetricType;
    IBOutlet UITextField* txt_mMetricId;
    IBOutlet UITextView*    txt_mFomula;
    IBOutlet UITextField*   txt_mMetricName;
    IBOutlet UILabel* lbl_mMetricID;
    JSCombo*    cmb_mMetric;
    JSCombo*    cmb_mSummeryMethod;
    JSCombo*    cmb_mMetricType;
    ///////////////////////////////////////////////////////////////////////////
    
    Tag* m_parentTag;
    NSString* m_manufacturerId;
    NSString* m_deviceId;
    NSString* m_interval;
    NSMutableArray* m_parentTags;
}

@property (nonatomic, weak) SourcesView* sourceView;
+(AddSourceView*)ShowView:(UIView*)parentView;
@end
