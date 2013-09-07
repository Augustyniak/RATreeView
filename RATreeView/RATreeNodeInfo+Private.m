//
//  RATreeNodeInfo+Private.m
//  RATreeView
//
//  Created by Rafal Augustyniak on 07.09.2013.
//  Copyright (c) 2013 Rafal Augustyniak. All rights reserved.
//

#import "RATreeNodeInfo+Private.h"

@implementation RATreeNodeInfo (Private)
@dynamic  treeDepthLevel;
@dynamic  expanded;

@dynamic siblingsNumber;
@dynamic positionInSiblings;

@dynamic  childrenTreeNodes;
@dynamic parentTreeNode;

@dynamic item;


- (id)initWithParent:(RATreeNode *)parent children:(NSArray *)children item:(id)item
{
  self = [super init];
  if (self) {
    self.parentTreeNode = parent;
    self.childrenTreeNodes = children;
    self.item = item;
  }
  return self;
}

@end
