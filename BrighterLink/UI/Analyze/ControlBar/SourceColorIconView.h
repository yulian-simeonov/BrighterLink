//
//  SourceColorIconView.h
//  BrighterLink
//
//  Created by Andriy on 11/19/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceColorIconView : UIView

@property (nonatomic, assign) int bannerWidth;

@property (nonatomic, retain) UIColor *bannerColor;
@property (nonatomic, retain) UIColor *symbolColor;

- (id) initWithSymbolColor:(UIColor *)color banner:(UIColor *)bannerColor width:(int)bannerWidth;

@end
