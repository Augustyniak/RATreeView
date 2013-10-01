
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
#import "RATreeNodeInfo+Private.h"

typedef enum RATreeDepthLevel {
  RATreeDepthLevelNotInitialized
} RATreeDepthLevel;

@interface RATreeNode ()

@property (nonatomic, getter = isExpanded, readwrite) BOOL expanded;
@property (nonatomic) NSInteger treeDepthLevel;

@property (strong, nonatomic, readwrite) id item;

@property (strong, nonatomic, readwrite) NSArray *descendants;
@property (strong, nonatomic, readwrite) RATreeNodeInfo *treeNodeInfo;

@end

@implementation RATreeNode

- (id)initWithItem:(id)item parent:(RATreeNode *)parent  expanded:(BOOL)expanded
{
  self = [super init];
  if (self) {
    self.treeDepthLevel = RATreeDepthLevelNotInitialized;
    self.item = item;
    self.parent = parent;
    self.expanded = expanded;
    self.children = [NSArray array];
  }
  return self;
}

#pragma mark Public methods

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

#pragma mark Properties

- (RATreeNodeInfo *)treeNodeInfo
{
  if (_treeNodeInfo == nil) {
    RATreeNodeInfo *treeNodeInfo = [[RATreeNodeInfo alloc] initWithParent:self.parent
                                                                 children:self.children];
    treeNodeInfo.treeDepthLevel = [self treeDepthLevel];
    treeNodeInfo.siblingsNumber = [self.parent.children count];
    treeNodeInfo.positionInSiblings = [self.parent.children indexOfObject:self];
    
    _treeNodeInfo = treeNodeInfo;
  }
  
  _treeNodeInfo.item = self.item;
  _treeNodeInfo.expanded = self.expanded;

  return _treeNodeInfo;
}

- (NSArray *)descendants
{
  if (_descendants == nil) {
    NSMutableArray *descendants = [NSMutableArray array];
    for (RATreeNode *treeNode in self.children) {
      [descendants addObject:treeNode];
      [descendants addObjectsFromArray:[treeNode descendants]];
    }
    _descendants = descendants;
  }
  return _descendants;
}

#pragma mark Private Helpers

- (NSInteger)treeDepthLevel
{
  if (_treeDepthLevel == RATreeDepthLevelNotInitialized) {
    NSInteger treeDepthLevel = 0;
    RATreeNode *current = self.parent.parent;
    while (current != nil) {
      treeDepthLevel++;
      current = current.parent;
    }
    _treeDepthLevel = treeDepthLevel;
  }
  return _treeDepthLevel;
}

@end
