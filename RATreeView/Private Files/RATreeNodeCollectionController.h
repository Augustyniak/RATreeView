
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

#import <Foundation/Foundation.h>

@class RATreeNodeController, RATreeNode, RATreeNodeCollectionController;

@protocol RATreeNodeCollectionControllerDataSource <NSObject>

- (NSInteger)treeNodeCollectionController:(RATreeNodeCollectionController *)controller numberOfChildrenForItem:(id)item;
- (id)treeNodeCollectionController:(RATreeNodeCollectionController *)controller child:(NSInteger)childIndex ofItem:(id)item;

@end


@interface RATreeNodeCollectionController : NSObject

@property (nonatomic, weak) id<RATreeNodeCollectionControllerDataSource> dataSource;
@property (nonatomic, readonly) NSInteger numberOfVisibleRowsForItems;

- (RATreeNode *)treeNodeForIndex:(NSInteger)index;
- (NSInteger)levelForItem:(id)item;
- (id)parentForItem:(id)item;
- (id)childInParent:(id)parent atIndex:(NSInteger)index;

- (NSInteger)indexForItem:(id)item;
- (NSInteger)lastVisibleDescendantIndexForItem:(id)item;

- (void)collapseRowForItem:(id)item collapseChildren:(BOOL)collapseChildren updates:(void(^)(NSIndexSet *))updates;
- (void)expandRowForItem:(id)item expandChildren:(BOOL)expandChildren updates:(void (^)(NSIndexSet *))updates;

- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item;
- (void)moveItemAtIndex:(NSInteger)index inParent:(id)parent toIndex:(NSInteger)newIndex inParent:(id)newParent updates:(void(^)(NSIndexSet *deletions, NSIndexSet *additions))updates;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)item updates:(void(^)(NSIndexSet *))updates;

@end
