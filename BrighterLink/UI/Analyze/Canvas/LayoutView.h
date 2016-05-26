//
//  LayoutView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SharedMembers.h"

@protocol LayoutViewDelegate <NSObject>

- (void) changedLayoutType:(NSInteger) type;

@end

@interface LayoutView : UIView
{

}

@property (nonatomic, assign) id <LayoutViewDelegate> delegate;

@property (nonatomic, assign) NSInteger layoutType;

- (void) setLayoutType:(NSInteger)layoutType;

@end
