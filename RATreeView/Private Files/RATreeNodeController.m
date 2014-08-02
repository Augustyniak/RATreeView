
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

@property (nonatomic, weak) RATreeNodeController *parentController;
@property (nonatomic, strong) NSMutableArray *mutablechildControllers;

@end

@implementation RATreeNodeController

- (instancetype)initWithParent:(RATreeNodeController *)parentController item:(RATreeNodeItem *)item expanded:(BOOL)expanded
{
  self = [super init];
  if (self) {
    _parentController = parentController;
    _treeNode = [[RATreeNode alloc] initWithLazyItem:item expanded:expanded];
    _mutablechildControllers = [NSMutableArray array];
  }
  
  return self;
}

- (void)expand
{
  [self.treeNode setExpanded:YES];
  [self.parentController expand];
}

- (void)collapse
{
  [self.treeNode setExpanded:NO];
  for (RATreeNodeController *controller in self.mutablechildControllers) {
    [controller collapse];
  }
  [self.mutablechildControllers removeAllObjects];
}

- (void)insertChildControllers:(NSArray *)controllers atIndexes:(NSIndexSet *)indexes
{
  [self.mutablechildControllers insertObjects:controllers atIndexes:indexes];
}

- (void)removeChildControllersAtIndexes:(NSIndexSet *)indexes
{
  [self.mutablechildControllers removeObjectsAtIndexes:indexes];
}

- (void)moveChildControllerAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
  id controller = self.mutablechildControllers[index];
  [self.mutablechildControllers removeObjectAtIndex:index];
  [self.mutablechildControllers insertObject:controller atIndex:index];
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
  
  for (RATreeNodeController *subnodeController in self.childControllers) {
    NSInteger lastIndex = [subnodeController lastVisibleDescendatIndexForItem:item];
    if (lastIndex != NSNotFound) {
      return lastIndex;
    }
  }
  
  return NSNotFound;
}


#pragma mark - Properties

- (NSArray *)childControllers
{
  return [self.mutablechildControllers copy];
}

- (NSInteger)index
{
  if (!self.parentController) {
    return -1;
    
  } else {
    NSInteger indexInParent = [self.parentController.childControllers indexOfObject:self];
    if (indexInParent != 0) {
      RATreeNodeController *controller = self.parentController.childControllers[indexInParent-1];
      return [controller lastVisibleDescendatIndex] + 1;
      
    } else {
      return self.parentController.index + 1 + indexInParent;
      
    }
  }
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
  NSInteger numberOfVisibleDescendants = [self.childControllers count];
  for (RATreeNodeController *controller in self.childControllers) {
    numberOfVisibleDescendants += controller.numberOfVisibleDescendants;
  }
  return numberOfVisibleDescendants;
}

- (NSInteger)level
{
  if (self.treeNode.item == nil) {
    return -1;
  }
  
  return self.parentController.level + 1;
}

@end
