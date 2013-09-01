
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

#import "RATreeNode.h"
#import "RATreeNodeInfo.h"

@interface RATreeNode ()

@property (nonatomic, getter = isExpanded, readwrite) BOOL expanded;

@end

@implementation RATreeNode

- (id)initWithItem:(id)item parent:(RATreeNode *)parent  expanded:(BOOL)expanded
{
  self = [super init];
  if (self) {
    self.item = item;
    self.parent = parent;
    self.expanded = expanded;
    self.children = [NSArray array];
  }
  return self;
}

- (BOOL)isVisible
{
  return self.parent.expanded || self.parent == nil;
}

- (void)addChildNode:(RATreeNode *)child
{
  NSMutableArray *children = [self.children mutableCopy];
  [children addObject:child];
  self.children = [NSArray arrayWithArray:children];
}

- (NSInteger)numberOfVisibleDescendants
{
  return [[self visibleDescendants] count];
}

- (NSArray *)visibleDescendants
{
  if (self.expanded) {
  NSMutableArray *visibleDescendants = [NSMutableArray array];
  for (RATreeNode *treeNode in self.children) {
    [visibleDescendants addObject:treeNode];
    if (treeNode.expanded) {
      [visibleDescendants addObjectsFromArray:[treeNode visibleDescendants]];
    }
  }
  return visibleDescendants;
  } else {
    return nil;
  }
}

- (NSArray *)descendants
{
  NSMutableArray *descendants = [NSMutableArray array];
  for (RATreeNode *treeNode in self.children) {
    [descendants addObject:treeNode];
    [descendants addObjectsFromArray:[treeNode descendants]];
  }
  return descendants;
}


- (void)expand
{
  self.expanded = YES;
  [self.parent expand];
}

- (void)collapse
{
  self.expanded = NO;
  for (RATreeNode *treeNode in self.children) {
    [treeNode collapse];
  }
}

- (NSInteger)startIndex
{
  NSInteger startIndex;
  if (self.parent.parent == nil) {
    startIndex = 0;
  } else {
    startIndex = [self.parent startIndex] + 1;
  }
  for (RATreeNode *treeNode in self.parent.children) {
    if (treeNode != self) {
      startIndex += 1;
      if (treeNode.expanded) {
        startIndex += [treeNode numberOfVisibleDescendants];
      }
    } else {
      break;
    }
  }
  return startIndex;
}

- (NSInteger)endIndex
{
  NSInteger startIndex = [self startIndex];
  return startIndex + [self numberOfVisibleDescendants];
}

- (RATreeNodeInfo *)treeNodeInfo
{
  NSInteger treeDepthLevel = [self treeDepthLevel];
  NSInteger numberOfParentChildren = [self.parent.children count];
  NSInteger positionInParentChildren = [self.parent.children indexOfObject:self];
  NSInteger numberOfChildren = [self.children count];
  NSInteger numberOfVisibleDescendants = [self numberOfVisibleDescendants];
  
  RATreeNodeInfo *treeNodeInfo = [[RATreeNodeInfo alloc] initWithExpanded:self.expanded
                                                           treeDepthLevel:treeDepthLevel
                                                   numberOfParentChildren:numberOfParentChildren
                                                 positionInParentChildren:positionInParentChildren
                                                         numberOfChildren:numberOfChildren
                                               numberOfVisibleDescendants:numberOfVisibleDescendants];
  return treeNodeInfo;
}

#pragma mark Private Helpers

- (NSInteger)treeDepthLevel
{
  NSInteger treeDepthLevel = 0;
  RATreeNode *current = self.parent.parent;
  while (current != nil) {
    treeDepthLevel++;
    current = current.parent;
  }
  return treeDepthLevel;
}

@end
