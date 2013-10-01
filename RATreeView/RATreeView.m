
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


#import "RATreeView.h"
#import "RATreeView+Enums.h"
#import "RATreeView+Private.h"
#import "RATreeView+UIScrollView.h"

#import "RATreeNodeCollectionController.h"
#import "RATreeNode.h"



@interface RATreeView ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) RATreeNodeCollectionController *treeNodeCollectionController;

@end

@implementation RATreeView

//Managing the Display of Content
@dynamic contentOffset;
@dynamic contentSize;
@dynamic contentInset;

//Managing Scrolling
@dynamic scrollEnabled;
@dynamic directionalLockEnabled;
@dynamic scrollsToTop;
@dynamic pagingEnabled;
@dynamic bounces;
@dynamic alwaysBounceVertical;
@dynamic alwaysBounceHorizontal;
@dynamic canCancelContentTouches;
@dynamic delaysContentTouches;
@dynamic decelerationRate;
@dynamic dragging;
@dynamic tracking;
@dynamic decelerating;

//Managing the Scroll Indicator
@dynamic indicatorStyle;
@dynamic scrollIndicatorInsets;
@dynamic showsHorizontalScrollIndicator;
@dynamic showsVerticalScrollIndicator;
//- (void)flashScrollIndicators;

//Zooming and Panning
@dynamic panGestureRecognizer;
@dynamic pinchGestureRecognizer;
@dynamic zoomScale;
@dynamic maximumZoomScale;
@dynamic minimumZoomScale;
@dynamic zoomBouncing;
@dynamic zooming;
@dynamic bouncesZoom;


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
    [self commonInitWithFrame:frame style:style];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInitWithFrame:self.frame style:RATreeViewStylePlain];
  }
  return self;
}

- (void)commonInitWithFrame:(CGRect)frame style:(RATreeViewStyle)style
{
  UITableViewStyle tableViewStyle = [RATreeView tableViewStyleForTreeViewStyle:style];
  
  UITableView *tableView =  [[UITableView alloc] initWithFrame:frame style:tableViewStyle];
  tableView.delegate = (id<UITableViewDelegate>)self;
  tableView.dataSource = (id<UITableViewDataSource>)self;
  tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  tableView.backgroundColor = [UIColor clearColor];
  [self addSubview:tableView];
  self.tableView = tableView;
  
  self.rowsExpandingAnimation = RATreeViewRowAnimationTop;
  self.rowsExpandingAnimation = RATreeViewRowAnimationBottom;
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


- (CGFloat)rowHeight
{
  return self.tableView.rowHeight;
}

- (void)setRowHeight:(CGFloat)rowHeight
{
  self.tableView.rowHeight = rowHeight;
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
  NSInteger index = [self.treeNodeCollectionController indexForItem:item];
  RATreeNode *treeNode = [self.treeNodeCollectionController treeNodeForIndex:index];
  [self expandCellForTreeNode:treeNode withRowAnimation:animation];
}


- (void)collapseRowForItem:(id)item
{
  [self collapseRowForItem:item withRowAnimation:self.rowsCollapsingAnimation];
}

- (void)collapseRowForItem:(id)item withRowAnimation:(RATreeViewRowAnimation)animation
{
  NSInteger index = [self.treeNodeCollectionController indexForItem:item];
  RATreeNode *treeNode = [self.treeNodeCollectionController treeNodeForIndex:index];
  [self collapseCellForTreeNode:treeNode withRowAnimation:animation];
}

#pragma mark Creating Table View Cells

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
  [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
  return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}

#pragma mark Accessing Header and Footer Views

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

#pragma mark Accessing Cells

- (UITableViewCell *)cellForItem:(id)item
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (NSArray *)visibleCells
{
  return [self.tableView visibleCells];
}

#pragma mark Scrolling the TreeView

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

#pragma mark Managing Selections

- (id)itemForSelectedRow
{
  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
  return [self treeNodeForIndex:indexPath.row].item;
}

- (NSArray *)itemsForSelectedRows
{
  NSMutableArray *items = [NSMutableArray array];
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  for (NSIndexPath *indexPath in selectedRows) {
    id item = [self treeNodeForIndex:indexPath.row].item;
    [items addObject:item];
  }
  return [NSArray arrayWithArray:items];
}

- (void)selectRowForItem:(id)item animated:(BOOL)animated scrollPosition:(RATreeViewScrollPosition)scrollPosition
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  UITableViewScrollPosition tableViewScrollPosition = [RATreeView tableViewScrollPositionForTreeViewScrollPosition:scrollPosition];
  [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:tableViewScrollPosition];
}

- (void)deselectRowForItem:(id)item animated:(BOOL)animated
{
  NSIndexPath *indexPath = [self indexPathForItem:item];
  [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
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

#pragma mark Managing the Editing of Tree Cells

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

#pragma mark Reloading the Tree View

- (void)reloadData
{
  [self setupTreeStructure];
  [self.tableView reloadData];
}

- (void)reloadRowsForItems:(NSArray *)items withRowAnimation:(RATreeViewRowAnimation)animation
{
  NSArray *rows = [self itemsForSelectedRows];
  UITableViewRowAnimation tableViewRowAnimation = [RATreeView tableViewRowAnimationForTreeViewRowAnimation:animation];
  [self.tableView reloadRowsAtIndexPaths:rows withRowAnimation:tableViewRowAnimation];
}


#pragma mark UIScrollView

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

@end
