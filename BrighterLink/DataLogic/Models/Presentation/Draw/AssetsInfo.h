//
//  UserInfo.h
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AssetsInfo : NSObject
{
    @public
    UIImage * image;
}

@property (nonatomic, strong) NSString  *ETag;
@property (nonatomic, strong) NSString  *Key;
@property (nonatomic, strong) NSString  *LastModified;
@property (nonatomic, strong) NSDictionary *Owner;
@property (nonatomic, strong) NSNumber  *Size;
@property (nonatomic, strong) NSString  * StorageClass;
@property (nonatomic, strong) NSString  *_id;
@property (nonatomic, strong) NSString  *sourceCDNURL;
@property (nonatomic, strong) NSString  *thumbnailURL;
@property (nonatomic, strong) NSString  *title;


@end
