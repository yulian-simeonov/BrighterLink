//
//  ReorderDashboardView.m
//  BrighterLink
//
//  Created by Andriy on 1/23/15.
//  Copyright (c) 2015 Brightergy. All rights reserved.
//

#import "ReorderDashboardView.h"
#import "ReorderCollectionCell.h"
#import "ReorderDashboardCell.h"
#import "SharedMembers.h"

#define COLLECTIONINFO_HEIGHT 34
#define COLLECTIONINFO_MARGIN 10

#define DASHBOARDINFO_HEIGHT 28
#define ITEMS_GAP 5
#define DASHBOARD_MARGIN 24
#define DASHBOARD_OTHER_MARGIN 10

@interface ReorderDashboardView()<UIGestureRecognizerDelegate>
{
    UIView* vw_captured;
    UIView* vw_dash;
    CAShapeLayer* m_dashBorder;
    NSMutableArray* m_collectionViews;
}
@property (nonatomic, assign) IBOutlet UIScrollView *svMain;

@property (nonatomic, retain) NSMutableArray *aryDashboards;

@end

@implementation ReorderDashboardView


- (void) initWithDashboards:(NSMutableArray *)aryDashboards
{
    self.aryDashboards = [[NSMutableArray alloc] init];
    for(CollectionInfo* collection in aryDashboards)
    {
        CollectionInfo* newCollection = [[CollectionInfo alloc] init];
        newCollection.title = collection.title;
        newCollection.aryDashboards = [collection.aryDashboards copy];
        newCollection.currentDashboard = collection.currentDashboard;
        [self.aryDashboards addObject:newCollection];
    }
    
    
    m_collectionViews = [[NSMutableArray alloc] init];
    
    vw_dash = [[UIView alloc] init];
    m_dashBorder = [CAShapeLayer layer];
    m_dashBorder.strokeColor = [UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f].CGColor;
    m_dashBorder.fillColor = nil;
    m_dashBorder.lineDashPattern = @[@2, @1];
    [vw_dash.layer addSublayer:m_dashBorder];
    
    [self reloadAllCollectionsAndDashboards];
}

- (IBAction)onDone:(id)sender
{
    [self.delegate onDoneReorderDashboard:self.aryDashboards];
}

- (IBAction)onCancel:(id)sender
{
    [self.delegate onCancelReorderDashboard];
}

- (void) reloadAllCollectionsAndDashboards
{
    NSArray *subviews = self.svMain.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    float height = 0;
    int idx = 0;
//    for(int i = 0; i < 5; i++)
    {
        for (CollectionInfo *collectionInfo in self.aryDashboards)
        {
            ReorderCollectionCell* vw = [self createCollectionInfoView:collectionInfo position:height];
            vw.idx = idx;
            height += vw.frame.size.height + COLLECTIONINFO_MARGIN;
            idx++;
        }
    }
    
    [self.svMain setContentSize:CGSizeMake(self.svMain.contentSize.width, height)];
}

- (ReorderCollectionCell*) createCollectionInfoView:(CollectionInfo *) collectionInfo position:(float)pos
{
    int numberOfDashboardInfo = (int)collectionInfo.aryDashboards.count;
    
    float width = CGRectGetWidth(self.svMain.frame);
    NSMutableArray* dashboardViews = [[NSMutableArray alloc] init];
    
    CGRect rtCollectionView = CGRectMake(0, pos, width, COLLECTIONINFO_HEIGHT + numberOfDashboardInfo * (DASHBOARDINFO_HEIGHT + ITEMS_GAP) + DASHBOARD_OTHER_MARGIN);
    ReorderCollectionCell *collectionInfoView = [[ReorderCollectionCell alloc] initWithFrame:rtCollectionView];
    [collectionInfoView setBackgroundColor:self.backgroundColor];
    collectionInfoView.layer.borderColor = [UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f].CGColor;
    collectionInfoView.layer.borderWidth = 1.0f;
    [collectionInfoView setCollectionInfo:collectionInfo];
    [collectionInfoView setOrgPos:collectionInfoView.center];
    
    UILabel *collectionInfoLabel = [self createCollectionInfoLabel:collectionInfo.title rt:CGRectMake(0, 0, rtCollectionView.size.width, COLLECTIONINFO_HEIGHT)];
    
    [collectionInfoView addSubview:collectionInfoLabel];
    collectionInfoLabel = nil;
    
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapDashboard:)];
    [longTap setMinimumPressDuration:0.6f];
    [longTap setDelegate:self];
    [collectionInfoView addGestureRecognizer:longTap];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveDashboard:)];
    [panGesture setDelegate:self];
    [collectionInfoView addGestureRecognizer:panGesture];
    
    for (int n = 0 ; n < collectionInfo.aryDashboards.count ; n ++) {
        
        DashboardInfo *dashboardInfo = [collectionInfo.aryDashboards objectAtIndex:n];
        
        CGRect rtDashboard = CGRectMake(DASHBOARD_MARGIN,
                                        COLLECTIONINFO_HEIGHT + ITEMS_GAP + (DASHBOARDINFO_HEIGHT + ITEMS_GAP) * n,
                                        rtCollectionView.size.width - (DASHBOARD_MARGIN + DASHBOARD_OTHER_MARGIN),
                                        DASHBOARDINFO_HEIGHT);
        
        ReorderDashboardCell *dashboardInfoLabel = [self createDashboardInfoView:dashboardInfo rt:rtDashboard];
        dashboardInfoLabel.idx = n;
        [dashboardViews addObject:dashboardInfoLabel];
        [collectionInfoView addSubview:dashboardInfoLabel];
    }
    
    [m_collectionViews addObject:@{@"view" : collectionInfoView, @"children" : dashboardViews}];
    [self.svMain addSubview:collectionInfoView];

    return collectionInfoView;
}

- (UILabel *) createCollectionInfoLabel:(NSString *)title rt:(CGRect) rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = [NSString stringWithFormat:@"  %@", title];
    label.textColor = [UIColor colorWithRed:46.0f / 255.0f green:153.0f / 255.0f blue:216.0f / 255.0f alpha:1.0f];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (ReorderDashboardCell *) createDashboardInfoView:(DashboardInfo *) dashboardInfo rt:(CGRect)rect
{
    ReorderDashboardCell *label = [[ReorderDashboardCell alloc] initWithFrame:rect];
    [label setDashboard:dashboardInfo];
    [label setUserInteractionEnabled:YES];
    [label setOrgPos:label.center];
    label.text = [NSString stringWithFormat:@"  %@", dashboardInfo.title];
    label.textColor = [UIColor colorWithRed:46.0f / 255.0f green:153.0f / 255.0f blue:216.0f / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.backgroundColor = [UIColor colorWithRed:238.0f / 255.0f green:238.0f / 255.0f blue:238.0f / 255.0f alpha:1.0f];
    label.layer.borderWidth = 1.0f;
    label.layer.borderColor = [UIColor colorWithRed:204.0f / 255.0f green:204.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f].CGColor;
    
    UILongPressGestureRecognizer* longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapDashboard:)];
    [longTap setMinimumPressDuration:0.5f];
    [longTap setDelegate:self];
    [label addGestureRecognizer:longTap];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveDashboard:)];
    [panGesture setDelegate:self];
    [label addGestureRecognizer:panGesture];
    return label;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)OnTapDashboard:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (vw_captured)
            return;
        if ([recognizer.view isKindOfClass:[ReorderDashboardCell class]])
        {
            ReorderDashboardCell* vw = (ReorderDashboardCell*)recognizer.view;
            [vw setCaptured:YES];
            for(UIGestureRecognizer* gesture in recognizer.view.gestureRecognizers)
            {
                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
                {
                    [gesture setDelegate:nil];
                }
            }
            [vw setHidden:YES];
            vw_captured = [self createDashboardInfoView:vw.dashboard rt:vw.frame];
        }
        else if([recognizer.view isKindOfClass:[ReorderCollectionCell class]])
        {
            ReorderCollectionCell* vw = (ReorderCollectionCell*)recognizer.view;
            [vw setCaptured:YES];
            for(UIGestureRecognizer* gesture in recognizer.view.gestureRecognizers)
            {
                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
                {
                    [gesture setDelegate:nil];
                }
            }
            [vw setHidden:YES];
            vw_captured = [self createCollectionInfoView:vw.collectionInfo position:vw.frame.origin.y];
            for(NSDictionary* item in [m_collectionViews copy])
            {
                if ([[item objectForKey:@"view"] isEqual:vw_captured])
                {
                    [m_collectionViews removeObject:item];
                    break;
                }
            }
        }
        [vw_dash setFrame:recognizer.view.frame];
        m_dashBorder.path = [UIBezierPath bezierPathWithRect:vw_dash.bounds].CGPath;
        m_dashBorder.frame = self.bounds;
        [recognizer.view.superview addSubview:vw_dash];
        
        vw_captured.layer.borderWidth = 3;
        [self addSubview:vw_captured];
        vw_captured.center = [self convertPoint:recognizer.view.center fromView:recognizer.view.superview];
    }
    else if(recognizer.state == UIGestureRecognizerStateCancelled ||
            recognizer.state == UIGestureRecognizerStateEnded ||
            recognizer.state == UIGestureRecognizerStateFailed)
    {
        if ([recognizer.view isKindOfClass:[ReorderDashboardCell class]])
        {
            if (!((ReorderDashboardCell*)recognizer.view).captured)
                return;
        }
        else if([recognizer.view isKindOfClass:[ReorderCollectionCell class]])
        {
            if (!((ReorderCollectionCell*)recognizer.view).captured)
                return;
        }
        if ([recognizer.view isKindOfClass:[ReorderDashboardCell class]])
        {
            ReorderDashboardCell* vw = (ReorderDashboardCell*)recognizer.view;
            [vw setCaptured:NO];
            [vw setHidden:NO];
            [vw setFrame:vw_dash.frame];
            for(UIGestureRecognizer* gesture in recognizer.view.gestureRecognizers)
            {
                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
                {
                    [gesture setDelegate:self];
                }
            }
            [self RearrangeDashboards:vw];
        }
        else if([recognizer.view isKindOfClass:[ReorderCollectionCell class]])
        {
            ReorderCollectionCell* vw = (ReorderCollectionCell*)recognizer.view;
            [vw setCaptured:NO];
            [vw setHidden:NO];
            [vw setFrame:vw_dash.frame];
            for(UIGestureRecognizer* gesture in recognizer.view.gestureRecognizers)
            {
                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
                {
                    [gesture setDelegate:self];
                }
            }
            [self RearrangeCollections];
        }
        [vw_captured removeFromSuperview];
        vw_captured = nil;
        [vw_dash removeFromSuperview];
    }
}

-(void)OnMoveDashboard:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateCancelled ||
        recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateFailed)
        return;
    if ([recognizer.view isKindOfClass:[ReorderDashboardCell class]])
    {
        if (!((ReorderDashboardCell*)recognizer.view).captured)
            return;
    }
    else if([recognizer.view isKindOfClass:[ReorderCollectionCell class]])
    {
        if (!((ReorderCollectionCell*)recognizer.view).captured)
            return;
    }
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    vw_captured.center = [self convertPoint:recognizer.view.center fromView:recognizer.view.superview];
    
    if ([recognizer.view isKindOfClass:[ReorderDashboardCell class]])
    {
        [self OnReorderDashboard:(ReorderDashboardCell*)recognizer.view];
    }
    else if([recognizer.view isKindOfClass:[ReorderCollectionCell class]])
    {
        [self OnReorderCollection:(ReorderCollectionCell*)recognizer.view];
    }
}

-(void)OnReorderDashboard:(ReorderDashboardCell*)vw
{
    NSDictionary* parent = nil;
    for(NSDictionary* item in m_collectionViews)
    {
        if ([[item objectForKey:@"view"] isEqual:vw.superview])
        {
            parent = item;
            break;
        }
    }
    ReorderCollectionCell* collectionCell = [parent objectForKey:@"view"];
    if (vw.center.y > COLLECTIONINFO_HEIGHT + ITEMS_GAP && vw.center.y < collectionCell.frame.size.height)
    {
        int selectedIdx = (vw.center.y - COLLECTIONINFO_HEIGHT + ITEMS_GAP) / (DASHBOARDINFO_HEIGHT + ITEMS_GAP);
        int idx = 0;
        for(ReorderDashboardCell* dashboardCell in [parent objectForKey:@"children"])
        {
            if (dashboardCell.hidden)
                continue;
            if (selectedIdx == idx)
                idx++;
            [dashboardCell setFrame:CGRectMake(DASHBOARD_MARGIN,
                                              COLLECTIONINFO_HEIGHT + ITEMS_GAP + (DASHBOARDINFO_HEIGHT + ITEMS_GAP) * idx,
                                              dashboardCell.frame.size.width,
                                               dashboardCell.frame.size.height)];
            dashboardCell.idx = idx;
            idx++;
        }
        if (selectedIdx >= ((NSArray*)[parent objectForKey:@"children"]).count)
            selectedIdx = ((NSArray*)[parent objectForKey:@"children"]).count - 1;
        vw.idx = selectedIdx;
        [vw_dash setFrame:CGRectMake(DASHBOARD_MARGIN,
                                    COLLECTIONINFO_HEIGHT + ITEMS_GAP + (DASHBOARDINFO_HEIGHT + ITEMS_GAP) * selectedIdx,
                                    vw_dash.frame.size.width,
                                     vw_dash.frame.size.height)];
    }
}

-(void)OnReorderCollection:(ReorderCollectionCell*)vw
{
    int selectedIdx = -1;
    
    for(NSDictionary* item in m_collectionViews)
    {
        ReorderCollectionCell* collectionCell = [item objectForKey:@"view"];
        if (collectionCell.hidden)
            continue;
        if (vw_dash.frame.origin.y < collectionCell.frame.origin.y &&
            vw.center.y > collectionCell.frame.origin.y + collectionCell.frame.size.height / 2 &&
            vw.center.y < collectionCell.frame.origin.y + collectionCell.frame.size.height)
        {
            selectedIdx = collectionCell.idx;
            break;
        }
        else if(vw_dash.frame.origin.y > collectionCell.frame.origin.y &&
                vw.center.y < collectionCell.frame.origin.y + collectionCell.frame.size.height / 2 &&
                vw.center.y > collectionCell.frame.origin.y)
        {
            selectedIdx = collectionCell.idx;
            break;
        }
    }
    if (selectedIdx == -1)
        return;
    int idx = 0;
    float yPos = 0;
    for(NSDictionary* item in m_collectionViews)
    {
        ReorderCollectionCell* collectionCell = [item objectForKey:@"view"];
        if (collectionCell.hidden)
            continue;
        if (selectedIdx == idx)
        {
            [vw_dash setFrame:CGRectMake(vw_dash.frame.origin.x, yPos, vw_dash.frame.size.width, vw_dash.frame.size.height)];
            yPos += (vw.frame.size.height + COLLECTIONINFO_MARGIN);
            vw.idx = idx;
            idx++;
        }
        [collectionCell setFrame:CGRectMake(collectionCell.frame.origin.x, yPos, collectionCell.frame.size.width, collectionCell.frame.size.height)];
        collectionCell.idx = idx;
        yPos += (collectionCell.frame.size.height + COLLECTIONINFO_MARGIN);
        idx++;
    }
    if (selectedIdx == idx)
    {
        [vw_dash setFrame:CGRectMake(vw_dash.frame.origin.x, yPos, vw_dash.frame.size.width, vw_dash.frame.size.height)];
        yPos += (vw.frame.size.height + COLLECTIONINFO_MARGIN);
        vw.idx = idx;
        idx++;
    }
}

-(void)RearrangeCollections
{
    NSMutableArray* collectionsInfo = [[NSMutableArray alloc] init];
    NSMutableArray* collections = [[NSMutableArray alloc] init];
    for(int i = 0; i < m_collectionViews.count; i++)
    {
        NSDictionary* item = [self GetCollectionByIdx:i];
        [collectionsInfo addObject:((ReorderCollectionCell*)[item objectForKey:@"view"]).collectionInfo];
        [collections addObject:item];
    }
    m_collectionViews = collections;
    self.aryDashboards = collectionsInfo;
}

-(NSDictionary*)GetCollectionByIdx:(int)idx
{
    for(NSDictionary* item in m_collectionViews)
    {
        ReorderCollectionCell* cell = [item objectForKey:@"view"];
        if (cell.idx == idx)
            return item;
    }
    return nil;
}

-(void)RearrangeDashboards:(ReorderDashboardCell*)vw
{
    NSDictionary* parent = nil;
    
    for(NSDictionary* item in m_collectionViews)
    {
        if ([[item objectForKey:@"view"] isEqual:vw.superview])
        {
            parent = item;
            break;
        }
    }
    CollectionInfo* collectionInfo = ((ReorderCollectionCell*)[parent objectForKey:@"view"]).collectionInfo;
    NSMutableArray* dashboardsInfo = [[NSMutableArray alloc] init];
    NSMutableArray* dashboards = [[NSMutableArray alloc] init];
    for(int i = 0; i < ((NSArray*)[parent objectForKey:@"children"]).count; i++)
    {
        ReorderDashboardCell* cell = [self GetDashboardByIdx:i dashboards:[parent objectForKey:@"children"]];
        [dashboardsInfo addObject:cell.dashboard];
        [dashboards addObject:cell];
    }
    NSDictionary* newCollection = @{@"view" : [parent objectForKey:@"view"], @"children" : dashboards};
    [m_collectionViews replaceObjectAtIndex:[m_collectionViews indexOfObject:parent] withObject:newCollection];
    collectionInfo.aryDashboards = dashboardsInfo;
}

-(ReorderDashboardCell*)GetDashboardByIdx:(int)idx dashboards:(NSArray*)ary
{
    for(ReorderDashboardCell* item in ary)
    {
        if (item.idx == idx)
            return item;
    }
    return nil;
}
@end
