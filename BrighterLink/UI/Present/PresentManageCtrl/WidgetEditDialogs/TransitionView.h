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


@protocol TransitionDelegate <NSObject>

- (void) sendSelectTransition:(NSString*) effect;

@end



@interface TransitionView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIImageView* img_bg;
    
@public
    NSString * m_selected;
}

@property (nonatomic, weak) IBOutlet UITableView  * m_table;
@property (nonatomic, weak) id<TransitionDelegate> delegate;

- (void) setEffect:(NSString*) effect;
- (IBAction) onClose:(id)sender;

@end
