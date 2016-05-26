//
//  TimelineGraphView.h
//  BrighterLink
//
//  Created by mobile on 11/26/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineGraphView : UIView
{
    float kGraphHeight;
    float kDefaultGraphWidth;
    float kOffsetX;
    float kOffsetY;
    float kStepX;
    float kStepY;
    float kGraphBottom;
    float kGraphTop;
    float kCircleRadius;
    float kLineStepX;
    float kLineStepY;
    UIImageView* img_line;
    NSArray* m_lines;
    NSMutableArray* m_topPoints;
}
@property (nonatomic, weak) id delegate;
+(TimelineGraphView*)ShowGraphic:(UIView*)parentView;
-(void)UpdateGraph:(int)xLength yLength:(float)yLength data:(NSArray*)data;
@end
