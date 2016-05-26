//
//  CompanyPanelView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyPanelView : UIView
{
    UIView* vw_parent;
    IBOutletCollection(UIImageView) NSArray* imgs_nav;
    IBOutletCollection(UIImageView) NSArray* imgs_icons;
    IBOutletCollection(UIImageView) NSArray* imgs_bgs;
    IBOutletCollection(UIImageView) NSArray* imgs_separator;
    IBOutletCollection(UILabel) NSArray* lbls_btnName;
    IBOutlet UIView* vw_content;
    int m_curTabIdx;
}
@property (nonatomic, strong) UIGestureRecognizer* tapGesture;
+(CompanyPanelView*)ShowCompanyPanelView:(UIView*)parentView;

@end
