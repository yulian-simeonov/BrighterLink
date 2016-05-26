//
//  SourcesView.h
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelatedDataSourcesView.h"

@interface SourcesView : UIView
{
    IBOutlet UILabel* lbl_title;
    IBOutlet UIImageView* img_searchBar;
    IBOutlet UITextField* txt_search;
    IBOutlet UIButton* btn_createSource;
    IBOutletCollection(UIImageView) NSArray* img_checkers;
    IBOutlet UITableView* tbl_sources;
    IBOutlet UIView* vw_detail;
    IBOutlet UIButton* btn_back;
    RelatedDataSourcesView* vw_relatedSources;
    NSMutableArray* m_dataSources;
    NSMutableArray* m_navigationQueue;
    BOOL m_bChecked[4];
    
    BOOL m_bReservedChecked[4];
    NSString* m_keyword;
}
+(UIView*)ShowView:(UIView*)parentView;
-(void)DidSelectRowWithObject:(id)object;
-(void)OnEditSource:(Tag*)tag delegate:(id)dlgt;
-(void)ReloadData;
-(void)RestoreSearchType;
-(IBAction)OnBack:(id)sender;
@end
