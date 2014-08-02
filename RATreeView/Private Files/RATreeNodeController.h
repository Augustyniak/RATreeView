
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

@class RATreeNodeController, RATreeNode, RATreeNodeItem;


@protocol RATreeNodeControllerDelegate <NSObject>

@end

@interface RATreeNodeController : NSObject

@property (nonatomic, weak, readonly) RATreeNodeController *parentController;
@property (nonatomic, strong, readonly) NSArray *childControllers;

@property (nonatomic, strong, readonly) RATreeNode *treeNode;
@property (nonatomic, readonly) NSInteger index;
@property (nonatomic, readonly) NSInteger numberOfVisibleDescendants;
@property (nonatomic, strong, readonly) NSIndexSet *descendantsIndexes;
@property (nonatomic, readonly) NSInteger level;

- (instancetype)initWithParent:(RATreeNodeController *)parentController item:(RATreeNodeItem *)item expanded:(BOOL)expanded;

- (void)collapse;
- (void)expand;

- (void)insertChildControllers:(NSArray *)controllers atIndexes:(NSIndexSet *)indexes;
- (void)moveChildControllerAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
- (void)removeChildControllersAtIndexes:(NSIndexSet *)indexes;

- (NSInteger)indexForItem:(id)item;
- (NSInteger)lastVisibleDescendatIndexForItem:(id)item;
- (RATreeNodeController *)controllerForIndex:(NSInteger)index;
- (RATreeNodeController *)controllerForItem:(id)item;

@end
