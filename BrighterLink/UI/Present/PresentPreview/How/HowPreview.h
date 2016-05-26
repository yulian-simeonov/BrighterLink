//
//  SolarPreview.h
//  BrighterLink
//
//  Created by mobile on 12/4/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowPreview : UIView
{
    
    float width;
    float height;
    
    IBOutlet UIImageView * img_bg;
    
    IBOutlet UIImageView* img_currency1;
    IBOutlet UIImageView* img_currency2;
    IBOutlet UIImageView* img_beam1;
    IBOutlet UIImageView* img_beam2;
    IBOutlet UIImageView* img_arrow1;
    IBOutlet UIImageView* img_arrow2;
    IBOutlet UIImageView* img_arrow3;
    IBOutletCollection(UIImageView) NSArray* img_steps;
    IBOutletCollection(UIImageView) NSArray* img_frameSteps;
    IBOutletCollection(UILabel) NSArray* lbl_steps;
    CGPoint m_arrowPoints[3];
    BOOL m_bStopAnimation;
    CGSize m_arrowOffset;
    
    NSTimer* m_beamTimer;
    NSTimer* m_stepTimer;
}
-(void)StartAnimation;
-(void)SetTexts:(NSArray*)txts;


- (void) setInfo;

@end
