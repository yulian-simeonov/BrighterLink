//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "HowDetailView.h"

#import "SharedMembers.h"

@interface HowDetailView()

@end

@implementation HowDetailView

- (void) awakeFromNib
{
    [self setInfo];
}


-(void) setInfo
{
    //How
    bHowOne = false;
    bHowTwo = false;
    bHowThree = false;
    bHowFour = false;
    dataHowOne = @[@"3", @"4", @"5", @"6"];
    //How
    NSMutableArray* data12 = [[NSMutableArray alloc] init];
    m_ComboHowOne = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_how_one.frame.origin.x, _m_img_how_one.frame.origin.y + _m_img_how_one.frame.size.height, _m_img_how_one.frame.size.width, 100)];
    [m_ComboHowOne setDelegate:self];
    
    for( int i = 0; i < [dataHowOne count]; i++ )
        [ data12 addObject:@{@"text" : dataHowOne[i], @"id" : [NSString stringWithFormat:@"%d", i]} ];
    [m_ComboHowOne UpdateData:data12];
    [self addSubview:m_ComboHowOne];
    
    
    m_ComboHowTwo = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_how_two.frame.origin.x, _m_img_how_two.frame.origin.y + _m_img_how_two.frame.size.height, _m_img_how_two.frame.size.width, 100)];
    [m_ComboHowTwo setDelegate:self];
    [m_ComboHowTwo UpdateData:data12];
    [self addSubview:m_ComboHowTwo];
    
    m_ComboHowThree = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_how_three.frame.origin.x, _m_img_how_three.frame.origin.y + _m_img_how_three.frame.size.height, _m_img_how_three.frame.size.width, 100)];
    [m_ComboHowThree setDelegate:self];
    [m_ComboHowThree UpdateData:data12];
    [self addSubview:m_ComboHowThree];
    
    m_ComboHowFour = [[JSCombo alloc] initWithFrame:CGRectMake(_m_img_how_four.frame.origin.x, _m_img_how_four.frame.origin.y + _m_img_how_four.frame.size.height, _m_img_how_four.frame.size.width, 100)];
    [m_ComboHowFour setDelegate:self];
    [m_ComboHowFour UpdateData:data12];
    [self addSubview:m_ComboHowFour];
    
    [_m_txtVHow_One setDelegate:self];  _m_txtVHow_One.tag = 1;
    [_m_txtVHow_Two setDelegate:self];  _m_txtVHow_Two.tag = 2;
    [_m_txtVHow_Three setDelegate:self]; _m_txtVHow_Three.tag = 3;
    [_m_txtVHow_Four setDelegate:self]; _m_txtVHow_Four.tag = 4;
}

-(void)SelectedObject:(id)control selectedObj:(id)obj
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
    
    if ( [control isEqual: m_ComboHowOne] ) {
        [_m_txtHow_One setText: [obj objectForKey:@"text"]];
        info.param.widgetHowDoesSolarWorkStepOneText = _m_txtHow_One.text;
    }
    else if ( [control isEqual: m_ComboHowTwo] ){
        [_m_txtHow_Two setText: [obj objectForKey:@"text"]];
        info.param.widgetHowDoesSolarWorkStepTwoText = _m_txtHow_Two.text;
    }
    else if ( [control isEqual: m_ComboHowThree] ){
        [_m_txtHow_Three setText: [obj objectForKey:@"text"]];
        info.param.widgetHowDoesSolarWorkStepThreeText = _m_txtHow_Three.text;
    }
    else if ( [control isEqual: m_ComboHowFour] ){
        [_m_txtHow_Four setText: [obj objectForKey:@"text"]];
        info.param.widgetHowDoesSolarWorkStepFourText = _m_txtHow_Four.text;
    }
}

//How
- (IBAction) on_pHow_One:(id)sender
{
    bHowOne = !bHowOne;
    
    if ( bHowOne ) {
        [m_ComboHowOne setHidden:false];
    }
    else{
        [m_ComboHowOne setHidden:true];
    }
}

- (IBAction) on_pHow_Two:(id)sender
{
    bHowTwo = !bHowTwo;
    
    if( bHowTwo ){
        [m_ComboHowTwo setHidden:false];
    }
    else{
        [m_ComboHowTwo setHidden:true];
    }
}

- (IBAction) on_pHow_Three:(id)sender
{
    bHowThree = !bHowThree;
    
    if ( bHowThree ) {
        [m_ComboHowThree setHidden:false];
    }
    else{
        [m_ComboHowThree setHidden:true];
    }
}

- (IBAction) on_pHow_Four:(id)sender
{
    bHowFour = !bHowFour;
    
    if ( bHowFour ) {
        [m_ComboHowFour setHidden:false];
    }
    else{
        [m_ComboHowFour setHidden:true];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_ComboHowOne setHidden:true];
    [m_ComboHowTwo setHidden: true];
    [m_ComboHowThree setHidden: true];
    [m_ComboHowFour setHidden: true];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ReceiveComboHidden"
     object:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    PWidgetInfo * info  = [SharedMembers sharedInstance].curWidget;
        
    int tag = textView.tag;

    switch ( tag ) {
        case 1:
            info.param.widgetHowDoesSolarWorkStepOneText = textView.text;
            break;
        case  2:
            info.param.widgetHowDoesSolarWorkStepTwoText = textView.text;
            break;
        case 3:
            info.param.widgetHowDoesSolarWorkStepThreeText = textView.text;
            break;
        case 4:
            info.param.widgetHowDoesSolarWorkStepFourText = textView.text;
            break;
        default:
            break;
    }    
}

@end
