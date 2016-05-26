//
//  ImageWidgetView.m
//  BrighterLink
//
//  Created by apple developer on 1/3/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import "ImageWidgetView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

@implementation ImageWidgetView

+(ImageWidgetView*)ShowImageWidget:(UIView*)parent
{
    ImageWidgetView* vw = [[ImageWidgetView alloc] init];
    [vw setFrame:CGRectMake(0, 0, parent.frame.size.width, 0)];
    
    [parent addSubview:vw];
    return vw;
}

-(id)init
{
    if (self = [super init])
    {
        img_widget = [[UIImageView alloc] init];
        [self addSubview:img_widget];
        img_widget.layer.borderWidth = 1;
        img_widget.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return self;
}

-(void)UpdateWidget
{
    [super UpdateWidget];
    if (!self.WgInfo)
        return;
    if ([[self.WgInfo objectForKey:@"imageUrl"] isEqual:[NSNull null]])
        return;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[self.WgInfo objectForKey:@"imageUrl"]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        float width = image.size.width;
        float imgFrameWidth = self.frame.size.width - 15;
        float ratio = width / imgFrameWidth;
        float imgFrameheight = image.size.height / ratio;
        [img_widget setFrame:CGRectMake(0, WIDGET_TITLEBAR_HEIGHT, imgFrameWidth, imgFrameheight - 1)];
        [img_widget setImage:image];
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, img_widget.frame.size.height + WIDGET_TITLEBAR_HEIGHT)];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CANVAS object:nil];
    }];
}
@end
