//
//  CompanyPanelView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "CompanyPanelView.h"
#import "AccountView.h"
#import "TeamView.h"
#import "ECMsView.h"
#import "AssetsView.h"
#import "SourcesView.h"
#import "GroupsView.h"

@implementation CompanyPanelView

+(CompanyPanelView*)ShowCompanyPanelView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CompanyPanelView" owner:self options:nil];
    CompanyPanelView* vw = [nib objectAtIndex:0];
    vw.layer.zPosition = 14;
    [vw Initialize];
    [vw setFrame:CGRectMake(1024, 20, vw.frame.size.width, vw.frame.size.height)];
    [parentView addSubview:vw];
    vw->vw_parent = parentView;
    [UIView animateWithDuration:0.5f animations:^{
        [vw setFrame:CGRectMake(1024 - vw.frame.size.width, vw.frame.origin.y, vw.frame.size.width, vw.frame.size.height)];
        vw.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:vw action:@selector(OnTapOutside:)];
        vw.tapGesture.cancelsTouchesInView = NO;
        [parentView addGestureRecognizer:vw.tapGesture];
        
    }];
    return vw;
}

-(void)Initialize
{
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(-5, 5);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    m_curTabIdx = 1;
    [self SelectTab:0];
}

-(void)SelectTab:(int)idx
{
    if (idx == m_curTabIdx)
        return;
    for(int i = 0; i < 4; i++)
    {
        if (i == idx)
        {
            [((UIImageView*)[imgs_nav objectAtIndex:i]) setHidden:NO];
            [((UIImageView*)[imgs_bgs objectAtIndex:i]) setHidden:NO];
            [((UIImageView*)[imgs_icons objectAtIndex:i]) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cp_icon_%@_selected.png", [self GetTabName:i].lowercaseString]]];
            [((UILabel*)[lbls_btnName objectAtIndex:i]) setTextColor:[UIColor colorWithRed:51.0f/255.0f green:145.0f/255.0f blue:180.0f/255.0f alpha:1]];
            
            [((UIImageView*)[imgs_separator objectAtIndex:0]) setCenter:CGPointMake(((UIImageView*)[imgs_separator objectAtIndex:0]).center.x, ((UIImageView*)[imgs_bgs objectAtIndex:i]).frame.origin.y)];
            [((UIImageView*)[imgs_separator objectAtIndex:1]) setCenter:CGPointMake(((UIImageView*)[imgs_separator objectAtIndex:1]).center.x, ((UIImageView*)[imgs_bgs objectAtIndex:i]).frame.origin.y + ((UIImageView*)[imgs_bgs objectAtIndex:i]).frame.size.height)];
        }
        else
        {
            [((UIImageView*)[imgs_nav objectAtIndex:i]) setHidden:YES];
            [((UIImageView*)[imgs_bgs objectAtIndex:i]) setHidden:YES];
            [((UIImageView*)[imgs_icons objectAtIndex:i]) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cp_icon_%@.png", [self GetTabName:i].lowercaseString]]];
            [((UILabel*)[lbls_btnName objectAtIndex:i]) setTextColor:[UIColor colorWithRed:172.0f/255.0f green:172.0f/255.0f blue:172.0f/255.0f alpha:1]];
        }
    }
    for(UIView* subView in vw_content.subviews)
        [subView removeFromSuperview];
    switch (idx) {
        case 0:
            [AccountView ShowView:vw_content];
            break;
        case 1:
            [TeamView ShowView:vw_content];
            break;
        case 2:
            [AssetsView ShowView:vw_content];
            break;
        case 3:
            [SourcesView ShowView:vw_content];
            break;
        default:
            break;
    }
    m_curTabIdx = idx;
}

-(IBAction)OnTab:(UIButton*)sender
{
    [self SelectTab:sender.tag];
}

-(IBAction)OnClose:(id)sender
{
    [self.tapGesture.view removeGestureRecognizer:self.tapGesture];
    [UIView animateWithDuration:0.5f animations:^{
        [self setFrame:CGRectMake(1024, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];        
    }];
}

-(NSString*)GetTabName:(int)idx
{
    NSString* ret = @"";
    switch (idx) {
        case 0:
            ret = @"Account";
            break;
        case 1:
            ret = @"Team";
            break;
        case 2:
            ret = @"Assets";
            break;
        case 3:
            ret = @"Sources";
            break;
        default:
            break;
    }
    return ret;
}

-(void)OnTapOutside:(UITapGestureRecognizer*)gesture
{
    if (CGRectContainsPoint(self.frame, [gesture locationInView:gesture.view]))
        return;
    [self OnClose:nil];
}
@end
