//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWaiter.h"
#import "WebManager.h"
#import "EnergyInfo.h"



@interface EnergyView : UIView
{
    EnergyInfo * m_Info;
    
    
    int width;
    int height;
}

//@property (nonatomic, weak) id<PresentTabDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIImageView * img_left_bg;

@property (nonatomic, weak) IBOutlet UILabel     * l_title1;
@property (nonatomic, weak) IBOutlet UILabel     * l_title2;
@property (nonatomic, weak) IBOutlet UILabel     * l_title3;

@property (nonatomic, weak) IBOutlet UIImageView * img_equal_bg;
@property (nonatomic, weak) IBOutlet UIImageView * img_equal;
@property (nonatomic, weak) IBOutlet UILabel     * l_value;
@property (nonatomic, weak) IBOutlet UILabel     * l_recycled;
@property (nonatomic, weak) IBOutlet UITextView  * txt_tons;
@property (nonatomic, weak) IBOutlet UIImageView * img_right_bg;
@property (nonatomic, weak) IBOutlet UIImageView * img_right;


@property (nonatomic, weak) IBOutlet UILabel     * l_Energy;
@property (nonatomic, weak) IBOutlet UILabel     * l_Acres;
@property (nonatomic, weak) IBOutlet UILabel     * l_from;

- (void) setRefresh:(EnergyInfo*) info;
- (void) resizeAllSubview:(CGRect) frame;

- (void) setInfo;
@end
