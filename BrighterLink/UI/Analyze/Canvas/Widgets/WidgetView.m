//
//  WidgetView.m
//  BrighterLink
//
//  Created by mobile on 11/26/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "WidgetView.h"

#import "AnalyzeViewController.h"

#import "SharedMembers.h"

@interface WidgetView()
{
    CAShapeLayer *_border;
    
    UILabel *_labelUnkownMessage;
    
    BOOL _isCreated;
}

@property (nonatomic, assign) float originHeight;

@end

@implementation WidgetView

- (void) awakeFromNib
{
    [self _init];
}

- (id) init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}

- (void) GetWidgetDatas
{
    if(self.WgInfo == nil)
    {
        [self setUnknowType];
        
        return;
    }
    
    NSString *widgetId = [self.WgInfo objectForKey:@"_id"];
    
    if(widgetId == nil || ![widgetId isKindOfClass:[NSString class]])
    {
        [self setUnknowType];
        
        return;
    }
    
    [self showTitle];
    
    NSDictionary *widgetGraphicData = [[SharedMembers sharedInstance] getWidgetGraphicData:widgetId];
    
    if(widgetGraphicData != nil)
    {
        if([self.WgComparisionData isEqual:widgetGraphicData])
            return;
        
        self.WgComparisionData = widgetGraphicData;
        
        [self hidePlaceHolderState];
        
        [self UpdateWidget];
    }
    else
    {
        if(![self isWaitingAnimation])
        {
            [self setPlaceHolderState];
            
            [self reqWidgetDatas];
        }
    }
}

-(void)UpdateWidget
{

}

- (void) showTitle
{
    NSLog(@"%@", self.WgInfo);
    
    NSString *type = [self getWidgetType];
    
    if([type isEqualToString:@"Equivalencies"])
    {
        self.lblTitle.textColor = [UIColor colorWithRed:0.0f / 255.0f green:133.0f / 255.0f blue:112.0f / 255.0f alpha:1.0f];
    }
    else
    {
        self.lblTitle.textColor = [UIColor blackColor];
    }
    
    BOOL titleShow = [[self.WgInfo objectForKey:@"titleShow"] boolValue];
    
    self.lblTitle.hidden = !titleShow;
    self.lblTitle.text = [self.WgInfo objectForKey:@"title"];
}

- (NSString *) getWidgetType
{
    if(self.WgInfo == nil) return nil;
    
    NSString *type = [self.WgInfo objectForKey:@"type"];
    
    if(type == nil || ![type isKindOfClass:[NSString class]]) return nil;
    
    return type;
}

- (void) _init
{
    if(_isCreated) return;
    
    _isCreated = YES;
    
    self.isMinimized = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, WIDGET_TITLEBAR_HEIGHT)];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    self.lblTitle = label;
    label = nil;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [self addSubview:activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;
    activityIndicatorView = nil;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDGET_TITLEBAR_HEIGHT, WIDGET_TITLEBAR_HEIGHT)];
    [button addTarget:self action:@selector(onCompress) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"analyze_icon_compress@2x"] forState:UIControlStateNormal];
    button.center = CGPointMake(self.frame.size.width - WIDGET_TITLEBAR_HEIGHT * 0.5, WIDGET_TITLEBAR_HEIGHT * 0.5);
    
    [self addSubview:button];
    self.btnCompress = button;
    button = nil;
    
    self.btnCompress.hidden = YES;
}

- (void) setPlaceHolderState
{
    _border = [CAShapeLayer layer];
    _border.strokeColor = [UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1].CGColor;
    _border.fillColor = nil;
    _border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:_border];
}

- (void) hidePlaceHolderState
{
    if(_border)
    {
        [_border removeFromSuperlayer];
    }
}

- (void) setUnknowType
{
    self.isUnknownState = YES;
    
    [self setPlaceHolderState];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Unknown Type Widget";
    
    [self addSubview:label];
    _labelUnkownMessage = label;
    label = nil;
}

- (void) layoutSubviews
{    
    if(self.lblTitle)
    {
        self.lblTitle.frame = CGRectMake(0, 0, self.frame.size.width, WIDGET_TITLEBAR_HEIGHT);
    }
    
    if(self.activityIndicatorView)
    {
        self.activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    }
    
    if(self.btnCompress)
    {
        self.btnCompress.center = CGPointMake(self.frame.size.width - WIDGET_TITLEBAR_HEIGHT * 0.5, WIDGET_TITLEBAR_HEIGHT * 0.5);
    }
    
    if(_border)
    {
        _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        _border.frame = self.bounds;
    }
    
    if(_labelUnkownMessage)
    {
        _labelUnkownMessage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

- (void) minimize:(void (^)())completion
{
    if(self.isMinimized)
        return;
    
    self.clipsToBounds = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.originHeight = CGRectGetHeight(self.frame);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, WIDGET_TITLEBAR_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        self.isMinimized = YES;
        
        completion();
        
    }];
}

- (void) maximize:(void (^)())completion
{
    if(!self.isMinimized)
        return;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.originHeight);
        
    } completion:^(BOOL finished) {
        
        self.isMinimized = NO;
        
        completion();
        
    }];
}

- (void) hideTooltipView
{
    
}

- (void) showCompressButton:(AnalyzeViewController *)analyzeController
{
    self.analyzeController = analyzeController;
    
    self.btnCompress.hidden = NO;
}

- (void) hideCompressButton
{
    self.btnCompress.hidden = YES;
}

- (void) onCompress
{
    [self.analyzeController compressFullWidgetView];
}

- (BOOL) isWaitingAnimation
{
    if(self.activityIndicatorView == nil) return NO;
    
    return self.activityIndicatorView.isAnimating;
}

- (void) startWaitingAnimation
{
    if(self.activityIndicatorView == nil)
    {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
        [self addSubview:activityIndicatorView];
        self.activityIndicatorView = activityIndicatorView;
        activityIndicatorView = nil;
    }
    
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    
    [self bringSubviewToFront:self.activityIndicatorView];
}

- (void) stopWaitingAnimation
{
    if(self.activityIndicatorView != nil)
    {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
    }
}

#pragma mark Req Widget Data
- (void) reqWidgetDatas
{
    [self startWaitingAnimation];
    
    NSString *dashboardId = [SharedMembers sharedInstance].currentDashboard._id;
    NSString *widgetId = [self.WgInfo objectForKey:@"_id"];
    
    [SharedMembers sharedInstance].webManager.ProcessError = NO;
    [[SharedMembers sharedInstance].webManager GetDashboardWidgetDatas:dashboardId widgetId:widgetId success:^(MKNetworkOperation *operation)
     {
         BOOL success = [[operation.responseJSON objectForKey:@"success"] boolValue];
         
         if(success)
         {
             NSDictionary *widgetData = [operation.responseJSON objectForKey:@"message"];
             
             NSLog(@"%@", widgetData);
             
             NSString *widgetId = [widgetData.allKeys firstObject];
             NSDictionary *widgetDrawingData = [widgetData.allValues firstObject];
             
             [[SharedMembers sharedInstance] addWidgetGraphicData:widgetId data:widgetDrawingData];
             
             self.WgComparisionData = widgetDrawingData;

             [self hidePlaceHolderState];
             
             [self UpdateWidget];
         }
         
         [self stopWaitingAnimation];
         
         
     } failure:^(MKNetworkOperation *operation, NSError *error)
     {
         [self stopWaitingAnimation];
     }];
}

@end
