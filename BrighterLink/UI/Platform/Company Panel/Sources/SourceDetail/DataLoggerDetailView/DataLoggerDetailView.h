//
//  DataLoggerDetailView.h
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@class SourcesView;
@interface DataLoggerDetailView : UIView
{
    IBOutlet UIButton* btn_edit;
    IBOutlet UIButton* btn_delete;
    
    IBOutlet UILabel* lbl_name;
    IBOutlet UILabel* lbl_manufacturer;
    IBOutlet UILabel* lbl_device;
    IBOutlet UILabel* lbl_accessMethod;
    IBOutlet UILabel* lbl_webAddres;
    IBOutlet UILabel* lbl_destination;
    IBOutlet UILabel* lbl_interval;
    IBOutlet UILabel* lbl_latitude;
    IBOutlet UILabel* lbl_longitude;
    
    Tag* m_tag;
}
@property (nonatomic, weak) SourcesView* delegate;
+(DataLoggerDetailView*)ShowView:(UIView*)parentView;
-(void)SetTagData:(Tag*)tg;
@end
