//
//  SourceDetailView.h
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@class SourcesView;
@interface FacilityDetailView : UIView
{
    IBOutlet UIButton* btn_edit;
    IBOutlet UIButton* btn_delete;
    
    IBOutlet UILabel* lbl_name;
    IBOutlet UILabel* lbl_address;
    IBOutlet UILabel* lbl_utilityProvider;
    IBOutlet UILabel* lbl_taxId;
    IBOutlet UILabel* lbl_utilityAccount;
    Tag* m_tag;
}
@property (nonatomic, weak) SourcesView* delegate;
+(FacilityDetailView*)ShowView:(UIView*)parentView;
-(void)SetTagData:(Tag*)tg;
@end
