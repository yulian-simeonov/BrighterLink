//
//  TablePageController.m
//  BrighterLink
//
//  Created by Andriy on 11/25/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TablePageController.h"

@interface TablePageController()
{
    int _pageIndex;
    
    int _pageCount;
}

@property (nonatomic, assign) IBOutlet UILabel *lblPageNumber;

@property (nonatomic, assign) IBOutlet UIButton *btnPreview;
@property (nonatomic, assign) IBOutlet UIButton *btnNext;

@end

@implementation TablePageController

- (void) awakeFromNib
{
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [UIColor colorWithRed:221.0f / 255.0f green:221.0f / 255.0f blue:221.0f / 255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 1.0f;
}

- (IBAction)onPreview:(id)sender
{
    [self.delegate previewPage];
}

- (IBAction)onNext:(id)sender
{
    [self.delegate nextPage];
}

- (void) updatePageIndex:(int)pageIndex max:(int)pageCount
{
    _pageIndex = pageIndex;
    _pageCount = pageCount;
    
    [self updateUI];
}

- (void) updateUI
{
    self.lblPageNumber.text = [NSString stringWithFormat:@"%d", _pageIndex + 1];
    
    self.btnPreview.userInteractionEnabled = YES;
    self.btnPreview.alpha = 1.0f;
    
    self.btnNext.userInteractionEnabled = YES;
    self.btnNext.alpha = 1.0f;
    
    if(_pageIndex == 0)
    {
        self.btnPreview.userInteractionEnabled = NO;
        self.btnPreview.alpha = 0.6f;
    }
    
    if(_pageIndex >= _pageCount - 1)
    {
        self.btnNext.userInteractionEnabled = NO;
        self.btnNext.alpha = 0.6f;
    }
}

@end
