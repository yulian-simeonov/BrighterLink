//
//  RelatedDataSourcesView.m
//  BrighterLink
//
//  Created by mobile master on 11/9/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "RelatedDataSourcesView.h"
#import "SourcesView.h"
#import "AddDataLoggerView.h"
#import "AddSensorView.h"
#import "AddMetricView.h"

@implementation RelatedDataSourcesView

+(RelatedDataSourcesView*)ShowView:(UIView*)parentView
{
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"RelatedDataSourcesView" owner:self options:nil];
    RelatedDataSourcesView* vw = [nib objectAtIndex:0];
    [vw Initialize];
    vw.layer.zPosition = 10;
    [parentView addSubview:vw];
    return vw;
}

-(void)Initialize
{
    btn_create.layer.borderWidth = 1;
    btn_create.layer.borderColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1].CGColor;
    m_dataSources = [[NSMutableArray alloc] init];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1].CGColor;
    if ([[SharedMembers sharedInstance].userInfo.role isEqualToString:@"TM"])
    {
        [btn_create setHidden:YES];
    }
}

-(void)UpdateData:(Tag*)tag
{
    m_tag = tag;
    if ([m_tag.tagType isEqualToString:@"Facility"])
    {
        [lbl_header setText:@"Related Scopes"];
        [lbl_title setText:@"Related Scopes"];
        [btn_create setTitle:@"  Add Scope" forState:UIControlStateNormal];
    }
    else if([m_tag.tagType isEqualToString:@"Scope"])
    {
        [lbl_header setText:@"Related Nodes"];
        [lbl_title setText:@"Related Nodes"];
        [btn_create setTitle:@"  Add Node" forState:UIControlStateNormal];
    }
    else if([m_tag.tagType isEqualToString:@"Node"])
    {
        [lbl_header setText:@"Related Metrics"];
        [lbl_title setText:@"Related Metrics"];
        [btn_create setTitle:@"  Add Metric" forState:UIControlStateNormal];
    }
    float tblHeight = 0;
    if ([m_tag.tagType isEqualToString:@"Node"])
    {
        tblHeight = m_tag.childrenTags.count * 41;
        if (m_tag.childrenTags.count > 4)
            tblHeight = 41 * 6;
    }
    else
    {
        tblHeight = m_tag.childrenTags.count * 62;
        if (m_tag.childrenTags.count > 4)
            tblHeight = 62 * 4;
    }
    [tbl_children setFrame:CGRectMake(tbl_children.frame.origin.x, tbl_children.frame.origin.y, tbl_children.frame.size.width, tblHeight)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.superview.frame.size.height - tbl_children.frame.origin.y - tbl_children.frame.size.height, self.frame.size.width, tbl_children.frame.origin.y + tbl_children.frame.size.height)];
    m_bOpened = YES;
    [tbl_children reloadData];
    [self setHidden:NO];
    [self OnOpenOrClose:nil];
}

-(void)Refresh
{
    [tbl_children reloadData];
}

-(IBAction)OnAddNew:(id)sender
{
    if ([m_tag.tagType isEqualToString:@"Facility"])
    {
        AddDataLoggerView* vw = [AddDataLoggerView ShowView:self.superview];
        [vw setParentTag:m_tag];
        [vw setRelatedSourceView:self];
    }
    else if([m_tag.tagType isEqualToString:@"Scope"])
    {
        AddSensorView* vw = [AddSensorView ShowView:self.superview];
        [vw setParentTag:m_tag];
        [vw setRelatedSourceView:self];
    }
    else if([m_tag.tagType isEqualToString:@"Node"])
    {
        AddMetricView* vw = [AddMetricView ShowView:self.superview];
        [vw setParentTag:m_tag];
        [vw setRelatedSourceView:self];
    }
    else
        return;
    [self setHidden:YES];
}

-(IBAction)OnOpenOrClose:(id)sender
{
    if (m_bOpened)
    {
        [UIView animateWithDuration:0.3f animations:^{
            [self setFrame:CGRectMake(self.frame.origin.x, self.superview.frame.size.height - 45, self.frame.size.width, tbl_children.frame.origin.y + tbl_children.frame.size.height)];
            [img_arrowIcon setImage:[UIImage imageNamed:@"icon_arrow_up.png"]];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            [self setFrame:CGRectMake(self.frame.origin.x, self.superview.frame.size.height - tbl_children.frame.origin.y - tbl_children.frame.size.height, self.frame.size.width, tbl_children.frame.origin.y + tbl_children.frame.size.height)];
            [img_arrowIcon setImage:[UIImage imageNamed:@"icon_arrow_down.png"]];
        }];
    }
    m_bOpened = !m_bOpened;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([m_tag.tagType isEqualToString:@"Node"])
        return 41;
    else
        return 62;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_tag.childrenTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        NSArray* nib = nil;
        if ([m_tag.tagType isEqualToString:@"Facility"])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DataLoggerCell" owner:self options:nil];
            DataLoggerCell* dCell = [nib objectAtIndex:0];
            [dCell SetTagData:[m_tag.childrenTags objectAtIndex:indexPath.row]];
            [dCell setDelegate:_delegate];
            cell = dCell;
        }
        else if([m_tag.tagType isEqualToString:@"Scope"])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"SensorCell" owner:self options:nil];
            SensorCell * sCell = [nib objectAtIndex:0];
            [sCell SetTagData:[m_tag.childrenTags objectAtIndex:indexPath.row]];
            [sCell setDelegate:_delegate];
            cell = sCell;
        }
        else if([m_tag.tagType isEqualToString:@"Node"])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MetricCell" owner:self options:nil];
            MetricCell* mCell = [nib objectAtIndex:0];
            [mCell SetTagData:[m_tag.childrenTags objectAtIndex:indexPath.row]];
            [mCell setDelegate:_delegate];
            cell = mCell;
        }
    }
    return cell;
}

@end
