//
//  TransitionContainerView.m
//  BrighterLink
//
//  Created by mobile on 12/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TransitionManager.h"
#import "AGGeometryKit.h"

/** Degrees to Radian **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

@implementation TransitionManager

+(void)SetData:(UIView*)vw transitionType:(TransitionEffect)type
{
    switch (type) {
        case T_Bounce:
            [TransitionManager Bounce:vw];
            break;
        case T_Flash:
            [TransitionManager Flash:vw];
            break;
        case T_Pulse:
            [TransitionManager Pulse:vw];
            break;
        case T_RubberBand:
            [TransitionManager RubberBand:vw];
            break;
        case T_Shake:
            [TransitionManager Shake:vw];
            break;
        case T_Swing:
            [TransitionManager Swing:vw];
            break;
        case T_Tada:
            [TransitionManager Tada:vw];
            break;
        case T_Wobble:
            [TransitionManager Wobble:vw];
            break;
        case T_BounceIn:
            [TransitionManager BounceIn:vw];
            break;
        case T_BounceInDown:
            [TransitionManager BounceInDown:vw];
            break;
        case T_BounceInUp:
            [TransitionManager BounceInUp:vw];
            break;
        case T_BounceInLeft:
            [TransitionManager BounceInLeft:vw];
            break;
        case T_BounceInRight:
            [TransitionManager BounceInRight:vw];
            break;
        case T_BounceOut:
            [TransitionManager BounceOut:vw];
            break;
        case T_BounceOutDown:
            [TransitionManager BounceOutDown:vw];
            break;
        case T_BounceOutLeft:
            [TransitionManager BounceOutLeft:vw];
            break;
        case T_BounceOutRight:
            [TransitionManager BounceOutRight:vw];
            break;
        case T_BounceOutUp:
            [TransitionManager BounceOutUp:vw];
            break;
        case T_FadeIn:
            [TransitionManager FadeIn:vw];
            break;
        case T_FadeInDown:
            [TransitionManager FadeInDown:vw];
            break;
        case T_FadeInDownBig:
            [TransitionManager FadeInDownBig:vw];
            break;
        case T_FadeInLeft:
            [TransitionManager FadeInLeft:vw];
            break;
        case T_FadeInLeftBig:
            [TransitionManager FadeInLeftBig:vw];
            break;
        case T_FadeInRight:
            [TransitionManager FadeInRight:vw];
            break;
        case T_FadeInRightBig:
            [TransitionManager FadeInRightBig:vw];
            break;
        case T_FadeInUp:
            [TransitionManager FadeInUp:vw];
            break;
        case T_FadeInUpBig:
            [TransitionManager FadeInUpBig:vw];
            break;
        case T_FadeOut:
            [TransitionManager FadeOut:vw];
            break;
        case T_FadeOutDown:
            [TransitionManager FadeOutDown:vw];
            break;
        case T_FadeOutDownBig:
            [TransitionManager FadeOutDownBig:vw];
            break;
        case T_FadeOutLeft:
            [TransitionManager FadeOutLeft:vw];
            break;
        case T_FadeOutLeftBig:
            [TransitionManager FadeOutLeftBig:vw];
            break;
        case T_FadeOutRight:
            [TransitionManager FadeOutRight:vw];
            break;
        case T_FadeOutRightBig:
            [TransitionManager FadeOutRightBig:vw];
            break;
        case T_FadeOutUp:
            [TransitionManager FadeOutUp:vw];
            break;
        case T_FadeOutUpBig:
            [TransitionManager FadeOutUpBig:vw];
            break;
        case T_Flip:
            [TransitionManager Flip:vw];
            break;
        case T_FlipInX:
            [TransitionManager FlipInX:vw];
            break;
        case T_FlipInY:
            [TransitionManager FlipInY:vw];
            break;
        case T_FlipOutX:
            [TransitionManager FlipOutX:vw];
            break;
        case T_FlipOutY:
            [TransitionManager FlipOutY:vw];
            break;
        case T_RotateIn:
            [TransitionManager RotateIn:vw];
            break;
        case T_RotateInDownLeft:
            [TransitionManager RotateInDownLeft:vw];
            break;
        case T_RotateInDownRight:
            [TransitionManager RotateInDownRight:vw];
            break;
        case T_RotateInUpLeft:
            [TransitionManager RotateInUpLeft:vw];
            break;
        case T_RotateInUpRight:
            [TransitionManager RotateInUpRight:vw];
            break;
        case T_RotateOut:
            [TransitionManager RotateOut:vw];
            break;
        case T_RotateOutDownLeft:
            [TransitionManager RotateOutDownLeft:vw];
            break;
        case T_RotateOutDownRight:
            [TransitionManager RotateOutDownRight:vw];
            break;
        case T_RotateOutUpLeft:
            [TransitionManager RotateOutUpLeft:vw];
            break;
        case T_RotateOutUpRight:
            [TransitionManager RotateOutUpRight:vw];
            break;
        case T_Hinge:
            [TransitionManager Hinge:vw];
            break;
        case T_RollIn:
            [TransitionManager RollIn:vw];
            break;
        case T_RollOut:
            [TransitionManager RollOut:vw];
            break;
        case T_ZoomIn:
            [TransitionManager ZoomIn:vw];
            break;
        case T_ZoomInDown:
            [TransitionManager ZoomInDown:vw];
            break;
        case T_ZoomInLeft:
            [TransitionManager ZoomInLeft:vw];
            break;
        case T_ZoomInRight:
            [TransitionManager ZoomInRight:vw];
            break;
        case T_ZoomInUp:
            [TransitionManager ZoomInUp:vw];
            break;
        case T_ZoomOut:
            [TransitionManager ZoomOut:vw];
            break;
        case T_ZoomOutDown:
            [TransitionManager ZoomOutDown:vw];
            break;
        case T_ZoomOutLeft:
            [TransitionManager ZoomOutLeft:vw];
            break;
        case T_ZoomOutRight:
            [TransitionManager ZoomOutRight:vw];
            break;
        case T_ZoomOutUp:
            [TransitionManager ZoomOutUp:vw];
            break;
        case T_LightSpeedIn:
            [TransitionManager LightSpeedIn:vw];
            break;
        case T_LightSpeedOut:
            [TransitionManager LightSpeedOut:vw];
            break;
        default:
            break;
    }
}

+(void)Bounce:(UIView*)vw
{
    NSString *keyPath = @"transform.translation.y";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  @[ @0.0f, @0.0f, @-30.0f, @-30.0f, @0.0f, @-15.0f, @0.0f, @-4.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.43f, @0.53f, @0.7f, @0.8f, @0.9f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Flash:(UIView*)vw
{
    NSString *keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  @[@1.0f, @0.0f, @1.0f, @0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Pulse:(UIView*)vw
{
    NSString *keyPath = @"transform.scale";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  @[@1.0f, @1.05f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RubberBand:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 0.75, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.75, 1.25, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 0.85, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 1.05, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 0.95, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.3f, @0.4f, @0.5f, @0.65, @0.75, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Shake:(UIView*)vw
{
    NSString *keyPath = @"transform.translation.x";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0, @-10.0, @10.0, @-10.0, @10.0, @-10.0, @10.0, @-10.0, @10.0, @-10.0, @0.0];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Swing:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(0.5f, 0);
    [vw setFrame:CGRectMake(vw.frame.origin.x, vw.frame.origin.y - vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(15), 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(-10), 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(5), 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(-5), 0, 0, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(0), 0, 0, 1)],
                           nil];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Tada:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(-3), 0, 0, 1), 0.9, 0.9f, 0.9f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(-3), 0, 0, 1), 0.9, 0.9f, 0.9f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(3), 0, 0, 1), 1.1, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(-3), 0, 0, 1), 1.1, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(3), 0, 0, 1), 1.1, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(-3), 0, 0, 1), 1.1, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(3), 0, 0, 1), 1.1, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(-3), 0, 0, 1), 1.1, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(degreesToRadians(3), 0, 0, 1), 1.1, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Wobble:(UIView*)vw
{
    float width = vw.frame.size.width;
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.75;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeRotation(degreesToRadians(-5), 0, 0, 1), width * -0.25f, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeRotation(degreesToRadians(3), 0, 0, 1), width * 0.2f, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeRotation(degreesToRadians(-3), 0, 0, 1), width * -0.15f, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeRotation(degreesToRadians(2), 0, 0, 1), width * 0.1f, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeRotation(degreesToRadians(-1), 0, 0, 1), width * -0.05f, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.15f, @0.3f, @0.45f, @0.6f, @0.75f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceIn:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.03f, 1.03f, 1.03f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.97f, 0.97f, 0.97f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceInDown:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -3000, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 25, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -10, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.6f, @0.75f, @0.9f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceInUp:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 3000, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -25, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 10, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.6f, @0.75f, @0.9f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceInLeft:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-3000, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(25, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-10, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.6f, @0.75f, @0.9f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceInRight:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(3000, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-25, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(10, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.6f, @0.75f, @0.9f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceOut:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.8f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3f, 0.3f, 0.3f)],
                           nil];
    
    translation.keyTimes = @[@0.0f, @0.2f, @0.5f, @0.55f, @0.8f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.8f;
    translation.values =  @[@1.0f, @1.0f, @1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.2f, @0.5f, @0.55f, @0.8f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceOutDown:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 10, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -20, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -20, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 2000, 0)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.45f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  @[@1.0f, @1.0f, @1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.45f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceOutLeft:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.8f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(20, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-2000, 0, 0)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.2f, @0.8f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.8f;
    translation.values =  @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.45f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceOutRight:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.8f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-20, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(2000, 0, 0)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.2f, @0.8f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.8f;
    translation.values =  @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.45f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)BounceOutUp:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -10, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 20, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 20, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, -2000, 0)],
                           nil];
    translation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.45f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values =  @[@1.0f, @1.0f, @1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.2f, @0.4f, @0.45f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeIn:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInDown:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 0.3f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.3f;
    translation.values = @[[NSNumber numberWithFloat:-vw.frame.size.height], @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInDownBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@-1000.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInLeft:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 0.3f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.3f;
    translation.values = @[[NSNumber numberWithFloat:-vw.frame.size.width], @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInLeftBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@-1000.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInRight:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 0.3f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.3f;
    translation.values = @[[NSNumber numberWithFloat:vw.frame.size.width], @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInRightBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1000.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInUp:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 0.3f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.3f;
    translation.values = @[[NSNumber numberWithFloat:vw.frame.size.height], @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeInUpBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@0.0f, @1.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1000.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOut:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutDown:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, [NSNumber numberWithFloat:vw.frame.size.height]];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutDownBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1000.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutLeft:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, [NSNumber numberWithFloat:-vw.frame.size.width]];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutLeftBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @-1000.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutRight:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, [NSNumber numberWithFloat:vw.frame.size.width]];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutRightBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.x";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1000.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutUp:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, [NSNumber numberWithFloat:vw.frame.size.height]];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FadeOutUpBig:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @0.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform.translation.y";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1000.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Flip:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    
    float perspective = 400;
    CATransform3D tran1 = CATransform3DMakeRotation(degreesToRadians(-360), 0, 1, 0);
    tran1.m34 = 1.0f / perspective;
    
    CATransform3D tran2 = CATransform3DMakeRotation(degreesToRadians(-190), 0, 1, 0);
    tran2.m34 = 1.0f / perspective;
    
    CATransform3D tran3 = CATransform3DMakeRotation(degreesToRadians(-170), 0, 1, 0);
    tran3.m34 = 1.0f / perspective;
    
    CATransform3D tran4 = CATransform3DMakeScale(0.95, 0.95f, 0.95f);
    tran4.m34 = 1.0f / perspective;
    
    CATransform3D tran5 = CATransform3DIdentity;
    tran5.m34 = 1.0f / perspective;
    
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:tran1],
                           [NSValue valueWithCATransform3D:tran2],
                           [NSValue valueWithCATransform3D:tran3],
                           [NSValue valueWithCATransform3D:tran4],
                           [NSValue valueWithCATransform3D:tran5],
                           nil];
    translation.keyTimes = @[@0.0f, @0.4f, @0.5f, @0.8f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FlipInX:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    float perspective = 400;
    CATransform3D tran1 = CATransform3DMakeRotation(degreesToRadians(90), 1, 0, 0);
    tran1.m34 = 1.0f / perspective;
    
    CATransform3D tran2 = CATransform3DMakeRotation(degreesToRadians(-40), 1, 0, 0);
    tran2.m34 = 1.0f / perspective;
    
    CATransform3D tran3 = CATransform3DMakeRotation(degreesToRadians(20), 1, 0, 0);
    tran3.m34 = 1.0f / perspective;
    
    CATransform3D tran4 = CATransform3DMakeRotation(degreesToRadians(-10), 1, 0, 0);
    tran4.m34 = 1.0f / perspective;
    
    CATransform3D tran5 = CATransform3DIdentity;
    tran5.m34 = 1.0f / perspective;
    
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:tran1],
                           [NSValue valueWithCATransform3D:tran2],
                           [NSValue valueWithCATransform3D:tran3],
                           [NSValue valueWithCATransform3D:tran4],
                           [NSValue valueWithCATransform3D:tran5],
                           nil];
    translation.keyTimes = @[@0.0f, @0.4f, @0.6f, @0.8f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FlipInY:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    float perspective = 400;
    CATransform3D tran1 = CATransform3DMakeRotation(degreesToRadians(90), 0, 1, 0);
    tran1.m34 = 1.0f / perspective;
    
    CATransform3D tran2 = CATransform3DMakeRotation(degreesToRadians(-40), 0, 1, 0);
    tran2.m34 = 1.0f / perspective;
    
    CATransform3D tran3 = CATransform3DMakeRotation(degreesToRadians(20), 0, 1, 0);
    tran3.m34 = 1.0f / perspective;
    
    CATransform3D tran4 = CATransform3DMakeRotation(degreesToRadians(-10), 0, 1, 0);
    tran4.m34 = 1.0f / perspective;
    
    CATransform3D tran5 = CATransform3DIdentity;
    tran5.m34 = 1.0f / perspective;
    
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:tran1],
                           [NSValue valueWithCATransform3D:tran2],
                           [NSValue valueWithCATransform3D:tran3],
                           [NSValue valueWithCATransform3D:tran4],
                           [NSValue valueWithCATransform3D:tran5],
                           nil];
    translation.keyTimes = @[@0.0f, @0.4f, @0.6f, @0.8f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FlipOutX:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    float perspective = 400;
    CATransform3D tran1 = CATransform3DIdentity;
    tran1.m34 = 1.0f / perspective;
    
    CATransform3D tran2 = CATransform3DMakeRotation(degreesToRadians(-20), 1, 0, 0);
    tran2.m34 = 1.0f / perspective;
    
    CATransform3D tran3 = CATransform3DMakeRotation(degreesToRadians(90), 1, 0, 0);
    tran3.m34 = 1.0f / perspective;
    
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:tran1],
                           [NSValue valueWithCATransform3D:tran2],
                           [NSValue valueWithCATransform3D:tran3],
                           nil];
    translation.keyTimes = @[@0.0f, @0.3f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.3f, @1.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)FlipOutY:(UIView*)vw
{
    NSString *keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    float perspective = 400;
    CATransform3D tran1 = CATransform3DIdentity;
    tran1.m34 = 1.0f / perspective;
    
    CATransform3D tran2 = CATransform3DMakeRotation(degreesToRadians(-20), 0, 1, 0);
    tran2.m34 = 1.0f / perspective;
    
    CATransform3D tran3 = CATransform3DMakeRotation(degreesToRadians(90), 0, 1, 0);
    tran3.m34 = 1.0f / perspective;
    
    translation.duration = 1.0f;
    translation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:tran1],
                           [NSValue valueWithCATransform3D:tran2],
                           [NSValue valueWithCATransform3D:tran3],
                           nil];
    translation.keyTimes = @[@0.0f, @0.3f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.3f, @1.0f];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateIn:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(-200), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateInDownLeft:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(0, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x - vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(-45), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateInDownRight:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(1.0f, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x + vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(45), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateInUpLeft:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(0, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x - vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(45), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateInUpRight:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(1.0f, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x + vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(-90), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateOut:(UIView*)vw
{
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(200), 0, 0, 1)],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateOutDownLeft:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(0, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x - vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(45), 0, 0, 1)],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateOutDownRight:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(1.0f, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x + vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(-45), 0, 0, 1)],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateOutUpLeft:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(0, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x - vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(-45), 0, 0, 1)],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RotateOutUpRight:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(1.0f, 1.0f);
    [vw setFrame:CGRectMake(vw.frame.origin.x + vw.frame.size.width / 2, vw.frame.origin.y + vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    
    NSString* keyPath = @"opacity";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"transform";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(90), 0, 0, 1)],
                          nil];
    translation.duration = 1.0f;
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)Hinge:(UIView*)vw
{
    vw.layer.anchorPoint = CGPointMake(0, 0);
    [vw setFrame:CGRectMake(vw.frame.origin.x - vw.frame.size.width / 2, vw.frame.origin.y - vw.frame.size.height / 2, vw.frame.size.width, vw.frame.size.height)];
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(80), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(60), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(80), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeRotation(degreesToRadians(60), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 700, 0)],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @1.0f, @1.0f, @1.0f, @1.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RollIn:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(-vw.frame.size.width, 0, 0), degreesToRadians(-120), 0, 0, 1)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)RollOut:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeTranslation(vw.frame.size.width, 0, 0), degreesToRadians(120), 0, 0, 1)],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @0.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomIn:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.5f;
    translation.values = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3f, 0.3f, 0.3f)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 0.5f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomInDown:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, -1000, 0), 0.1f, 0.1f, 0.1f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, 60, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomInLeft:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(-1000, 0, 0), 0.1f, 0.1f, 0.1f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(10, 0, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomInRight:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(1000, 0, 0), 0.1f, 0.1f, 0.1f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(-10, 0, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomInUp:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, 1000, 0), 0.1f, 0.1f, 0.1f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, -60, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@0.0f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomOut:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3f, 0.3f, 0.3f)],
                          [NSValue valueWithCATransform3D:CATransform3DIdentity],
                          nil];
    translation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @0.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomOutDown:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, -60, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, 1000, 0), 0.1f, 0.1f, 0.1f)],
                          nil];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomOutLeft:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(42, 0, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(-1000, 0, 0), 0.1f, 0.1f, 0.1f)],
                          nil];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomOutRight:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(-42, 0, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(1000, 0, 0), 0.1f, 0.1f, 0.1f)],
                          nil];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)ZoomOutUp:(UIView*)vw
{
    NSString* keyPath = @"transform";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DIdentity],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, 60, 0), 0.475f, 0.475f, 0.475f)],
                          [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeTranslation(0, -1000, 0), 0.1f, 0.1f, 0.1f)],
                          nil];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
    
    keyPath = @"opacity";
    translation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    translation.duration = 1.0f;
    translation.values = @[@1.0f, @1.0f, @0.0f];
    translation.keyTimes = @[@0.0f, @0.4f, @1.0f];
    [vw.layer addAnimation:translation forKey:keyPath];
}

+(void)LightSpeedIn:(UIView*)vw
{
    [vw.layer ensureAnchorPointIsSetToZero];
    AGKQuad quad1 = AGKQuadMake(CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width * 2, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width * 2 - 120, vw.frame.origin.y + vw.frame.size.height),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width - 120, vw.frame.origin.y + vw.frame.size.height));
    AGKQuad quad2 = AGKQuadMake(CGPointMake(vw.frame.origin.x, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width + 80, vw.frame.origin.y + vw.frame.size.height),
                                CGPointMake(vw.frame.origin.x + 80, vw.frame.origin.y + vw.frame.size.height));
    AGKQuad quad3 = AGKQuadMake(CGPointMake(vw.frame.origin.x, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width - 20, vw.frame.origin.y + vw.frame.size.height),
                                CGPointMake(vw.frame.origin.x - 20, vw.frame.origin.y + vw.frame.size.height));
    AGKQuad quad4 = AGKQuadMake(CGPointMake(vw.frame.origin.x, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y + vw.frame.size.height),
                                CGPointMake(vw.frame.origin.x, vw.frame.origin.y + vw.frame.size.height));
    vw.layer.quadrilateral = quad1;
    vw.alpha = 0.0f;
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        vw.layer.quadrilateral = quad2;
        vw.alpha = 1.0f;
    } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                vw.layer.quadrilateral = quad3;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                    vw.layer.quadrilateral = quad4;
                } completion:^(BOOL finished) {
                    
                }];
            }];
    }];
}

+(void)LightSpeedOut:(UIView*)vw
{
    [vw.layer ensureAnchorPointIsSetToZero];
    AGKQuad quad1 = AGKQuadMake(CGPointMake(vw.frame.origin.x, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y + vw.frame.size.height),
                                CGPointMake(vw.frame.origin.x, vw.frame.origin.y + vw.frame.size.height));
    AGKQuad quad2 = AGKQuadMake(CGPointMake(vw.frame.origin.x + vw.frame.size.width, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width * 2, vw.frame.origin.y),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width * 2 - 120, vw.frame.origin.y + vw.frame.size.height),
                                CGPointMake(vw.frame.origin.x + vw.frame.size.width - 120, vw.frame.origin.y + vw.frame.size.height));
    vw.layer.quadrilateral = quad1;
    vw.alpha = 1.0f;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        vw.layer.quadrilateral = quad2;
        vw.alpha = 0.0f;
    } completion:^(BOOL finished) {
        vw.alpha = 1.0f;
        vw.layer.quadrilateral = quad1;
    }];
}
@end
