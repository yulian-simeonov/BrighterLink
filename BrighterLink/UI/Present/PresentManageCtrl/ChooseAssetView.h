//
//  CISnapshotVC.h
//  CarIQ
//
//  Created by Ping Ahn on 9/26/14.
//  Copyright (c) 2014 Ping Ahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseAssetViewDelegate;


typedef enum : NSUInteger {
    PresentationAssets,
    PAccountAssets,
    PGeneralAssets,
} PAssetsType;



@interface ChooseAssetView : UIViewController
{
    NSMutableArray * arrGeneralAssets;
    NSMutableArray * arrAccountsAssets;
    NSMutableArray * arrPresentationAssets;
    
    int m_nSelectIdx;
    
    int m_nType; // 0: PresentationDetail  1: widgetDetail
    
    int nResponse ;
}

@property (nonatomic, weak) id<ChooseAssetViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIScrollView * m_scroll;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnPresent;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnClient;
@property (nonatomic, weak) IBOutlet UIButton     * m_btnGeneral;

@property (nonatomic, strong)     NSString* m_selectedAccountId;

- (IBAction) onPresent:(id)sender;
- (IBAction) onClient:(id)sender;
- (IBAction) onGeneral:(id)sender;

- (void) refresh:(int) type;
@end


@protocol ChooseAssetViewDelegate <NSObject>

- (void)ChooseAssetViewDidCloseButtonPressed:(ChooseAssetView *)popupVC;


@end