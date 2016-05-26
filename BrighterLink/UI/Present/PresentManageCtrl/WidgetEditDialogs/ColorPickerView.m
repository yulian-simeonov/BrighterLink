//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "ColorPickerView.h"
#import "SharedMembers.h"

@interface ColorPickerView()

@end

@implementation ColorPickerView

- (void) awakeFromNib
{
    [_colorPicker setSelectionColor:RSRandomColorOpaque(YES)];
    [_colorPicker setDelegate:self];
    
    NSArray*  nib = [[NSBundle mainBundle] loadNibNamed:@"RSBrightnessSlider" owner:self options:nil];
    _brightnessSlider = [nib objectAtIndex:0];
    [_brightnessSlider setFrame:CGRectMake(229, 12, 45, 200)];
    [_brightnessSlider setColorPicker:_colorPicker];
    [self addSubview:_brightnessSlider];
    
    self.layer.cornerRadius = 10.0f;
    _m_btnCancel.layer.cornerRadius  = 10.0f;
    _m_btnOK.layer.cornerRadius  = 10.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SetSliderColor:)
                                                 name:@"SetSliderColor"
                                               object:nil];
    
    
}


- (void) SetSliderColor:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    _brightnessSlider.m_imgbg.backgroundColor  = _colorPatch.backgroundColor;
}



- (void) setInfo:(UIColor*) color
{
    [_colorPicker setSelectionColor: color];
    _brightnessSlider.m_imgbg.backgroundColor  = color;
    [_m_vOrigin setBackgroundColor:color];
}

#pragma mark - RSColorPickerView delegate methods

- (void)colorPickerDidChangeSelection:(RSColorPickerView *)cp {
    
    // Get color data
    UIColor *color = [cp selectionColor];
    
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    // Update important UI
    _colorPatch.backgroundColor = color;
    
    int ir = r * 255;
    int ig = g * 255;
    int ib = b * 255;
    
    [_m_txtR setText: [NSString stringWithFormat:@"%d", ir]];
    [_m_txtG setText: [NSString stringWithFormat:@"%d", ig]];
    [_m_txtB setText: [NSString stringWithFormat:@"%d", ib]];
    [_m_txtHex setText: [self hexStringForColor: color]];

    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    [_brightnessSlider setValue: brightness];
    
    [_m_txtHue setText:[NSString stringWithFormat:@"%d", (int)(hue * 255)]];
    [_m_txtSat setText: [NSString stringWithFormat:@"%d", (int)(saturation * 255)]];
    [_m_txtBrighter setText: [NSString stringWithFormat:@"%d", (int)(brightness * 255)]];
    
}


- (NSString *)hexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString.lowercaseString;
}

- (IBAction) onOk:(id)sender
{
    [self setHidden:true];
    
    id<ColorPickerDelegate> Delegate = self.delegate;
    [Delegate setFontColor: _m_txtHex.text];

}

- (IBAction) onCancel:(id)sender
{
    [self setHidden: true];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL flag  = true;
    if ( [string isEqualToString:@"0"] || [string isEqualToString:@"1"] || [string isEqualToString:@"2"] || [string isEqualToString:@"3"] || [string isEqualToString:@"4"] || [string isEqualToString:@"5"] || [string isEqualToString:@"6"] || [string isEqualToString:@"7"] ||
        [string isEqualToString:@"8"] || [string isEqualToString:@"9"] || [string isEqualToString:@""] || [string isEqualToString:@"\n"]) {
        flag  = true;
    }
    else{
        flag = false;
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter only Number" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil] show];
    }
    
    
    return flag;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int digit  = textField.text.intValue;
    
    if ( digit > 255 ) {
        textField.text  = @"255";
    }
}

@end
