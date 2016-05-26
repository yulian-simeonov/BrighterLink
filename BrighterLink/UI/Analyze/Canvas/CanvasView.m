//
//  CanvasView.m
//  BrighterLink
//
//  Created by Anriy Homuch on 11/5/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "CanvasView.h"
#import "WidgetView.h"
#import "TimelineWidgetView.h"
#import "BarWidgetView.h"
#import "TableWidgetView.h"
#import "EquivalenceWidgetView.h"
#import "PieWidgetView.h"
#import "KpiWidgetView.h"
#import "WidgetCollectionViewCell.h"
#import "UICollectionViewWaterfallLayout.h"
#import "ImageWidgetView.h"
#import "CanvasToolsView.h"

#define USER_DEFINE 1000
#define COUNT_OF_MOSAIC 4

#define GAP 10

#define WIDGETIDENTIFIER_BAR @"Bar"
#define WIDGETIDENTIFIER_TIMELINE @"Timeline"
#define WIDGETIDENTIFIER_PIE @"Pie"
#define WIDGETIDENTIFIER_TABLE @"Table"
#define WIDGETIDENTIFIER_EQUIVALENCIES @"Equivalencies"
#define WIDGETIDENTIFIER_KPI @"Kpi"
#define WIDGETIDENTIFIER_IMAGE @"Image"
#define PLACEHOLDERWIDGET @"placeholder"
#define UNKNOWNWIDGET @"unknown"

float canvasMap[6][COUNT_OF_MOSAIC][4] = {
    {{0.0f, 0.0f, 1.0f, 1.0f},{1.0f, 1.0f, 0.0f, 0.0f},{1.0f, 1.0f, 0.0f, 0.0f},{1.0f, 1.0f, 0.0f, 0.0f} },
    {{0.0f, 0.0f, 0.5f, 1.0f},{0.5f, 0.0f, 0.5f, 1.0f},{1.0f, 1.0f, 0.0f, 0.0f},{1.0f, 1.0f, 0.0f, 0.0f} },
    {{0.0f, 0.0f, 0.25f, 1.0f},{0.25f, 0.0f, 0.25f, 1.0f},{0.5f, 0.0f, 0.25f, 1.0f},{0.75f, 0.0f, 0.25f, 1.0f} },
    {{0.0f, 0.0f, 0.25f, 1.0f},{0.25f, 0.0f, 0.75f, 1.0f},{1.0f, 1.0f, 0.0f, 0.0f},{1.0f, 1.0f, 0.0f, 0.0f} },
    {{0.0f, 0.0f, 0.25f, 1.0f},{0.25f, 0.0f, 0.5f, 1.0f},{0.75f, 0.0f, 0.25f, 1.0f},{1.0f, 1.0f, 0.0f, 0.0f} },
    {{0.0f, 0.0f, 0.75f, 1.0f},{0.75f, 0.0f, 0.25f, 1.0f},{1.0f, 0.0f, 0.0f, 0.0f},{1.0f, 1.0f, 0.0f, 0.0f} },
};

int canvasColumns[6] = {1, 2, 4, 2, 3, 2};

@interface CanvasView()<UICollectionViewDelegateWaterfallLayout, CanvasToolsViewDelegate, WidgetViewDelegate>
{
    NSInteger _selectedWidgetIndex;
    
    NSInteger _currentFocusPosForMoving;
    
    WidgetView *_movingWidgetView;
    NSDictionary *_movingWidgetData;
}

@property (nonatomic, assign) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) UICollectionViewWaterfallLayout *layout;

@property (nonatomic, assign) CanvasToolsView *canvasToolsView;

@property (nonatomic, retain) NSMutableArray *aryWidgets;

@end

@implementation CanvasView

- (void) awakeFromNib
{
    [self initData];
    [self initView];
    
    [self updateUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLayout) name:NOTIFICATION_RELOAD_CANVAS object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reloadLayout) userInfo:nil repeats:YES];
}

- (void) initView
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WidgetCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:WIDGETIDENTIFIER_BAR];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WidgetCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:WIDGETIDENTIFIER_PIE];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WidgetCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:WIDGETIDENTIFIER_TIMELINE];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WidgetCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:WIDGETIDENTIFIER_TABLE];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WidgetCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:WIDGETIDENTIFIER_EQUIVALENCIES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WidgetCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:PLACEHOLDERWIDGET];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WidgetCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:UNKNOWNWIDGET];
    
    self.layout = [[UICollectionViewWaterfallLayout alloc] init];
    self.layout.sectionInset = UIEdgeInsetsMake(GAP, GAP, GAP, GAP);
    self.layout.delegate = self;
    
    self.collectionView.collectionViewLayout = self.layout;
}

- (void) initData
{
    self.type = CanvasType1;
    
    _selectedWidgetIndex = NSNotFound;
}

- (void) layoutSubviews
{
    [self updateUI];
}

- (void) updateUI
{
    self.layout.columnCount = canvasColumns[self.type - 1];
    
    NSMutableArray *aryWidths = [[NSMutableArray alloc] init];
    for (int column = 0 ; column < self.layout.columnCount; column ++)
    {
        float width = (self.frame.size.width - GAP * (self.layout.columnCount + 1)) * canvasMap[self.type - 1][column][2];
        
        [aryWidths addObject:[NSNumber numberWithFloat:width]];
    }

    self.layout.aryWidthsForColumns = aryWidths;
    aryWidths = nil;
    
    [self.collectionView reloadData];
    [self.layout invalidateLayout];
}

- (void) updateCanvasWithType:(NSInteger) type
{
    self.type = type;
    self.type = MIN(CanvasType6, MAX(self.type, CanvasType1));
    
    self.aryWidgets = nil;
    self.aryWidgets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *widget in [SharedMembers sharedInstance].currentDashboard.widgetDatas) {
        
        NSDictionary *widgetInfo = [widget objectForKey:@"widget"];
        
        if(widgetInfo != nil && [widgetInfo isKindOfClass:[NSDictionary class]])
        {
            [self.aryWidgets addObject:widget];
        }
    }
    
    self.canvasToolsView.hidden = YES;
    
    [self updateUI];
}

- (void) loadWidgetView:(WidgetCollectionViewCell *)cell index:(NSInteger)index
{
    NSDictionary* item = [self.aryWidgets objectAtIndex:index];
    
    NSDictionary *widget = [item objectForKey:@"widget"];
    if(widget == nil || ![widget isKindOfClass:[NSDictionary class]]) return;
    
    NSString *widgetType = [widget objectForKey:@"type"];
    
    if(cell.widgetView == nil || ![[cell.widgetView getWidgetType] isEqualToString:widgetType])
    {
        cell.widgetView = [self createWidgetView:cell.containerView type:widgetType];
        cell.widgetView.delegate = self;
        
        [self addTapGestureToWidgetView:cell.widgetView];
    }
    
    cell.widgetView.tag = index;
    
    cell.widgetView.frame = CGRectMake(cell.widgetView.frame.origin.x, cell.widgetView.frame.origin.y, cell.containerView.frame.size.width, cell.containerView.frame.size.height);
    
    [self setDataToWidget:cell.widgetView index:index];
}

- (void) addTapGestureToWidgetView:(WidgetView *)widgetView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWidgetView:)];
    
    [widgetView addGestureRecognizer:tapGesture];
    tapGesture = nil;
}

- (WidgetView *)createWidgetView:(UIView *)parent type:(NSString *)widgetType
{
    NSArray *subviews = parent.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    WidgetView *widgetView = nil;
    
    if([widgetType isEqualToString:WIDGETIDENTIFIER_TIMELINE])
    {
        widgetView = [TimelineWidgetView ShowGraphic:parent];
    }
    else if([widgetType isEqualToString:WIDGETIDENTIFIER_BAR])
    {
        widgetView = [[BarWidgetView alloc] initWithParent:parent];
    }
    else if ([widgetType isEqualToString:WIDGETIDENTIFIER_PIE])
    {
        widgetView = [PieWidgetView ShowPieWidget:parent];
    }
    else if([widgetType isEqualToString:WIDGETIDENTIFIER_TABLE])
    {
        widgetView = [[TableWidgetView alloc] initWithParent:parent];
    }
    else if([widgetType isEqualToString:WIDGETIDENTIFIER_EQUIVALENCIES])
    {
        widgetView = [[EquivalenceWidgetView alloc] initWithParent:parent];
    }
    else if([widgetType isEqualToString:WIDGETIDENTIFIER_KPI])
    {
        widgetView = [[KpiWidgetView alloc] initWithParent:parent];
    }
    else if([widgetType isEqualToString:WIDGETIDENTIFIER_IMAGE])
    {
        widgetView = [ImageWidgetView ShowImageWidget:parent];
    }
    else if([widgetType isEqualToString:PLACEHOLDERWIDGET])
    {
        widgetView = [[WidgetView alloc] init];
        widgetView.frame = CGRectMake(0, 0, parent.frame.size.width, parent.frame.size.height);
        
        [parent addSubview:widgetView];
        [widgetView setPlaceHolderState];
    }
    else
    {
        widgetView = [[WidgetView alloc] init];
        widgetView.frame = CGRectMake(0, 0, parent.frame.size.width, parent.frame.size.height);
        
        [parent addSubview:widgetView];
        [widgetView setUnknowType];
    }
    
    return widgetView;
}

- (void)setDataToWidget:(WidgetView *)widgetView index:(NSInteger)index
{
    NSDictionary* item = [self.aryWidgets objectAtIndex:index];
    
    NSDictionary *widgetInfo = [item objectForKey:@"widget"];
    if(widgetInfo == nil || ![widgetInfo isKindOfClass:[NSDictionary class]]) return;
    
    [widgetView setWgInfo:widgetInfo];
    
    if(!widgetView.isUnknownState)
    {
        [widgetView GetWidgetDatas];
    }
}

- (void) showCanvasToolsView:(CGRect) rect
{
    if(self.canvasToolsView == nil)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CanvasToolsView" owner:self options:nil];
        self.canvasToolsView = [nib objectAtIndex:0];
        self.canvasToolsView.delegate = self;
        
        [self addSubview:self.canvasToolsView];
    }
    
    self.canvasToolsView.hidden = NO;
    [self bringSubviewToFront:self.canvasToolsView];
    
    self.canvasToolsView.frame = CGRectMake(rect.origin.x,
                                            rect.origin.y,
                                            rect.size.width,
                                            self.canvasToolsView.frame.size.height);
    
    self.canvasToolsView.hidden = !CGRectContainsPoint(self.collectionView.frame, self.canvasToolsView.center);
}

- (NSDictionary *)getPlaceHolderWidgetData
{
    NSDictionary *placeHolderWidget = @{@"widget" : @{@"type" : PLACEHOLDERWIDGET}};
    
    return placeHolderWidget;
}

- (NSInteger) getFitCellIndexForCurrentMovingWidget
{
    CGPoint pt = _movingWidgetView.center;
    
    for (int n = 0 ; n < self.aryWidgets.count; n ++) {
        
        CGRect rt = [self getRectOfWidgetViewOnCanvas:n];
        
        if(CGRectContainsPoint(rt, pt))
        {
            return n;
        }
    }
    
    if(pt.y < 0) return 0;
    
    return self.aryWidgets.count - 1;
}

- (void)prepareMoving
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedWidgetIndex inSection:0];
    WidgetCollectionViewCell *cell = (WidgetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    _movingWidgetView = cell.widgetView;
    
    [_movingWidgetView removeFromSuperview];
    [self addSubview:_movingWidgetView];
    
    [self bringSubviewToFront:self.canvasToolsView];
    
    _movingWidgetView.userInteractionEnabled = NO;
    _movingWidgetView.frame = [self getRectOfWidgetViewOnCanvas:_selectedWidgetIndex];
    
    cell.widgetView = nil;
    
    _movingWidgetData = [self.aryWidgets objectAtIndex:_selectedWidgetIndex];
    [self.aryWidgets removeObjectAtIndex:_selectedWidgetIndex];
    
    NSDictionary *placeHolderWidget = [self getPlaceHolderWidgetData];
    [self.aryWidgets insertObject:placeHolderWidget atIndex:_selectedWidgetIndex];
    
    _currentFocusPosForMoving = _selectedWidgetIndex;
}

- (void) releaseMovingState
{
    _selectedWidgetIndex = NSNotFound;
    self.canvasToolsView.hidden = YES;
    
    if(_movingWidgetView)
    {
        [_movingWidgetView removeFromSuperview];
        _movingWidgetView = nil;
    }
    
    [self.aryWidgets removeObjectAtIndex:_currentFocusPosForMoving];
    [self.aryWidgets insertObject:_movingWidgetData atIndex:_currentFocusPosForMoving];
    
    _currentFocusPosForMoving = NSNotFound;
    _movingWidgetData = nil;
}

- (void) updateMovingState:(UIView *)view
{
    _movingWidgetView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, _movingWidgetView.frame.size.width, _movingWidgetView.frame.size.height);
    
    NSInteger currentFitWidgetIndexForMoving = [self getFitCellIndexForCurrentMovingWidget];
    
    if(_currentFocusPosForMoving != currentFitWidgetIndexForMoving)
    {
        NSDictionary *placeHolderWidget = [self.aryWidgets objectAtIndex:_currentFocusPosForMoving];
        [self.aryWidgets removeObjectAtIndex:_currentFocusPosForMoving];
        
        if(currentFitWidgetIndexForMoving >= self.aryWidgets.count)
        {
            [self.aryWidgets addObject:placeHolderWidget];
        }
        else
        {
            [self.aryWidgets insertObject:placeHolderWidget atIndex:currentFitWidgetIndexForMoving];
        }
        
        _currentFocusPosForMoving = currentFitWidgetIndexForMoving;
        
        [self.collectionView reloadData];
    }
}

- (BOOL) isUnknownWidget:(NSString *)type
{
    if([type isEqualToString:WIDGETIDENTIFIER_BAR]) return NO;
    if([type isEqualToString:WIDGETIDENTIFIER_TIMELINE]) return NO;
    if([type isEqualToString:WIDGETIDENTIFIER_PIE]) return NO;
    if([type isEqualToString:WIDGETIDENTIFIER_TABLE]) return NO;
    if([type isEqualToString:WIDGETIDENTIFIER_EQUIVALENCIES]) return NO;
    
    if([type isEqualToString:PLACEHOLDERWIDGET]) return NO;

    return YES;
}

#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.aryWidgets.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = [self.aryWidgets objectAtIndex:indexPath.item];
    NSDictionary *widget = [item objectForKey:@"widget"];
    NSString *widgetType = [widget objectForKey:@"type"];
    
    if([self isUnknownWidget:widgetType]) widgetType = UNKNOWNWIDGET;
    
    WidgetCollectionViewCell *cell = (WidgetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:widgetType forIndexPath:indexPath];
    
    cell.containerView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    
    [self loadWidgetView:cell index:indexPath.item];
    
    return cell;
}

#pragma mark UICollectionViewDelegateWaterfullLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WidgetCollectionViewCell *cell = (WidgetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    float height = WIDGET_DEFAULT_HEIGHT;
    if(cell == nil)
    {
    }
    else
    {
        height = cell.widgetView.frame.size.height;
    }
    
    return height;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateCanvasToolsView];
}

- (void) updateCanvasToolsView
{
    if(_selectedWidgetIndex == NSNotFound) return;
    
    CGRect rect = [self getRectOfWidgetViewOnCanvas:_selectedWidgetIndex];
    
    [self showCanvasToolsView:rect];
}

#pragma mark CanvasToolsViewDelegate

- (void) startDragWidgetView:(UIView *)view
{
    if(_selectedWidgetIndex == NSNotFound) return;
    
    [self prepareMoving];
    
    [self.collectionView reloadData];
}

- (CGRect) getRectOfWidgetViewOnCanvas:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect cellRect = attributes.frame;
    
    CGRect cellFrameInSuperview = [self.collectionView convertRect:cellRect toView:[self.collectionView superview]];
    
    return cellFrameInSuperview;
}

- (void)moveDragWidgetView:(UIView *)toolsView
{
    if(_movingWidgetView == nil) return;
    
    [self updateMovingState:toolsView];
}

- (void) stopDragWidgetView:(UIView *)view
{
    [self releaseMovingState];
    
    [self.collectionView reloadData];
}

- (void) minimizeCurrentWidgetView:(UIView *)view
{
    if(_selectedWidgetIndex != NSNotFound)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedWidgetIndex inSection:0];
        WidgetCollectionViewCell *cell = (WidgetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        [cell.widgetView minimize:^{
            
            [self.layout invalidateLayout];
        }];
    }
}

- (void) maxmizeCurrentWidgetView:(UIView *)view
{
    if(_selectedWidgetIndex != NSNotFound)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedWidgetIndex inSection:0];
        WidgetCollectionViewCell *cell = (WidgetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        [cell.widgetView maximize:^{
            
            [self.layout invalidateLayout];
            
        }];
    }
}

- (void) deleteWidgetView:(UIView *)view
{
    NSString *widgetId = [self getCurrentSelectedWidgetId];
    
    if(widgetId.length == 0) return;
    
    [self.delegate deleteWidgetWithId:widgetId];
}

- (void) editWidgetView:(UIView *)view
{
    NSString *widgetId = [self getCurrentSelectedWidgetId];
    
    if(widgetId.length == 0) return;
    
    [self.delegate editWidgetWithId:widgetId];
}

- (NSString *) getCurrentSelectedWidgetId
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedWidgetIndex inSection:0];
    WidgetCollectionViewCell *cell = (WidgetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSDictionary *widgetInfo = cell.widgetView.WgInfo;
    
    if(widgetInfo == nil || ![widgetInfo isKindOfClass:[NSDictionary class]]) return @"";
    
    NSString *widgetId = [widgetInfo objectForKey:@"_id"];
    
    return widgetId;
}

- (void) expandWidgetView:(UIView *)view
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedWidgetIndex inSection:0];
    WidgetCollectionViewCell *cell = (WidgetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    [self.delegate expandWidgetView:cell.widgetView];
}

#pragma mark UITapGestureFunction

- (void)tapWidgetView:(UITapGestureRecognizer *)gesture
{
    NSInteger selectedWidgetIndex = gesture.view.tag;
    
    WidgetView *widgetView = (WidgetView *)gesture.view;
    [widgetView hideTooltipView];
    
    if(selectedWidgetIndex == _selectedWidgetIndex)
    {
        _selectedWidgetIndex = NSNotFound;
        self.canvasToolsView.hidden = YES;
        
        return;
    }
    
    _selectedWidgetIndex = selectedWidgetIndex;
    
    CGRect rect = [self getRectOfWidgetViewOnCanvas:_selectedWidgetIndex];
    
    [self showCanvasToolsView:rect];
    [self.canvasToolsView setMinimizeState:((WidgetView *)gesture.view).isMinimized];
}

#pragma mark WidgetViewDelegate

- (void) updatedWidgetHeight:(UIView *)widgetView
{
    [self reloadLayout];
}

- (void) reloadLayout
{
    [self.layout invalidateLayout];
}

@end
