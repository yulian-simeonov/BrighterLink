//
//  TimelineWidgetLegendView.h
//  BrighterLink
//
//  Created by mobile on 11/27/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineWidgetLegendView : UIView
{
    NSMutableArray* m_whiteSpots;
    NSArray* m_data;
}
@property (nonatomic, weak) id delegate;
-(void)UpdateData:(NSArray*)data;
@end
