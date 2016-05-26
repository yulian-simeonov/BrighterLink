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
#import "LineCell.h"
#import "TagsPanelView.h"

@protocol PresentTabDelegate <NSObject>

- (void) onClickWidgetButtons:(int) idx Point:(CGPoint)pt;
- (void) onMoveWidget:(CGPoint) pt;
- (void) onDropWidget:(CGPoint) pt;
- (void) onCancelWidget;


- (void) createPresentation:(NSString*) name id:(NSString*)templateId;
- (void) GetPresentation:(NSString*) presentationId;
- (void) GetPresentationTimeline:(NSString*) presentationId;

- (void) GetAllPresentation;

- (void) setCurTime:(float) curTime;


@end

@interface PresentTabView : UIView<UITextFieldDelegate, TableDelegate>
{
    BOOL  bBlank;
    
    UIView * m_vTemp;
    BOOL     m_bCreated;
    
    BOOL     m_bTemplateChk;
    
    /// Tab Bar Button Image, Label
    IBOutletCollection(UIImageView) NSArray* imgs_nav;
    IBOutletCollection(UIImageView) NSArray* imgs_icons;
    IBOutletCollection(UIImageView) NSArray* imgs_bgs;
    IBOutletCollection(UIImageView) NSArray* imgs_separator;
    IBOutletCollection(UILabel) NSArray* lbls_btnName;
    
    
    
    // Select Template
    int  m_nSelectedTemplateIdx;
    
    
    NSMutableArray * m_arrPresentTemp;
    NSMutableArray * m_arrEditorTemp;
    
    int  m_nType;
    
    ///
    int  m_nTempletHeight;
    UIView * m_vTemplet;
    
     TagsPanelView* vw_tags;
}

@property (nonatomic, weak) id<PresentTabDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIImageView * img_Tab_bg;
@property (nonatomic, weak) IBOutlet UIImageView * img_Widgets_bg;


@property (nonatomic, weak) IBOutlet UIView  * m_vWidget;
@property (nonatomic, weak) IBOutlet UIView  * m_vPresentations;
@property (nonatomic, weak) IBOutlet UIView  * m_vEditors;
@property (nonatomic, weak) IBOutlet UIView  * m_vData;


//Presentations
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Presentations_bg;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_Presentations_search;
@property (nonatomic, weak) IBOutlet UITableView * m_table_Presentations;
//Editors
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Editor_bg;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_Editor_search;
@property (nonatomic, weak) IBOutlet UITableView * m_table_Editor;
//Data
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Data_bg;
@property (nonatomic, weak) IBOutlet UITextField * m_txt_Data_search;

// Create New Present
@property (nonatomic, weak) IBOutlet UIView  * m_vCreateNew;

@property (nonatomic, weak) IBOutlet UITextField * m_txtNewPresentName;

@property (nonatomic, weak) IBOutlet UILabel * m_lCaption;
@property (nonatomic, weak) IBOutlet UILabel * m_lDescription;
@property (nonatomic, weak) IBOutlet UIButton * m_btnBlank;
@property (nonatomic, weak) IBOutlet UIButton * m_btnTemple;

//tab
@property (nonatomic, weak) IBOutlet UIImageView *m_img_widget;
@property (nonatomic, weak) IBOutlet UIImageView *m_img_presentations;
@property (nonatomic, weak) IBOutlet UIImageView *m_img_editors;
@property (nonatomic, weak) IBOutlet UIImageView *m_img_data;

@property (nonatomic, weak) IBOutlet UILabel * m_lwidget;
@property (nonatomic, weak) IBOutlet UILabel * m_lpresentations;
@property (nonatomic, weak) IBOutlet UILabel * m_leditors;
@property (nonatomic, weak) IBOutlet UILabel * m_ldata;

@property (nonatomic, weak) IBOutlet UIButton * m_btn_widget;
@property (nonatomic, weak) IBOutlet UIButton * m_btn_presentations;
@property (nonatomic, weak) IBOutlet UIButton * m_btn_editors;
@property (nonatomic, weak) IBOutlet UIButton * m_btn_data;


@property (nonatomic, weak) IBOutlet UIImageView * m_img_Weather;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Graph;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Energy;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_How;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Frame;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Image;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_Solar;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_TextArea;


// create new Presentation
@property (nonatomic, weak) IBOutlet UILabel * m_lTemplateName;
@property (nonatomic, weak) IBOutlet UILabel * m_lTemplateDes;
@property (nonatomic, weak) IBOutlet UITextView * m_txtTemplateDes;

@property (nonatomic, weak) IBOutlet UIImageView * m_img_divider;
@property (nonatomic, weak) IBOutlet UIButton    * m_btn_CreatePresentation;
@property (nonatomic, weak) IBOutlet UIButton    * m_btn_Cancel;
@property (nonatomic, weak) IBOutlet UIButton    * m_btn_Check;

@property (nonatomic, weak) IBOutlet UIPickerView * m_pTemplate;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnTempleateText;   // Select BUTTON Template list
- (IBAction) onSelectTemplate:(id)sender;


// WEATHER MARK

@property (nonatomic, weak) IBOutlet UIImageView * m_imgQuestionMark;

@property (nonatomic, weak) IBOutlet UITextView  * m_txtClone;
@property (nonatomic, weak) IBOutlet UIImageView * m_imgClone;

@property (nonatomic, weak) IBOutlet UIImageView * m_img_weather_mark;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_graph_mark;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_energy_mark;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_how_mark;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_iframe_mark;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_image_mark;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_solar_mark;
@property (nonatomic, weak) IBOutlet UIImageView * m_img_textarea_mark;


@property (nonatomic, weak) IBOutlet UIImageView * m_img_new_bg;


@property (nonatomic, weak) IBOutlet UIImageView * m_img_Mask;
//Tab bar
- (IBAction) onWidgets:(id)sender;
- (IBAction) onPresentations:(id)sender;
- (IBAction) onEditors:(id)sender;
- (IBAction) onData:(id)sender;

// Widgets
- (IBAction) onWeather:(id)sender;
- (IBAction) onGraph:(id)sender;
- (IBAction) onEnergy:(id)sender;
- (IBAction) onHow:(id)sender;
- (IBAction) oniFrame:(id)sender;
- (IBAction) onImage:(id)sender;
- (IBAction) onSolar:(id)sender;
- (IBAction) onTextArea:(id)sender;

- (IBAction) onCreateNew:(id)sender;
- (IBAction) onBlank:(id)sender;
- (IBAction) onTemple:(id)sender;
- (IBAction) onCreatePresentation:(id)sender;
- (IBAction) onCancel:(id)sender;


- (void) setRefresh;
- (void) showMask:(BOOL) flag;
@end
