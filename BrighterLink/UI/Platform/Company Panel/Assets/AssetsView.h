//
//  AssetsView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSCombo.h"

typedef enum : NSUInteger {
    GeneralAssets,
    AccountAssets
} AssetsType;

@interface AssetsView : UIView<JSComboDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIButton* btn_generalAssets;
    IBOutlet UIButton* btn_accountAssets;
    IBOutlet UIButton* btn_upload;
    IBOutlet UILabel* lbl_message;
    IBOutlet UIView* vw_search;
    IBOutlet UIScrollView* vw_assets;
    IBOutlet UIView* vw_bottom;
    IBOutlet UIButton* btn_moreAssets;
    IBOutlet UILabel* lbl_account;
    IBOutlet UITextField* txt_account;
    IBOutlet UIButton* btn_account;
    IBOutlet UIView* vw_content;
    IBOutlet UIImageView* img_searchBar;
    JSCombo* cmb_account;
    AssetsType m_assetType;
    NSMutableArray* m_assets;
    NSMutableArray* m_filteredAssets;
    float m_lastPositions[4];
    NSString* m_selectedAccountId;
}
+(AssetsView*)ShowView:(UIView*)parentView;
-(void)RefreshContentView;
@end
