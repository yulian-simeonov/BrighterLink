//
//  JSCombo.h
//  BrighterLink
//
//  Created by mobile master on 11/15/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSComboDelegate <NSObject>
-(void)SelectedObject:(id)control selectedObj:(id)obj;
@end

@interface JSCombo : UIView<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* m_data;
    UITableView* tbl_combo;
    id m_selectedItem;
}
@property (nonatomic, weak) id<JSComboDelegate> delegate;
-(void)UpdateData:(NSArray*)data;
-(void)setSelectedItem:(id)selectedItem;
-(id)GetItemByText:(NSString*)txt;
@end
