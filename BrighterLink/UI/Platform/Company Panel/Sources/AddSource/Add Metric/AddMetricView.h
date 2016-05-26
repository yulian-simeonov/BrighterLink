//
//  AddMetricView.h
//  BrighterLink
//
//  Created by mobile master on 11/18/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCombo.h"
#import "Tag.h"

@class RelatedDataSourcesView;
@interface AddMetricView : UIView<JSComboDelegate>
{
    IBOutlet UIButton* btn_back;
    
    IBOutlet UITextField* txt_mMetric;
    IBOutlet UITextField* txt_mSummaryMethod;
    IBOutlet UITextField* txt_mMetricType;
    IBOutlet UITextField* txt_mMetricId;
    IBOutlet UITextView*    txt_mFomula;
    IBOutlet UITextField*   txt_mMetricName;
    IBOutlet UILabel* lbl_mMetricID;
    IBOutlet UILabel* lbl_mMetricName;
    JSCombo*    cmb_mMetric;
    JSCombo*    cmb_mSummeryMethod;
    JSCombo*    cmb_mMetricType;
}

@property (nonatomic, weak) Tag* parentTag;
@property (nonatomic, weak) RelatedDataSourcesView* relatedSourceView;
+(AddMetricView*)ShowView:(UIView*)parentView;
@end
