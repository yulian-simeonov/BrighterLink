//
//  RelatedDataSourcesView.h
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLoggerCell.h"
#import "SensorCell.h"
#import "MetricCell.h"
#import "Tag.h"

@class SourcesView;
@interface RelatedDataSourcesView : UIView
{
    IBOutlet UIButton* btn_create;
    IBOutlet UILabel* lbl_header;
    IBOutlet UILabel* lbl_title;
    IBOutlet UITableView* tbl_children;
    IBOutlet UIImageView* img_arrowIcon;
    NSMutableArray* m_dataSources;
    Tag*    m_tag;
    BOOL m_bOpened;
}
@property (nonatomic, weak) SourcesView* delegate;
+(RelatedDataSourcesView*)ShowView:(UIView*)parentView;
-(void)UpdateData:(Tag*)tag;
-(void)Refresh;
@end
