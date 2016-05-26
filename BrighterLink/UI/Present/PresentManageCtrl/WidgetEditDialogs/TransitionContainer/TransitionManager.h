//
//  TransitionContainerView.h
//  BrighterLink
//
//  Created by mobile on 12/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    T_Bounce,
    T_Flash,
    T_Pulse,
    T_RubberBand,
    T_Shake,
    T_Swing,
    T_Tada,
    T_Wobble,
    T_BounceIn,
    T_BounceInDown,
    T_BounceInUp,
    T_BounceInLeft,
    T_BounceInRight,
    T_BounceOut,
    T_BounceOutDown,
    T_BounceOutLeft,
    T_BounceOutRight,
    T_BounceOutUp,
    T_FadeIn,
    T_FadeInDown,
    T_FadeInDownBig,
    T_FadeInLeft,
    T_FadeInLeftBig,
    T_FadeInRight,
    T_FadeInRightBig,
    T_FadeInUp,
    T_FadeInUpBig,
    T_FadeOut,
    T_FadeOutDown,
    T_FadeOutDownBig,
    T_FadeOutLeft,
    T_FadeOutLeftBig,
    T_FadeOutRight,
    T_FadeOutRightBig,
    T_FadeOutUp,
    T_FadeOutUpBig,
    T_Flip,
    T_FlipInX,
    T_FlipInY,
    T_FlipOutX,
    T_FlipOutY,
    T_RotateIn,
    T_RotateInDownLeft,
    T_RotateInDownRight,
    T_RotateInUpLeft,
    T_RotateInUpRight,
    T_RotateOut,
    T_RotateOutDownLeft,
    T_RotateOutDownRight,
    T_RotateOutUpLeft,
    T_RotateOutUpRight,
    T_Hinge,
    T_RollIn,
    T_RollOut,
    T_ZoomIn,
    T_ZoomInDown,
    T_ZoomInLeft,
    T_ZoomInRight,
    T_ZoomInUp,
    T_ZoomOut,
    T_ZoomOutDown,
    T_ZoomOutLeft,
    T_ZoomOutRight,
    T_ZoomOutUp,
    T_LightSpeedIn,
    T_LightSpeedOut
} TransitionEffect;
@interface TransitionManager : NSObject
+(void)SetData:(UIView*)vw transitionType:(TransitionEffect)type;
@end
