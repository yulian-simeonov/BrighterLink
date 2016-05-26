//
//  TablePageController.h
//  BrighterLink
//
//  Created by Andriy on 11/25/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TablePageControllerDelegate <NSObject>

- (void) previewPage;
- (void) nextPage;

@end

@interface TablePageController : UIView
{

}

@property (nonatomic, assign) id<TablePageControllerDelegate> delegate;

- (void) updatePageIndex:(int)pageIndex max:(int)pageCount;

@end
