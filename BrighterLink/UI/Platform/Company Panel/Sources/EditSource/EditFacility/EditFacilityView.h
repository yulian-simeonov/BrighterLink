//
//  EditFacilityView.h
//  BrighterLink
//
//  Created by mobile master on 11/10/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "FacilityDetailView.h"

@interface EditFacilityView : UIView
{
    IBOutlet UIButton* btn_back;
    
    IBOutlet UITextField* txt_fName;
    IBOutlet UITextView* txt_fAddress;
    IBOutlet UITextField* txt_fUtilityProvider;
    IBOutlet UITextField* txt_fTaxId;
    IBOutlet UITextField* txt_fUtilityAccount;
    
    Tag* m_tag;
}
@property (nonatomic, weak) FacilityDetailView* delegate;
+(EditFacilityView*)ShowView:(UIView*)parentView;
-(void)UpdateWithData:(Tag*)tag;
@end
