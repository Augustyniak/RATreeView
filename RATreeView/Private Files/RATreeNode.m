
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


#import "RATreeNode.h"

#import "RATreeNodeItem.h"


@interface RATreeNode () {
  BOOL _expanded;
}

@property (nonatomic) BOOL expanded;
@property (nonatomic, strong) RATreeNodeItem *lazyItem;
@property (nonatomic, copy) BOOL (^expandedBlock)(id);

@end


@implementation RATreeNode

- (id)initWithLazyItem:(RATreeNodeItem *)item expandedBlock:(BOOL (^)(id))expandedBlock;
{
  self = [super init];
  if (self) {
    _lazyItem = item;
    _expandedBlock = expandedBlock;
  }
  
  return self;
}


#pragma mark -

- (RATreeNodeItem *)item
{
  return self.lazyItem.item;
}

- (BOOL)expanded
{
  if (self.expandedBlock) {
    _expanded = self.expandedBlock(self.item);
    self.expandedBlock = nil;
  }
  
  return _expanded;
}

- (void)setExpanded:(BOOL)expanded
{
  self.expandedBlock = nil;
  _expanded = expanded;
}

@end
