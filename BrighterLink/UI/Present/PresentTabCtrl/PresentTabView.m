//
//  DashboardPanelView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "PresentTabView.h"

#import "SharedMembers.h"
#import "LineCell.h"
#import "EditorCell.h"
#import "SharedMembers.h"

#import "PresentationInfo.h"
#import "EditorInfo.h"
#import "PresentationTemplates.h"

@interface PresentTabView()

@end

@implementation PresentTabView

#define WIDGET_BTN_WIDTH  188
#define WIDGET_BTN_HEIGHT  46


- (void) awakeFromNib
{
    [self onSelectTab:0];
    [_m_table_Presentations setTag:0];
    [_m_table_Editor setTag:1];
    
    bBlank = true;
    
    m_vTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDGET_BTN_WIDTH, WIDGET_BTN_HEIGHT)];
    [m_vTemp setBackgroundColor:[UIColor redColor]];
    
    m_bCreated = false;
    
    [self SelectTab:0];
    
    //create view
    
    [_m_lTemplateName setHidden:true];
    [_m_lTemplateDes setHidden:true];
    [_m_txtTemplateDes setHidden:true];
    [_m_btn_Check setHidden: true];
    
    [_m_img_divider setFrame:CGRectMake(25, 273, 193, 1)];
    [_m_btn_CreatePresentation setFrame:CGRectMake(36, 262, 110, 20)];
    [_m_btn_Cancel setFrame:CGRectMake( 159, 262, 51, 20)];

    m_bTemplateChk = false; bBlank = true;
    
    m_nSelectedTemplateIdx = 0; [_m_pTemplate setHidden:true]; [_m_pTemplate setBackgroundColor:[UIColor lightGrayColor]];
    
    m_nType = 0;


    m_arrPresentTemp = [[NSMutableArray alloc] init];
    m_arrEditorTemp = [[NSMutableArray alloc] init];
    
    
    [_m_txt_Editor_search setDelegate:self];
    [_m_txt_Presentations_search setDelegate:self];
    [_m_txt_Data_search setDelegate:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_m_txtClone setHidden:true];
    [_m_imgClone setHidden:true];
    
    [_m_img_divider setFrame:CGRectMake(25, 273, 193, 1)];
    [_m_btn_CreatePresentation setFrame:CGRectMake(36, 262-5, 110, 30)];
    [_m_btn_Cancel setFrame:CGRectMake( 159, 262-5, 51, 30)];
    
    [_m_img_new_bg setFrame:CGRectMake( _m_img_new_bg.frame.origin.x, _m_img_new_bg.frame.origin.y, _m_img_new_bg.frame.size.width, _m_btn_Cancel.frame.origin.y + _m_btn_Cancel.frame.size.height - 70)];

    
    vw_tags = [TagsPanelView ShowView:self];
    [vw_tags setFrame:CGRectMake(80, 65, vw_tags.frame.size.width, vw_tags.frame.size.height)];
    [vw_tags setHidden:YES];
    
    [self addSubview:_m_img_Mask];
    [_m_img_Mask setFrame:CGRectMake(0, 65, vw_tags.frame.size.width + 83, vw_tags.frame.size.height)];
   [_m_img_Mask setHidden:true];

}

- (void) showMask:(BOOL) flag
{
    [_m_img_Mask setHidden: !flag];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if( _m_vPresentations.isHidden == false )
    {
        //Get location of the swipe
        CGPoint location = [gestureRecognizer locationInView:_m_table_Presentations];
        
        //Get the corresponding index path within the table view
        NSIndexPath *indexPath = [_m_table_Presentations indexPathForRowAtPoint:location];
        
        //Check if index path is valid
        if(indexPath)
        {
            PresentationInfo * info =  (PresentationInfo*)m_arrPresentTemp[indexPath.row];
            info->m_bSelected = true;
            [_m_table_Presentations reloadData];
        }
    }
    else if( _m_vEditors.isHidden  == false ){
        //Get location of the swipe
        CGPoint location = [gestureRecognizer locationInView:_m_table_Editor];
        
        //Get the corresponding index path within the table view
        NSIndexPath *indexPath = [_m_table_Editor indexPathForRowAtPoint:location];
        
        //Check if index path is valid
        if(indexPath)
        {
            EditorInfo * info  = (EditorInfo*)m_arrEditorTemp[indexPath.row];
            info->m_bSelected = true;
            
            [_m_table_Editor reloadData];
        }
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if( _m_vPresentations.isHidden == false )
    {
        //Get location of the swipe
        CGPoint location = [gestureRecognizer locationInView:_m_table_Presentations];
        
        //Get the corresponding index path within the table view
        NSIndexPath *indexPath = [_m_table_Presentations indexPathForRowAtPoint:location];
        
        //Check if index path is valid
        if(indexPath)
        {
            //Get the cell out of the table view
            PresentationInfo * info =  (PresentationInfo*)m_arrPresentTemp[indexPath.row];
            info->m_bSelected = false;
            
            [_m_table_Presentations reloadData];
        }
    }
    else if( _m_vEditors.isHidden  == false ){
        //Get location of the swipe
        CGPoint location = [gestureRecognizer locationInView:_m_table_Editor];
        
        //Get the corresponding index path within the table view
        NSIndexPath *indexPath = [_m_table_Editor indexPathForRowAtPoint:location];
        
        //Check if index path is valid
        if(indexPath)
        {
            EditorInfo * info  = (EditorInfo*)m_arrEditorTemp[indexPath.row];
            info->m_bSelected = false;
            
            [_m_table_Editor reloadData];

        }
    }
}

- (void) setRefresh
{
//    if ([[SharedMembers sharedInstance].arrTemplates count] == 0) {
//        return;
//    }
    switch ( m_nType ) {
        case 1:
            [self GetRealArr: _m_txt_Presentations_search.text];
            break;
        case 2:
            [self GetRealArr: _m_txt_Editor_search.text];
            break;
        case 3:
            [self GetRealArr: _m_txt_Data_search.text];
            break;
        default:
            break;
    }

    [_m_table_Editor reloadData];
    [_m_table_Presentations reloadData];
    
//    PresentationTemplates * temple  = [[SharedMembers sharedInstance].arrTemplates objectAtIndex: 0];
//    [_m_lTemplateName setText: temple.name];
//    [_m_lTemplateDes setText: temple.description];
//    [_m_pTemplate setHidden:true];
    m_nSelectedTemplateIdx  = 0;
    
//    [_m_pTemplate reloadAllComponents];
    
    [self cleanWidgetMarkImg];
    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
    for ( PWidgetInfo * widget in info.m_widgets )
    {
        UIColor * color  = [widget.param colorFromHexString: widget.timeline.backgroundColor];
        
        if ( [widget.name isEqualToString:@"Graph"] ) {
            [_m_img_graph_mark setBackgroundColor: color];
        }else if ( [widget.name isEqualToString:@"Energy Equivalencies"]){
            [_m_img_energy_mark setBackgroundColor: color];
        }else if ( [widget.name isEqualToString:@"How Does Solar Work"]) {
            [_m_img_how_mark setBackgroundColor:  color];
        }else if ( [widget.name isEqualToString:@"iFrame"]){
            [_m_img_iframe_mark setBackgroundColor: color];
        }else if ( [widget.name isEqualToString:@"Image"]){
            [_m_img_image_mark setBackgroundColor: color];
        }else if ( [widget.name isEqualToString:@"Solar Generation"]){
            [_m_img_solar_mark setBackgroundColor: color];
        }else if ( [widget.name isEqualToString:@"TextArea"]){
            [_m_img_textarea_mark setBackgroundColor: color];
        }else if ( [widget.name isEqualToString: @"Weather"]){
            [_m_img_weather_mark setBackgroundColor: color];
        }
    }
}

-(IBAction)OnTab:(UIButton*)sender
{
    [self SelectTab:sender.tag];
}

-(NSString*)GetTabName:(int)idx
{
    NSString* ret = @"";
    switch (idx) {
        case 0:
            ret = @"widget";
            break;
        case 1:
            ret = @"presentations";
            break;
        case 2:
            ret = @"editor";
            break;
        case 3:
            ret = @"data";
            break;
        default:
            break;
    }
    return ret;
}

- (void) cleanWidgetMarkImg
{
    [_m_img_graph_mark setBackgroundColor:[UIColor clearColor]];
    [_m_img_energy_mark setBackgroundColor:[UIColor clearColor]];
    [_m_img_how_mark setBackgroundColor: [UIColor clearColor]];
    [_m_img_iframe_mark setBackgroundColor:[UIColor clearColor]];
    [_m_img_image_mark setBackgroundColor:[UIColor clearColor]];
    [_m_img_solar_mark setBackgroundColor:[UIColor clearColor]];
    [_m_img_textarea_mark setBackgroundColor:[UIColor clearColor]];
    [_m_img_weather_mark setBackgroundColor:[UIColor clearColor]];
}

-(void)SelectTab:(int)idx
{
/*  if (idx == m_curTabIdx)
        return;
*/
    for(int i = 0; i < 4; i++)
    {
        if (i == idx)
        {
            [((UIImageView*)[imgs_nav objectAtIndex:i]) setHidden:NO];
            [((UIImageView*)[imgs_bgs objectAtIndex:i]) setHidden:NO];
            [((UIImageView*)[imgs_icons objectAtIndex:i]) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_on.png", [self GetTabName:i].lowercaseString]]];
            [((UILabel*)[lbls_btnName objectAtIndex:i]) setTextColor:[UIColor colorWithRed:51.0f/255.0f green:145.0f/255.0f blue:180.0f/255.0f alpha:1]];
            
            [((UIImageView*)[imgs_separator objectAtIndex:0]) setCenter:CGPointMake(((UIImageView*)[imgs_separator objectAtIndex:0]).center.x, ((UIImageView*)[imgs_bgs objectAtIndex:i]).frame.origin.y)];
            [((UIImageView*)[imgs_separator objectAtIndex:1]) setCenter:CGPointMake(((UIImageView*)[imgs_separator objectAtIndex:1]).center.x, ((UIImageView*)[imgs_bgs objectAtIndex:i]).frame.origin.y + ((UIImageView*)[imgs_bgs objectAtIndex:i]).frame.size.height)];
        }
        else
        {
            [((UIImageView*)[imgs_nav objectAtIndex:i]) setHidden:YES];
            [((UIImageView*)[imgs_bgs objectAtIndex:i]) setHidden:YES];
            [((UIImageView*)[imgs_icons objectAtIndex:i]) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png", [self GetTabName:i].lowercaseString]]];
            [((UILabel*)[lbls_btnName objectAtIndex:i]) setTextColor:[UIColor colorWithRed:172.0f/255.0f green:172.0f/255.0f blue:172.0f/255.0f alpha:1]];
        }
    }
    

    switch (idx) {
        case 0:
        {
            [self onSelectTab:0];
            [self cleanWidgetMarkImg];
            PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
            for ( PWidgetInfo * widget in info.m_widgets )
            {
                UIColor * color  = [widget.param colorFromHexString: widget.timeline.backgroundColor];
                if ( [widget.name isEqualToString:@"Graph"] ) {
                    [_m_img_graph_mark  setBackgroundColor: color];
                }else if ( [widget.name isEqualToString:@"Energy Equivalencies"]){
                    [_m_img_energy_mark setBackgroundColor: color];
                }else if ( [widget.name isEqualToString:@"How Does Solar Work"]) {
                    [_m_img_how_mark setBackgroundColor:  color];
                }else if ( [widget.name isEqualToString:@"iFrame"]){
                    [_m_img_iframe_mark setBackgroundColor: color];
                }else if ( [widget.name isEqualToString:@"Image"]){
                    [_m_img_image_mark setBackgroundColor: color];
                }else if ( [widget.name isEqualToString:@"Solar Generation"]){
                    [_m_img_solar_mark setBackgroundColor: color];
                }else if ( [widget.name isEqualToString:@"TextArea"]){
                    [_m_img_textarea_mark setBackgroundColor: color];
                }else if ( [widget.name isEqualToString: @"Weather"]){
                    [_m_img_weather_mark setBackgroundColor: color];
                }
            }
            break;
        }
        case 1:
        {
            [self onSelectTab:1];
//            [_m_pTemplate reloadAllComponents];
//            if ( [[SharedMembers sharedInstance].arrTemplates count] > 0 ) {
//                PresentationTemplates * temple = [[SharedMembers sharedInstance].arrTemplates objectAtIndex:0];
//                [_m_lTemplateName setText: temple.name];
//            }
//            else
//                [_m_lTemplateName setText: @""];
            break;
        }
        case 2:
            [self onSelectTab:2];
            break;
        case 3:
            [self onSelectTab:3];
            break;
        default:
            break;
    }
}


- (void) onSelectTab:(int) idx{
    
    m_nType  = idx;
    switch ( idx) {
        case 0:{
            [_m_vWidget setHidden:false]; [_m_vWidget setUserInteractionEnabled:true];
            [_m_vPresentations setHidden:true]; [_m_vPresentations setUserInteractionEnabled:false];
            [_m_vEditors  setHidden:true]; [_m_vEditors setUserInteractionEnabled:false];
            [vw_tags setHidden:true]; [vw_tags setUserInteractionEnabled:false];
            [_m_vCreateNew setHidden: true]; [_m_vCreateNew setUserInteractionEnabled:false];

            [_m_btn_widget setBackgroundImage:[UIImage imageNamed:@"tab_highlight.png"] forState:UIControlStateNormal];
            [_m_btn_widget setAlpha:0.4];
            
            [_m_btn_presentations setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_presentations setAlpha:0.1];
            [_m_btn_editors setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_editors setAlpha:0.1];
            [_m_btn_data setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_data setAlpha:0.1];
        }
            break;
        case 1:
        {
            [_m_vWidget setHidden:true]; [_m_vWidget setUserInteractionEnabled:false];
            [_m_vPresentations setHidden:false]; [_m_vPresentations setUserInteractionEnabled:true];
            [_m_vEditors  setHidden:true]; [_m_vEditors setUserInteractionEnabled:false];
            [vw_tags setHidden:true]; [vw_tags setUserInteractionEnabled:false];
            [_m_vCreateNew setHidden: true]; [_m_vCreateNew setUserInteractionEnabled:false];

            [_m_btn_widget setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_widget setAlpha:0.1];
            
            [_m_btn_presentations setBackgroundImage:[UIImage imageNamed:@"tab_highlight.png"] forState:UIControlStateNormal];
            [_m_btn_presentations setAlpha:0.4];
            [_m_btn_editors setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_editors setAlpha:0.1];
            [_m_btn_data setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_data setAlpha:0.1];
            
            [self GetRealArr: _m_txt_Presentations_search.text];
            
            UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleSwipeLeft:)];
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];

            [_m_table_Presentations addGestureRecognizer:recognizer];
            
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(handleSwipeRight:)];
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];

            [_m_table_Presentations addGestureRecognizer:recognizer];
            
             [_m_table_Presentations reloadData];
        }
            break;
        case 2:
        {
            [_m_vWidget setHidden:true];    [_m_vWidget setUserInteractionEnabled:false];
            [_m_vPresentations setHidden:true]; [_m_vPresentations setUserInteractionEnabled:false];
            [_m_vEditors  setHidden:false]; [_m_vEditors setUserInteractionEnabled: true];
            [vw_tags setHidden:true]; [vw_tags setUserInteractionEnabled:false];
            [_m_vCreateNew setHidden: true]; [_m_vCreateNew setUserInteractionEnabled: false];
            
            [_m_btn_widget setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_widget setAlpha:0.1];
            [_m_btn_presentations setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_presentations setAlpha:0.1];
            [_m_btn_editors setBackgroundImage:[UIImage imageNamed:@"tab_highlight.png"] forState:UIControlStateNormal];
            [_m_btn_editors setAlpha:0.4];
            [_m_btn_data setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_data setAlpha:0.1];
            
            [self GetRealArr: _m_txt_Editor_search.text];
            
            UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleSwipeLeft:)];
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
            [_m_table_Editor addGestureRecognizer:recognizer];
            
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(handleSwipeRight:)];
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
            [_m_table_Editor addGestureRecognizer:recognizer];
            
            [_m_table_Editor reloadData];
        }
            break;
        case 3:
        {
            [_m_vWidget setHidden:true];  [_m_vWidget setUserInteractionEnabled:false];
            [_m_vPresentations setHidden:true]; [_m_vPresentations setUserInteractionEnabled:false];
            [_m_vEditors  setHidden:true]; [_m_vEditors setUserInteractionEnabled: false];
            [vw_tags setHidden:false]; [vw_tags setUserInteractionEnabled: true];
            [_m_vCreateNew setHidden: true]; [_m_vCreateNew setUserInteractionEnabled: false];

            [_m_btn_widget setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_widget setAlpha:0.1];
            [_m_btn_presentations setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_presentations setAlpha:0.1];
            [_m_btn_editors setBackgroundImage:nil forState:UIControlStateNormal];
            [_m_btn_editors setAlpha:0.1];
            [_m_btn_data setBackgroundImage:[UIImage imageNamed:@"tab_highlight.png"] forState:UIControlStateNormal];
            [_m_btn_data setAlpha:0.4];
        }
            break;
        case 4:
        {
            [_m_vWidget setHidden:true];  [_m_vWidget setUserInteractionEnabled:false];
            [_m_vPresentations setHidden:true]; [_m_vPresentations setUserInteractionEnabled: false];
            [_m_vEditors  setHidden:true]; [_m_vEditors setUserInteractionEnabled: false];
            [vw_tags setHidden:true]; [vw_tags setUserInteractionEnabled: false];
            [_m_vCreateNew setHidden: false]; [_m_vCreateNew setUserInteractionEnabled: true];
            
            [_m_btnBlank setBackgroundImage:[UIImage imageNamed:@"btn_blank_on.png"] forState:UIControlStateNormal];
            [_m_btnTemple setBackgroundImage:[UIImage imageNamed:@"btn_temple_off.png"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

//Tab bar
- (IBAction) onWidgets:(id)sender
{
    [self onSelectTab:0];
    m_nType = 0;
}

- (IBAction) onPresentations:(id)sender
{
    [self onSelectTab:1];
    
    m_nType = 1;
}

- (IBAction) onEditors:(id)sender
{
    [self onSelectTab:2];
    
    m_nType = 2;
}

- (IBAction) onData:(id)sender
{
    [self onSelectTab:3];
    
    m_nType = 3;
}

#pragma mark Create New Presentation


- (IBAction) onCreateNew:(id)sender
{
    [self onSelectTab:4];
    
    [self setTempleInfo];
}

- (IBAction) onBlank:(id)sender
{
    bBlank = true;
    
    [_m_btnBlank setBackgroundImage:[UIImage imageNamed:@"btn_blank_on.png"] forState:UIControlStateNormal];
    [_m_btnTemple setBackgroundImage:[UIImage imageNamed:@"btn_temple_off.png"] forState:UIControlStateNormal];
    
//    [_m_lTemplateName setHidden:true];
//    [_m_lTemplateDes setHidden:true];
//    [_m_txtTemplateDes setHidden:true];
//    [_m_btn_Check setHidden:true];
    
    if ( m_vTemplet )
    {
        [m_vTemplet setHidden:true];
    }

    
    [_m_img_divider setFrame:CGRectMake(25, 273, 193, 1)];
    [_m_btn_CreatePresentation setFrame:CGRectMake(36, 262-5, 110, 30)];
    [_m_btn_Cancel setFrame:CGRectMake( 159, 262-5, 51, 30)];
    
    [_m_img_new_bg setFrame:CGRectMake( _m_img_new_bg.frame.origin.x, _m_img_new_bg.frame.origin.y, _m_img_new_bg.frame.size.width, _m_btn_Cancel.frame.origin.y + _m_btn_Cancel.frame.size.height - 70)];
}

- (IBAction) onTemple:(id)sender
{
    bBlank = false;
    
    [_m_btnBlank setBackgroundImage:[UIImage imageNamed:@"btn_blank_off.png"] forState:UIControlStateNormal];
    [_m_btnTemple setBackgroundImage:[UIImage imageNamed:@"btn_temple_on.png"] forState:UIControlStateNormal];
    
//    [_m_lTemplateName setHidden:false];
//    [_m_lTemplateDes setHidden:false];
//    [_m_txtTemplateDes setHidden:false];
//    [_m_btn_Check setHidden:false];

    if ( m_vTemplet ) {
        [m_vTemplet setHidden:false];
    }
  
    int delta = m_nTempletHeight - 50;
    [_m_img_divider setFrame:CGRectMake(25, 358 + delta, 193, 1)];
    [_m_btn_CreatePresentation setFrame:CGRectMake(36, 342 + delta, 110, 30)];
    [_m_btn_Cancel setFrame:CGRectMake( 159, 342 + delta, 51, 30)];

    [_m_img_new_bg setFrame:CGRectMake( _m_img_new_bg.frame.origin.x, _m_img_new_bg.frame.origin.y, _m_img_new_bg.frame.size.width, _m_btn_Cancel.frame.origin.y + _m_btn_Cancel.frame.size.height + delta)];
}

- (void) setTempleInfo
{
    float oriX  = 37.f;
    float oriY  = 258.f;
    float nameHeight = 26.f;
    float desHeight  = 21.f;

    NSArray * arr  = [SharedMembers sharedInstance].arrTemplates;
    
    m_nTempletHeight = 0; // [arr count];
    m_vTemplet = [[UIView alloc] initWithFrame:CGRectMake(0, oriY-250, _m_vCreateNew.frame.size.width, m_nTempletHeight)];
    [m_vTemplet setBackgroundColor:[UIColor clearColor]];

    
    m_nTempletHeight = 0;
    float txtHeight = 70;
    int total = [arr count];
    if ( total >= 5 ) {
        total = 5;
    }
    for ( int i = 0 ; i < total; i++ )
    {
        PresentationTemplates * temple  = (PresentationTemplates*)[arr objectAtIndex: i];
        [_m_lTemplateName setText: temple.name];

        UILabel * name  = [[UILabel alloc] initWithFrame:CGRectMake(oriX, oriY+m_nTempletHeight, 150, nameHeight)];
        [name setText: temple.name];
        [name setFont:[UIFont systemFontOfSize:14]];
        [name setTextColor:[UIColor colorWithRed:0 green:128.f/255.f blue:185.f/255.f alpha:1]];
        [m_vTemplet addSubview: name];
        
        UILabel * des   = [[UILabel alloc] initWithFrame:CGRectMake(oriX,  oriY + 26 + m_nTempletHeight, 150, desHeight)];
        [des setText: @"Description:"];
        [des setFont: [UIFont systemFontOfSize:12]];
        [des setTextColor:[UIColor lightGrayColor]];
        [m_vTemplet addSubview: des];
        
        UITextView * txt  = [[UITextView alloc] initWithFrame:CGRectMake(oriX, oriY + 46 + m_nTempletHeight, 150, 34)];
        [txt setFont:[UIFont systemFontOfSize:12]];
        [txt setBackgroundColor:[UIColor clearColor]];
        [txt setTextColor:[UIColor lightGrayColor]];

        if ( [temple.des isEqual:[NSNull null]] ) {
            txtHeight = 50;
        }else{
            txtHeight = 70;
            [txt setText: temple.des];
            [m_vTemplet addSubview: txt];
        }
        
        UIButton * btnEdit      = [[UIButton alloc] initWithFrame:CGRectMake( 160, oriY + m_nTempletHeight + 10, 50, 50)];
        [btnEdit addTarget: self action:@selector(onCheckTemplate:) forControlEvents:UIControlEventTouchUpInside];
        [btnEdit setImage:[UIImage imageNamed:@"login_btn_uncheck.png"] forState:UIControlStateNormal];
        btnEdit.tag = i;
        
        [m_vTemplet addSubview:btnEdit];

        UIImageView * imgLine  = [[UIImageView alloc] initWithFrame:CGRectMake(oriX, (oriY + txtHeight) + m_nTempletHeight, 160, 1)];
        [imgLine setBackgroundColor:[UIColor blackColor]];
        [m_vTemplet addSubview: imgLine];
        m_nTempletHeight += txtHeight;
        
    }
    [_m_vCreateNew addSubview: m_vTemplet];
    [m_vTemplet setHidden: true];
}

- (void) onCheckTemplate:(id) sender
{
    for ( UIView * v in [m_vTemplet subviews] ) {
        if ( [v isKindOfClass:[UIButton class]] ) {
            UIButton * btn = (UIButton*)v;
            [btn setImage:[UIImage imageNamed:@"login_btn_uncheck.png"] forState:UIControlStateNormal];
        }
    }
    
    UIButton * btn = (UIButton*) sender;
    [btn setImage: [UIImage imageNamed:@"login_btn_check.png"] forState:UIControlStateNormal];
    m_nSelectedTemplateIdx = btn.tag;
}

- (IBAction) onTemplateCheck:(id)sender
{
    if( [_m_lTemplateName.text isEqual:@""] )
        return;
    
    UIButton * btn  = (UIButton*) sender;
    
    m_bTemplateChk = !m_bTemplateChk;
    
    if ( m_bTemplateChk ) {
        [btn setImage: [UIImage imageNamed:@"btn_chk_on.png"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage: [UIImage imageNamed:@"btn_chk_off.png"] forState:UIControlStateNormal];
    }
}

- (IBAction) onCreatePresentation:(id)sender
{
    [self onSelectTab:1];
    
    NSString * str  = _m_txtNewPresentName.text;
    id<PresentTabDelegate> Delegate = self.delegate;
    if ( [str isEqual:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please fill Presentation Name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString * m_id  = @"";
    if ( !bBlank ) {
        PresentationTemplates * temple;
        if ( [[SharedMembers sharedInstance].arrTemplates count] > 0) {
            temple = [[SharedMembers sharedInstance].arrTemplates objectAtIndex:m_nSelectedTemplateIdx];
            m_id = temple._id;
        }
    }
    
    [Delegate createPresentation:str id: m_id];
}

- (IBAction) onCancel:(id)sender
{
    [self onSelectTab:1];
}


- (IBAction) onSelectTemplate:(id)sender
{
//    if ( _m_pTemplate.isHidden ) {
//        [_m_pTemplate setHidden:false];
//    }
//    else
//        [_m_pTemplate setHidden:true];
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return  [[SharedMembers sharedInstance].arrTemplates count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PresentationTemplates * temple = [[SharedMembers sharedInstance].arrTemplates objectAtIndex: row];
    return temple.name;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    PresentationTemplates * temple  = [[SharedMembers sharedInstance].arrTemplates objectAtIndex: row];
    [_m_lTemplateName setText: temple.name];
//    [_m_lTemplateDes setText: temple.description];
    [_m_pTemplate setHidden:true];
    m_nSelectedTemplateIdx  = row;
}


#pragma mark Table View
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int nTag  = tableView.tag;
    int height = 0;
    
    if ( nTag == 0 ) {
        height = 74.0f;
    }
    else if ( nTag  == 1 ){
        height  = 77.0f;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    int nTag = tableView.tag;
    int nCount = 0;
    if ( nTag == 0 ) {
        nCount =  [m_arrPresentTemp count];
    }
    else if ( nTag == 1 ){
        nCount  =  [m_arrEditorTemp count];
    }
    
    return nCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int nTag = tableView.tag;
    if ( nTag == 0 ) {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        LineCell *cell = (LineCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSString * nibCell = @"LineCell";
            NSArray *nib  = [[NSBundle mainBundle] loadNibNamed: nibCell owner:self options:nil];
            cell = (LineCell*)[nib objectAtIndex:0];
        }
        PresentationInfo * info =  (PresentationInfo*)m_arrPresentTemp[indexPath.row];
        
        NSString * date  = info.createdDate;
        NSArray * arr = [date componentsSeparatedByString:@"-"];
        NSString * sub  = arr[2];
        NSArray * arr1 = [sub componentsSeparatedByString:@"T"];
        
        date = [NSString stringWithFormat:@"%@/%@/%@", arr[1], arr1[0], arr[0]];
        
        if ( info->m_bSelected == false ) {
            [cell.m_btnRemove setHidden:true];
        }
        else{
            [cell.m_btnRemove setHidden:false];
        }

        cell->index = indexPath.row; [cell setDelegate:self];
        [cell setinfo: info.name  Creator:[NSString stringWithFormat:@"Creator: %@; Created Date: %@", info.creatorName, date ] Duration:[NSString stringWithFormat:@"Duration: %d sec", [info.duration integerValue] ]];
        
        return  cell;
    }
    else if ( nTag  == 1 ){
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        EditorCell *cell = (EditorCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            
            NSString * nibCell = @"EditorCell";
            NSArray *nib  = [[NSBundle mainBundle] loadNibNamed: nibCell owner:self options:nil];
            cell = (EditorCell*)[nib objectAtIndex:0];
        }
        EditorInfo * info  = (EditorInfo*)m_arrEditorTemp[indexPath.row];
        [cell setInfo:nil Name:info.name URL:info.email];
        
        if ( info->m_bSelected ) {
            [cell.m_btnRemove setHidden: false];
        }
        else{
            [cell.m_btnRemove setHidden: true];
        }
        
        
        if ( info->m_bAdded ) {
            [cell.m_imgMask setHidden:true];
            [cell.m_btnRemove setImage:[UIImage imageNamed:@"edit_close.png"] forState:UIControlStateNormal];
            cell->m_bAdded = true;
        }
        else{
            [cell.m_imgMask setHidden:false];
            [cell.m_btnRemove setImage:[UIImage imageNamed:@"icon_add.png"] forState:UIControlStateNormal];
            cell->m_bAdded = false;
//icon_add            
        }
        
        [cell setEditorInfo:info Index:indexPath.row];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        return  cell;
    }
    return nil;
}

- (void) onReloadData:(NSString*) _id Index:(int)idx
{
    PresentationInfo * info = [SharedMembers sharedInstance].curPresent;
    if ( [info._id isEqualToString:_id] ) {

        id<PresentTabDelegate> Delegate = self.delegate;

        if ( [[SharedMembers sharedInstance].arrAllPresentations count] <= idx ) {
            idx = 0;
        }

        PresentationInfo * info = [[SharedMembers sharedInstance].arrAllPresentations objectAtIndex:idx];
        [Delegate GetPresentation: info._id];
        [Delegate setCurTime:0.0f];

    }
    else
    {
        [self GetRealArr:_m_txt_Presentations_search.text];
        [_m_table_Presentations reloadData];
        [[NSNotificationCenter defaultCenter]         postNotificationName:@"HideProgress"         object:self];
    }
}

#pragma mark -
#pragma mark Table view delegate
- (void) selectRowAtIndexPath:(id) sender {
    
    
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition{
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nTag = tableView.tag;
    if ( nTag == 0 ) {
        id<PresentTabDelegate> Delegate = self.delegate;
        PresentationInfo * info = [[SharedMembers sharedInstance].arrAllPresentations objectAtIndex:indexPath.row];
  
        [Delegate GetPresentation: info._id];
        [Delegate setCurTime:0.0f];
        
        [[NSNotificationCenter defaultCenter]         postNotificationName:@"ShowProgress"         object:self];

    }
    else if ( nTag  == 1 ){
        
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    
    if (  _m_vWidget.isHidden == false ) {
        CGPoint touchLoc = [touch locationInView: _m_vWidget];
        CGPoint pt  = CGPointMake(0, 0);
        
        id<PresentTabDelegate> Delegate = self.delegate;
        if ( CGRectContainsPoint( _m_img_Weather.frame, touchLoc)) {
            pt = _m_img_Weather.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 0 Point: pt];
        }
        else if ( CGRectContainsPoint( _m_img_Graph.frame, touchLoc)){
            pt = _m_img_Graph.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 1 Point: pt];
        }
        else if ( CGRectContainsPoint( _m_img_Energy.frame, touchLoc)){
            pt = _m_img_Energy.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 2 Point: pt];
        }
        else if ( CGRectContainsPoint( _m_img_How.frame, touchLoc)){
            pt = _m_img_How.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 3 Point: pt];
        }
        else if ( CGRectContainsPoint( _m_img_Frame.frame, touchLoc)){
            pt = _m_img_Frame.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 4 Point: pt];
        }
        else if (CGRectContainsPoint( _m_img_Image.frame, touchLoc)){
            pt = _m_img_Image.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 5 Point: pt];
        }
        else if ( CGRectContainsPoint( _m_img_Solar.frame, touchLoc)){
            pt = _m_img_Solar.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 6 Point: pt];
        }
        else if ( CGRectContainsPoint( _m_img_TextArea.frame, touchLoc)){
            pt = _m_img_TextArea.center; pt.x += 71; pt.y += 84;
            [Delegate onClickWidgetButtons : 7 Point: pt];
        }
        else if ( CGRectContainsPoint( _m_imgQuestionMark.frame,  touchLoc)){
            [_m_txtClone setHidden:false];
            [_m_imgClone setHidden:false];
        }
        
    }
    else if ( _m_vCreateNew.isHidden  == false ){
        if ( m_vTemplet.isHidden == false ) {
            CGPoint touchLoc = [touch locationInView: m_vTemplet];

            for ( UIView * v in [m_vTemplet subviews] ) {
                if ( [v isKindOfClass:[UIButton class]] ) {
                    
                    if ( CGRectContainsPoint( v.frame, touchLoc)) {
                        UIButton * btn = (UIButton*) v;
                        [btn setImage: [UIImage imageNamed:@"login_btn_check.png"] forState:UIControlStateNormal];
                        m_nSelectedTemplateIdx = btn.tag;
                    }
                    else
                    {
                        UIButton * btn = (UIButton*)v;
                        [btn setImage:[UIImage imageNamed:@"login_btn_uncheck.png"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    if (_m_vWidget.isHidden == false ) {
        CGPoint touchLoc = [touch locationInView: _m_vWidget];
        CGPoint pt  = CGPointMake(touchLoc.x + 71, touchLoc.y + 84);
        id<PresentTabDelegate> Delegate = self.delegate;
        [Delegate onMoveWidget:pt];
    }
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    if (_m_vWidget.isHidden == false ) {
        CGPoint touchLoc = [touch locationInView: _m_vWidget];
        id<PresentTabDelegate> Delegate = self.delegate;
        if ( touchLoc.x > 353 && touchLoc.x < 852 && touchLoc.y > 138 && touchLoc.y < 403) {
            CGPoint pt  = CGPointMake(touchLoc.x + 71, touchLoc.y + 84);
            
            [Delegate onDropWidget:pt];
        }
        else
            [Delegate onCancelWidget];
    }
    
    [_m_txtClone setHidden:true];
    [_m_imgClone setHidden:true];

}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    if (_m_vWidget.isHidden == false ) {
        CGPoint touchLoc = [touch locationInView: _m_vWidget];
        id<PresentTabDelegate> Delegate = self.delegate;
        if ( touchLoc.x > 353 && touchLoc.x < 852 && touchLoc.y > 138 && touchLoc.y < 403) {
            CGPoint pt  = CGPointMake(touchLoc.x + 71, touchLoc.y + 84);
            [Delegate onDropWidget:pt];
        }
        else
            [Delegate onCancelWidget];
    }
    
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    [self GetRealArr: textField.text];
//    
//    [textField resignFirstResponder];
//    return NO;
//}


-(void)onKeyboardHide:(NSNotification *)notification
{
    //keyboard will hide
    switch ( m_nType ) {
        case 1:
            [self GetRealArr: _m_txt_Presentations_search.text];
            break;
        case 2:
            [self GetRealArr: _m_txt_Editor_search.text];
            break;
        case 3:
            [self GetRealArr: _m_txt_Data_search.text];
            break;
        default:
            break;
    }
    
    [_m_txt_Data_search resignFirstResponder];
    [_m_txt_Presentations_search resignFirstResponder];
    [_m_txt_Editor_search resignFirstResponder];
}

- (void) GetRealArr:(NSString*) search
{
    [m_arrPresentTemp removeAllObjects];
    [m_arrEditorTemp removeAllObjects];
    
    NSString * sSearch = search.lowercaseString;
    
    switch ( m_nType ) {
        case  1:
        {
            NSMutableArray * presentations  = [SharedMembers sharedInstance].arrAllPresentations;
            if ( [sSearch isEqualToString:@""] ) {
                for ( int i = 0; i < [presentations count]; i++ ) {
                    PresentationInfo * info  = [presentations objectAtIndex:i];
                    [m_arrPresentTemp addObject:info];
                }
            }
            for ( int i = 0; i < [presentations count]; i++ ) {
                PresentationInfo * info  = [presentations objectAtIndex:i];
                if ([info.name.lowercaseString rangeOfString:sSearch].location==NSNotFound) {
                }else
                {
                    [m_arrPresentTemp addObject: info];
                }
            }
            
            [_m_table_Presentations reloadData];
        }
            break;
        case 2:
        {
            NSMutableArray * editors  = [SharedMembers sharedInstance].arrEditors;
            if ( [search isEqualToString:@""] ) {
                for ( int i = 0; i < [editors count]; i++ ) {
                    EditorInfo * info  = [editors objectAtIndex:i];
                    [m_arrEditorTemp addObject: info];
                }
            }
            for ( int i = 0; i < [editors count]; i++ ) {
                EditorInfo * info  = [editors objectAtIndex:i];
                if ([info.name.lowercaseString rangeOfString:sSearch].location==NSNotFound){
                } else {
                    [m_arrEditorTemp addObject: info];
                }
            }
            [_m_table_Editor reloadData];
        }
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    //keyboard will hide
    switch ( m_nType ) {
        case 1:
        {
            NSString * s = [NSString stringWithFormat:@"%@%@", _m_txt_Presentations_search.text, string];
            [self GetRealArr: s];
        }
            break;
        case 2:
        {
            NSString * s = [NSString stringWithFormat:@"%@%@", _m_txt_Editor_search.text, string];
            [self GetRealArr: s];
        }
            break;
        case 3:
        {
            NSString * s = [NSString stringWithFormat:@"%@%@", _m_txt_Data_search.text, string];
            [self GetRealArr: s];
        }
            break;
        default:
            break;
    }

    return true;
}


@end
