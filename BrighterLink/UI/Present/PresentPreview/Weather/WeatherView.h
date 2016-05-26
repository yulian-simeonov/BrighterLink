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
#import "WeatherInfo.h"


@interface WeatherView : UIView
{
    BOOL bDetail;
    
    WeatherInfo * m_Info;
    
    int nCol;
    int nRow;
    
    float m_width;
    float m_height;
    
}


@property (nonatomic, weak) IBOutlet UIView * m_vMini;
@property (nonatomic, weak) IBOutlet UIView * m_vDetail;

//mini
@property (nonatomic, weak) IBOutlet UIImageView * m_img_top_mini;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_top_mini;
@property (nonatomic, weak) IBOutlet UILabel * m_l_val;
@property (nonatomic, weak) IBOutlet UILabel * m_l_F;
@property (nonatomic, weak) IBOutlet UILabel * m_l_state;
@property (nonatomic, weak) IBOutlet UILabel * m_l_wind;
@property (nonatomic, weak) IBOutlet UILabel * m_l_wind_val;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_F;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Icon;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_arrow;
@property (nonatomic, weak) IBOutlet UILabel * m_l_MPH;
@property (nonatomic, weak) IBOutlet UILabel * m_l_o_mini;

//Detail
@property (nonatomic, weak) IBOutlet UIImageView * m_imgTop;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_top;

@property (nonatomic, weak) IBOutlet UIImageView * m_line1;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgIcon;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_weather;
@property (nonatomic, weak) IBOutlet UILabel * m_l_31;
@property (nonatomic, weak) IBOutlet UILabel * m_l_51;
@property (nonatomic, weak) IBOutlet UILabel * m_l_48;
@property (nonatomic, weak) IBOutlet UILabel * m_l_o;
@property (nonatomic, weak) IBOutlet UILabel * m_l_f;

@property (nonatomic, weak) IBOutlet UIImageView * m_line2;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_wind_val_detail;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_wind_detail;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgArrow;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_MPH_detail;

@property (nonatomic, weak) IBOutlet UILabel     * m_l_humidity_val;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_humidity;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_humidity_mark;

@property (nonatomic, weak) IBOutlet UILabel     * m_l_visibility_val;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_visibility_mark;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_visibility;

@property (nonatomic, weak) IBOutlet UILabel     * m_l_pressure_val;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_pressure_mark;
@property (nonatomic, weak) IBOutlet UILabel     * m_l_pressure;

@property (nonatomic, weak) IBOutlet UIView      * m_vtempView;



- (void) setRefresh:(WeatherInfo*) info Col:(int) col Row:(int) row;
- (void) resizeAllSubview:(CGRect) frame;
@end
