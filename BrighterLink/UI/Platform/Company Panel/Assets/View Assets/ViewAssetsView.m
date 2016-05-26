//
//  ViewAssetsView.m
//  BrighterLink
//
//  Created by mobile on 11/23/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "ViewAssetsView.h"
#import "SharedMembers.h"
#import "SDWebImageManager.h"

@implementation ViewAssetsView

+(ViewAssetsView*)ShowView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAssetsView" owner:self options:nil];
    ViewAssetsView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    vw.layer.zPosition = 20;
    [[SharedMembers sharedInstance].currentViewController.view addSubview:vw];
    return vw;
}

-(void)Initialize
{
    img_header.layer.cornerRadius = 8;
    img_frame.layer.cornerRadius = 8;
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    
    [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, -768, vw_content.frame.size.width, vw_content.frame.size.height)];
    [UIView animateWithDuration:0.3f animations:^{
        [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, 0, vw_content.frame.size.width, vw_content.frame.size.height)];
    }];
    
    [img_header addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    [img_frame addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouch:)];
    [self addGestureRecognizer:gesture];
}

-(void)SetImageInfo:(NSDictionary*)imgInfo
{
    [lbl_name setText:[imgInfo objectForKey:@"title"]]; 
    [JSWaiter ShowWaiter:img_frame title:@"Loading" type:3];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[imgInfo objectForKey:@"sourceCDNURL"]] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize){
        [JSWaiter SetProgress:(float)receivedSize / (float)expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [JSWaiter HideWaiter];
        if (!image)
            return;
        float ratio = image.size.height / image.size.width;
        float height = img_photo.frame.size.width * ratio;
        if (height < 575)
        {
            [img_photo setFrame:CGRectMake(img_photo.frame.origin.x, img_photo.frame.origin.y, img_photo.frame.size.width, height)];
            [img_frame setFrame:CGRectMake(img_frame.frame.origin.x, img_frame.frame.origin.y, img_frame.frame.size.width, img_photo.frame.size.height + 30)];
        }
        else
        {
            float width = 575.0f / ratio;
            [img_photo setFrame:CGRectMake((vw_content.frame.size.width - width) / 2, img_photo.frame.origin.y, width, 575)];
            [img_frame setFrame:CGRectMake(img_photo.frame.origin.x - 15, img_frame.frame.origin.y, width + 30, img_photo.frame.size.height + 30)];
        }
        [img_photo setImage:image];
    }];
}

-(IBAction)OnBack:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        [vw_content setFrame:CGRectMake(vw_content.frame.origin.x, -768, vw_content.frame.size.width, vw_content.frame.size.height)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)OnTouch:(UIGestureRecognizer*)gesture
{
    [self OnBack:nil];
}
@end
