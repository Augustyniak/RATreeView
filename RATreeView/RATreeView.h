
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


#import <UIKit/UIKit.h>
#import "RATreeNodeInfo.h"



@class RATreeView;
@class RATreeViewCell;
@class RATreeNodeInfo;
@class RATreeNodeCollectionController;
@class RATreeNode;


typedef enum {
  RATreeViewStylePlain = 0,
  RATreeViewStyleGrouped
} RATreeViewStyle;

typedef enum RATreeViewCellSeparatorStyle {
  RATreeViewCellSeparatorStyleNone = 0,
  RATreeViewCellSeparatorStyleSingleLine,
  RATreeViewCellSeparatorStyleSingleLineEtched
} RATreeViewCellSeparatorStyle;

typedef enum RATreeViewScrollPosition {
  RATreeViewScrollPositionNone = 0,
  RATreeViewScrollPositionTop,
  RATreeViewScrollPositionMiddle,
  RATreeViewScrollPositionBottom
} RATreeViewScrollPosition;

typedef enum RATreeViewRowAnimation {
  RATreeViewRowAnimationNone = 0,
  RATreeViewRowAnimationRight,
  RATreeViewRowAnimationLeft,
  RATreeViewRowAnimationTop,
  RATreeViewRowAnimationBottom,
  RATreeViewRowAnimationMiddle,
  RATreeViewRowAnimationAutomatic
} RATreeViewRowAnimation;



@protocol RATreeViewDataSource <NSObject>

@required
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item;
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item;
@optional
//Inserting or Deleting Table Rows
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
@end


@protocol RATreeViewDelegate <NSObject, UIScrollViewDelegate>
@optional
// Configuring Rows for the Table View
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;

// Managin Accessory Views
- (void)treeView:(RATreeView *)treeView accessoryButtonTappedForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;

//Expanding and Collapsing the Outline
- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel;
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;

//Managing Selections
- (id)treeView:(RATreeView *)treeView willSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (id)treeView:(RATreeView *)treeView willDeselectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;

//Editing Tree Rows
- (void)treeView:(RATreeView *)treeView willBeginEditingRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (void)treeView:(RATreeView *)treeView didEndEditingRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (NSString *)treeView:(RATreeView *)treeView titleForDeleteConfirmationButtonForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (BOOL)treeView:(RATreeView *)treeView shouldIndentWhileEditingRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;

//Tracking the Removal of Views
- (void)treeView:(RATreeView *)treeView didEndDisplayingCell:(RATreeViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;

//Copying and Pasting Row Content
- (BOOL)treeView:(RATreeView *)treeView shouldShowMenuForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (BOOL)treeView:(RATreeView *)treeView canPerformAction:(SEL)action forRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo withSender:(id)sender;
- (void)treeView:(RATreeView *)treeView performAction:(SEL)action forRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo withSender:(id)sender;

//Managing Table View Highlighting
- (BOOL)treeView:(RATreeView *)treeView shouldHighlightRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (BOOL)treeView:(RATreeView *)treeView didHighlightRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
- (BOOL)treeView:(RATreeView *)treeView didUnhighlightRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;
@end


@interface RATreeView : UIView

@property (weak, nonatomic) id<RATreeViewDataSource> dataSource;
@property (weak, nonatomic) id<RATreeViewDelegate> delegate;

// Initializing a TreeView Object
- (id)initWithFrame:(CGRect)frame style:(RATreeViewStyle)style;

//Configuring a Tree View
- (NSInteger)numberOfRows;
@property (nonatomic, readonly) RATreeViewStyle style;
@property (nonatomic) RATreeViewCellSeparatorStyle separatorStyle;
@property (strong, nonatomic) UIColor *separatorColor;
@property (nonatomic) CGFloat rowHeight;
@property (strong, nonatomic) UIView *backgroundView;

//Expanding and Collapsing Rows
- (void)expandRowForItem:(id)item withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)collapseRowForItem:(id)item withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)expandRowForItem:(id)item;
- (void)collapseRowForItem:(id)item;
@property (nonatomic) RATreeViewRowAnimation rowsExpandingAnimation;
@property (nonatomic) RATreeViewRowAnimation rowsCollapsingAnimation;

// Creating Table View Cells
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

// Accessing Header and Footer Views
@property (strong, nonatomic) UIView *treeHeaderView;
@property (strong, nonatomic) UIView *treeFooterView;

// Accessing Cells
- (UITableViewCell *)cellForItem:(id)item;
- (NSArray *)visibleCells;

// Scrolling the TreeView
- (void)scrollToRowForItem:(id)item atScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToNearestSelectedRowAtScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated;

// Managing Selections
- (id)itemForSelectedRow;
- (NSArray *)itemsForSelectedRows;
- (void)selectRowForItem:(id)item animated:(BOOL)animated scrollPosition:(RATreeViewScrollPosition)scrollPosition;
- (void)deselectRowForItem:(id)item animated:(BOOL)animated;
@property (nonatomic) BOOL allowsSelection;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic) BOOL allowsSelectionDuringEditing;
@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing;

// Managing the Editing of Tree Cells
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
@property (nonatomic, getter = isEditing) BOOL editing;

// Reloading the Tree View
- (void)reloadData;
- (void)reloadRowsForItems:(NSArray *)items withRowAnimation:(RATreeViewRowAnimation)animation;

/////////////////////////////
// UIScrollView Staff
/////////////////////////////

//Managing the Display of Content
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) UIEdgeInsets contentInset;

//Managing Scrolling
@property (nonatomic) BOOL scrollEnabled;
@property (nonatomic) BOOL directionalLockEnabled;
@property (nonatomic) BOOL scrollsToTop;
- (void)scrollRectToVisible:(CGRect)visible animated:(BOOL)animated;
@property (nonatomic) BOOL pagingEnabled;
@property (nonatomic) BOOL bounces;
@property (nonatomic) BOOL alwaysBounceVertical;
@property (nonatomic) BOOL alwaysBounceHorizontal;
@property (nonatomic) BOOL canCancelContentTouches;
@property (nonatomic) BOOL delaysContentTouches;
@property (nonatomic) BOOL decelerationRate;
@property (nonatomic, readonly) BOOL dragging;
@property (nonatomic, readonly) BOOL tracking;
@property (nonatomic, readonly) BOOL decelerating;

//Managing the Scroll Indicator
@property (nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
@property (nonatomic) UIEdgeInsets scrollIndicatorInsets;
@property (nonatomic) BOOL showsHorizontalScrollIndicator;
@property (nonatomic) BOOL showsVerticalScrollIndicator;
- (void)flashScrollIndicators;

//Zooming and Panning
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic, readonly) UIPinchGestureRecognizer *pinchGestureRecognizer;
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;
@property (nonatomic) CGFloat zoomScale;
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated;
@property (nonatomic) CGFloat maximumZoomScale;
@property (nonatomic) CGFloat minimumZoomScale;
@property (nonatomic, readonly) BOOL zoomBouncing;
@property (nonatomic, readonly) BOOL zooming;
@property (nonatomic) BOOL bouncesZoom;

@end

