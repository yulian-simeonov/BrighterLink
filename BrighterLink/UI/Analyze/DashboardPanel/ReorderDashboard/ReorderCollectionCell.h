//
//  ReorderCollectionCell.h
//  BrighterLink
//
//  Created by apple developer on 1/27/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedMembers.h"

@interface ReorderCollectionCell : UIView
@property (nonatomic, strong) CollectionInfo* collectionInfo;
@property (nonatomic)   BOOL captured;
@property (nonatomic) CGPoint   orgPos;
@property (nonatomic) int idx;
@end
