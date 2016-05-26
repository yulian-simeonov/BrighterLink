//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PresentFullScreenView.h"

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

#define CELL_SIZE   58.125
#define TIMELINE_CELL_STEP     80.95238095238095

#define TEST_MODE  true

@interface PresentFullScreenView()

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

@implementation PresentFullScreenView

- (void) awakeFromNib
{
    _m_vCanvas.backgroundColor = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:240.f/255.f alpha:1.0f];
    
    m_max_line = 2; //default
    [self  onDrawCanvas: 0.0f];
    
    arrViews = [[NSMutableArray alloc] init];
    arrIndex = [[NSMutableArray alloc] init];
    arrInfo  = [[NSMutableArray alloc] init];
    
    arrTimelineWidgetViews = [[NSMutableArray alloc] init];
    arrTimelineWidgetInfos = [[NSMutableArray alloc] init];
    
    arrWidgetInfo = [[NSMutableArray alloc] init];
    m_cur_time = 0;
    
    m_nSelectWidgetInTimeline = 0;
    m_bPlay = false;
    
}

- (void) setInitialInfo
{
  
}

// Play Present
- (void) onPlayPresent
{
    m_bPlay = true;
    [self initDrawPlayWidgets];
}

- (void) onStopPresent
{
    m_bPlay = false;
    [timer invalidate]; timer = nil;

    [self onInitDrawCanvas];
    [self onDrawCanvas: m_cur_time];
}

- (void) Play
{
    if(m_cur_time > m_max_present_duration )
    {
        m_cur_time = 0;
    }
    m_cur_time += 0.2f;
    [self onDrawCanvas: m_cur_time];
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
    UIView * view  = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CELL_SIZE * widthNum, CELL_SIZE * heightNum)];
    [view setBackgroundColor:[self colorFromHexString1: clr]];
    view.layer.cornerRadius = 10.0f;
    view.tag = [arrViews count];
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

- (void) setPresentationInfo:(BOOL) flag
{

    if( flag ){
        
        [_m_vContain setHidden:false];
        [_m_vWebContain setHidden:true];
        
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
        [self onInitDrawCanvas];
        [self onDrawCanvas: m_cur_time];

        [self GetPreviewDatas];
        
        [self   onPlayPresent];
    }
    else{
        [self showWebView];
    }
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
            }
        }
        else{
            UIView * v = [arrViews objectAtIndex: i];
            [v setHidden: true];
        }
    }
}

- (void) showWebView
{
    [JSWaiter ShowWaiter:self title:@"" type:0];
    [_m_vContain setHidden:true];
    [_m_vWebContain setHidden:false];
    NSString * link  = [SharedMembers sharedInstance].curPresent._id;
    NSString * presentLink = [ NSString stringWithFormat:@"%@/presentation?id=%@", @"https://blmobile.brightergy.com", link];
    
    NSURL *url = [NSURL URLWithString:presentLink];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_m_vWeb loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [JSWaiter HideWaiter];
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

        UIView * tempView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
        [tempView setBackgroundColor:[UIColor clearColor]];
        
        NSString * name = info.name;
        
        if ( [name isEqualToString:@"Graph"] ) {
            GraphView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"GraphView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                 [view setFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
                 [view  setInfo: info->graph Widget:info generation:[info.param.widgetGraphGeneration boolValue] maxPower:[info.param.widgetGraphMaxPower boolValue]];
                 [tempView addSubview:view];
        }
        else if ( [name isEqualToString:@"Weather"]){
                
            WeatherView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
                [view setRefresh:info->weather Col:col Row:row];
            [view resizeAllSubview:view.frame];
                [tempView addSubview: view];
                    
        }
        else if ( [name isEqualToString:@"Energy Equivalencies"]){
                
            EnergyView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EnergyView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
                [view setRefresh: info->energy];
            [view resizeAllSubview:view.frame];
                [tempView addSubview: view];
                    
        }
        else if ( [name isEqualToString:@"How Does Solar Work"]){
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"HowPreview" owner:self options:nil];
                HowPreview* vw = [nib objectAtIndex:0];
                [vw SetTexts:@[ info.param.widgetHowDoesSolarWorkStepOneText , info.param.widgetHowDoesSolarWorkStepTwoText, info.param.widgetHowDoesSolarWorkStepThreeText, info.param.widgetHowDoesSolarWorkStepFourText]];
                [vw setFrame:CGRectMake(0, -12, col * CELL_SIZE, row * CELL_SIZE)];
                [vw setInfo];
    //            [vw StartAnimation];
                [tempView addSubview:vw];
            
        }
        else if ( [name isEqualToString:@"iFrame"]){

            iFrameView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"iFrameView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
                [view resizeAllSubview:view.frame url: info.param.widgetIFrameUrl];
            [view setRefresh];
                [tempView addSubview: view];
        }
        else if ( [name isEqualToString:@"Image"]){
                
                
            WidgetImageView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"WidgetImageView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                [view setFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
            [view resizeAllSubview:view.frame];
               
                [tempView addSubview: view];
                
        }
        else if ( [name isEqualToString:@"Solar Generation"] ){
            
            SolarView * view;
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SolarView" owner:self options:nil];
            view = [nib objectAtIndex:0];
                    [view setFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
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
                [view setFrame:CGRectMake(0, 0, col * CELL_SIZE, row * CELL_SIZE)];
                
                [view setText: info.param.widgetTextareaContent];
                
            [view setInfo];
                [tempView addSubview: view];
        }
    
        [arrWidgetInfo addObject: tempView];
    }
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    CGPoint pt = [touch locationInView: self];
    if ( !CGRectContainsPoint( _m_vContain.frame, pt) ) {
        [timer invalidate]; timer = nil;
        [self removeFromSuperview];
    }
    
}


@end
