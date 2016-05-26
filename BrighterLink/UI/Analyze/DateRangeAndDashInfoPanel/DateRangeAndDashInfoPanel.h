//
//  DateRangeAndDashInfoPanel.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateRangeAndDashInfoPanelDelegate <NSObject>

- (void) tappedDashboardInfo;
- (void) tappedRangeDate;

@end

@interface DateRangeAndDashInfoPanel : UIView
{

}

@property (nonatomic, assign) id <DateRangeAndDashInfoPanelDelegate> delegate;

- (void) _update;

@end