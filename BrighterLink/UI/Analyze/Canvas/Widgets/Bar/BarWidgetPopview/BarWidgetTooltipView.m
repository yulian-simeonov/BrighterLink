//
//  BarWidgetTooltipView.m
//  BrighterLink
//
//  Created by Andriy on 12/11/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "BarWidgetTooltipView.h"

@interface BarWidgetTooltipView()

@property (nonatomic, assign) IBOutlet UILabel *lblSegmentName;
@property (nonatomic, assign) IBOutlet UILabel *lblSegmentValue;

@end

@implementation BarWidgetTooltipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setSegmentDataWithName:(NSString *)name value:(NSString *)value
{
    self.lblSegmentName.text = name;
    self.lblSegmentValue.text = value;
}

@end
