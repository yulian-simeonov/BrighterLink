//
//  TimelineWidgetTooltipView.m
//  BrighterLink
//
//  Created by mobile on 11/27/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "TimelineWidgetTooltipView.h"
#import "SharedMembers.h"

@implementation TimelineWidgetTooltipView

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

-(void)UpdateData:(NSArray*)data date:(NSString*)date
{
    for(UIView* vw in self.subviews)
        [vw removeFromSuperview];
    UILabel* lblDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 100, 20)];
    [lblDate setText:date];
    [lblDate setFont:[UIFont boldSystemFontOfSize:14]];
    [lblDate sizeToFit];
    [self addSubview:lblDate];
    
    float rowHeight = 20;
    float frameWidth = [self GetLabelMaxSize:data].width + 22;
    for(int i = 0; i < data.count; i++)
    {
        UIImageView* spot = [[UIImageView alloc] initWithFrame:CGRectMake(5, lblDate.frame.size.height + lblDate.frame.origin.y + i * rowHeight + 4, 12, 12)];
        [spot setBackgroundColor:[[SharedMembers sharedInstance].arySegmentColors objectAtIndex:[[[data objectAtIndex:i] objectForKey:@"color"] intValue]]];
        spot.layer.cornerRadius = spot.frame.size.width / 2;
        [self addSubview:spot];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, lblDate.frame.size.height + lblDate.frame.origin.y + i * rowHeight, 0, rowHeight)];
        [lbl setText:[[data objectAtIndex:i] objectForKey:@"text"]];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        [lbl sizeToFit];
        lbl.center = CGPointMake(lbl.center.x, 10 + lblDate.frame.size.height + lblDate.frame.origin.y + i * rowHeight);
        [self addSubview:lbl];
        
        UILabel* lbl_value = [[UILabel alloc] initWithFrame:CGRectMake(150, lblDate.frame.size.height + lblDate.frame.origin.y + i * rowHeight, 0, rowHeight)];
        NSDictionary* item = [data objectAtIndex:i];
        if ([[item objectForKey:@"type"] isEqualToString:@"int"])
            [lbl_value setText:[NSString stringWithFormat:@"%d", [[[data objectAtIndex:i] objectForKey:@"value"] intValue]]];
        else
            [lbl_value setText:[NSString stringWithFormat:@"%.2f", [[[data objectAtIndex:i] objectForKey:@"value"] floatValue]]];
        [lbl_value setFont:[UIFont boldSystemFontOfSize:12]];
        [lbl_value sizeToFit];
        lbl_value.center = CGPointMake(frameWidth - lbl_value.frame.size.width / 2 - 5, 10 + lblDate.frame.size.height + lblDate.frame.origin.y + i * rowHeight);
        [self addSubview:lbl_value];
    }
    [self setFrame:CGRectMake(self.superview.frame.size.width - frameWidth, self.frame.origin.y, frameWidth, lblDate.frame.size.height + lblDate.frame.origin.y + rowHeight * data.count + 5)];
}

-(CGSize)GetLabelMaxSize:(NSArray*)data
{
    NSString* maxTxt = @"";
    for(int i = 0; i < data.count; i++)
    {
        NSDictionary* item = [data objectAtIndex:i];
        NSString* txt = nil;
        if ([[item objectForKey:@"type"] isEqualToString:@"int"])
            txt = [NSString stringWithFormat:@"%@    %d", [item objectForKey:@"text"], [[item objectForKey:@"value"] intValue]];
        else
            txt = [NSString stringWithFormat:@"%@    %.2f", [item objectForKey:@"text"], [[item objectForKey:@"value"] floatValue]];
        if(txt.length > maxTxt.length)
            maxTxt = txt;
    }
    UILabel* lbl = [[UILabel alloc] init];
    [lbl setFont:[UIFont boldSystemFontOfSize:12]];
    [lbl setText:maxTxt];
    [lbl sizeToFit];
    return CGSizeMake(lbl.frame.size.width, lbl.frame.size.height) ;
}
@end
