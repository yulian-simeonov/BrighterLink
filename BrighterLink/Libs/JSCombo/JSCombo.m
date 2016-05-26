//
//  JSCombo.m
//  BrighterLink
//
//  Created by mobile master on 11/15/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "JSCombo.h"

@implementation JSCombo

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        tbl_combo = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        [self addSubview:tbl_combo];
        [tbl_combo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tbl_combo setDelegate:self];
        [tbl_combo setDataSource:self];
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(-3, 3);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.3;
        [self setUserInteractionEnabled:YES];
        [self setHidden:YES];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [tbl_combo setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_data)
        return m_data.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%d", indexPath.row]];
    }
    [cell.textLabel setText:[[m_data objectAtIndex:indexPath.row] objectForKey:@"text"]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    if ([m_selectedItem isEqual:[m_data objectAtIndex:indexPath.row]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)        
//        return;
    for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
        {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]].accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(SelectedObject:selectedObj:)])
            [_delegate SelectedObject:self selectedObj:[m_data objectAtIndex:indexPath.row]];
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self setHidden:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"test");
}

-(void)UpdateData:(NSArray*)data
{
    m_data = data;
    [tbl_combo reloadData];
    if (m_data.count < 5)
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, m_data.count * 20)];
}

-(void)setSelectedItem:(id)selectedItem
{
    m_selectedItem = selectedItem;
    if (selectedItem)
    {
        if (_delegate)
        {
            if ([_delegate respondsToSelector:@selector(SelectedObject:selectedObj:)])
                [_delegate SelectedObject:self selectedObj:m_selectedItem];
        }
    }
    [tbl_combo reloadData];
}

-(id)GetItemByText:(NSString*)txt
{
    for(NSDictionary* item in m_data)
    {
        if ([[item objectForKey:@"text"] isEqualToString:txt])
            return item;
    }
    return nil;
}
@end
