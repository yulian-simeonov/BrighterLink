//
//  EquivalenceSegmentView.h
//  BrighterLink
//
//  Created by Andriy on 1/6/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EQUIVALENCE_SEG_HEIGHT 100

@interface EquivalenceSegmentView : UIView

- (void) setEquivalenceSegmentData:(NSDictionary *)data type:(NSString *)type co:(BOOL)showCO green:(BOOL)showGreen index:(int)index;

@end
