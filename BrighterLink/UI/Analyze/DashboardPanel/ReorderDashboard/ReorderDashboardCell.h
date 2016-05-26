//
//  ReorderDashboardCell.h
//  BrighterLink
//
//  Created by apple developer on 1/26/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedMembers.h"

@interface ReorderDashboardCell : UILabel
@property (nonatomic, strong) DashboardInfo* dashboard;
@property (nonatomic)   BOOL captured;
@property (nonatomic) CGPoint   orgPos;
@property (nonatomic) int idx;
@end
