//
//  CISnapshotVC.h
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseAssetView.h"
#import "JSCombo.h"

@protocol CISnapshotVCDelegate;

@interface PresentationDetailView : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, JSComboDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    bool bTemplate;
    bool bTitle;
    bool bSystemSize;
    bool bLastUpdated;
    bool bGenerating;

    int  m_nSystemSize;
    int  m_nReimbursement;
    NSMutableArray * arrAdmin;
    
    JSCombo * m_ComboAccounts;
    
    
    int   m_nAssetType;
    NSString * m_selectAssetId;
}

@property (nonatomic, weak) id<CISnapshotVCDelegate> delegate;

@property (nonatomic, retain) ChooseAssetView *assetVC;

//@property (nonatomic, retain) UIImage *snapshotImage;

@property (nonatomic, weak) IBOutlet UIImageView * m_img_title_bg;
@property (nonatomic, weak) IBOutlet UITextField  * m_txt_Name;
@property (nonatomic, weak) IBOutlet UITextView   * m_txt_Description;
@property (nonatomic, weak) IBOutlet UITextField  * m_txt_Logo;
@property (nonatomic, weak) IBOutlet UITextField  * m_txt_SystemSize;
@property (nonatomic, weak) IBOutlet UITextField  * m_txt_Reimbursement;
@property (nonatomic, weak) IBOutlet UITextField  * m_txt_ChooseAdmin;

@property (nonatomic, weak) IBOutlet UIButton     * m_btn_template;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_title;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_systemSize;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_generatingSince;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_lastUpdated;

@property (nonatomic, weak) IBOutlet UIPickerView * m_picker;

@property (nonatomic, weak) IBOutlet UIButton     * m_btn_save;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_cancel;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_choose_general;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_choose_client;
@property (nonatomic, weak) IBOutlet UIButton     * m_btn_choose_presentation;


@property (nonatomic, weak) IBOutlet UIImageView  * m_img_choose_account_bg;
@property (nonatomic, weak) IBOutlet UILabel      * m_l_general_assets;
@property (nonatomic, weak) IBOutlet UILabel      * m_l_client_assets;
@property (nonatomic, weak) IBOutlet UILabel      * m_l_presentation_assets;

-(IBAction) onLogo:(id)sender;
-(IBAction) onTemplete:(id)sender;
-(IBAction) onTitle:(id)sender;
-(IBAction) onSystemSize:(id)sender;
-(IBAction) onGeneratingSince:(id)sender;
-(IBAction) onLastUpdated:(id)sender;

-(IBAction) onChooseGeneralFile:(id)sender;
-(IBAction) onChooseClientFile:(id)sender;
-(IBAction) onChoosePresentationFile:(id)sender;

-(IBAction) onChooseAdmin:(id)sender;


- (IBAction) onUpSystemSize:(id)sender;
- (IBAction) onDownSystemSize:(id)sender;
- (IBAction) onUpReimbursement:(id)sender;
- (IBAction) onDownReimbursement:(id)sender;

- (IBAction) onSave:(id)sender;

- (void) setInfo;

@end

@protocol CISnapshotVCDelegate <NSObject>
- (void)CISnapshotVCDidCloseButtonPressed:(PresentationDetailView *)popupVC;

@end