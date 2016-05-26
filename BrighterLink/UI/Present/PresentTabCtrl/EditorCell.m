//
//  LineCell.m
//  Lingua SA
//
//  Created by 陈玉亮 on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditorCell.h"
#import "AppDelegate.h"
#import "SharedMembers.h"


@interface EditorCell ()

@end

@implementation EditorCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void) setNormalView:(BOOL) flag
{
    if ( flag ) {
        [_m_vNormal setHidden:false];
        [_m_vDelete setHidden:true];
    }
    else{
        [_m_vNormal setHidden:true];
        [_m_vDelete setHidden:false];
    }
}

- (void) setInfo:(UIImage*) image Name:(NSString*) name URL:(NSString*) url
{
//  [_m_imgPhoto setImage: image];
    [_m_lName setText: name];
    [_m_lURL setText: url];
}

- (IBAction) onRemove:(id)sender
{
    if ( m_bAdded ) 
    {
        [_m_vDelete setHidden: false];
        [_m_vNormal setHidden: true];
    }
    else{

        NSDictionary * dic =  @{
                                @"USER_ID" : m_Info._id,
                                @"USER_EMAIL" : m_Info.email,
                                @"USER_NAME" :  m_Info.name,
                                @"INDEX"     :  [NSString stringWithFormat:@"%d", m_Idx],
                                @"PICTURE"   :  m_Info.profilePictureUrl,
                                };
        
           [[NSNotificationCenter defaultCenter]         postNotificationName:@"ShowAddEditor"  object:self userInfo: dic];
    }
}

- (IBAction) onClose:(id)sender
{
    [_m_vDelete setHidden: true];
    [_m_vNormal setHidden: false];
}

- (void) setEditorInfo:(EditorInfo*) editor Index:(int) idx
{
    m_Info = editor;
    m_Idx  = idx;
}

- (IBAction) onDelete:(id)sender
{
    
    [_m_vDelete setHidden: true];
    [_m_vNormal setHidden: false];
    
    EditorInfo * info  = [[SharedMembers sharedInstance].arrEditors objectAtIndex:m_Idx];
    info->m_bAdded = false;
    info->m_bSelected  = false;
    
    [[NSNotificationCenter defaultCenter]         postNotificationName:@"ConfrimEditor"  object:self];
    
//    PresentationInfo * info  = [SharedMembers sharedInstance].curPresent;
//    
//    NSDictionary * dic  = @{
//                            @"userId" : m_Info._id,
//                            @"presentationId" :  info._id,
//                            };
//    
//    [[SharedMembers sharedInstance].webManager DeleteEditors:info._id param:dic success:^(MKNetworkOperation *networkOperation) {
//        
//        NSLog(@"%@", networkOperation.responseJSON);
//        [_m_vDelete setHidden: true];
//        [_m_vNormal setHidden: false];
//        
//    } failure:^(MKNetworkOperation *errorOp, NSError *error) {
//       
//        [_m_vDelete setHidden: true];
//        [_m_vNormal setHidden: false];
//    }];

    // add

}


@end
