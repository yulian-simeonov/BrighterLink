//
//  DashboardPanelView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSWaiter.h"
#import "WebManager.h"
#import "JSCombo.h"



@interface HowDetailView : UIView<JSComboDelegate, UITextViewDelegate>
{
    
    //How
    BOOL bHowOne;
    BOOL bHowTwo;
    BOOL bHowThree;
    BOOL bHowFour;
    
    
    NSArray * dataHowOne;
    //How
    JSCombo * m_ComboHowOne;
    JSCombo * m_ComboHowTwo;
    JSCombo * m_ComboHowThree;
    JSCombo * m_ComboHowFour;
    
    
 
}

//How Items

@property (nonatomic, weak) IBOutlet UITextView   * m_txtVHow_One;

@property (nonatomic, weak) IBOutlet UITextField  * m_txtHow_One;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_how_one;

@property (nonatomic, weak) IBOutlet UITextView   * m_txtVHow_Two;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtHow_Two;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_how_two;

@property (nonatomic, weak) IBOutlet UITextView   * m_txtVHow_Three;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtHow_Three;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_how_three;

@property (nonatomic, weak) IBOutlet UITextView   * m_txtVHow_Four;
@property (nonatomic, weak) IBOutlet UITextField  * m_txtHow_Four;
@property (nonatomic, weak) IBOutlet UIImageView  * m_img_how_four;



- (IBAction) on_pHow_One:(id)sender;
- (IBAction) on_pHow_Two:(id)sender;
- (IBAction) on_pHow_Three:(id)sender;
- (IBAction) on_pHow_Four:(id)sender;


@end
