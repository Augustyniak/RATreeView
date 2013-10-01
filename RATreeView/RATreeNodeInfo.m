
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

#import "RATreeNodeInfo.h"
#import "RATreeNodeInfo+Private.h"
#import "RATreeNode.h"

@interface RATreeNodeInfo ()

@property (nonatomic, getter = isExpanded, readwrite) BOOL expanded;
@property (nonatomic, readwrite) NSInteger treeDepthLevel;

@property (nonatomic, readwrite) NSInteger siblingsNumber;
@property (nonatomic, readwrite) NSInteger positionInSiblings;

@property (strong, nonatomic, readwrite) RATreeNodeInfo *parent;
@property (strong, nonatomic, readwrite) NSArray *children;

@property (strong, nonatomic, readwrite) RATreeNode *parentTreeNode;
@property (strong, nonatomic, readwrite) NSArray * childrenTreeNodes;

@property (strong, nonatomic, readwrite) id item;

@end

@implementation RATreeNodeInfo


#pragma mark Properties

- (RATreeNodeInfo *)parent
{
  if (_parent == nil) {
    _parent = [self.parentTreeNode treeNodeInfo];
  }
  return _parent;
}

- (NSArray *)children
{
  if (_children == nil) {
    NSMutableArray *treeNodesInfos = [NSMutableArray array];
    for (RATreeNode *treeNode in self.childrenTreeNodes) {
      [treeNodesInfos addObject:[treeNode treeNodeInfo]];
    }
    _children = treeNodesInfos;
  }
  return _children;
}


@end
