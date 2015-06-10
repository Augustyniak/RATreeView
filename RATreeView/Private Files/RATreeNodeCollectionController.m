
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


#import "RATreeNodeCollectionController.h"
#import "RATreeNodeController.h"

#import "RATreeNode.h"
#import "RATreeNodeItem+Private.h"

#import "RABatchChanges.h"


@interface RATreeNodeCollectionController () <RATreeNodeItemDataSource>

@property (nonatomic, strong) RATreeNodeController *rootController;

@end


@implementation RATreeNodeCollectionController

- (NSInteger)numberOfVisibleRowsForItems
{
  return self.rootController.numberOfVisibleDescendants;
}

- (RATreeNode *)treeNodeForIndex:(NSInteger)index
{
  return [self.rootController controllerForIndex:index].treeNode;
}

- (NSInteger)indexForItem:(id)item
{
  return [self.rootController indexForItem:item];
}

- (NSInteger)lastVisibleDescendantIndexForItem:(id)item
{
  return [self.rootController lastVisibleDescendatIndexForItem:item];
}

- (id)parentForItem:(id)item
{
  RATreeNodeController *controller = [self.rootController controllerForItem:item];
  return controller.parentController.treeNode.item;
}

- (NSInteger)levelForItem:(id)item
{
  return [self.rootController controllerForItem:item].level;
}

- (id)childInParent:(id)parent atIndex:(NSInteger)index
{
  RATreeNodeController *controller = [self.rootController controllerForItem:parent].childControllers[index];
  return controller.treeNode.item;
}

- (void)expandRowForItem:(id)item updates:(void (^)(NSIndexSet *))updates
{
  [self expandRowForItem:item expandChildren:YES updates:updates];
}

- (void)expandRowForItem:(id)item expandChildren:(BOOL)expandChildren updates:(void (^)(NSIndexSet *))updates
{
  NSParameterAssert(updates);
  
  RATreeNodeController *parentController = [self.rootController controllerForItem:item];
  NSMutableArray *items = [@[item] mutableCopy];
  
  while ([items count] > 0) {
    id currentItem = [items firstObject];
    [items removeObject:currentItem];
    
    RATreeNodeController *controller = [self.rootController controllerForItem:currentItem];
    NSMutableArray *oldChildItems = [NSMutableArray array];
    for (RATreeNodeController *nodeController in controller.childControllers) {
      [oldChildItems addObject:nodeController.treeNode.item];
    }
    
    NSInteger numberOfChildren = [self.dataSource treeNodeCollectionController:self numberOfChildrenForItem:controller.treeNode.item];
    NSIndexSet *allIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfChildren)];
    
    NSArray *currentChildControllersAndIndexes = [self controllersAndIndexesForNodesWithIndexes:allIndexes inParentController:controller];
    NSArray *currentChildControllers = [currentChildControllersAndIndexes valueForKey:@"controller"];
    
    NSMutableArray *childControllersToInsert = [NSMutableArray array];
    NSMutableIndexSet *indexesForInsertions = [NSMutableIndexSet indexSet];
    NSMutableArray *childControllersToRemove = [NSMutableArray array];
    NSMutableIndexSet *indexesForDeletions = [NSMutableIndexSet indexSet];
    
    for (RATreeNodeController *loopNodeController in currentChildControllers) {
      if (![controller.childControllers containsObject:loopNodeController]
          && ![oldChildItems containsObject:controller.treeNode.item]) {
        [childControllersToInsert addObject:loopNodeController];
        NSInteger index = [currentChildControllers indexOfObject:loopNodeController];
        NSAssert(index != NSNotFound, nil);
        [indexesForInsertions addIndex:index];
      }
    }
    
    for (RATreeNodeController *loopNodeController in controller.childControllers) {
      if (![currentChildControllers containsObject:loopNodeController]
          && ![childControllersToInsert containsObject:loopNodeController]) {
        [childControllersToRemove addObject:loopNodeController];
        NSInteger index = [controller.childControllers indexOfObject:loopNodeController];
        NSAssert(index != NSNotFound, nil);
        [indexesForDeletions addIndex:index];
      }
    }
    
    [controller removeChildControllersAtIndexes:indexesForDeletions];
    [controller insertChildControllers:childControllersToInsert atIndexes:indexesForInsertions];
    
    if (expandChildren) {
      for (RATreeNodeController *nodeController in controller.childControllers) {
        [items addObject:nodeController.treeNode.item];
      }
    }

    [controller expandAndExpandChildren:expandChildren];
  }
  
  updates(parentController.descendantsIndexes);
}

- (void)collapseRowForItem:(id)item collapseChildren:(BOOL)collapseChildren updates:(void (^)(NSIndexSet *))updates
{
  NSParameterAssert(updates);
  
  RATreeNodeController *controller = [self.rootController controllerForItem:item];
  NSIndexSet *deletions = controller.descendantsIndexes;
  [controller collapseAndCollapseChildren:collapseChildren];
  
  updates(deletions);
}

- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item
{
  RATreeNodeController *parentController = [self.rootController controllerForItem:item];
  NSArray *newControllers = [self controllersForNodesWithIndexes:indexes inParentController:parentController];
  [parentController insertChildControllers:newControllers atIndexes:indexes];
}

- (void)moveItemAtIndex:(NSInteger)index inParent:(id)parent toIndex:(NSInteger)newIndex inParent:(id)newParent updates:(void (^)(NSIndexSet *, NSIndexSet *))updates
{
  NSParameterAssert(updates);
  
  NSMutableIndexSet *removedIndexes = [NSMutableIndexSet indexSet];
  NSMutableIndexSet *addedIndexes = [NSMutableIndexSet indexSet];
  
  RATreeNodeController *parentController = [self.rootController controllerForItem:parent];
  
  if (parent == newParent) {
    [parentController moveChildControllerAtIndex:index toIndex:newIndex];
    
  } else {
    RATreeNodeController *childController = parentController.childControllers[index];
    
    [removedIndexes addIndex:childController.index];
    [removedIndexes addIndexes:childController.descendantsIndexes];
    
    RATreeNodeController *newParentController = [self.rootController controllerForItem:parent];
    [parentController removeChildControllersAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    [newParentController insertChildControllers:@[childController] atIndexes:[NSIndexSet indexSetWithIndex:newIndex]];
    
    [addedIndexes addIndex:childController.index];
    [addedIndexes addIndexes:childController.descendantsIndexes];
  }
  
  updates(removedIndexes, addedIndexes);
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item updates:(void (^)(NSIndexSet *))updates
{
  RATreeNodeController *parentController = [self.rootController controllerForItem:item];
  
  NSMutableIndexSet *indexesToRemoval = [NSMutableIndexSet indexSet];
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    RATreeNodeController *controller = parentController.childControllers[idx];
    [indexesToRemoval addIndex:controller.index];
    [indexesToRemoval addIndexes:controller.descendantsIndexes];
  }];
  
  [parentController removeChildControllersAtIndexes:indexes];
  
  updates(indexesToRemoval);
}

- (NSArray *)controllersAndIndexesForNodesWithIndexes:(NSIndexSet *)indexes inParentController:(RATreeNodeController *)parentController
{
  NSMutableArray *childControllers = [parentController.childControllers mutableCopy];
  NSMutableArray *currentControllers = [NSMutableArray array];
  
  NSMutableArray *invalidItems = [NSMutableArray array];
  for (RATreeNodeController *nodeController in parentController.childControllers) {
    [invalidItems addObject:nodeController.treeNode.item];
  }
  
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    
    RATreeNodeController *controller;
    RATreeNodeController *oldControllerForCurrentIndex = nil;
    
    
    RATreeNodeItem *lazyItem = [[RATreeNodeItem alloc] initWithParent:parentController.treeNode.item index:idx];
    lazyItem.dataSource = self;
    
    
    for (RATreeNodeController *controller in parentController.childControllers) {
      if ([controller.treeNode.item isEqual:lazyItem.item]) {
        oldControllerForCurrentIndex = controller;
      }
    }
    if (oldControllerForCurrentIndex != nil) {
      controller = oldControllerForCurrentIndex;
      
    } else {
      controller = [[RATreeNodeController alloc] initWithParent:parentController item:lazyItem expandedBlock:^BOOL(id item) {
        return [childControllers indexOfObjectPassingTest:^BOOL(RATreeNodeController *controller, NSUInteger idx, BOOL *stop) {
          return [controller.treeNode.item isEqual:item];
        }] != NSNotFound;
      }];
    }
    
    [currentControllers addObject:@{ @"index" : @(idx),
                                 @"controller" : controller }];
  }];
  
  return [currentControllers copy];
}

- (NSArray *)controllersForNodesWithIndexes:(NSIndexSet *)indexes inParentController:(RATreeNodeController *)parentController
{
  return [[self controllersAndIndexesForNodesWithIndexes:indexes inParentController:parentController] valueForKey:@"controller"];
}

- (NSArray *)controllersForNodes:(NSInteger)nodesNumber inParentController:(RATreeNodeController *)parentController
{
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, nodesNumber)];
  return [self controllersForNodesWithIndexes:indexSet inParentController:parentController];
}

#pragma mark - RATreeNodeController delegate

- (id)treeNodeController:(RATreeNodeController *)controller child:(NSInteger)childIndex
{
  return [self.dataSource treeNodeCollectionController:self child:childIndex ofItem:controller.treeNode.item];
}

- (NSInteger)numberOfChildrenForTreeNodeController:(RATreeNodeController *)controller
{
  return [self.dataSource treeNodeCollectionController:self numberOfChildrenForItem:controller.treeNode.item];
}


#pragma mark - RATreeNodeItem data source

- (id)itemForTreeNodeItem:(RATreeNodeItem *)treeNodeItem
{
  return [self.dataSource treeNodeCollectionController:self child:treeNodeItem.index ofItem:treeNodeItem.parent];
}


#pragma mark - Properties

- (RATreeNodeController *)rootController
{
  if (!_rootController) {
    _rootController = [[RATreeNodeController alloc] initWithParent:nil item:nil expandedBlock:^BOOL(id _) {
      return YES;
    }];
    
    NSInteger numberOfChildren = [self.dataSource treeNodeCollectionController:self numberOfChildrenForItem:nil];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfChildren)];
    NSArray *childControllers = [self controllersForNodesWithIndexes:indexSet inParentController:_rootController];
    [_rootController insertChildControllers:childControllers atIndexes:indexSet];
  }
  
  return _rootController;
}

@end
