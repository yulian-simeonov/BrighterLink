//
//  DataLoggerCell.h
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@class SourcesView;

@interface DataLoggerCell : UITableViewCell
{
    Tag* m_tag;
    IBOutlet UILabel* lbl_name;
    IBOutlet UILabel* lbl_detail;
}

@property (nonatomic, weak) SourcesView* delegate;
-(void)SetTagData:(Tag*)tg;
@end
