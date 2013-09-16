
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RATreeNodeCollectionController.h"
#import "RATreeNode.h"

@implementation RATreeNodeCollectionController

- (id)init
{
  self = [super init];
  if (self) {
    self.root = [[RATreeNode alloc] initWithItem:nil parent:nil expanded:YES];
  }
  return self;
}

- (void)addTreeNode:(RATreeNode *)treeNode
{
  if (treeNode.parent == nil) {
    [self.root addChildNode:treeNode];
    treeNode.parent = self.root;
  } else {
    [treeNode.parent addChildNode:treeNode];
    if (treeNode.expanded) {
      [treeNode expand];
    }
  }
}

- (RATreeNode *)treeNodeForIndex:(NSInteger)index
{
  if (index < 0) {
    return nil;
  }
  return [self treeNodeForIndex:index treeNode:self.root];
}

- (RATreeNode *)treeNodeForIndex:(NSInteger)index treeNode:(RATreeNode *)currentTreeNode
{
  for (RATreeNode *treeNode in currentTreeNode.children) {
    if ([treeNode startIndex] == index) {
      return treeNode;
    } else if (index <= [treeNode endIndex]) {
      return [self treeNodeForIndex:index treeNode:treeNode];
    }
  }
  return nil;
}

- (NSInteger)indexForItem:(id)item
{
  return [self indexForItem:item treeNode:self.root];
}

- (NSInteger)indexForItem:(id)item treeNode:(RATreeNode *)currentTreeNode
{
  NSArray *array = [self.root visibleDescendants];
  NSInteger index = 0;
  for (RATreeNode *treeNode in array) {
    if ([treeNode.item isEqual:item]) {
      return index;
    }
    index++;
  }
  return -1;
}




@end
