//
//  AddNewWidgetView.h
//  BrighterLink
//
//  Created by Andriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SharedMembers.h"

typedef enum : NSUInteger {
    
    DROP_TIMELINE_METRIC,
    DROP_TIMELINE_COMPARE,
    DROP_TIMELINE_GROUPDIMENTION,
    
    DROP_PIE_METRIC,
    DROP_PIE_GROUPDIMENTION,
    DROP_PIE_SLICES,
    
    DROP_BAR_METRIC,
    DROP_BAR_GROUPDIMENSION,
    DROP_BAR_PIVOTDIMENSION,
    
    DROP_TABLE_METRIC,
    DROP_TABLE_EXTRA_METRIC,
    DROP_TABLE_GROUPDIMENSION,
    DROP_TABLE_SHOW_ROWS,
    
    DROP_EQUI_METRIC,
    DROP_EQUI_ORIENTATION,
    DROP_EQUI_TYPE,
    
    DROP_KPI_SUMMARYMETHOD,
    DROP_KPI_METRIC,
    DROP_KPI_COMPAREMETRIC,
    
    DROP_DRILLDOWN,
    
} DROP_TYPE;


@protocol AddNewWidgetViewDelegate <NSObject>

- (void) addNewWidget:(WidgetInfo *)newWidget;

@end

@interface AddNewWidgetView : UIView<UIActionSheetDelegate>
{

}

@property (nonatomic, assign) id <AddNewWidgetViewDelegate> delegate;

@property (nonatomic, retain) NSString *widgetId;

- (void) setWidgetId:(NSString *)widgetId;

@end
