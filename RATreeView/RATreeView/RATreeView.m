
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


#import "RATreeView.h"
#import "RATreeView_ClassExtension.h"
#import "RATreeView+Enums.h"
#import "RATreeView+Private.h"

#import "RABatchChanges.h"

#import "RATreeNodeCollectionController.h"
#import "RATreeNode.h"

#import "RATableView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation RATreeView
#pragma clang diagnostic pop


#pragma mark Initializing a TreeView Object

- (id)init
{
  return [self initWithFrame:CGRectMake(0, 0, 100, 100) style:RATreeViewStylePlain];
}

- (id)initWithFrame:(CGRect)frame
{
  return [self initWithFrame:frame style:RATreeViewStylePlain];
}

- (id)initWithFrame:(CGRect)frame style:(RATreeViewStyle)style
{
  self = [super initWithFrame:frame];
  if (self) {
    CGRect innerFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self commonInitWithFrame:innerFrame style:style];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    CGRect innerFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self commonInitWithFrame:innerFrame style:RATreeViewStylePlain];
  }
  return self;
}

- (void)commonInitWithFrame:(CGRect)frame style:(RATreeViewStyle)style
{
  UITableViewStyle tableViewStyle = [RATreeView tableViewStyleForTreeViewStyle:style];

  RATableView *tableView =  [[RATableView alloc] initWithFrame:frame style:tableViewStyle];
  tableView.tableViewDelegate = (id<UITableViewDelegate>)self;
  tableView.dataSource = (id<UITableViewDataSource>)self;
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableView.backgroundColor = [UIColor clearColor];

  [self addSubview:tableView];
  [self setTableView:tableView];

  self.expandsChildRowsWhenRowExpands = NO;
  self.collapsesChildRowsWhenRowCollapses = NO;
  self.rowsExpandingAnimation = RATreeViewRowAnimationTop;
  self.rowsCollapsingAnimation = RATreeViewRowAnimationBottom;
}

- (void)awakeFromNib
{
  [super awakeFromNib];

  self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark Scroll View

- (UIScrollView *)scrollView
{
  return self.tableView;
}


#pragma mark Configuring a Tree View

- (NSInteger)numberOfRows
{
  return [self.tableView numberOfRowsInSection:0];
}

- (RATreeViewStyle)style
{
  UITableViewStyle tableViewStyle = self.tableView.style;
  return [RATreeView treeViewStyleForTableViewStyle:tableViewStyle];
}

#if TARGET_OS_IOS

- (RATreeViewCellSeparatorStyle)separatorStyle
{
  RATreeViewCellSeparatorStyle style = [RATreeView treeViewCellSeparatorStyleForTableViewSeparatorStyle:self.tableView.separatorStyle];
  return style;
}

- (void)setSeparatorStyle:(RATreeViewCellSeparatorStyle)separatorStyle
{
  UITableViewCellSeparatorStyle tableViewSeparatorStyle = [RATreeView tableViewCellSeparatorStyleForTreeViewCellSeparatorStyle:separatorStyle];
  self.tableView.separatorStyle = tableViewSeparatorStyle;
}

- (UIColor *)separatorColor
{
  return self.tableView.separatorColor;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
  self.tableView.separatorColor = separatorColor;
}

#endif

- (CGFloat)rowHeight
{
  return self.tableView.rowHeight;
}

- (void)setRowHeight:(CGFloat)rowHeight
{
  self.tableView.rowHeight = rowHeight;
}

- (CGFloat)estimatedRowHeight
{
  if ([self.tableView respondsToSelector:@selector(estimatedRowHeight)]) {
    return self.tableView.estimatedRowHeight;
  } else {
    return 0;
  }
}

- (void)setEstimatedRowHeight:(CGFloat)estimatedRowHeight
{
  if ([self.tableView respondsToSelector:@selector(estimatedRowHeight)]) {
    self.tableView.estimatedRowHeight = estimatedRowHeight;
  }
}

- (UIEdgeInsets)separatorInset
{
  if ([self.tableView respondsToSelector:@selector(separatorInset)]) {
    return self.tableView.separatorInset;
  } else {
    return UIEdgeInsetsZero;
  }
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset
{
  if ([self.tableView respondsToSelector:@selector(separatorInset)]) {
    self.tableView.separatorInset = separatorInset;
  }
}

#if TARGET_OS_IOS

- (UIVisualEffect *)separatorEffect
{
  if ([self.tableView respondsToSelector:@selector(separatorEffect)]) {
    return self.tableView.separatorEffect;
  } else {
    return nil;
  }
}

- (void)setSeparatorEffect:(UIVisualEffect *)separatorEffect
{
  if ([self.tableView respondsToSelector:@selector(separatorEffect)]) {
    self.tableView.separatorEffect = separatorEffect;
  }
}

#endif

- (BOOL)cellLayoutMarginsFollowReadableWidth
{
  if ([self.tableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)]) {
    return self.tableView.cellLayoutMarginsFollowReadableWidth;
  } else {
    return NO;
  }
}

- (void)setCellLayoutMarginsFollowReadableWidth:(BOOL)cellLayoutMarginsFollowReadableWidth
{
  if ([self.tableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)]) {
    self.tableView.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth;
  }
}

- (UIView *)backgroundView
{
  return self.tableView.backgroundView;
}

- (void)setBackgroundView:(UIView *)backgroundView
{
  self.tableView.backgroundView = backgroundView;
}


#pragma mark Expanding and Collapsing Rows

- (void)expandRowForItem:(id)item
{
  [self expandRowForItem:item withRowAnimation:self.rowsExpandingAnimation];
}

- (void)expandRowForItem:(id)item withRowAnimation:(RATreeViewRowAnimation)animation
{
  [self expandRowForItem:item expandChildren:NO withRowAnimation:animation];
}

- (void)expandRowForItem:(id)item expandChildren:(BOOL)expandChildren withRowAnimation:(RATreeViewRowAnimation)animation
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
  if (!treeNode || treeNode.expanded) {
    return;
  }
  [self expandCellForTreeNode:treeNode expandChildren:expandChildren withRowAnimation:animation];
}

- (void)collapseRowForItem:(id)item
{
  [self collapseRowForItem:item withRowAnimation:self.rowsCollapsingAnimation];
}

- (void)collapseRowForItem:(id)item withRowAnimation:(RATreeViewRowAnimation)animation
{
  [self collapseRowForItem:item collapseChildren:NO withRowAnimation:animation];
}

- (void)collapseRowForItem:(id)item collapseChildren:(BOOL)collapseChildren withRowAnimation:(RATreeViewRowAnimation)animation
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
  if (!treeNode) {
    return;
  }
  [self collapseCellForTreeNode:treeNode collapseChildren:collapseChildren withRowAnimation:animation];
}


#pragma mark - Changing tree's structure

- (void)beginUpdates
{
  [self.tableView beginUpdates];
  [self.batchChanges beginUpdates];
}

- (void)endUpdates
{
  [self.batchChanges endUpdates];
  [self.tableView endUpdates];
}

- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation
{
  if (parent && ![self isCellForItemExpanded:parent]) {
    return;
  }
  __weak __typeof(self) weakSelf = self;
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [weakSelf insertItemAtIndex:idx inParent:parent withAnimation:animation];
  }];
}

- (void)deleteItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation
{
  if (parent && ![self isCellForItemExpanded:parent]) {
    return;
  }
  __weak __typeof(self) weakSelf = self;
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [weakSelf removeItemAtIndex:idx inParent:parent withAnimation:animation];
  }];
}


#pragma mark - Creating Table View Cells

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
  [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
  [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
  return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}


#pragma mark - Accessing Header and Footer Views

- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier
{
  [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
}

- (void)registerClass:(Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier
{
  [self.tableView registerClass:aClass forHeaderFooterViewReuseIdentifier:identifier];
}

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier
{
  return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

- (UIView *)treeHeaderView
{
  return self.tableView.tableHeaderView;
}

- (void)setTreeHeaderView:(UIView *)treeHeaderView
{
  self.tableView.tableHeaderView = treeHeaderView;
}

- (UIView *)treeFooterView
{
  return self.tableView.tableFooterView;
}

- (void)setTreeFooterView:(UIView *)treeFooterView
{
  self.tableView.tableFooterView = treeFooterView;
}


#pragma mark - Working with Expandability

- (BOOL)isCellForItemExpanded:(id)item
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  return [self treeNodeForIndexPath:indexPath].expanded;
}

- (BOOL)isCellExpanded:(UITableViewCell *)cell
{
  id item = [self itemForCell:cell];
  return [self isCellForItemExpanded:item];
}

#pragma mark - Working with Indentation

- (NSInteger)levelForCellForItem:(id)item
{
  return [self.treeNodeCollectionController levelForItem:item];
}

- (NSInteger)levelForCell:(UITableViewCell *)cell
{
  id item = [self itemForCell:cell];
  return [self levelForCellForItem:item];
}

#pragma mark - Getting the Parent for an Item

- (id)parentForItem:(id)item
{
  return [self.treeNodeCollectionController parentForItem:item];
}


#pragma mark - Accessing Cells

- (UITableViewCell *)cellForItem:(id)item
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (NSArray *)visibleCells
{
  return [self.tableView visibleCells];
}

- (id)itemForCell:(UITableViewCell *)cell
{
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  return [self treeNodeForIndexPath:indexPath].item;
}

- (id)itemForRowAtPoint:(CGPoint)point
{
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
  return !indexPath ? nil : [self treeNodeForIndexPath:indexPath].item;
}

- (id)itemsForRowsInRect:(CGRect)rect
{
  NSArray *indexPaths = [self.tableView indexPathsForRowsInRect:rect];
  return [self itemsForIndexPaths:indexPaths];
}

- (NSArray *)itemsForVisibleRows
{
  NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
  return [self itemsForIndexPaths:indexPaths];
}


#pragma mark - Scrolling the TreeView

- (void)scrollToRowForItem:(id)item atScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  UITableViewScrollPosition tableViewScrollPosition = [RATreeView tableViewScrollPositionForTreeViewScrollPosition:scrollPosition];
  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:tableViewScrollPosition animated:animated];
}

- (void)scrollToNearestSelectedRowAtScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated
{
  UITableViewScrollPosition tableViewScrollPosition = [RATreeView tableViewScrollPositionForTreeViewScrollPosition:scrollPosition];
  [self.tableView scrollToNearestSelectedRowAtScrollPosition:tableViewScrollPosition animated:animated];
}


#pragma mark - Managing Selections

- (id)itemForSelectedRow
{
  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
  return [self treeNodeForIndexPath:indexPath].item;
}

- (NSArray *)itemsForSelectedRows
{
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  return [self itemsForIndexPaths:selectedRows];
}

- (void)selectRowForItem:(id)item animated:(BOOL)animated scrollPosition:(RATreeViewScrollPosition)scrollPosition
{
  if ([self isCellForItemExpanded:[self parentForItem:item]]) {
    NSIndexPath *indexPath = [self indexPathForItem:item];
    UITableViewScrollPosition tableViewScrollPosition = [RATreeView tableViewScrollPositionForTreeViewScrollPosition:scrollPosition];
    [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:tableViewScrollPosition];
  }
}

- (void)deselectRowForItem:(id)item animated:(BOOL)animated
{
  if ([self isCellForItemExpanded:[self parentForItem:item]]) {
    NSIndexPath *indexPath = [self indexPathForItem:item];
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
  }
}

- (BOOL)allowsSelection
{
  return self.tableView.allowsSelection;
}

- (void)setAllowsSelection:(BOOL)allowsSelection
{
  self.tableView.allowsSelection = allowsSelection;
}

- (BOOL)allowsMultipleSelection
{
  return self.tableView.allowsMultipleSelection;
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
  self.tableView.allowsMultipleSelection = allowsMultipleSelection;
}

- (BOOL)allowsSelectionDuringEditing
{
  return self.tableView.allowsSelectionDuringEditing;
}

- (void)setAllowsSelectionDuringEditing:(BOOL)allowsSelectionDuringEditing
{
  self.tableView.allowsSelectionDuringEditing = allowsSelectionDuringEditing;
}

- (BOOL)allowsMultipleSelectionDuringEditing
{
  return self.tableView.allowsMultipleSelectionDuringEditing;
}

- (void)setAllowsMultipleSelectionDuringEditing:(BOOL)allowsMultipleSelectionDuringEditing
{
  self.tableView.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing;
}


#pragma mark - Managing the Editing of Tree Cells

- (BOOL)isEditing
{
  return self.tableView.isEditing;
}

- (void)setEditing:(BOOL)editing
{
  self.tableView.editing = editing;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [self.tableView setEditing:editing animated:animated];
}


#pragma mark - Reloading the Tree View

- (void)reloadData
{
  [self setupTreeStructure];
  [self.tableView reloadData];
}

- (void)reloadRowsForItems:(NSArray *)items withRowAnimation:(RATreeViewRowAnimation)animation
{
  NSMutableArray *indexes = [NSMutableArray array];
  UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:animation];
  for (id item in items) {
    NSIndexPath *indexPath = [self indexPathForItem:item];
    [indexes addObject:indexPath];
  }

  [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:tableViewRowAnimation];
}

- (void)reloadRows
{
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
  [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - UIScrollView's properties

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
  [self.tableView setContentOffset:contentOffset animated:animated];
}

- (void)scrollRectToVisible:(CGRect)visible animated:(BOOL)animated
{
  [self.tableView scrollRectToVisible:visible animated:animated];
}

- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated
{
  [self.tableView setZoomScale:zoomScale animated:animated];
}

- (void)flashScrollIndicators
{
  [self.tableView flashScrollIndicators];
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated
{
  [self.tableView zoomToRect:rect animated:animated];
}


#pragma mark -

- (NSArray *)itemsForIndexPaths:(NSArray *)indexPaths
{
  if (!indexPaths) {
    return nil;
  }
  NSMutableArray *items = [NSMutableArray array];
  for (NSIndexPath *indexPath in indexPaths) {
    [items addObject:[self treeNodeForIndexPath:indexPath].item];
  }

  return [items copy];
}

@end
