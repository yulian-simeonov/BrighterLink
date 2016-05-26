//
//  MyTreeNode.m
//  MyTreeViewPrototype
//
//  Created by Jon Limjap on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSTreeNode.h"

@implementation JSTreeNode

@synthesize index, value;
@synthesize parent, children;
@synthesize inclusive;

#pragma mark -
#pragma mark Initializers

- (id)initWithValue:(id)_value {
	self = [super init];
	if (self) {
		value = _value;
		inclusive = NO;
	}
	
	return self;
}

#pragma mark -
#pragma mark Custom Properties

- (NSMutableArray *)children {
	if (!children) {
		children = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	return children;
}

#pragma mark -
#pragma mark Methods

- (NSUInteger)descendantCount {
	NSUInteger cnt = 0;
	
	for (JSTreeNode *child in self.children) {
		if (self.inclusive) {
			cnt++;
			if (child.children.count > 0) {
				cnt += [child descendantCount];
			}
		}
	}
	
	return cnt;
}

- (NSArray *)flattenElements {
	return [self flattenElementsWithCacheRefresh:NO];
}

- (NSArray *)flattenElementsWithCacheRefresh:(BOOL)invalidate {
	if (!flattenedTreeCache || invalidate) {
		//if there was a previous cache and due for invalidate, release resources first
		if (flattenedTreeCache) {
			flattenedTreeCache = nil;
		}
		
		NSMutableArray *allElements = [[NSMutableArray alloc] initWithCapacity:[self descendantCount]];
		[allElements addObject:self];
		
		if (inclusive) {
			for (JSTreeNode *child in self.children) {
				[allElements addObjectsFromArray:[child flattenElementsWithCacheRefresh:invalidate]];
			}
		}
		
		flattenedTreeCache = [[NSArray alloc] initWithArray:allElements];
	}
	
	return flattenedTreeCache;
}

- (void)addChild:(JSTreeNode *)newChild {
	newChild.parent = self;
	[self.children addObject:newChild];
}

- (NSUInteger)levelDepth {
	if (!parent) return 0;
	
	NSUInteger cnt = 0;
	cnt++;
	cnt += [parent levelDepth];
	
	return cnt;
}

- (BOOL)isRoot {
	return (!parent);
}

- (BOOL)hasChildren {
	return (self.children.count > 0);
}

-(void)setSelected:(BOOL)selected
{
    m_selected = selected;
}

-(BOOL)selected
{
    return m_selected;
}

-(void)SelectChildren:(BOOL)selected
{
    [self setSelected:selected];
    if (children)
    {
        for(JSTreeNode* child in children)
        {
            [child SelectChildren:selected];
        }
    }
}

-(void)UpdateParent
{
    if (parent)
    {
        BOOL selectedAll = YES;
        for(JSTreeNode* child in parent.children)
        {
            if (!child.selected)
            {
                selectedAll = NO;
                break;
            }
        }
        parent.selected = selectedAll;
        [parent UpdateParent];
    }
}
@end

