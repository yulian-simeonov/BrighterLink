//
//  ControlBar.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentInfo;

@protocol ControlBarDelegate <NSObject>

- (void) addNewWidget;
- (void) editLayout;

- (void) editCurrentDashboard;
- (void) deleteCurrentDashboard;

- (void) addNewSource;
- (void) editSource:(SegmentInfo *)segment;

@end

@interface ControlBar : UIView
{

}

@property (nonatomic, assign) id <ControlBarDelegate> delegate;

@property (nonatomic, assign) IBOutlet UILabel *lblTitle;

- (void) _update;

@end
