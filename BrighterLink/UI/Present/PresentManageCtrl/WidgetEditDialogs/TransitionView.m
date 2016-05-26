//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TransitionView.h"

#import "SharedMembers.h"

@interface TransitionView()

@end

@implementation TransitionView

/*

@[@"-- Choose Transition In --", //0,1,10,16, 22, 32, 42, 48, 51, 57, 63, 70
@"Attention Seekers", //1
@"  bounce", @" flash", @"  pulas", @"  rubberBand", @" shake", @"  swing", @"  tada", @"   wobble",
@"Bouncing Entrances", //10
@"  bounceIn", @" bounceInDown", @"    bounceInLeft", @"   bounceInRight", @" bounceInUp",
@"Bouncing Exits", //16
@"  bounceOut", @"  bounceOutDown", @"  bounceOutLeft", @"  bounceOutRight", @" bounceOutUp",
@"Fading Entrances", //22
@"  fadeIn", @" fadeInDown", @" fadeInDownBig", @"  fadeInLeft", @" fadeInLeftBig", @"	fadeInRight", @"    fadeInRightBig", @" fadeInUp", @"   fadeInUpBig",
@"Fading Exits", //32
@"  fadeOut", @"    fadeOutDown", @"    fadeOutDownBig", @" fadeOutLeft", @"    fadeOutLeftBig", @" fadeOutRight", @"   fadeOutRightBig", @"    fadeOutUp", @" fadeOutUpBig",
@"Flippers", //42
@"  flip", @"   flipInX", @"    flipInY", @"    flipOutX", @"   flipOutY",
@"Lightspeed", //48
@"  lightSpeedIn", @"   lightSpeedOut",
@"Rotating Entrances", //51
@"  rotateIn", @"   rotateInDownLeft", @"   rotateInDownRight", @"  rotateInUpLeft", @" rotateInUpRight",
@"Rotating Exits", //57
@"  rotateOut", @"  rotateOutDownLeft", @"  rotateOutDownRight", @" rotateOutUpLeft", @"    rotateOutUpRight",
@"Sliders", //63
@"  slideInDown", @"	slideInLeft", @"	slideInRight", @"   slideOutLeft", @"	slideOutRight", @"	slideOutUp",
@"Specials", //70
@"  hinge", @"	rollIn", @" rollOut"];

*/

NSString * AttentionSeekers[] = {
    @"bounce", @"flash", @"pulas", @"rubberBand", @"shake", @"swing", @"tada", @"wobble"
};
NSString * BouncingEntrances[] = {
    @"bounceIn", @"bounceInDown", @"bounceInLeft", @"bounceInRight", @"bounceInUp"
};
NSString * BouncingExits[] = {
    @"bounceOut", @"bounceOutDown", @"bounceOutLeft", @"bounceOutRight", @"bounceOutUp"
};
NSString * FadingEntrances[] = {
    @"fadeIn", @"fadeInDown", @"fadeInDownBig", @"fadeInLeft", @"fadeInLeftBig", @"fadeInRight", @"fadeInRightBig", @"fadeInUp", @"fadeInUpBig"
};
NSString * FadingExits[] = {
    @"fadeOut", @"fadeOutDown", @"fadeOutDownBig", @"fadeOutLeft", @"fadeOutLeftBig", @"fadeOutRight", @"fadeOutRightBig", @"fadeOutUp", @"fadeOutUpBig"
};
NSString * Flippers[] = {
    @"flip", @"flipInX", @"flipInY", @"flipOutX", @"flipOutY"
};
NSString * Lightspeed[] = {
    @"lightSpeedIn", @"lightSpeedOut"
};
NSString * RotatingEntrances[] = {
    @"rotateIn", @"rotateInDownLeft", @"rotateInDownRight", @"rotateInUpLeft", @"rotateInUpRight"
};
NSString * RotatingExits[] = {
    @"rotateOut", @"rotateOutDownLeft", @"rotateOutDownRight", @"rotateOutUpLeft", @"rotateOutUpRight"
};
NSString * ZoomEntrances[] = {
    @"zoomIn", @"zoomInDown", @"zoomInLeft", @"zoomInRight", @"zoomInUp"
};
NSString * ZoomExits[] = {
    @"zoomOut", @"zoomOutDown", @"zoomOutLeft", @"zoomOutRight", @"zoomOutUp"
};
NSString * Specials[] = {
    @"hinge", @"rollin", @"rollOut"
};



- (void) awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnRemove)];
    [img_bg addGestureRecognizer:gesture];
}

-(void)OnRemove
{
    [self setHidden:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str =@"";
    switch ( section ) {
        case 0:
            str = @"AttentionSeekers";
            break;
        case 1:
            str = @"BouncingEntrances";
            break;
        case 2:
            str = @"BouncingExits";
            break;
        case 3:
            str = @"FadingEntrances";
            break;
        case 4:
            str = @"FadingExits";
            break;
        case 5:
            str = @"Flippers";
            break;
        case 6:
            str = @"Lightspeed";
            break;
        case 7:
            str = @"RotationEntrances";
            break;
        case 8:
            str = @"RotationExits";
            break;
        case 9:
            str = @"Specials";
            break;
        case 10:
            str = @"Zoom Entrances";
            break;
        case 11:
            str = @"Zoom Exits";
            break;
        default:
            break;
    }

    return str;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int n = 0;
    
    switch ( section ) {
        case 0:
            n = 8;
            break;
        case 1:
            n = 5;
            break;
        case 2:
            n = 5;
            break;
        case 3:
            n = 9;
            break;
        case 4:
            n = 9;
            break;
        case 5:
            n = 5;
            break;
        case 6:
            n = 2;
            break;
        case 7:
            n = 5;
            break;
        case 8:
            n = 5;
            break;
        case 9:
            n = 3;
            break;
        case 10:
        case 11:
            n = 5;
            break;
        default:
            break;
    }
    
    return n;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    }
    
    NSString * str  = @"";
    switch ( indexPath.section ) {
        case 0:
            str = AttentionSeekers[indexPath.row];
            break;
        case 1:
            str = BouncingEntrances[indexPath.row];
            break;
        case 2:
            str = BouncingExits[indexPath.row];
            break;
        case 3:
            str = FadingEntrances[indexPath.row];
            break;
        case 4:
            str = FadingExits[indexPath.row];
            break;
        case 5:
            str = Flippers[indexPath.row];
            break;
        case 6:
            str = Lightspeed[indexPath.row];
            break;
        case 7:
            str = RotatingEntrances[indexPath.row];
            break;
        case 8:
            str = RotatingExits[indexPath.row];
            break;
        case 9:
            str = Specials[indexPath.row];
            break;
        case 10:
            str = ZoomEntrances[indexPath.row];
            break;
        case 11:
            str = ZoomExits[indexPath.row];
            break;
        default:
            break;

    }
    [cell.textLabel setText:str];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    
    if ([m_selected isEqual:str])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
        return;
//    for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
//    {
//        for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
//        {
//            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].accessoryType = UITableViewCellAccessoryNone;
//        }
//    }
//    
//    if (_delegate)
//    {
//        if ([_delegate respondsToSelector:@selector(SelectedObject:selectedObj:)])
//            [_delegate SelectedObject:self selectedObj:[m_data objectAtIndex:indexPath.row]];
//    }
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    [self setHidden:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString * str;
    switch ( indexPath.section ) {
        case 0:
            str =  AttentionSeekers[indexPath.row];
            break;
        case 1:
            str =  BouncingEntrances[indexPath.row];
            break;
        case 2:
            str =  BouncingExits[indexPath.row];
            break;
        case 3:
            str =  FadingEntrances[indexPath.row];
            break;
        case 4:
            str =  FadingExits[indexPath.row];
            break;
        case 5:
            str =  Flippers[indexPath.row];
            break;
        case 6:
            str =  Lightspeed[indexPath.row];
            break;
        case 7:
            str =  RotatingEntrances[indexPath.row];
            break;
        case 8:
            str =  RotatingExits[indexPath.row];
            break;
        case 9:
            str =  Specials[indexPath.row];
            break;
        case 10:
            str = ZoomEntrances[indexPath.row];
            break;
        case 11:
            str = ZoomExits[indexPath.row];
            break;
        default:
            break;
            
    }

    m_selected  = str;
    
    id<TransitionDelegate> Delegate = self.delegate;
    [Delegate sendSelectTransition:str];
    
}


- (void) setEffect:(NSString*) effect
{
    m_selected = effect;
    [_m_table reloadData];
}

@end
