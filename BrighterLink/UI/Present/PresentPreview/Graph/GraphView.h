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
#import "GraphInfo.h"
#import "PWidgetInfo.h"


@interface GraphView : UIView
{
    BOOL        m_bGeneration;
    BOOL        m_bMaxPower;
    
    double      m_GenerationMax;
    double      m_MaxPowerMax;
    
    UIColor *   generationClr;
    UIColor *   maxClr;

    BOOL        m_bFillColor;
    
@public
    GraphInfo * m_Info;
    PWidgetInfo * m_widget;
}
@property (nonatomic) IBOutlet UITextView * m_txtHeader;

- (void) setInfo:(GraphInfo*) info Widget:(PWidgetInfo*)widget  generation:(BOOL) bGeneration maxPower:(BOOL) bMax;
@end
