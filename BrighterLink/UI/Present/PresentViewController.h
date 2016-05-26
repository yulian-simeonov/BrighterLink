//
//  PresentViewController.h
//  BrighterLink
//
//  Created by mobile master on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentationDetailView.h"
#import "PresentFullScreenView.h"
#import "SharePresentView.h"
#import "PresentTabView.h"
#import "WidgetDetailView.h"
#import "WidgetStartInfo.h"
#import "JSCombo.h"

@interface PresentViewController : UIViewController<JSComboDelegate>
{
    BOOL  bPalyPresentation;
    BOOL  bCreative;
    
    JSCombo * m_ComboFullScreenMode;
    
    UIView * m_vTemp;
    
    NSString * lastPresentId;
    
    float m_nCurTime;

@public
    int   m_nSelectedWidget;
}

@property (nonatomic, retain) IBOutlet UILabel * m_PresentationName;


@property (nonatomic, retain) PresentationDetailView *presentationDetailVC;
@property (nonatomic, retain) SharePresentView * shareVC;
@property (nonatomic, retain) WidgetDetailView * widgetDetailView;

@property (nonatomic, retain) PresentFullScreenView *presentationFullVC;


@property (nonatomic, retain) IBOutlet UIButton * m_btnPlay;
@property (nonatomic, retain) IBOutlet UIImageView * m_img_play;
@property (nonatomic, retain) IBOutlet UIButton * m_btnFullScreen;

//Manage Ctrl
- (IBAction) onPresentDetail:(id)sender;
- (IBAction) onClonePresent:(id)sender;
- (IBAction) onSharePresent:(id)sender;

// Play Present
- (IBAction) onPlayPresentation:(id)sender;
- (IBAction) onShowFullMode:(id)sender;

- (IBAction) onPlayFullScreen:(id)sender;

- (void) GetPresentation:(NSString*) presentationId time:(float) curTime;
- (void) createWidgetInfo:(WidgetStartInfo*) startInfo;

@end
