//
//  FacilityCell.m
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "FacilityCell.h"
#import "SourcesView.h"

@implementation FacilityCell

-(void)SetTagData:(Tag*)tg
{
    m_tag = tg;
    [lbl_name setText:tg.name];
    [lbl_detail setText:@"Not specified"];
    if (m_tag.street.length > 0 && m_tag.city.length > 0 && m_tag.state.length > 0 && m_tag.country.length > 0)
        [lbl_detail setText:[NSString stringWithFormat:@"%@, %@, %@, %@", m_tag.street, m_tag.city, m_tag.state, m_tag.country]];
}

-(IBAction)OnSelect:(id)sender
{
    [_delegate DidSelectRowWithObject:m_tag];
}

@end
