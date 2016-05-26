//
//  LineCell.h
//  Lingua SA
//
//  Created by 陈玉亮 on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorInfo.h"

@protocol EditDelegate <NSObject>
- (void) GetEditors:(NSString*) presentationId;
- (void) ShowAddEditor:(NSString*)UserId present:(NSString*) presentationId name:(NSString*) Name;

@end


@interface EditorCell : UITableViewCell
{


    int          m_Idx;
    
    @public
    
    BOOL  m_bAdded;
    EditorInfo * m_Info;
    
}

@property (nonatomic, weak) id<EditDelegate> delegate;


@property (nonatomic, weak) IBOutlet UIView  * m_vNormal;
@property (nonatomic, weak) IBOutlet UIView  * m_vDelete;
@property (nonatomic, weak) IBOutlet UIImageView  * m_imgMask;


@property (nonatomic, weak) IBOutlet UIImageView * m_imgPhoto;
@property (nonatomic, weak) IBOutlet UILabel * m_lName;
@property (nonatomic, weak) IBOutlet UILabel * m_lURL;
@property (nonatomic, weak) IBOutlet UIButton * m_btnRemove;


- (void) setEditorInfo:(EditorInfo*) editor Index:(int) idx;

- (void) setInfo:(UIImage*) image Name:(NSString*) name URL:(NSString*) url;

- (IBAction) onRemove:(id)sender;

- (IBAction) onClose:(id)sender;
- (IBAction) onDelete:(id)sender;

- (void) setNormalView:(BOOL) flag;
@end
