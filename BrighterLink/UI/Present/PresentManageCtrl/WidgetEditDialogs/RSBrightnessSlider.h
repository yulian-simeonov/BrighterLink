//
//  RSBrightnessSlider.h
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//

#import <Foundation/Foundation.h>
#import "RSColorPickerView.h"

@interface RSBrightnessSlider : UIView

@property (nonatomic) RSColorPickerView *colorPicker;

@property (nonatomic) IBOutlet UIImageView * m_imgbg;
@property (nonatomic) IBOutlet UIImageView * m_imgMark;



- (void) setValue:(float) val;
@end
