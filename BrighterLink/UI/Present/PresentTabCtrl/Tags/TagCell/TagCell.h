//
//  TagCell.h
//  BrighterLink
//
//  Created by apple developer on 1/22/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "DataSourceTreeCell.h"

@interface TagCell : UITableViewCell
{
    IBOutlet UIButton* btn_icon;
    IBOutlet UILabel* lbl_text;
    IBOutlet UIView* vw_content;
    IBOutlet UIButton* btn_select;
@public
    Tag* m_data;
    BOOL m_bSelected;
}
@property (nonatomic, weak) id<DataSourceTreeCellDelegate> delegaate;
-(void)SetData:(Tag*)data selected:(BOOL)selected cellWidth:(float)cellWidth;
@end
