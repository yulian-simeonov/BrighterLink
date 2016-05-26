//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "ImageDetailView.h"
#import "UIViewController+CWPopup.h"
#import "SharedMembers.h"

@interface ImageDetailView()

@end

@implementation ImageDetailView

- (void) awakeFromNib
{
    _assetVC = [[ChooseAssetView alloc] initWithNibName:@"ChooseAssetView" bundle:nil];
    [_assetVC setDelegate:self];
}

//IMage
- (IBAction) onImageOpen:(id)sender
{
//    _assetVC.m_selectedAccountId = [SharedMembers sharedInstance].selectedAccountId;
    [_assetVC refresh:1];
    [parent presentPopupViewController:_assetVC type:false animated:YES completion:^(void) {
    }];
}

- (void)ChooseAssetViewDidCloseButtonPressed:(ChooseAssetView *)popupVC
{
    if (parent.popupViewController != nil) {
        [parent dismissPopupViewControllerAnimated:YES completion:^{
            
            PWidgetInfo * info = [SharedMembers sharedInstance].curWidget;
            [_m_txtImage_URL setText:info.param.widgetURL];
        }];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    PWidgetInfo * widget  = [SharedMembers sharedInstance].curWidget;

    widget.param.widgetURL = textView.text;
}


@end
