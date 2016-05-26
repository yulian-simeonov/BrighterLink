//
//  LayoutOneTypeView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SharedMembers.h"

@protocol LayoutOneTypeViewDelegate <NSObject>

- (void) selectLayoutType:(NSInteger) type;

@end

@interface LayoutOneTypeView : UIView
{

}

@property (nonatomic, assign) id <LayoutOneTypeViewDelegate> delegate;

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger type;

- (void) setCanvasType:(NSInteger)type;

- (void) setSelected:(BOOL)selected;

@end
