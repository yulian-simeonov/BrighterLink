//
//  SensorDetailView.h
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@class SourcesView;

@interface SensorDetailView : UIView
{
    IBOutlet UIButton* btn_edit;
    IBOutlet UIButton* btn_delete;
    
    IBOutlet UILabel* lbl_name;
    IBOutlet UILabel* lbl_manufacturer;
    IBOutlet UILabel* lbl_device;
    IBOutlet UILabel* lbl_sensorTarget;
    IBOutlet UILabel* lbl_weatherStation;
    IBOutlet UILabel* lbl_groups;
    IBOutlet UILabel* lbl_interval;
    IBOutlet UILabel* lbl_latitude;
    IBOutlet UILabel* lbl_longitude;

    Tag*    m_tag;
}
@property (nonatomic, weak) SourcesView* delegate;
+(SensorDetailView*)ShowView:(UIView*)parentView;
-(void)SetTagData:(Tag*)tg;
@end
