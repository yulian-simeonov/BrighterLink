//
//  WidgetCollectionViewCell.h
//  BrighterLink
//
//  Created by Andriy on 11/30/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WidgetView;

@interface WidgetCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) WidgetView *widgetView;

@property (nonatomic, assign) IBOutlet UIView *containerView;

@end
