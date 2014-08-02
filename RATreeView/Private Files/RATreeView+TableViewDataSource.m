
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

#import "RATreeView+TableViewDataSource.h"
#import "RATreeView+Private.h"
#import "RATreeView_ClassExtension.h"

#import "RATreeNodeCollectionController.h"
#import "RATreeNodeController.h"
#import "RATreeNode.h"

@implementation RATreeView (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (self.treeNodeCollectionController == nil) {
    [self setupTreeStructure];
  }
  return self.treeNodeCollectionController.numberOfVisibleRowsForItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
  return [self.dataSource treeView:self cellForItem:treeNode.item];
}


#pragma mark - Inserting or Deleting Table Rows

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.dataSource respondsToSelector:@selector(treeView:commitEditingStyle:forRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.dataSource treeView:self commitEditingStyle:editingStyle forRowForItem:treeNode.item];
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.dataSource respondsToSelector:@selector(treeView:canEditRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.dataSource treeView:self canEditRowForItem:treeNode.item];
  }
  return YES;
}

@end
