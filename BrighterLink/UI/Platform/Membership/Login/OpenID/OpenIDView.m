//
//  OpenIDView.m
//  BrighterLink
//
//  Created by apple developer on 2/21/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//
// http://openid.yandex.ru/berckyt666

#import "OpenIDView.h"

@implementation OpenIDView

+(OpenIDView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"OpenIDView" owner:self options:nil];
    OpenIDView* vw = [nib objectAtIndex:0];
    [parentView addSubview:vw];
    [vw Initialize];
    return vw;
}

-(void)Initialize
{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnClose:)];
    [img_bg addGestureRecognizer:gesture];
    
    vw_content.layer.cornerRadius = 5;
    vw_content.layer.shadowOffset = CGSizeMake(-5, 5);
    vw_content.layer.shadowRadius = 5;
    vw_content.layer.shadowOpacity = 0.5;
    
    txt_url.layer.borderWidth = 1;
    txt_url.layer.borderColor = [UIColor blackColor].CGColor;
    
    btn_login.layer.borderWidth = 1;
    btn_login.layer.borderColor = [UIColor blackColor].CGColor;
}

-(IBAction)OnClose:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)OnLogin:(id)sender
{
    NSString* callBackUrl = @"blmobileOneAll://";
    NSString* nonce = [[NSUUID UUID] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:nonce forKey:@"nonce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    callBackUrl = [callBackUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString* loginData = txt_url.text;
    loginData = [loginData stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString* strUrl = [NSString stringWithFormat:@"https://brightergy.api.oneall.com/socialize/connect/mobile/OpenId/?nonce=%@&callback_uri=%@&login_data=%@", nonce, callBackUrl, loginData];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
    [self removeFromSuperview];
}

-(IBAction)OnOneAll:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.oneall.com/services/social-link/?utm_source=brightergy_login_openid_layer&utm_medium=banner&utm_campaign=branding"]];
}
@end
