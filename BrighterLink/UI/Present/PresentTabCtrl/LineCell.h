//
//  LineCell.h
//  Lingua SA
//
//  Created by 陈玉亮 on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableDelegate <NSObject>
- (void) onReloadData:(NSString*) _id Index:(int) idx;
@end


@interface LineCell : UITableViewCell
{

    NSString * _id;
    
    @public
    int index;
    
}
@property (nonatomic, weak) id<TableDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel * m_title;
@property (nonatomic, weak) IBOutlet UITextView * m_creater;
@property (nonatomic, weak) IBOutlet UILabel * m_duration;
@property (nonatomic, weak) IBOutlet UIButton * m_btnRemove;

- (void) setinfo:(NSString*) title Creator:(NSString*) creator Duration:(NSString*) duration;
- (IBAction) onRemove:(id)sender;

@end
