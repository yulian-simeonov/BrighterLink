//
//  DataSourceTreeCell.h
//  BrighterLink
//
//  Created by mobile master on 11/8/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@protocol DataSourceTreeCellDelegate <NSObject>
@required
-(void)OnExpand:(UITableViewCell*)cell object:(id)object;
-(void)OnCollaps:(UITableViewCell*)cell object:(id)object;
-(void)OnSelect:(UITableViewCell*)cell object:(id)object;
@end

@interface DataSourceTreeCell : UITableViewCell
{
    IBOutlet UIButton* btn_icon;


    IBOutlet UIView* vw_content;
    IBOutlet UIButton* btn_eye;
    IBOutlet UIButton* btn_select;
@public
    IBOutlet UIImageView* img_eye;
    IBOutlet UILabel* lbl_text;    
    Tag* m_data;
    BOOL m_bExpanded;
    BOOL m_bSelected;
}
@property (nonatomic, weak) id<DataSourceTreeCellDelegate> delegaate;
-(void)SetData:(Tag*)data level:(int)level expanded:(BOOL)expanded selected:(BOOL)selected;
-(void)SetDataForPresent:(Tag*)data level:(int)level expanded:(BOOL)expanded selected:(BOOL)selected cellWidth:(float)cellWidth;

-(void)SetDataForPresent1:(Tag*)data level:(int)level expanded:(BOOL)expanded selected:(BOOL)selected cellWidth:(float)cellWidth;

@end
