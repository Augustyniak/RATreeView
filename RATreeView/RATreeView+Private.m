
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

#import "RATreeView+Private.h"
#import "RATreeView+Enums.h"

#import "RATreeNode.h"
#import "RATreeNodeCollectionController.h"



@implementation RATreeView (Private)

@dynamic tableView;
@dynamic treeNodeCollectionController;

- (NSArray *)childrenForItem:(id)item
{
  NSMutableArray *children = [NSMutableArray array];
  NSInteger numberOfChildren = [self.dataSource treeView:self numberOfChildrenOfItem:item];
  
  for (int i = 0; i < numberOfChildren; i++) {
    [children addObject:[self.dataSource treeView:self child:i ofItem:item]];
  }
  return [NSArray arrayWithArray:children];
}

- (void)setupTreeStructure
{
  self.treeNodeCollectionController = [[RATreeNodeCollectionController alloc] init];
  [self setupTreeStructureWithParentNode:nil treeDepthLevel:0];
}

- (void)setupTreeStructureWithParentNode:(RATreeNode *)parentTreeNode treeDepthLevel:(NSInteger)treeDepthLevel
{
  NSArray *children = [self childrenForItem:parentTreeNode.item];
  for (id item in children) {
    BOOL expanded = NO;
    if ([self.dataSource respondsToSelector:@selector(treeView:shouldItemBeExpandedAfterDataReload:treeDepthLevel:)]) {
      expanded = [self.delegate treeView:self shouldItemBeExpandedAfterDataReload:item treeDepthLevel:treeDepthLevel];
    }
    RATreeNode *treeNode = [[RATreeNode alloc] initWithItem:item parent:parentTreeNode expanded:expanded];
    
    [self setupTreeStructureWithParentNode:treeNode treeDepthLevel:(treeDepthLevel + 1)];
    [self.treeNodeCollectionController addTreeNode:treeNode];
  }
}

- (RATreeNode *)treeNodeForIndex:(NSInteger)index
{
  return [self.treeNodeCollectionController treeNodeForIndex:index];
}

- (NSIndexPath *)indexPathForItem:(id)item
{
  return [NSIndexPath indexPathForRow:[self.treeNodeCollectionController indexForItem:item] inSection:0];
}

#pragma mark Collapsing and Expanding Rows

- (void)collapseCellForTreeNode:(RATreeNode *)treeNode
{
  [self collapseCellForTreeNode:treeNode withRowAnimation:self.rowsCollapsingAnimation];
}

- (void)collapseCellForTreeNode:(RATreeNode *)treeNode withRowAnimation:(RATreeViewRowAnimation)rowAnimation
{
  [self.tableView beginUpdates];
  NSMutableArray *indexes = [NSMutableArray array];
  for (int index = [treeNode startIndex] + 1; index <= [treeNode endIndex]; index++) {
    [indexes addObject:[NSIndexPath indexPathForRow:index inSection:0]];
  }
  [treeNode collapse];
  UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:rowAnimation];
  [self.tableView deleteRowsAtIndexPaths:indexes withRowAnimation:tableViewRowAnimation];
  [self.tableView endUpdates];
}

- (void)expandCellForTreeNode:(RATreeNode *)treeNode
{
  [self expandCellForTreeNode:treeNode withRowAnimation:self.rowsExpandingAnimation];
}

- (void)expandCellForTreeNode:(RATreeNode *)treeNode withRowAnimation:(RATreeViewRowAnimation)rowAnimation
{
  [self.tableView beginUpdates];
  [treeNode expand];
  NSMutableArray *indexes = [NSMutableArray array];
  for (int index = [treeNode startIndex] + 1; index <= [treeNode endIndex]; index++) {
    [indexes addObject:[NSIndexPath indexPathForRow:index inSection:0]];
  }
  UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:rowAnimation];
  [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:tableViewRowAnimation];
  [self.tableView endUpdates];

}

@end
