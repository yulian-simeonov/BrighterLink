//
//  UICollectionViewWaterfallLayout.h
//  BrighterLink
//
//  Created by mobile on 11/26/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewWaterfallLayout;

@protocol UICollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface UICollectionViewWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<UICollectionViewDelegateWaterfallLayout> delegate;

@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to layout content in a section
@property (nonatomic, retain) NSMutableArray *aryWidthsForColumns;

@end
