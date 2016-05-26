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
#import "SolarInfo.h"



@interface SolarView : UIView
{
    float width;
    float height;
    
    BOOL  bCurrent;
    BOOL  bTotal;
    BOOL  bReim;
    
    SolarInfo * m_Info;
}

@property (nonatomic, weak) IBOutlet UILabel * m_l_title1;
@property (nonatomic, weak) IBOutlet UILabel * m_l_title2;

@property (nonatomic, weak) IBOutlet UIImageView  * m_img_title_bg;

@property (nonatomic, weak) IBOutlet UILabel * m_l_Total;
@property (nonatomic, weak) IBOutlet UILabel * m_l_Since;

@property (nonatomic, weak) IBOutlet UILabel * m_l_kwh;


- (void) setRefresh:(SolarInfo*) info;
- (void) resizeAllSubview:(CGRect) frame origentation:(BOOL) bVertical;

@end
