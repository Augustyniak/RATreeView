
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


#import "RATreeNodeController.h"

#import "RATreeNode.h"
#import "RATreeNode_ClassExtension.h"


@interface RATreeNodeController ()

@property (nonatomic, strong) RATreeNode *treeNode;

@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger numberOfVisibleDescendants;
@property (nonatomic) NSInteger level;
@property (nonatomic, weak) RATreeNodeController *parentController;
@property (nonatomic, strong) NSMutableArray *mutablechildControllers;

@end


@implementation RATreeNodeController

- (instancetype)initWithParent:(RATreeNodeController *)parentController item:(RATreeNodeItem *)item expandedBlock:(BOOL (^)(id))expandedBlock
{
  self = [super init];
  if (self) {
    [self invalidate];
    _level = NSIntegerMin;
    _parentController = parentController;
    _treeNode = [[RATreeNode alloc] initWithLazyItem:item expandedBlock:expandedBlock];
    _mutablechildControllers = [NSMutableArray array];
  }
  
  return self;
}

- (void)insertChildControllers:(NSArray *)controllers atIndexes:(NSIndexSet *)indexes
{
  if (indexes.count == 0) {
    return;
  }
  [self.mutablechildControllers insertObjects:controllers atIndexes:indexes];
  [self invalidateTreeNodesAfterChildAtIndex:[indexes firstIndex] - 1];
}

- (void)removeChildControllersAtIndexes:(NSIndexSet *)indexes
{
  if (indexes.count == 0) {
    return;
  }
  [self.mutablechildControllers removeObjectsAtIndexes:indexes];
  [self invalidateTreeNodesAfterChildAtIndex:[indexes firstIndex] - 1];
}

- (void)moveChildControllerAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
  if (index == newIndex) {
    return;
  }
  id controller = self.mutablechildControllers[index];
  [self.mutablechildControllers removeObjectAtIndex:index];
  [self.mutablechildControllers insertObject:controller atIndex:index];
  [self invalidateTreeNodesAfterChildAtIndex:MIN(index, newIndex)-1];
}

- (RATreeNodeController *)controllerForItem:(id)item
{
  if (item == self.treeNode.item) {
    return self;
  }
  
  for (RATreeNodeController *controller in self.childControllers) {
    RATreeNodeController *result = [controller controllerForItem:item];
    if (result) {
      return result;
    }
  }
  
  return nil;
}

- (RATreeNodeController *)controllerForIndex:(NSInteger)index
{
  if (self.index == index) {
    return self;
  }
  
  if (!self.treeNode.expanded) {
    return nil;
  }
  
  for (RATreeNodeController *controller in self.childControllers) {
    RATreeNodeController *result = [controller controllerForIndex:index];
    if (result) {
      return result;
    }
  }
  
  return nil;
}

- (NSInteger)indexForItem:(id)item
{
  RATreeNodeController *controller = [self controllerForItem:item];
  return controller ? controller.index : NSNotFound;
}

- (NSInteger)lastVisibleDescendatIndexForItem:(id)item
{
  if (self.treeNode.item == item) {
    return [self lastVisibleDescendatIndex];
  }
  
  for (RATreeNodeController *nodeController in self.childControllers) {
    NSInteger lastIndex = [nodeController lastVisibleDescendatIndexForItem:item];
    if (lastIndex != NSNotFound) {
      return lastIndex;
    }
  }
  
  return NSNotFound;
}


#pragma mark - Collapsing and expanding

- (void)expandAndExpandChildren:(BOOL)expandChildren
{
  for (RATreeNodeController *nodeController in self.childControllers) {
    [nodeController invalidate];
  }
  [self privateExpandAndExpandChildren:expandChildren];
}

- (void)privateExpandAndExpandChildren:(BOOL)expandChildren
{
  [self.treeNode setExpanded:YES];
  [self invalidate];
  
  for (RATreeNodeController *nodeController in self.childControllers) {
    if (nodeController.treeNode.expanded || expandChildren) {
      [nodeController expandAndExpandChildren:expandChildren];
    }
  }

  [self.parentController invalidateTreeNodesAfterChildAtIndex:[self.parentController.childControllers indexOfObject:self]];
}

- (void)collapseAndCollapseChildren:(BOOL)collapseChildren
{
  [self privateCollapseAndCollapseChildren:collapseChildren];
}

- (void)privateCollapseAndCollapseChildren:(BOOL)collapseChildren
{
  [self.treeNode setExpanded:NO];
  [self invalidate];
  
  if (collapseChildren) {
    for (RATreeNodeController *controller in self.childControllers) {
      [controller collapseAndCollapseChildren:collapseChildren];
    }
  }
  
  [self.parentController invalidateTreeNodesAfterChildAtIndex:[self.parentController.childControllers indexOfObject:self]];
}


#pragma mark -

- (void)invalidate
{
  [self invalidateNumberOfVisibleDescendants];
  [self invalideIndex];
}

- (void)invalidateNumberOfVisibleDescendants
{
  self.numberOfVisibleDescendants = NSIntegerMin;
}

- (void)invalideIndex
{
  self.index = NSIntegerMin;
}

- (void)invalidateTreeNodesAfterChildAtIndex:(NSInteger)index
{
  NSInteger selfIndex = [self.parentController.childControllers indexOfObject:self];
  [self.parentController invalidateTreeNodesAfterChildAtIndex:selfIndex];
  
  [self invalidate];
  [self invalidateDescendantsNodesAfterChildAtIndex:index];
}

- (void)invalidateDescendantsNodesAfterChildAtIndex:(NSInteger)index
{
  if (!self.treeNode.expanded) {
    return;
  }
  for (NSInteger i = index + 1; i < self.childControllers.count; i++) {
    RATreeNodeController *controller = self.childControllers[i];
    [controller invalidate];
    [controller invalidateDescendantsNodesAfterChildAtIndex:-1];
  }
}


#pragma mark - Properties

- (NSArray *)childControllers
{
  return self.mutablechildControllers;
}

- (NSInteger)index
{
  if (_index != NSIntegerMin) {
    return _index;
  }
  if (!self.parentController) {
    _index = -1;
    
  } else if (!self.parentController.treeNode.expanded) {
    _index = NSNotFound;
    
  } else {
    NSInteger indexInParent = [self.parentController.childControllers indexOfObject:self];
    if (indexInParent != 0) {
      RATreeNodeController *controller = self.parentController.childControllers[indexInParent-1];
      _index =  [controller lastVisibleDescendatIndex] + 1;
      
    } else {
      _index = self.parentController.index + 1;
    }
  }
  return _index;
}

- (NSInteger)lastVisibleDescendatIndex
{
  return self.index + self.numberOfVisibleDescendants;
}

- (NSIndexSet *)descendantsIndexes
{
  NSInteger numberOfVisibleDescendants = self.numberOfVisibleDescendants;
  NSInteger startIndex = self.index + 1;
  
  NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
  for (NSInteger i = startIndex; i < startIndex + numberOfVisibleDescendants; i++) {
    [indexSet addIndex:i];
  }
  return [indexSet copy];
}

- (NSInteger)numberOfVisibleDescendants
{
  if (_numberOfVisibleDescendants == NSIntegerMin) {
    if (self.treeNode.expanded) {
      NSInteger numberOfVisibleDescendants = [self.childControllers count];
      for (RATreeNodeController *controller in self.childControllers) {
        numberOfVisibleDescendants += controller.numberOfVisibleDescendants;
      }
      _numberOfVisibleDescendants = numberOfVisibleDescendants;
    } else {
      _numberOfVisibleDescendants = 0;
    }
  }
  return _numberOfVisibleDescendants;
}

- (NSInteger)level
{
  if (self.treeNode.item == nil) {
    return -1;
  }
  
  if (_level == NSIntegerMin) {
    _level = self.parentController.level + 1;
  }
  
  return _level;
}

@end
