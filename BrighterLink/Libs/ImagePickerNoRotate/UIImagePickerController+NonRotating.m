//
//  UIImagePickerController.m
//  BrighterLink
//
//  Created by mobile master on 11/13/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "UIImagePickerController+NonRotating.h"

@implementation UIImagePickerController (NonRotating)

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
@end
