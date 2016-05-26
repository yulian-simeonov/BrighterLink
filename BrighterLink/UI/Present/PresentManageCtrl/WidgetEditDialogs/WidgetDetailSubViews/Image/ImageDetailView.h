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
#import "ChooseAssetView.h"



@interface ImageDetailView : UIView<ChooseAssetViewDelegate>
{
    @public
     UIViewController * parent;
}

@property (nonatomic, retain) ChooseAssetView *assetVC;
//Image Items
@property (nonatomic, weak) IBOutlet UITextField * m_txtImage_URL;
@property (nonatomic, weak) IBOutlet UIButton    * m_btnImage_Open;

- (IBAction) onImageOpen:(id)sender;

@end
