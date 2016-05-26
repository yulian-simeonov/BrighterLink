//
//  AddSourceAndGroupView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentInfo;

@protocol AddSourceAndGroupViewDelegate <NSObject>

- (void) addNewSegment:(SegmentInfo *)segment;
- (void) updateSegment:(SegmentInfo *)segment;
- (void) deleteSegment:(SegmentInfo *)segment;

@end

@interface AddSourceAndGroupView : UIView
{

}

@property (nonatomic, assign) id <AddSourceAndGroupViewDelegate> delegate;

@property (nonatomic, retain) SegmentInfo *segment;

@end
