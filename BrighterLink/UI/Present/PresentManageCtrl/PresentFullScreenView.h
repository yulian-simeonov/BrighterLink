//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationDetailView.h"
#import "SharePresentView.h"
#import "WidgetStartInfo.h"




@interface PresentFullScreenView : UIView<UITextFieldDelegate>
{
    
    NSTimer* timer;
    NSMutableArray * arrViews;
    NSMutableArray * arrIndex;
    NSMutableArray * arrInfo;
    
    NSMutableArray * arrTimelineWidgetViews;
    NSMutableArray * arrTimelineWidgetInfos;
    
    float cellSize;
    
    float m_cur_time;
    int m_max_line;
    int m_max_present_duration;
    
    int     m_nSelectWidgetInTimeline;
    
    BOOL    m_bPlay;
    int     curWidgetTotal;
    
    NSMutableArray * arrWidgetInfo;
    UIView * m_Prev;
    
    @public
    UIViewController * parent;

}

@property (nonatomic, weak) IBOutlet UIView   * m_vContain;
@property (nonatomic, weak) IBOutlet UIView   * m_vWebContain;
@property (nonatomic, weak) IBOutlet UIWebView * m_vWeb;

@property (nonatomic, weak) IBOutlet UIView   * m_vCanvas;
@property (nonatomic, weak) IBOutlet UIView   * m_vWidget;
@property (nonatomic, weak) IBOutlet UILabel  * m_txt_Present_title;


- (void) setPresentationInfo:(BOOL) flag;
- (WidgetStartInfo*) getWidgetStartInfo:(int) idx;
@end
