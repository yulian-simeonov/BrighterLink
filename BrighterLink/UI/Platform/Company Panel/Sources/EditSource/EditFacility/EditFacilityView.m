//
//  EditFacilityView.m
//  BrighterLink
//
//  Created by mobile master on 11/10/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "EditFacilityView.h"

@implementation EditFacilityView

+(EditFacilityView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EditFacilityView" owner:self options:nil];
    EditFacilityView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
}

-(void)UpdateWithData:(Tag*)tag
{
    m_tag = tag;
    [txt_fName setText:m_tag.name];
    NSMutableString* strAddress = [[NSMutableString alloc] init];
    if (m_tag.street.length > 0)
        [strAddress appendFormat:@"%@\n", m_tag.street];
    if (m_tag.city.length > 0)
        [strAddress appendFormat:@"%@\n", m_tag.city];
    if (m_tag.state.length > 0)
        [strAddress appendFormat:@"%@\n", m_tag.state];
    if (m_tag.country.length > 0)
        [strAddress appendFormat:@"%@\n", m_tag.country];
    [txt_fAddress setText:strAddress];
    [txt_fUtilityProvider setText:m_tag.utilityProvider];
    [txt_fTaxId setText:m_tag.taxID];
    [txt_fUtilityAccount setText:[m_tag.utilityAccounts componentsJoinedByString:@","]];
}
    
-(IBAction)OnBack:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)OnUpdate:(id)sender
{
    if(txt_fName.text.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please put the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    m_tag.name = txt_fName.text;
    NSArray* address = [txt_fAddress.text componentsSeparatedByString:@"\n"];
    if (address.count > 0)
        m_tag.street = [address objectAtIndex:0];
    if (address.count > 1)
        m_tag.city = [address objectAtIndex:1];
    if (address.count > 2)
        m_tag.state = [address objectAtIndex:2];
    if (address.count > 3)
        m_tag.country = [address objectAtIndex:3];
    m_tag.utilityProvider = txt_fUtilityProvider.text;
    m_tag.taxID = txt_fTaxId.text;
    m_tag.utilityAccounts = [txt_fUtilityAccount.text componentsSeparatedByString:@","];
    [JSWaiter ShowWaiter:self title:@"Updating..." type:0];
    [m_tag UpdateTag:^(MKNetworkOperation *networkOperation) {
        [JSWaiter HideWaiter];
        [self OnBack:nil];
        [_delegate SetTagData:m_tag];
    } failed:nil];
}
@end
