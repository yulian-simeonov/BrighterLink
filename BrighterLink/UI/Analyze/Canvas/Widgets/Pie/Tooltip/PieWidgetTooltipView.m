//
//  PieWidgetTooltipView.m
//  BrighterLink
//
//  Created by mobile on 12/21/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PieWidgetTooltipView.h"

@implementation PieWidgetTooltipView

-(id)init
{
    if (self = [super init])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
    }
    return self;
}

-(void)UpdateData:(NSString*)title value:(float)value
{
    for(UIView* vw in self.subviews)
        [vw removeFromSuperview];
    UILabel* lblTitle = [[UILabel alloc] init];
    if (![lblTitle isEqual:[NSNull null]])
        [lblTitle setText:title];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [lblTitle sizeToFit];
    [lblTitle setFrame:CGRectMake(0, 0, lblTitle.frame.size.width + 20, lblTitle.frame.size.height)];
    [lblTitle setBackgroundColor:[UIColor colorWithRed:245.0f / 255.0f green:245.0f / 255.0f blue:245.0f / 255.0f alpha:1]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    UILabel* lblValue = [[UILabel alloc] init];
    [lblValue setText:[NSString stringWithFormat:@"%.2f", value]];
    [lblValue setFont:[UIFont boldSystemFontOfSize:14]];
    [lblValue sizeToFit];
    [lblValue setFrame:CGRectMake(0, 0, lblValue.frame.size.width + 20, lblTitle.frame.size.height)];
    [lblValue setTextAlignment:NSTextAlignmentCenter];
    
    float frameWidth = MAX(lblTitle.frame.size.width, lblValue.frame.size.width);
    [lblTitle setFrame:CGRectMake(0, 0, frameWidth, lblTitle.frame.size.height)];
    [lblValue setFrame:CGRectMake(0, lblTitle.frame.size.height, frameWidth, lblTitle.frame.size.height)];
    
    [self addSubview:lblTitle];
    [self addSubview:lblValue];
    
    UIView* middleLine = [[UILabel alloc] init];
    [middleLine setBackgroundColor:[UIColor lightGrayColor]];
    [middleLine setFrame:CGRectMake(0, lblTitle.frame.size.height, frameWidth, 1)];
    [self addSubview:middleLine];
    
    [self setFrame:CGRectMake(0, self.frame.origin.y, frameWidth, lblTitle.frame.size.height * 2)];
}
@end
