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

@protocol PresentDrawDelegate <NSObject>

- (void) showWidgetEditView:(int) type mode:(int) nMode;


@end



@interface PresentDrawView : UIView<UITextFieldDelegate>
{

    
    NSTimer* timer;
    NSMutableArray * arrViews;
    NSMutableArray * arrIndex;
    NSMutableArray * arrInfo;
    
    NSMutableArray * arrTimelineWidgetViews;
    NSMutableArray * arrTimelineWidgetInfos;
    
    int nSelectedIdx;
    BOOL bResize;
    float cellSize;
    
    float m_cur_time;
    int m_max_line;
    int m_max_present_duration;
    
    
    // Timeline Touch Point
    CGPoint oriPt;
    CGPoint movePt;
    BOOL    bMoveTimeline;
    BOOL    bMoveTimelineWidget;
    
    int     m_nSelectWidgetInTimeline;
    
    
    BOOL    m_bPlay;
    
    int     curWidgetTotal;
    
    NSMutableArray * arrWidgetInfo;
    
    UIView * m_Prev;
    
    @public
    UIViewController * parent;



}
@property (nonatomic, weak) id<PresentDrawDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIView   * m_vCanvas;
@property (nonatomic, weak) IBOutlet UIView   * m_vTimeline;
@property (nonatomic, weak) IBOutlet UIView   * m_vWidget;

@property (nonatomic, weak) IBOutlet UIImageView * img_new_present_title_bg;
@property (nonatomic, weak) IBOutlet UIImageView * img_canvas_bg;
@property (nonatomic, weak) IBOutlet UIImageView * img_line_bg;

@property (nonatomic, weak) IBOutlet UITextField * m_txt_Present_title;

@property (nonatomic, weak) IBOutlet UILabel    * m_l_duration;


// Play Present

- (void) onPlayPresent;
- (void) onStopPresent;

- (WidgetStartInfo*) selectWidgetType:(int) type Point:(CGPoint) pt;

- (void) setPresentationInfo:(float) curTime;
- (void) setDuration:(int) duration;

- (WidgetStartInfo*) getWidgetStartInfo:(int) idx;
@end
