//
//  UIImagePickerController.h
//  BrighterLink
//
//  Created by mobile master on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImagePickerController (NonRotating)
- (BOOL)shouldAutorotate;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
@end
