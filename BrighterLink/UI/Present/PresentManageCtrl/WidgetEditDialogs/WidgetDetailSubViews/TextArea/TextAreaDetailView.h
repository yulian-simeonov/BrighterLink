//
//  CustomDetailTextAreaView.h
//  BrighterLink
//
//  Created by mobile on 12/4/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextAreaDetailView : UIView
{
    IBOutlet UIWebView* vw_web;
    NSString* m_txt;
}
-(void)SetText:(NSString*)txt;
-(NSString*)GetText;
@end
