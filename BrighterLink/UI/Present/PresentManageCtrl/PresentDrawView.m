//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PresentDrawView.h"

#import "SharedMembers.h"
#import "PWidgetInfo.h"
#import "GraphInfo.h"
#import "PresentViewController.h"
#import "SDWebImageManager.h"
#import "TransitionManager.h"


#import "EnergyView.h"
#import "WeatherView.h"
#import "GraphView.h"
#import "GraphInfo.h"
#import "EnergyInfo.h"
#import "SolarView.h"
#import "iFrameView.h"
#import "WidgetImageView.h"
#import "TextAreaView.h"
#import "HowPreview.h"

#import "Command.h"


#define CANVAS_VIEW_COL_NUM    16
#define CANVAS_VIEW_ROW_NUM    7

#define TIMELINE_VIEW_CELL_NUM  10

#define CELL_SIZE   42
#define TIMELINE_CELL_STEP     80.95238095238095

#define TEST_MODE  true

@interface PresentDrawView()

enum WidgetTypew{
    
    WEATHER = 0,
    GRAPH,
    ENERGY,
    HOW,
    iFRAME,
    IMAGE,
    SOLAR,
    TEXTAREA,
};
@end

@implementation PresentDrawView

- (void) awakeFromNib
{
//    self.dicDashboardInfo = [SharedMembers sharedInstance].dashboards;
    
    _m_vCanvas.backgroundColor = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.0f];
    _m_vTimeline.backgroundColor = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.0f];
    _m_vTimeline.layer.cornerRadius = 10.0f;
    
    _img_new_present_title_bg.backgroundColor  = [UIColor colorWithRed:45.f/255.f green:144.f/255.f blue:182.f/255.f alpha:1.0f];
    _img_line_bg.backgroundColor = [UIColor colorWithRed:170.f/255.f green:170.f/255.f blue:170.f/255.f alpha:1.0f];
    
    
    m_max_line = 2; //default
    [self  onDrawCanvas: 0.0f];
    [self  onDrawTimeline: 0.0f];
    
    nSelectedIdx  = -1;  bResize = false;
    arrViews = [[NSMutableArray alloc] init];
    arrIndex = [[NSMutableArray alloc] init];
    arrInfo  = [[NSMutableArray alloc] init];
    
    arrTimelineWidgetViews = [[NSMutableArray alloc] init];
    arrTimelineWidgetInfos = [[NSMutableArray alloc] init];
    
    arrWidgetInfo = [[NSMutableArray alloc] init];
    
    m_cur_time = 0;
    
    bMoveTimeline = false;
    bMoveTimelineWidget = false;
    m_nSelectWidgetInTimeline = 0;
    
    m_bPlay = false;
    
    [_m_txt_Present_title setReturnKeyType:UIReturnKeyDone];
}

- (void) setInitialInfo
{
  
}

// Play Present
- (void) onPlayPresent
{
    m_bPlay = true;
//    m_cur_time = 0;
    
    [self initDrawPlayWidgets];
}

- (void) onStopPresent
{
    m_bPlay = false;
    [timer invalidate]; timer = nil;

    [self onInitDrawCanvas];
    
    float step = TIMELINE_CELL_STEP /10.0f;
    [self onDrawCanvas: m_cur_time];
    [self onDrawTimeline: m_cur_time * step];
}

- (void) Play
{
    if(m_cur_time > m_max_present_duration )
    {
        [timer invalidate]; timer = nil;
    }
    m_cur_time += 0.2f;
    
    float step = TIMELINE_CELL_STEP /10.0f;
    
    [self onDrawCanvas: m_cur_time];
    [self onDrawTimeline: m_cur_time * step];

}

- (WidgetStartInfo*) selectWidgetType:(int) type Point:(CGPoint) pt
{
    WidgetStartInfo * info;
    switch ( type ) {
        case WEATHER:
            [arrViews addObject: [self createWidget:5 height:2 Title:@"Weather" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0] ];
            [arrInfo addObject:[NSNumber numberWithInt:WEATHER]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        case GRAPH:
            [arrViews addObject: [self createWidget:8 height:7 Title:@"Graph" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0]];
            [arrInfo addObject:[NSNumber numberWithInt:GRAPH]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        case ENERGY:
            [arrViews addObject: [self createWidget:7 height:4 Title:@"Energy Equivalencies" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0]];
            
            [arrInfo addObject:[NSNumber numberWithInt:ENERGY]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        case HOW:
            [arrViews addObject: [self createWidget:16 height:7 Title:@"How Does Solar Work" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0]];

            [arrInfo addObject:[NSNumber numberWithInt:HOW]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        case iFRAME:
            [arrViews addObject: [self createWidget:16 height:7 Title:@"iFrame" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0]];

            [arrInfo addObject:[NSNumber numberWithInt:iFRAME]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        case IMAGE:
            [arrViews addObject: [self createWidget:6 height:4 Title:@"Image" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0]];
            [arrInfo addObject:[NSNumber numberWithInt:IMAGE]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        case SOLAR:
            [arrViews addObject: [self createWidget:5 height:5 Title:@"Solar Generation" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0]];

            [arrInfo addObject:[NSNumber numberWithInt:SOLAR]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        case TEXTAREA:
            [arrViews addObject: [self createWidget:5 height:2 Title:@"TextArea" icon:@"temp_icon" Point:pt color:@"FFFFFF" layout:0]];
            [arrInfo addObject:[NSNumber numberWithInt:TEXTAREA]];
            [self setWidgetPos:[arrViews count]-1];
            info = [self getWidgetStartInfo:[arrViews count]-1];
            break;
        default:
            break;
    }
    return info;
}

- (UIColor *) colorFromHexString1:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIView*) createWidget:(int) widthNum height:(int) heightNum Title:(NSString*) title icon:(NSString*) iconName Point:(CGPoint) pt color:(NSString*) clr layout:(int) layoutOrder
{
    
    float oriY   = 10.0f;
    float size  = 20.f;
    
    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CELL_SIZE * widthNum, CELL_SIZE * heightNum)];
    [view setBackgroundColor:[self colorFromHexString1: clr]];
    view.layer.cornerRadius = 10.0f;
    view.tag = [arrViews count];
    
    UIView * subView = [[UIView alloc] initWithFrame:CGRectMake(1.f, 1.f, CELL_SIZE * widthNum - 2, CELL_SIZE * heightNum - 2)];
    [subView setBackgroundColor:[UIColor whiteColor]];
    subView.layer.cornerRadius = 10.0f;
    
    UILabel * lTitle = [[UILabel alloc] initWithFrame:CGRectMake( view.frame.size.width/2, view.frame.size.height/2, view.frame.size.width , 50)];
    
    [lTitle setText:title];
    [lTitle setFont:[UIFont fontWithName:@"Arial" size:18]];
    [lTitle setTextColor: [UIColor blackColor]];
    [lTitle setTextAlignment:NSTextAlignmentCenter];
    [lTitle setCenter: CGPointMake( view.frame.size.width/2, view.frame.size.height * 2.f/3.f)];
    
    UIImage * image = [self GetImage: title];
    UIImageView * imgIconView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, size * 1.5f, size * 2)];
    [imgIconView setCenter: CGPointMake( view.frame.size.width/2, lTitle.center.y - 30.f)];
    [imgIconView setImage: image];
    imgIconView.contentMode  = UIViewContentModeScaleAspectFill;
    
    UIButton * btnDepulicte = [[UIButton alloc] initWithFrame: CGRectMake( view.frame.size.width - 4 * size -4, oriY, size, size)];
    [btnDepulicte addTarget: self action:@selector(onDepulicate:) forControlEvents:UIControlEventTouchUpInside];
    [btnDepulicte setImage:[UIImage imageNamed:@"duplicate.png"] forState:UIControlStateNormal];
    btnDepulicte.tag = [arrViews count];
    
    UIButton * btnEdit      = [[UIButton alloc] initWithFrame:CGRectMake( view.frame.size.width - 3 * size -4, oriY, size, size)];
    [btnEdit addTarget: self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    btnEdit.tag = [arrViews count];
    
    UIButton * btnRemove    = [[UIButton alloc] initWithFrame:CGRectMake( view.frame.size.width - 2 * size - 4, oriY, size, size)];
    [btnRemove addTarget: self action:@selector(onRemove:) forControlEvents:UIControlEventTouchUpInside];
    [btnRemove setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
    btnRemove.tag = [arrViews count];
    
    UIButton * btnPreview   = [[UIButton alloc] initWithFrame:CGRectMake( view.frame.size.width - size - 4, oriY, size, size)];
    [btnPreview addTarget: self action:@selector(onPreview:) forControlEvents:UIControlEventTouchUpInside];
    [btnPreview setImage:[UIImage imageNamed:@"preview.png"] forState:UIControlStateNormal];
    btnPreview.tag = [arrViews count];
    
    UIView * imgContainView = [[UIView alloc] initWithFrame:CGRectMake( view.frame.size.width - size -6, view.frame.size.height - size-6, size, size)];
    [imgContainView setBackgroundColor:[UIColor clearColor]];

    UIImage * img  = [UIImage imageNamed: @"increase.png"];
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [imgView setImage:img];
    
    [imgContainView addSubview:imgView];

    subView.layer.cornerRadius = 10.0f;
    subView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [subView addSubview:lTitle];
    [subView addSubview: imgIconView];
    
    [subView addSubview: imgContainView];
    [subView addSubview: btnDepulicte];
    [subView addSubview: btnEdit];
    [subView addSubview: btnRemove];
    [subView addSubview: btnPreview];

    [view addSubview:subView];
    
    [arrIndex addObject: [NSNumber numberWithInt:[arrViews count]]];
    
    view.center = pt;
    view.layer.zPosition = 50-layoutOrder;
    [_m_vWidget addSubview: view];
    
    return  view;
}

- (WidgetStartInfo*) getWidgetStartInfo:(int) idx
{
    WidgetStartInfo * info  = [[WidgetStartInfo alloc] init];
    
    int min = (int)(m_cur_time / 60.f);
    int sec = (int)(m_cur_time - 60 * min);
    info.startPoint  =  [NSString stringWithFormat:@"%d:%d", min, sec];
    
    UIView * view = (UIView*)[arrViews objectAtIndex:idx];
    view.tag = idx;
    float x = view.frame.origin.x;
    float y = view.frame.origin.y;
    
    int nCol = (int)(x / CELL_SIZE + 0.5f);
    int nRow = (int)(y / CELL_SIZE + 0.5f);
    
    info.rowPos = [NSString stringWithFormat:@"%d", nRow];
    info.colPos = [NSString stringWithFormat:@"%d", nCol];
    
    return  info;
}

- (void) onTemp:(id) sender
{
    UIButton * btn = (UIButton*) sender;
    NSLog(@"%d", btn.tag);
    UIView * view  = (UIView*)[arrViews objectAtIndex: btn.tag];
    [_m_vWidget bringSubviewToFront:view];
}

- (void) onDepulicate:(id) sender
{
    
    UIButton *btn = (UIButton*) sender;
    UIView * view = (UIView*) [arrViews objectAtIndex: btn.tag];
    PWidgetInfo * widget = [arrInfo objectAtIndex: btn.tag];
    int type  = [self GetType: widget.name];
    
    WidgetStartInfo * startInfo = [self selectWidgetType:type Point: view.center];
    
    PresentViewController * viewController = (PresentViewController*) parent;

    viewController->m_nSelectedWidget = type;
    [viewController createWidgetInfo: startInfo];
    viewController->m_nSelectedWidget = -1;
}

- (void) onEdit:(id) sender
{
    UIButton *btn = (UIButton*) sender;
    PWidgetInfo * widget = [arrInfo objectAtIndex: btn.tag];

    [SharedMembers sharedInstance].curWidget = widget;
    int type  = [self GetType: widget.name];
  
    id<PresentDrawDelegate> Delegate = self.delegate;
    [Delegate showWidgetEditView:type mode:0];
}

- (void) onRemove:(id) sender
{
    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
    
    UIButton *btn = (UIButton*) sender;
    
    [[NSNotificationCenter defaultCenter]         postNotificationName:@"ShowProgress"         object:self];
    PWidgetInfo * widget = [arrInfo objectAtIndex: btn.tag];
    [[SharedMembers sharedInstance].webManager DeleteWidget: widget._id success:^(MKNetworkOperation *networkOperation) {

        PresentViewController* present =  (PresentViewController*)parent;
        [present GetPresentation:info._id time:m_cur_time];
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        [[NSNotificationCenter defaultCenter]         postNotificationName:@"HideProgress"         object:self];
    }];
}

- (void) onPreview:(id) sender
{
    UIButton *btn = (UIButton*) sender;
    PWidgetInfo * widget = [arrInfo objectAtIndex: btn.tag];
    
    [SharedMembers sharedInstance].curWidget = widget;
    int type  = [self GetType: widget.name];
    
    id<PresentDrawDelegate> Delegate = self.delegate;
    [Delegate showWidgetEditView:type mode:1];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    CGPoint pt = [touch locationInView: self];
    int max  = -1;
    
    if ( CGRectContainsPoint( _m_vTimeline.frame, pt) ) {
        oriPt = [touch locationInView: _m_vTimeline];
        bMoveTimeline  = true;
        bMoveTimelineWidget = false;
        for ( int i  = 0; i < [arrTimelineWidgetViews count]; i++ ) {
            UIView * v  = (UIView*) [arrTimelineWidgetViews objectAtIndex:i];
            if ( CGRectContainsPoint( v.frame, oriPt) ) {
                if ( max <= v.layer.zPosition ) {
                    bMoveTimelineWidget = true;
                    bMoveTimeline = false;
                    m_nSelectWidgetInTimeline = i;
                    max = v.layer.zPosition;
                }
            }
        }
        
        if ( max != -1 ) {
            UIView * v  = (UIView*) [arrTimelineWidgetViews objectAtIndex:m_nSelectWidgetInTimeline];
            v.layer.zPosition = 100;
        }
    }
    else
    {
        if ( !m_bPlay ) {
            bMoveTimeline  = false;
            bMoveTimelineWidget = false;

            CGPoint touchLoc = [touch locationInView: _m_vWidget];
            for ( int j = 0; j < [arrViews count]; j++) {
                UIView * v = (UIView*)[arrViews objectAtIndex:j];
                if ( v.isHidden == false ) {
                    if ( CGRectContainsPoint( v.frame, touchLoc) ) {
                        if ( max <= v.layer.zPosition ) {
                            max = v.layer.zPosition;
                            CGRect rect = CGRectMake(v.frame.size.width - CELL_SIZE, v.frame.size.height - CELL_SIZE, CELL_SIZE, CELL_SIZE);
                            CGPoint touchLoc1 = [touch locationInView: v];
                            if ( CGRectContainsPoint( rect, touchLoc1) ) {
                                bResize = true;
                            }
                            nSelectedIdx  = v.tag;
                        }
                    }
                }
            }
            
            if ( max != -1 ) {
                UIView * view  = (UIView*)[arrViews objectAtIndex: nSelectedIdx];
                view.layer.zPosition = 100;
            }
            
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)eventD
{
    UITouch * touch = [touches anyObject];
    
    if( bMoveTimeline ) // Timeline Move
    {
        CGPoint pt  = [touch locationInView: _m_vTimeline];
        float delta  = oriPt.x - pt.x;
        m_cur_time += (delta * 10) / TIMELINE_CELL_STEP;
        
        oriPt = pt;
        
        float step = TIMELINE_CELL_STEP /10.0f;
        [self onDrawCanvas:m_cur_time];
        [self onDrawTimeline:m_cur_time * step];
    }
    else if ( bMoveTimelineWidget )
    {
        CGPoint pt  = [touch locationInView: _m_vTimeline];
        
        UIView * v  = (UIView*) [arrTimelineWidgetViews objectAtIndex: m_nSelectWidgetInTimeline];
        
        v.center = pt;

    }
    else // Widget Move in Canvas
    {
        CGPoint touchLoc = [touch locationInView: _m_vWidget];
        if( nSelectedIdx != -1 )
        {
            if ( TEST_MODE ) {
                if ( bResize ) {
                    UIView * view  = (UIView*)[arrViews objectAtIndex: nSelectedIdx];
                    float width = touchLoc.x - view.frame.origin.x;
                    float height = touchLoc.y - view.frame.origin.y;

                    if( width < 2 * CELL_SIZE )    width = 2 * CELL_SIZE;
                    if( height < 2 * CELL_SIZE )   height = 2 * CELL_SIZE;
                    if( width > 16 * CELL_SIZE )   width = 16 * CELL_SIZE;
                    if( height > 7 * CELL_SIZE )   height = 7 * CELL_SIZE;
                    
                    
                    float deltaX = width - view.frame.size.width;
                    [view setFrame:CGRectMake( view.frame.origin.x, view.frame.origin.y, width, height)];
                    
                    for ( UIView * v in [view subviews] ) {
                        if( [v isKindOfClass:[UIView class]] )
                        {
                            [v setFrame: CGRectMake( 1, 1, width - 2, height - 2)];
                            for ( UIView * subV in [v subviews] ) {

                                if ( [subV isKindOfClass:[UIButton class]] ) {
                                    [subV setFrame: CGRectMake(subV.frame.origin.x + deltaX, subV.frame.origin.y, subV.frame.size.width, subV.frame.size.height)];
                                }
                                else if ( [subV isKindOfClass:[UIImageView class]]){
                                    [subV setCenter:CGPointMake( width/2, height * 2/3 - 30)];
                                }
                                else if( [subV isKindOfClass: [UILabel class]]){
                                    [subV setCenter:CGPointMake( width/2, height * 2/3)];
                                }
                                else if ( [subV isKindOfClass: [UIView class]]){
                                    float size  = subV.frame.size.width;
                                    [subV setFrame:CGRectMake(v.frame.size.width -size-6, v.frame.size.height - size - 6, size, size)];
                                }
                            }
                        }
                    }
                }
                else
                {
                    UIView * view  = (UIView*)[arrViews objectAtIndex: nSelectedIdx];
                    view.center = touchLoc;
                }
            }
            else
            {
                UIView * view  = (UIView*)[arrViews objectAtIndex: nSelectedIdx];
                view.center = touchLoc;
            }
        }
    }
    
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint pt  = [touch locationInView: _m_vTimeline];
    
    if( bMoveTimeline ) // Timeline Move
    {
        bMoveTimeline  = false;
        
        if ( m_cur_time < 0) {
            m_cur_time = 0;
            float step = TIMELINE_CELL_STEP /10.0f;
            [self onDrawCanvas:m_cur_time];
            [self onDrawTimeline:m_cur_time * step];
        }
    }
    else if ( bMoveTimelineWidget){
        
        UIView * v  = (UIView*) [arrTimelineWidgetViews objectAtIndex: m_nSelectWidgetInTimeline];
        PWidgetInfo * widget  = (PWidgetInfo*) [arrTimelineWidgetInfos objectAtIndex: m_nSelectWidgetInTimeline];
        NSLog( @"%f", v.frame.origin.x );
        float ori = [self GetFirstTimeOfWidgets];
        int time    = (int)( v.frame.origin.x  - ori) * 10 / TIMELINE_CELL_STEP;
        
        int min  =  time / 60;
        int sec  = time % 60;
        
        widget.param.startDate = [NSString stringWithFormat:@"%d:%d", min, sec];
        
        int row = [self GetTimelineRowCount: pt];
        widget.param.timelineRowPosition  = [NSNumber numberWithInt:row];
        [self replaceTimelineRowCounts:row];
        
        float step = TIMELINE_CELL_STEP /10.0f;
        [self onInitDrawCanvas];
        [self onDrawCanvas:time];
        [self onDrawTimeline:time * step];
        [self setPresentDuration];
        
        [widget setWidgetDictionary:true];
        [[SharedMembers sharedInstance].webManager UpdateWidget:widget._id param:widget->msgDic success:^(MKNetworkOperation *networkOperation) {
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
    }
    else
    {
        [self setWidgetPos:nSelectedIdx];
        
        if ( nSelectedIdx == - 1 || nSelectedIdx > [arrInfo count]-1) {
            return;
        }
        
        PWidgetInfo * widget  = [arrInfo objectAtIndex: nSelectedIdx];
        UIView * view = (UIView*)[arrViews objectAtIndex:nSelectedIdx];
        widget.param.rowPosition = [NSNumber numberWithInt: ( view.frame.origin.y / CELL_SIZE)];
        widget.param.colPosition = [NSNumber numberWithInt: ( view.frame.origin.x / CELL_SIZE)];
        widget.param.rowCount    = [NSNumber numberWithInt: (view.frame.size.height / CELL_SIZE)];
        widget.param.colCount    = [NSNumber numberWithInt: (view.frame.size.width / CELL_SIZE)];
        nSelectedIdx = -1;
        
        [widget setWidgetDictionary:true];
        [[SharedMembers sharedInstance].webManager UpdateWidget:widget._id param:widget->msgDic success:^(MKNetworkOperation *networkOperation) {
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
        
        if(TEST_MODE)
            bResize = false;
        
        float step = TIMELINE_CELL_STEP /10.0f;
        [self onInitDrawCanvas];
        [self onDrawCanvas:m_cur_time];
        [self onDrawTimeline:m_cur_time * step];
    }

//    for ( int i = 0; i < [arrInfo count]; i++ ) {
//        PWidgetInfo * widget  = [arrInfo objectAtIndex:i];
//        [widget setWidgetDictionary:true];
//        [[SharedMembers sharedInstance].webManager UpdateWidget:widget->msgDic success:^(MKNetworkOperation *networkOperation) {
//
//        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
//
//        }];
//    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint pt  = [touch locationInView: _m_vTimeline];
    
    if ( bMoveTimeline ) {
        bMoveTimeline = false;
        if ( m_cur_time < 0) {
            m_cur_time = 0;
            float step = TIMELINE_CELL_STEP /10.0f;
            [self onDrawCanvas:m_cur_time];
            [self onDrawTimeline:m_cur_time * step];
        }
    }
    else if ( bMoveTimelineWidget )
    {
        UIView * v  = (UIView*) [arrTimelineWidgetViews objectAtIndex: m_nSelectWidgetInTimeline];
        PWidgetInfo * widget  = (PWidgetInfo*) [arrTimelineWidgetInfos objectAtIndex: m_nSelectWidgetInTimeline];
        NSLog( @"%f", v.frame.origin.x );
        float ori = [self GetFirstTimeOfWidgets];
        int time    = (int)( v.frame.origin.x  - ori) * 10 / TIMELINE_CELL_STEP;
        
        int min  =  time / 60;
        int sec  = time % 60;
        
        widget.param.startDate = [NSString stringWithFormat:@"%d:%d", min, sec];
        
        int row = [self GetTimelineRowCount: pt];
        widget.param.timelineRowPosition  = [NSNumber numberWithInt:row];
        [self replaceTimelineRowCounts:row];
        
        PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
        [info setWidgetDictionary:true];
        
        float step = TIMELINE_CELL_STEP /10.0f;
        [self onInitDrawCanvas];
        [self onDrawCanvas:time];
        [self onDrawTimeline:time * step];
        
        [self setPresentDuration];
    }
    else
    {
        [self setWidgetPos:nSelectedIdx];
        
        if ( nSelectedIdx == - 1 || nSelectedIdx > [arrInfo count]-1) {
            return;
        }
        
        PWidgetInfo * widget  = [arrInfo objectAtIndex: nSelectedIdx];
        UIView * view = (UIView*)[arrViews objectAtIndex:nSelectedIdx];
        widget.param.rowPosition = [NSNumber numberWithInt: ( view.frame.origin.y / CELL_SIZE)];
        widget.param.colPosition = [NSNumber numberWithInt: ( view.frame.origin.x / CELL_SIZE)];
        widget.param.rowCount    = [NSNumber numberWithInt: (view.frame.size.height / CELL_SIZE)];
        widget.param.colCount    = [NSNumber numberWithInt: (view.frame.size.width / CELL_SIZE)];

        nSelectedIdx = -1;
        
        [widget setWidgetDictionary:true];
        [[SharedMembers sharedInstance].webManager UpdateWidget: widget._id param:widget->msgDic success:^(MKNetworkOperation *networkOperation) {
            
        } failure:^(MKNetworkOperation *errorOp, NSError *error) {
            
        }];
        
        if (TEST_MODE) {
            bResize = false;
        }
        
        float step = TIMELINE_CELL_STEP /10.0f;
        [self onInitDrawCanvas];
        [self onDrawCanvas:m_cur_time];
        [self onDrawTimeline:m_cur_time * step];
    }
}

- (int) GetTimelineRowCount:( CGPoint ) pt
{
    int n = 0;
    float stepY  = _m_vTimeline.frame.size.height / (m_max_line + 3);
    float oriY   = stepY + 20.0f;
    
    // draw row line
    for ( int j = 0; j < m_max_line+2; j++ ) {
        float startPos  = oriY + stepY * j; float endPos = oriY + stepY * (j+1);
        if ( startPos <= pt.y && endPos > pt.y )
        {
            n = j;   break;
        }
    }
    return  n;
}

// timeline :  Get rowCount  : Param.timelineRowCount
- (void) replaceTimelineRowCounts:(int) idx
{
    int startTime  = (m_cur_time/10) * 10;
    int endTime    = startTime + 10;
    
    NSMutableArray * temp  = [[NSMutableArray alloc] init];
    
    for ( int i = 0; i < [arrTimelineWidgetInfos count]; i++  ) {
        
        if ( i == m_nSelectWidgetInTimeline) {
            continue;
        }
        
        PWidgetInfo * widget = [arrTimelineWidgetInfos objectAtIndex:i];
        NSString * startPoint  = widget.param.startDate;
        NSArray * arr  = [startPoint componentsSeparatedByString:@":"];
        NSString * min;         NSString * sec;
        
        if ( [startPoint isEqualToString:@""] ) {
            min = @"0"; sec = @"0";
        }
        else{
            min = arr[0];
            sec = arr[1];
        }
        int startPos  = min.intValue*60 + sec.intValue;
        
        if ( startPos >= startTime && endTime > startPos ) {
            [temp addObject:widget];
        }
    }
    BOOL flag  = false;
    for ( int i = 0; i < [temp count]; i++ ) {
        PWidgetInfo *widget = [temp objectAtIndex:i];
        int n =  [widget.param.timelineRowPosition intValue];
        if ( n == idx ) {
            flag  = true;
        }
    }
    
    if ( flag ) {
        for ( int i = 0; i < [temp count]; i++ ) {
            PWidgetInfo *widget = [temp objectAtIndex:i];
            int n =  [widget.param.timelineRowPosition intValue];
            if ( n >= idx ) {
                widget.param.timelineRowPosition = [NSNumber numberWithInt: n+1];
            }
        }
    }
}

- (float) GetFirstTimeOfWidgets
{
    float Min  = 0;
    if ( [arrTimelineWidgetViews count] > 0 ) {
        UIView * firstV = [arrTimelineWidgetViews objectAtIndex:0];
        Min = firstV.frame.origin.x;
        for ( int i = 0; i < [arrTimelineWidgetViews count]; i++ ) {
            UIView * v  = [arrTimelineWidgetViews objectAtIndex:i];
            
            float x  = v.frame.origin.x;
            
            (Min > x) ? Min = x: Min;
        }
    }
    return  Min;
}

- (void) setWidgetPos:(int) idx
{
    if ( idx == -1 ) {
        return;
    }

    UIView * view = (UIView*)[arrViews objectAtIndex:idx];
    view.tag = idx;
    float x = view.frame.origin.x;
    float y = view.frame.origin.y;
    
    float sizeX = view.frame.size.width;
    float sizeY = view.frame.size.height;
    
    int nCol = (int)(x / CELL_SIZE + 0.5f);
    int nRow = (int)(y / CELL_SIZE + 0.5f);
    
    if(nCol < 0)   nCol = 0;
    if(nRow < 0)   nRow = 0;
    
    
    int nSizeCellX = (int) (sizeX / CELL_SIZE + 0.5f);
    int nSizeCellY = (int) (sizeY / CELL_SIZE + 0.5f);
    
    if(nSizeCellX > 16)   nSizeCellX = 16;
    if(nSizeCellY > 7)    nSizeCellY = 7;
    
    float deltaX =  view.frame.size.width - nSizeCellX * CELL_SIZE;
    [view setFrame:CGRectMake( CELL_SIZE * nCol, CELL_SIZE * nRow, nSizeCellX * CELL_SIZE, nSizeCellY * CELL_SIZE)];
    
    float lastX = CELL_SIZE * (nCol + nSizeCellX);
    float lastY = CELL_SIZE * (nRow + nSizeCellY);
    
    if ( lastX > 16 * CELL_SIZE ) {
        lastX = 16 * CELL_SIZE;
        [view setFrame:CGRectMake( lastX - nSizeCellX * CELL_SIZE, CELL_SIZE * nRow, nSizeCellX * CELL_SIZE, nSizeCellY * CELL_SIZE)];
    }
    
    nCol = (int)((view.frame.origin.x) / CELL_SIZE);
    
    if ( lastY > 7 * CELL_SIZE ){
        lastY = 7 * CELL_SIZE;
        [view setFrame:CGRectMake( CELL_SIZE * nCol, lastY - nSizeCellY * CELL_SIZE, nSizeCellX * CELL_SIZE, nSizeCellY * CELL_SIZE)];
    }
    
    
    for ( UIView * v in [view subviews] ) {
        if( [v isKindOfClass:[UIView class]] )
        {
            float width = view.frame.size.width;
            float height = view.frame.size.height;
            [v setFrame: CGRectMake( 1, 1, width - 2, height - 2)];
            for ( UIView * subV in [v subviews] ) {
                if ( [subV isKindOfClass:[UIButton class]] ) {
                    
                    [subV setFrame: CGRectMake(subV.frame.origin.x  - deltaX, subV.frame.origin.y, subV.frame.size.width, subV.frame.size.height)];
                }
                else if ( [subV isKindOfClass:[UIImageView class]]){
                    [subV setCenter:CGPointMake( width/2, height * 2/3 - 30)];
                }
                else if( [subV isKindOfClass: [UILabel class]]){
                    [subV setCenter:CGPointMake( width/2, height * 2/3)];
                }
                else if ( [subV isKindOfClass: [UIView class]]){
                    float size  = subV.frame.size.width;
                    [subV setFrame:CGRectMake(v.frame.size.width -size-6, v.frame.size.height - size - 6, size, size)];
                }
            }
        }
    }
}

- (void) setPresentationInfo:(float) curTime
{
    NSLog(@"start");
    
    for ( UIView * v in arrViews) {
        [v removeFromSuperview];
    }
    [arrViews removeAllObjects];
    [arrInfo removeAllObjects];
    
    PresentationInfo * curPresent = [SharedMembers sharedInstance].curPresent;
    
    m_max_line = 2;
    m_max_present_duration = 0;
    for ( PWidgetInfo * widget in curPresent.m_widgets ) {
    
        int timelineRowPos  = [widget.param.timelineRowPosition intValue];
        (m_max_line < timelineRowPos) ? m_max_line = timelineRowPos : m_max_line;

        NSString * startPoint =   widget.param.startDate;
        NSArray * arr  = [startPoint componentsSeparatedByString:@":"];

        NSString * min;
        NSString * sec;

        if ( [startPoint isEqualToString:@""] ) {
                min = @"0"; sec = @"0";
        }
        else{
            min = arr[0];
            sec = arr[1];
        }
        int  dur =       [widget.param.duration intValue];

        int startTime  = min.intValue*60 + sec.intValue;
        (m_max_present_duration < startTime + dur) ? m_max_present_duration = startTime+dur : m_max_present_duration;
    }
    [_m_txt_Present_title setText:curPresent.name];
    float step = TIMELINE_CELL_STEP /10.0f;
    [self onInitDrawCanvas];
    [self onDrawCanvas: m_cur_time];
    [self onDrawTimeline: m_cur_time * step];
    
    NSLog( @"%d", [curPresent.duration integerValue] );

    
    [self setPresentDuration];
    _m_l_duration.text = [NSString stringWithFormat:@"(total presentation time: %d secs)", [curPresent.duration integerValue] ];
    [self GetPreviewDatas];
}

- (void) onInitDrawCanvas
{
    for ( UIView * v in arrViews) {
        [v removeFromSuperview];
    }
    [arrViews removeAllObjects];
    [arrInfo removeAllObjects];
    [arrIndex removeAllObjects];
    
    for ( UIView * subView in [_m_vCanvas subviews] ) {
        [subView removeFromSuperview];
    }
    
    for ( int i = 0; i < CANVAS_VIEW_COL_NUM+1; i++ ) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CELL_SIZE * i, 0, 1, _m_vCanvas.frame.size.height)];
        lineView.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:196.0/255.0 alpha:1.0f];
        [_m_vCanvas addSubview:lineView];
    }
    
    for ( int j = 0; j < 8; j++ ) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake( 0, CELL_SIZE * j, _m_vCanvas.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:196.0/255.0 alpha:1.0f];
        [_m_vCanvas addSubview:lineView];
    }
    
    // Draw Widgets
    PresentationInfo * curPresent = [SharedMembers sharedInstance].curPresent;
    
    m_max_line = 2;
    for ( int i = 0; i < [curPresent.m_widgets count]; i++ ) {
        PWidgetInfo * widget = [curPresent.m_widgets objectAtIndex:i];
        int timelineRowPos  = [widget.param.timelineRowPosition intValue];
        (m_max_line < timelineRowPos) ? m_max_line = timelineRowPos : m_max_line;
        
        NSString * startPoint =   widget.param.startDate;
        NSString * min;
        NSString * sec;
        
        if ( [startPoint isEqualToString:@""] ) {
            min = @"0"; sec = @"0";
        }
        else {
            NSArray * arr  = [startPoint componentsSeparatedByString:@":"];
            min = arr[0];
            sec = arr[1];
        }
        
        // timeline time (start point)
        int colPos  = [widget.param.colPosition intValue];
        int rowPos  = [widget.param.rowPosition intValue];
        int col     = [widget.param.colCount intValue];
        int row     = [widget.param.rowCount intValue];
        
        CGPoint pt  = CGPointMake( (colPos + (float)col/2.0f) * CELL_SIZE, (rowPos + (float)row/2.0f) * CELL_SIZE );
        if ( m_bPlay ) {
            UIView * v = [self createWidget:col height:row Title:widget.name icon:@"temp_icon" Point:pt color: widget.timeline.backgroundColor layout:[widget.param.timelineRowPosition intValue]] ;
            [v addSubview: [arrWidgetInfo objectAtIndex:i]];
            [v setHidden:true];
            [arrViews addObject:v];
        }
        else{
            [arrViews addObject: [self createWidget:col height:row Title:widget.name icon:@"temp_icon" Point:pt color: widget.timeline.backgroundColor layout:[widget.param.timelineRowPosition intValue]] ];
        }
        [arrInfo addObject: widget];
    }
    
    for ( int  i = 0; i < [arrViews count]; i++  ) {
        UIView * v  = [arrViews objectAtIndex:i];
        [v setHidden: true];
    }
}

- (void) onDrawCanvas:(float) delta
{
    // Draw Widgets
    PresentationInfo * curPresent = [SharedMembers sharedInstance].curPresent;
    m_max_line = 2;
    for ( int i = 0; i <  [curPresent.m_widgets count]; i++  ) {
        PWidgetInfo * widget = [curPresent.m_widgets objectAtIndex:i];
        int timelineRowPos  = [widget.param.timelineRowPosition intValue];
        (m_max_line < timelineRowPos) ? m_max_line = timelineRowPos : m_max_line;
        
        NSString * startPoint =   widget.param.startDate;
        NSString * min;
        NSString * sec;
        
        if ( [startPoint isEqualToString:@""] ) {
            min = @"0"; sec = @"0";
        }
        else{
            NSArray * arr  = [startPoint componentsSeparatedByString:@":"];
            min = arr[0];
            sec = arr[1];
        }
        
        int dur   = [widget.param.duration intValue];
        int start = min.intValue * 60 + sec.intValue;
        int end   = start + dur;
        
        // timeline time (start point)
        if( delta >= start && delta < end ) {
            if ( m_bPlay ) {
                UIView * v = [arrViews objectAtIndex: i];
                [v addSubview:[arrWidgetInfo objectAtIndex:i]];
                [v setHidden: false];
                int idx  =  1000;
                if ( fabs(start - delta) < 0.3 ) {
                    
                    UIView * how = [arrWidgetInfo objectAtIndex:i];
                    
                    for ( UIView * subHow in [how subviews] )
                    {
                        if ( [subHow isKindOfClass:[HowPreview class]] ) {
                            HowPreview * v =  (HowPreview*)subHow;
                            [v StartAnimation];
                        }
                    }
                    
                    idx = [Command GetTransitionEffectIdx: widget.param.transitionIn ];
                    [TransitionManager SetData:v transitionType: idx];
                }
                else if( fabs(end - delta) < 0.3 ){
                    idx = [Command GetTransitionEffectIdx: widget.param.transitionOut];
                    [TransitionManager SetData:v transitionType: idx];
                }
            }
            else{
                UIView * v = [arrViews objectAtIndex: i];
                [v setHidden: false];
                
//                int idx  =  1000;
//                if ( fabs(start - delta) < 0.3 ) {
//                    idx = [Command GetTransitionEffectIdx: widget.param.transitionIn ];
//                    [TransitionManager SetData:v transitionType: idx];
//                }
//                else if( fabs(end - delta) < 0.3 ){
//                    idx = [Command GetTransitionEffectIdx: widget.param.transitionOut];
//                    [TransitionManager SetData:v transitionType: idx];
//                }

            }
        }
        else{
            UIView * v = [arrViews objectAtIndex: i];
            [v setHidden: true];
        }
    }
}

- (void) initDrawPlayWidgets
{
    [self GetPreviewDatas];
    [self     onInitDrawCanvas];
    timer   = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(Play) userInfo:nil repeats:true];
}

- (void) GetPreviewDatas
{
    
    [arrWidgetInfo removeAllObjects];
    curWidgetTotal = 0;
    
    PresentationInfo * present = [SharedMembers sharedInstance].curPresent;
    for ( int i = 0; i < [present.m_widgets count]; i++ ) {
        PWidgetInfo * info = [present.m_widgets objectAtIndex:i];
        
        [SharedMembers sharedInstance].curWidget  = info;
        
        int col = [info.param.colCount intValue];
        int row  = [info.param.rowCount intValue];

        UIView * tempView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, col * 42.f, row * 42.f)];
        [tempView setBackgroundColor:[UIColor clearColor]];
        
        NSString * name = info.name;
        
        if ( [name isEqualToString:@"Graph"] ) {
            GraphView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"GraphView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                 [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
                 [view  setInfo: info->graph Widget:info generation:[info.param.widgetGraphGeneration boolValue] maxPower:[info.param.widgetGraphMaxPower boolValue]];
                 [tempView addSubview:view];
        }
        else if ( [name isEqualToString:@"Weather"]){
                
            WeatherView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
                [view setRefresh:info->weather Col:col Row:row];
            [view resizeAllSubview:view.frame];
                [tempView addSubview: view];
                    
        }
        else if ( [name isEqualToString:@"Energy Equivalencies"]){
                
            EnergyView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
                [view setRefresh: info->energy];
            [view resizeAllSubview:view.frame];
                [tempView addSubview: view];
                    
        }
        else if ( [name isEqualToString:@"How Does Solar Work"]){
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"HowPreview" owner:self options:nil];
                HowPreview* vw = [nib objectAtIndex:0];
                [vw SetTexts:@[ info.param.widgetHowDoesSolarWorkStepOneText , info.param.widgetHowDoesSolarWorkStepTwoText, info.param.widgetHowDoesSolarWorkStepThreeText, info.param.widgetHowDoesSolarWorkStepFourText]];
                [vw setFrame:CGRectMake(0, -12, col * 42.f, row * 42.0f)];
                [vw setInfo];
    //            [vw StartAnimation];
                [tempView addSubview:vw];
            
        }
        else if ( [name isEqualToString:@"iFrame"]){

            iFrameView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"iFrameView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
                [view resizeAllSubview:view.frame url: info.param.widgetIFrameUrl];
            [view setRefresh];
                [tempView addSubview: view];
        }
        else if ( [name isEqualToString:@"Image"]){
                
                
            WidgetImageView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WidgetImageView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
            [view resizeAllSubview:view.frame];
               
                [tempView addSubview: view];
                
        }
        else if ( [name isEqualToString:@"Solar Generation"] ){
            
            SolarView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SolarView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                    [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
                    [view setRefresh:info->solar];
                    
                    if ( [info.param.widgetSolarGenerationOrientation isEqualToString:@"Vertical"] ) {
                [view resizeAllSubview:view.frame origentation:false];
            }
            else{
                [view resizeAllSubview:view.frame origentation:true];
            }
            
                    [tempView addSubview: view];
        }
        else if ( [name isEqualToString:@"TextArea"]){
                
            TextAreaView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TextAreaView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * 42.f, row * 42.0f)];
                
                [view setText: info.param.widgetTextareaContent];
                
            [view setInfo];
                [tempView addSubview: view];
        }
    
        [arrWidgetInfo addObject: tempView];
    }
}

- (void) onDrawTimeline:(float) delta // delta = m_cur_time
{
    
    for ( UIView * subView in [_m_vTimeline subviews] ) {
        [subView removeFromSuperview];
    }
    
    [arrTimelineWidgetViews removeAllObjects];
    [arrTimelineWidgetInfos removeAllObjects];

    
    float stepY  = _m_vTimeline.frame.size.height / (m_max_line + 3);
    float oriY   = stepY + 20.0f;
    
    // draw row line
    for ( int j = 0; j < m_max_line+2; j++ ) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake( 0, oriY + stepY * j, _m_vTimeline.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:196.0/255.0 alpha:1.0f];
        [_m_vTimeline addSubview:lineView];
    }
    
    float stepX  = TIMELINE_CELL_STEP;
    float oriX   = _m_vTimeline.frame.size.width/2.0f;
    oriY -= 5.0f;
    //draw col line and labels    
    int nRowNum  = m_max_present_duration / 10 + 1;
    
    if( nRowNum < 10 )
        nRowNum = 10;
    
    for ( int j = 0; j < nRowNum + 50; j++ ) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake( oriX + stepX * j - delta, oriY, 1, stepY * (m_max_line + 1) + 5.0f )];
        lineView.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:196.0/255.0 alpha:1.0f];
        
        if ( lineView.frame.origin.x >= 0 ) {
            [_m_vTimeline addSubview:lineView];
        }
        
        UILabel * ltime = [[UILabel alloc] initWithFrame:CGRectMake( oriX + stepX * j - delta, 25.0f, 50, 20 ) ];
        
        if ( j == 0) {
            [ltime setText:@"00:00"];
            [ltime setFont:[UIFont fontWithName:@"Arial" size:14]];
            [ltime setTextColor: [UIColor blackColor]];
        }
        else
        {
            int min = 10*j / 60;
            int sec = 10*j % 60;
            NSString * sMin;
            if( min == 0 )
                sMin = [NSString stringWithFormat:@"00"];
            else if( min > 0 && min < 10 )
                sMin = [NSString stringWithFormat:@"0%d", min];
            else
                sMin = [NSString stringWithFormat:@"%d", min];
            
            NSString * sSec;
            if ( sec == 0 ) {
                sSec = @"00";
            }else
                sSec = [NSString stringWithFormat:@"%d", sec];

            
            [ltime setText:[NSString stringWithFormat:@"%@:%@", sMin, sSec]];
            [ltime setFont:[UIFont fontWithName:@"Arial" size:12]];
            [ltime setTextColor: [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:196.0/255.0 alpha:1.0f]];
        }
        
        [ltime setTextAlignment:NSTextAlignmentCenter];
        [ltime setCenter:CGPointMake( oriX + stepX * j - delta, 25.0f)];
        
        if ( ltime.frame.origin.x + ltime.frame.size.width >= 0) {
            [_m_vTimeline addSubview:ltime];
        }
        
    }
    
    // Draw Widgets
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    //    stepY -= 10;
    oriY += 6.0f;
    for ( PWidgetInfo * widget in info.m_widgets ) {
        int duration = [widget.param.duration intValue];
        
        NSString *str = widget.param.startDate;
        NSString * min;
        NSString * sec;
        if ( [str isEqualToString:@""] ) {
            min = @"0"; sec = @"0";
        }
        else{
            NSArray * arr  = [str componentsSeparatedByString:@":"];
            min  = arr[0];  sec  = arr[1];
        }
        
        int startPos = min.intValue * 60 + sec.intValue;
//        int rowPos   = [widget.timeline.timelineRowPosition intValue];
        int rowPos   = [widget.param.timelineRowPosition intValue];
        
        
        UIColor * color  = [widget.param colorFromHexString: widget.timeline.backgroundColor];
//        NSString * icon = widget.timeline.icon;
//        NSString * icon = widget.param.icon;
//        NSLog( @"%@", icon);
        UIView * v_Widget = [[UIView alloc] initWithFrame:CGRectMake(oriX + (stepX * startPos)/10.0f - delta, oriY + stepY * rowPos-1, (stepX * duration)/10.0f, stepY-2)];
        [v_Widget setBackgroundColor:color];
        
        UIImageView * imgView  = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, stepY-3, stepY-3)];
        NSString * name = widget.name;
        UIImage * image  = [self GetImage: name];
        imgView.image   = image;
        [imgView setBackgroundColor:[UIColor whiteColor]];
        [v_Widget addSubview: imgView];
        
        if ( v_Widget.frame.origin.x + v_Widget.frame.size.width > 0) {
            [_m_vTimeline addSubview: v_Widget];
        }
        
        [arrTimelineWidgetViews addObject: v_Widget];
        [arrTimelineWidgetInfos addObject: widget];
    }
    
    // Draw blue line (mark)
    UIImageView * markView = [[UIImageView alloc] initWithFrame:CGRectMake( oriX - 2.5f, oriY-5, 5, 8)];
    [markView setImage:[UIImage imageNamed:@"linetop.png"]];
    [_m_vTimeline addSubview:markView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake( oriX, oriY, 1, _m_vTimeline.frame.size.height - oriY)];
    lineView.backgroundColor = [UIColor colorWithRed:51.f/255.f green:152.f/255.f blue:216.f/255.f alpha:1.0f];
    [_m_vTimeline addSubview:lineView];
    
    UIImageView * tempView  = [[UIImageView alloc] initWithFrame:CGRectMake( -TIMELINE_CELL_STEP, 0, TIMELINE_CELL_STEP, _m_vTimeline.frame.size.height)];
    [tempView setBackgroundColor:[UIColor whiteColor]];
    [_m_vTimeline addSubview: tempView];
    
}

- (UIImage *) GetImage:(NSString*) name
{
    
    UIImage * image;
    if ( [name isEqualToString:@"Graph"] ){
        image  = [UIImage imageNamed:@"graph.png"];
    }
    else if( [name isEqualToString:@"Energy Equivalencies"]){
        image = [UIImage imageNamed:@"energy.png"];
    }
    else if ( [name isEqualToString:@"How Does Solar Work"]){
        image = [UIImage imageNamed:@"kwh.png"];
    }
    else if ( [name isEqualToString:@"iFrame"]){
        image = [UIImage imageNamed:@"iframe.png"];
    }
    else if ( [name isEqualToString:@"Image"]){
        image = [UIImage imageNamed:@"draw_image.png"];
    }
    else if ( [name isEqualToString:@"Solar Generation"]){
        image = [UIImage imageNamed:@"solar.png"];
    }
    else if ( [name isEqualToString:@"TextArea"]){
        image = [UIImage imageNamed:@"textarea.png"];
    }
    else if ( [name isEqualToString:@"Weather"]){
        image = [UIImage imageNamed:@"weather.png"];
    }

    return  image;
}

- (int) GetType:(NSString*) name
{
    
    int ret  = 0;
    
    if ( [name isEqualToString:@"Weather"] ) {
        ret = WEATHER;
    }
    else if ( [name isEqualToString:@"Image"]) {
        ret = IMAGE;
    }
    else if ( [name isEqualToString:@"Graph"]) {
        ret = GRAPH;
    }
    else if ( [name isEqualToString:@"TextArea"]) {
        ret = TEXTAREA;
    }
    else if ( [name isEqualToString:@"Energy Equivalencies"]) {
        ret = ENERGY;
    }
    else if ( [name isEqualToString:@"How Does Solar Work"]){
        ret = HOW;
    }
    else if ( [name isEqualToString:@"Solar Generation"]) {
        ret = SOLAR;
    }
    else if ( [name isEqualToString:@"iFrame"]) {
        ret = iFRAME;
    }
    
    return  ret;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;    
    info.name = textField.text;
    
    [info getPresentationDic];
    
    [[NSNotificationCenter defaultCenter]         postNotificationName:@"ShowProgress"         object:self];
    [[SharedMembers sharedInstance].webManager EditPresentation:info._id param:info->msgDic success:^(MKNetworkOperation *networkOperation) {
        [[NSNotificationCenter defaultCenter]         postNotificationName:@"HideProgress"         object:self];
    [[NSNotificationCenter defaultCenter]         postNotificationName:@"ConfrimEditor"  object:self];
    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
        [[NSNotificationCenter defaultCenter]         postNotificationName:@"HideProgress"         object:self];
    }];

    [textField resignFirstResponder];
    
    return true;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;    
    textField.text = info.name;
}

- (void) setPresentDuration
{
    float max  = 0;
    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
    for (int i = 0; i < [info.m_widgets count]; i++ ) {
        PWidgetInfo * widget  = [info.m_widgets objectAtIndex:i];
        
        NSString * startPoint = widget.param.startDate;
        NSArray * arr  = [startPoint componentsSeparatedByString:@":"];
        NSString * min;         NSString * sec;
        
        if ( [startPoint isEqualToString:@""] ) {
            min = @"0"; sec = @"0";
        }
        else{
            min = arr[0];
            sec = arr[1];
        }
        int dur  = min.intValue*60 + sec.intValue + [widget.param.duration intValue];
        if (max < dur ) {
            info.duration = [NSNumber numberWithInt: dur];
            max = dur;
        }
    }
    
    [[NSNotificationCenter defaultCenter]         postNotificationName:@"ConfrimEditor"  object:self];
}

- (void) setDuration:(int) duration
{
    _m_l_duration.text = [NSString stringWithFormat:@"(total presentation time: %d secs)", duration ];
}


@end
