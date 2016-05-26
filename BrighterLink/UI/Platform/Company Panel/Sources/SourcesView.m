//
//  SourcesView.m
//  BrighterLink
//
//  Created by mobile master on 11/6/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "SourcesView.h"
#import "FacilityCell.h"
#import "DataLoggerCell.h"
#import "SensorCell.h"
#import "MetricCell.h"
#import "AddSourceView.h"
#import "FacilityDetailView.h"
#import "DataLoggerDetailView.h"
#import "SensorDetailView.h"
#import "EditFacilityView.h"
#import "EditDataLoggerView.h"
#import "EditSensorView.h"
#import "Tag.h"
#import "SharedMembers.h"
#import "EditMetricView.h"

@implementation SourcesView

+(UIView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SourcesView" owner:self options:nil];
    SourcesView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    img_searchBar.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1].CGColor;
    img_searchBar.layer.borderWidth = 1;
    img_searchBar.layer.cornerRadius = 4;
    btn_createSource.layer.borderWidth = 1;
    btn_createSource.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    btn_back.layer.borderWidth = 1;
    btn_back.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    m_navigationQueue = [[NSMutableArray alloc] init];
    [btn_back setHidden:YES];
    for(UIImageView* img_checker in img_checkers)
    {
        img_checker.layer.borderWidth = 1;
        img_checker.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    
    m_dataSources = [[NSMutableArray alloc] init];
    vw_relatedSources = [RelatedDataSourcesView ShowView:self];
    vw_relatedSources.center = CGPointMake(self.frame.size.width / 2, vw_relatedSources.frame.size.height / 2);
    [vw_relatedSources setDelegate:self];
    [self addSubview:vw_relatedSources];
    [vw_relatedSources setHidden:YES];
    
    if([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
    {
        [btn_createSource setHidden:YES];
    }
    
    [self ReloadData];
}

-(IBAction)OnClickSearchType:(UIButton*)sender
{
    [self SetSearchType:sender.tag];
}

-(void)SetSearchType:(int)type
{
    m_bChecked[type] = !m_bChecked[type];
    UIImageView* checker = (UIImageView*)[img_checkers objectAtIndex:type];
    if (m_bChecked[type])
        [checker setImage:[UIImage imageNamed:@"checkbox-selected.png"]];
    else
        [checker setImage:[UIImage imageNamed:@"checkbox.png"]];
    [self ReloadData];
}

-(void)RestoreSearchType
{
    [txt_search setText:m_keyword];
    for(int i = 0; i < 4; i++)
    {
        m_bChecked[i] = m_bReservedChecked[i];
        UIImageView* checker = (UIImageView*)[img_checkers objectAtIndex:i];
        if (m_bChecked[i])
            [checker setImage:[UIImage imageNamed:@"checkbox-selected.png"]];
        else
            [checker setImage:[UIImage imageNamed:@"checkbox.png"]];
    }
    [tbl_sources reloadData];
}

-(void)ClearSearchType
{
    m_keyword = txt_search.text;
    [txt_search setText:nil];
    for(int i = 0; i < 4; i++)
    {
        m_bReservedChecked[i] = m_bChecked[i];
        m_bChecked[i] = NO;
        UIImageView* checker = (UIImageView*)[img_checkers objectAtIndex:i];
        [checker setImage:[UIImage imageNamed:@"checkbox.png"]];
    }
}

-(IBAction)OnCreateSource:(id)sender
{
    AddSourceView* vw = [AddSourceView ShowView:self.superview];
    [vw setSourceView:self];
}

-(void)OnEditSource:(Tag*)tag delegate:(id)dlgt
{
    if ([tag.tagType isEqualToString:@"Facility"])
    {
        EditFacilityView* vw = [EditFacilityView ShowView:self.superview];
        [vw setDelegate:dlgt];
        [vw UpdateWithData:tag];
    }
    else if([tag.tagType isEqualToString:@"Scope"])
    {
        EditDataLoggerView* vw = [EditDataLoggerView ShowView:self.superview];
        [vw setDelegate:dlgt];
        [vw UpdateWithData:tag];
    }
    else if([tag.tagType isEqualToString:@"Node"])
    {
        EditSensorView* vw = [EditSensorView ShowView:self.superview];
        [vw setDelegate:dlgt];
        [vw UpdateWithData:tag];
    }
}

-(IBAction)OnTextChanged:(UITextField*)sender
{
    [self ReloadData];
}

-(void)ReloadData
{
    for(UIView* vw in vw_detail.subviews)
    {
        if ([vw isEqual:tbl_sources])
            continue;
        else
            [vw removeFromSuperview];
    }
    [m_navigationQueue removeAllObjects];
    [btn_back setHidden:YES];
    [vw_relatedSources setHidden:YES];
    [lbl_title setText:@"Sources"];
    
    [m_dataSources removeAllObjects];
    BOOL hasSearchType = NO;
    for(int i = 0; i < 4; i++)
    {
        if (m_bChecked[i])
        {
            hasSearchType = YES;
            break;
        }
    }
    if (!hasSearchType)
    {
        m_bChecked[0] = YES;
    }
    NSMutableArray* tmpAry = [[NSMutableArray alloc] init];
    for(Tag* tg in [SharedMembers sharedInstance].RootTags)
    {
        [self CheckTag:tg ary:tmpAry];
    }
    for(Tag* tg in tmpAry)
    {
        if ([tg.tagType isEqualToString:@"Facility"] && m_bChecked[0])
            [m_dataSources addObject:tg];
    }
    for(Tag* tg in tmpAry)
    {
        if ([tg.tagType isEqualToString:@"Scope"] && m_bChecked[1])
            [m_dataSources addObject:tg];
    }
    for(Tag* tg in tmpAry)
    {
        if ([tg.tagType isEqualToString:@"Node"] && m_bChecked[2])
            [m_dataSources addObject:tg];
    }
    for(Tag* tg in tmpAry)
    {
        if ([tg.tagType isEqualToString:@"Metric"] && m_bChecked[3])
            [m_dataSources addObject:tg];
    }
    if (!hasSearchType)
        m_bChecked[0] = NO;
    [tbl_sources reloadData];
}

-(void)CheckTag:(Tag*)tg ary:(NSMutableArray*)ary
{
    if (([tg.tagType isEqualToString:@"Facility"] && m_bChecked[0]) ||
        ([tg.tagType isEqualToString:@"Scope"] && m_bChecked[1]) ||
        ([tg.tagType isEqualToString:@"Node"] && m_bChecked[2]) ||
        ([tg.tagType isEqualToString:@"Metric"] && m_bChecked[3]))
    {
        if (txt_search.text.length > 0)
        {
            if([tg.name.lowercaseString rangeOfString:txt_search.text.lowercaseString].location != NSNotFound)
                [ary addObject:tg];
        }
        else
            [ary addObject:tg];
    }
    for(Tag* tgItem in tg.childrenTags)
    {
        [self CheckTag:tgItem ary:ary];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tag* item = [m_dataSources objectAtIndex:indexPath.row];
    if ([item.tagType isEqualToString:@"Metric"])
        return 41;
    else
        return 62;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        NSArray* nib = nil;
        Tag* item = [m_dataSources objectAtIndex:indexPath.row];
        if([item.tagType isEqualToString:@"Facility"])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"FacilityCell" owner:self options:nil];
            FacilityCell* fCell = [nib objectAtIndex:0];
            [fCell SetTagData:item];
            [fCell setDelegate:self];
            cell = fCell;
        }
        else if([item.tagType isEqualToString:@"Scope"])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DataLoggerCell" owner:self options:nil];
            DataLoggerCell* dCell = [nib objectAtIndex:0];
            [dCell SetTagData:item];
            [dCell setDelegate:self];
            cell = dCell;
        }
        else if([item.tagType isEqualToString:@"Node"])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"SensorCell" owner:self options:nil];
            SensorCell * sCell = [nib objectAtIndex:0];
            [sCell SetTagData:item];
            [sCell setDelegate:self];
            cell = sCell;
        }
        else if([item.tagType isEqualToString:@"Metric"])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MetricCell" owner:self options:nil];
            MetricCell* mCell = [nib objectAtIndex:0];
            [mCell SetTagData:item];
            [mCell setDelegate:self];
            cell = mCell;
        }
    }
    return cell;
}

-(void)DidSelectRowWithObject:(id)object
{
    if (m_navigationQueue.count == 0)
        [self ClearSearchType];
    Tag* param = (Tag*)object;
    UIView* vw_child;
    if ([param.tagType isEqualToString:@"Facility"])
    {
        FacilityDetailView* vw = [FacilityDetailView ShowView:vw_detail];
        [vw SetTagData:param];
        [vw setDelegate:self];
        vw_child = vw;
        [lbl_title setText:@"Facility"];
    }
    else if([param.tagType isEqualToString:@"Scope"])
    {
        DataLoggerDetailView* vw = [DataLoggerDetailView ShowView:vw_detail];
        [vw SetTagData:param];
        [vw setDelegate:self];
        vw_child = vw;
        [lbl_title setText:@"Scope"];
    }
    else if([param.tagType isEqualToString:@"Node"])
    {
        SensorDetailView* vw = [SensorDetailView ShowView:vw_detail];
        [vw SetTagData:param];
        [vw setDelegate:self];
        vw_child = vw;
        [lbl_title setText:@"Node"];
    }
    else if([param.tagType isEqualToString:@"Metric"])
    {
        EditMetricView* vw = [EditMetricView ShowView:self];
        if (m_navigationQueue.count == 0)
            [vw setSourceView:self];
        else
        {
            [vw_relatedSources setHidden:YES];
            [vw setRelatedSourceView:vw_relatedSources];
        }
        [vw UpdateWithData:param];
        
        return;
    }
    [vw_relatedSources UpdateData:param];
    
    [vw_relatedSources setHidden:NO];
    [btn_back setHidden:NO];
    [vw_detail addSubview:vw_child];
    [m_navigationQueue addObject:@{@"object" : object, @"view" : vw_child}];
}

-(IBAction)OnBack:(id)sender
{
    NSDictionary* lastObject = [m_navigationQueue lastObject];
    [((UIView*)[lastObject objectForKey:@"view"]) removeFromSuperview];
    [m_navigationQueue removeLastObject];
    if (m_navigationQueue.count == 0)
    {
        [btn_back setHidden:YES];
        [vw_relatedSources setHidden:YES];
        [lbl_title setText:@"Sources"];
        [self RestoreSearchType];
    }
    else
    {
        lastObject = [m_navigationQueue lastObject];
        Tag* tag = [lastObject objectForKey:@"object"];
        [vw_relatedSources UpdateData:tag];
        if ([tag.tagType isEqualToString:@"Facility"])
        {
            [lbl_title setText:@"Facility"];
        }
        else if([tag.tagType isEqualToString:@"Scope"])
        {
            [lbl_title setText:@"Scope"];
        }
        else if([tag.tagType isEqualToString:@"Node"])
        {
            [lbl_title setText:@"Node"];
        }
        [vw_relatedSources Refresh];
    }
}
@end
