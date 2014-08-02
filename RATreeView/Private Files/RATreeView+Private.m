
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
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
#import "RATreeView+RATreeNodeCollectionControllerDataSource.h"
#import "RATreeView_ClassExtension.h"

#import "RABatchChanges.h"

#import "RATreeNode.h"
#import "RATreeNodeController.h"
#import "RATreeNodeCollectionController.h"



@implementation RATreeView (Private)

- (void)setupTreeStructure
{
  self.treeNodeCollectionController = [[RATreeNodeCollectionController alloc] init];
  self.treeNodeCollectionController.dataSource = self;
  self.batchChanges = [[RABatchChanges alloc] init];
}

- (NSArray *)childrenForItem:(id)item
{
  NSParameterAssert(item);
  
  NSMutableArray *children = [NSMutableArray array];
  NSInteger numberOfChildren = [self.dataSource treeView:self numberOfChildrenOfItem:item];
  
  for (int i = 0; i < numberOfChildren; i++) {
    [children addObject:[self.dataSource treeView:self child:i ofItem:item]];
  }
  
  return [NSArray arrayWithArray:children];
}

- (RATreeNode *)treeNodeForIndexPath:(NSIndexPath *)indexPath
{
  NSParameterAssert(indexPath.section == 0);
  return [self.treeNodeCollectionController treeNodeForIndex:indexPath.row];
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
  [self.batchChanges beginUpdates];
  
  NSInteger index = [self.treeNodeCollectionController lastVisibleDescendantIndexForItem:treeNode.item];
  
  __weak typeof(self) weakSelf = self;
  [self.batchChanges collapseItemWithBlock:^{
    UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:rowAnimation];
    [weakSelf.treeNodeCollectionController collapseRowForItem:treeNode.item updates:^(NSIndexSet *deletions) {
      [weakSelf.tableView deleteRowsAtIndexPaths:IndexesToIndexPaths(deletions) withRowAnimation:tableViewRowAnimation];
    }];
  } lastIndex:index];
  
  [self.batchChanges endUpdates];
  [self.tableView endUpdates];
}

- (void)expandCellForTreeNode:(RATreeNode *)treeNode
{
  [self expandCellForTreeNode:treeNode withRowAnimation:self.rowsExpandingAnimation];
}

- (void)expandCellForTreeNode:(RATreeNode *)treeNode withRowAnimation:(RATreeViewRowAnimation)rowAnimation
{
  [self.tableView beginUpdates];
  [self.batchChanges beginUpdates];
  
  NSInteger index = [self.treeNodeCollectionController indexForItem:treeNode.item];
  __weak typeof(self) weakSelf = self;
  [self.batchChanges expandItemWithBlock:^{
    UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:rowAnimation];
    [weakSelf.treeNodeCollectionController expandRowForItem:treeNode.item updates:^(NSIndexSet *insertions) {
      [weakSelf.tableView insertRowsAtIndexPaths:IndexesToIndexPaths(insertions) withRowAnimation:tableViewRowAnimation];
    }];
  } atIndex:index];
  
  
  [self.batchChanges endUpdates];
  [self.tableView endUpdates];
}

- (void)insertItemAtIndex:(NSInteger)index inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation
{
  NSInteger idx = [self.treeNodeCollectionController indexForItem:parent];
  if (idx == NSNotFound) {
    return;
  }
  idx += index + 1;
  
  __weak typeof(self) weakSelf = self;
  [self.batchChanges insertItemWithBlock:^{
    [weakSelf.treeNodeCollectionController insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:animation];
    [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:tableViewRowAnimation];
    
  } atIndex:idx];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)moveItemAtIndex:(NSInteger)index inParent:(id)parent toIndex:(NSInteger)newIndex inParent:(id)newParent
#pragma clang diagnostic pop
{
  NSInteger idx = [self.treeNodeCollectionController indexForItem:parent];
  if (idx == NSNotFound) {
    return;
  }
  
  idx += index + 1;
  __weak typeof(self) weakSelf = self;
  [self.batchChanges insertItemWithBlock:^{
    [weakSelf.treeNodeCollectionController moveItemAtIndex:index inParent:parent toIndex:newIndex inParent:newParent updates:^(NSIndexSet *deletions, NSIndexSet *additions) {
      NSArray *deletionsArray = IndexesToIndexPaths(deletions);
      NSArray *additionsArray = IndexesToIndexPaths(additions);
    
      NSInteger i = 0;
      for (NSIndexPath *deletedIndexPath in deletionsArray) {
        [weakSelf.tableView moveRowAtIndexPath:deletedIndexPath toIndexPath:additionsArray[i]];
        i++;
      }
    }];
  } atIndex:idx];
}

- (void)removeItemAtIndex:(NSInteger)index inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation
{
  id child = [self.treeNodeCollectionController childInParent:parent atIndex:index];
  NSInteger idx = [self.treeNodeCollectionController lastVisibleDescendantIndexForItem:child];
  if (idx == NSNotFound) {
    return;
  }
  
  __weak typeof(self) weakSelf = self;
  [self.batchChanges insertItemWithBlock:^{
    [weakSelf.treeNodeCollectionController removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent updates:^(NSIndexSet *removedIndexes) {
      UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:animation];
      [weakSelf.tableView deleteRowsAtIndexPaths:IndexesToIndexPaths(removedIndexes) withRowAnimation:tableViewRowAnimation];
    }];
  } atIndex:idx];
}

#pragma mark -

static NSArray * IndexesToIndexPaths(NSIndexSet *indexes)
{
  NSMutableArray *indexPaths = [NSMutableArray array];
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
  }];
  return [indexPaths copy];
}

@end
