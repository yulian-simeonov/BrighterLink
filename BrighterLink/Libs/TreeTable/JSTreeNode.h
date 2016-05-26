//
//  MyTreeNode.h
//  MyTreeViewPrototype
//
//  Created by Jon Limjap on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSTreeNode.h"

@interface JSTreeNode : NSObject {
	int index;
	id value;
	JSTreeNode *parent;
	NSMutableArray *children;
	BOOL inclusive;
	NSArray *flattenedTreeCache;
    BOOL m_selected;
}

@property (nonatomic) int index;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) JSTreeNode *parent;
@property (nonatomic, strong, readonly) NSMutableArray *children;
@property (nonatomic) BOOL inclusive;
@property (nonatomic) BOOL selected;

- (id)initWithValue:(id)_value;

- (void)addChild:(JSTreeNode *)newChild;
- (NSUInteger)descendantCount;
- (NSUInteger)levelDepth;
- (NSArray *)flattenElements;
- (NSArray *)flattenElementsWithCacheRefresh:(BOOL)invalidate;
- (BOOL)isRoot;
- (BOOL)hasChildren;
-(BOOL)selected;
-(void)SelectChildren:(BOOL)selected;
-(void)UpdateParent;
@end
