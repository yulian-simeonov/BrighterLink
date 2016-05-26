//
//  MoreAssetsView.h
//  BrighterLink
//
//  Created by mobile on 11/23/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsView.h"

@interface MoreAssetsView : UIView
{
    IBOutlet UIView* vw_content;
    IBOutlet UIScrollView* vw_assets;
    IBOutlet UITextField* txt_search;
    IBOutlet UIButton* btn_back;
    IBOutlet UIImageView* img_header;
    IBOutlet UILabel* lbl_title;
    NSMutableArray* m_assets;
    NSMutableArray* m_filteredAssets;
    float m_lastPositions[3];
    int m_assetType;
    NSString* m_selectedAccountId;
}
@property (nonatomic, strong) AssetsView* delegate;
+(MoreAssetsView*)ShowView;
-(void)Update:(NSMutableArray*)array assetType:(AssetsType)assetType accountId:(NSString*)accountId;
@end
