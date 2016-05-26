//
//  SourceDetailView.m
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "FacilityDetailView.h"
#import "SourcesView.h"
#import "SharedMembers.h"

@implementation FacilityDetailView

+(FacilityDetailView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"FacilityDetailView" owner:self options:nil];
    FacilityDetailView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_edit.layer.borderWidth = 1;
    btn_edit.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
    {
        [btn_edit setHidden:YES];
        [btn_delete setHidden:YES];
    }
}

-(IBAction)OnEdit:(id)sender
{
    [_delegate OnEditSource:m_tag delegate:self];
}

-(void)SetTagData:(Tag*)tg
{
    m_tag = tg;
    [lbl_name setText:m_tag.name];
    [lbl_address setText:@"Not specified"];
    if (m_tag.street.length > 0 && m_tag.city.length > 0 && m_tag.state.length > 0 && m_tag.country.length > 0)
        [lbl_address setText:[NSString stringWithFormat:@"%@ %@ %@ %@", m_tag.street, m_tag.city, m_tag.state, m_tag.country]];
    if (m_tag.taxID.length > 0)
        [lbl_taxId setText:m_tag.taxID];
    else
        [lbl_taxId setText:@"Default"];
    if (m_tag.utilityProvider.length > 0)
        [lbl_utilityProvider setText:m_tag.utilityProvider];
    else
        [lbl_utilityProvider setText:@"Default"];
    if (m_tag.utilityAccounts.count > 0)
    {
        NSString* utilityAccounts = [m_tag.utilityAccounts objectAtIndex:0];
        for(int i = 1; i < m_tag.utilityAccounts.count; i++)
        {
            utilityAccounts = [NSString stringWithFormat:@"%@, %@", utilityAccounts, [m_tag.utilityAccounts objectAtIndex:i]];
        }
        [lbl_utilityAccount setText:utilityAccounts];
    }
    [btn_delete setHidden:NO];
    if (m_tag.childrenTags)
    {
        if (m_tag.childrenTags.count > 0)
            [btn_delete setHidden:YES];
    }
}

-(IBAction)OnDelete:(id)sender
{
    [JSWaiter ShowWaiter:_delegate title:@"Deleting..." type:0];
    [m_tag DeleteTag:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [_delegate OnBack:nil];
    } failed:nil];
}
@end
