//
//  Tag.m
//  BrighterLink
//
//  Created by mobile master on 11/12/14.
//  Copyright (c) 2014 Brightergy. All rights reserved.
//

#import "Tag.h"

@implementation Tag

-(id)init
{
    if (self = [super init])
    {
        m_selected = NO;
        m_parent = nil;
    }
    return self;
}

-(void)SetDataWithDictionary:(NSDictionary*)dic parent:(Tag*)parentTag
{
    [self setDictionary:dic];
    _childrenTags = [[NSMutableArray alloc] init];
    m_parent = parentTag;
    for(NSDictionary* tg in [dic objectForKey:@"childTags"])
    {
        Tag* tag = [[Tag alloc] init];
        [tag SetDataWithDictionary:tg parent:self];
        [_childrenTags addObject:tag];
    }
}

-(void)AddNewTag:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock
{
    [[SharedMembers sharedInstance].webManager CreateTag:[self getDictionary] success:^(MKNetworkOperation *networkOperation) {
        [self setDictionary:[[networkOperation.responseJSON objectForKey:@"message"] objectAtIndex:0]];
        successBlock(networkOperation);
    } failure:nil];
}

-(void)UpdateTag:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock
{
    self.childrenTags = nil;
    [[SharedMembers sharedInstance].webManager EditTag:[self getDictionary] tagId:self._id success:^(MKNetworkOperation *networkOperation) {
        [self setDictionary:[networkOperation.responseJSON objectForKey:@"message"]];
        successBlock(networkOperation);
    } failure:nil];
}

-(void)DeleteTag:(SuccessBlock)successBlock failed:(ErrorBlock)errorBlock
{
    [[SharedMembers sharedInstance].webManager DeleteTag:self._id success:^(MKNetworkOperation *networkOperation) {
        [m_parent.childrenTags removeObject:self];
        successBlock(networkOperation);
//        [[SharedMembers sharedInstance].webManager GetUserTags:[SharedMembers sharedInstance].userInfo._id success:^(MKNetworkOperation *networkOperation) {
//            for(NSDictionary* tag in [networkOperation.responseJSON objectForKey:@"message"])
//            {
//                Tag* tg = [[Tag alloc] init];
//                [tg SetDataWithDictionary:tag parent:nil];
//                [[SharedMembers sharedInstance].RootTags addObject:tg];
//            }
//            successBlock(networkOperation);
//        } failure:errorBlock];
    } failure:errorBlock];
}

-(void)setSelected:(BOOL)selected
{
    m_selected = selected;
    for(Tag* tg in _childrenTags)
    {
        [tg setSelected:selected];
    }
}

-(void)UpdateParent
{
    if (m_parent)
    {
        BOOL selectedAll = YES;
        for(Tag* child in m_parent.childrenTags)
        {
            if (!child->m_selected)
            {
                selectedAll = NO;
                break;
            }
        }
        m_parent->m_selected = selectedAll;
        [m_parent UpdateParent];
    }
}
@end
