
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


#import <UIKit/UIKit.h>



@class RATreeView, RATreeNodeCollectionController, RATreeNode;


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
  RATreeViewRowAnimationFade = 0,
  RATreeViewRowAnimationRight,
  RATreeViewRowAnimationLeft,
  RATreeViewRowAnimationTop,
  RATreeViewRowAnimationBottom,
  RATreeViewRowAnimationNone,
  RATreeViewRowAnimationMiddle,
  RATreeViewRowAnimationAutomatic = UITableViewRowAnimationAutomatic
} RATreeViewRowAnimation;


/**
 * The data source of the RATreeView object must conform to RATreeVIewDataSource protocol. It is implemented by an object with metdiates the application's data model for RATreeView object.
 */
@protocol RATreeViewDataSource <NSObject>

///------------------------------------------------
/// Configuring a Tree View
///------------------------------------------------

/**
 *  Ask the data source to return the number of child items encompassed by a given item. (required)
 *
 *  @param treeView     The tree-view that sent the message.
 *  @param item         An item identifying a cell in tree view.
 *  @param treeNodeInfo Object including additional information about item.
 *
 *  @return The number of child items encompassed by item. If item is nil, this method should return the number of children for the top-level item.
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item;


/**
 *  Asks the data source for a cell to insert for a specified item. (required)
 *
 *  @param treeView     A tree-view object requesting the cell.
 *  @param item         An item identifying a cell in tree view.
 *
 *  @return An object inheriting from UITableViewCell that the tree view can use for the specified row. An assertion is raised if you return nil.
 */
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item;

/**
 *  Ask the data source to return the child item at the specified index of a given item. (required)
 *
 *  @param treeView The tree-view object requesting child of the item at the specified index.
 *  @param index    The index of the child item from item to return.
 *  @param item     An item identifying a cell in tree view.
 *
 *  @return The child item at index of a item. If item is nil, returns the appropriate child item of the root object.
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item;

@optional

///------------------------------------------------
/// Inserting or Deleting Tree Rows
///------------------------------------------------

/**
 *  Asks the data source to commit the insertion or deletion of a row for specified item in the receiver.
 *
 *  @param treeView     The tree-view object requesting the insertion or deletion.
 *  @param editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by item. Possible editing styles are `UITableViewCellEditingStyleInsert` or `UITableViewCellEditingStyleDelete`.
 *  @param item         An item identifying a cell in tree view.
 *  @param treeNodeInfo Object including additional information about item.
 */
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item;

/**
 *  Asks the data source to verify that row for given item is editable.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a cell in tree view.
 *
 *  @return `YES` if the row indicated by indexPath is editable; otherwise, `NO`.
 */
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item;

@end


/**
 *  The delegate of a RATreeView object must adopt the RATreeViewDelegate protocol. Optional methods of the protocol allow the delegate to manage selections, help to delete and reorder cells, and perform other actions.
 */
@protocol RATreeViewDelegate <NSObject, UIScrollViewDelegate>

@optional


///------------------------------------------------
/// Configuring Rows for the Tree View
///------------------------------------------------

/**
 *  Asks the delegate for the height to use for a row for a specified item.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a cell in tree view.
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) that row should be.
 */
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item;

/**
 *  Asks the delegate for the estimated height of a row for a specified item.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a cell in tree view.
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) of the header for section.
 */
- (CGFloat)treeView:(RATreeView *)treeView estimatedHeightForRowForItem:(id)item NS_AVAILABLE_IOS(7_0);

/**
 *  Asks the delegate to return the level of indentation for a row for a specified item.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a cell in tree view.
 *
 *  @return Returns the depth of the specified row to show its hierarchical position.
 */
- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item;

/**
 *  Tells the delegate the tree view is about to draw a cell for a particular item.
 *
 *  @param treeView     The tree-view object informing the delegate of this impending event.
 *  @param cell         A table-view cell object that tableView is going to use when drawing the row.
 *  @param item         An item identifying a cell in tree view.
 */
- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item;

///------------------------------------------------
/// @name Managing Accessory Views
///------------------------------------------------

/**
 *  Tells the delegate that the user tapped the accessory (disclosure) view associated with a row for a given item.
 *
 *  @param treeView     The tree-view object informing the delegate of this event.
 *  @param item         An item identifying a cell in tree view.
 */
- (void)treeView:(RATreeView *)treeView accessoryButtonTappedForRowForItem:(id)item;


///------------------------------------------------
/// @name Expanding and Collapsing Tree View rows
///------------------------------------------------


/**
 *  Asks delegate whether a row for a specified item should be expanded.
 *
 *  @param treeView       The tree-view object requesting this information.
 *  @param item           An item identifying a row in tree view.
 *
 *  @return YES if the background of the row should be expanded, otherwise NO.
 *  @discussion If the delegate does not implement this method, the default is YES.
 */
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item;

/**
 *  Asks delegate whether a row for a specified item should be collapsed.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return YES if the background of the row should be expanded, otherwise NO.
 *  @discussion If the delegate does not implement this method, the default is YES.
 */
- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item;

/**
 *  Tells the delegate that a row for a specified item is about to be expanded.
 *
 *  @param treeView     A tree-view object informing the delegate about the impending expansion.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item;

/**
 *  Tells the delegate that a row for a specified item is about to be collapsed.
 *
 *  @param treeView     A tree-view object informing the delegate about the impending collapse.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item;

/**
 *  Tells the delegate that the row for a specified item is now expanded.
 *
 *  @param treeView     A tree-view object informing the delegate that new row is expanded.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item;

/**
 *  Tells the delegate that the row for a specified item is now collapsed.
 *
 *  @param treeView     A tree-view object informing the delegate that new row is collapsed.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item;


///------------------------------------------------
/// @name Managing Selections
///------------------------------------------------

/**
 *  Tells the delegate that a row for a specified item is about to be selected.
 *
 *  @param treeView     A tree-view object informing the delegate about the impending selection.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return An id object that confirms or alters the selected row. Return an id object other than item if you want another cell to be selected. Return nil if you don't want the row selected.
 */
- (id)treeView:(RATreeView *)treeView willSelectRowForItem:(id)item;

/**
 *  Tells the delegate that the row for a specified item is now selected.
 *
 *  @param treeView     A tree-view object informing the delegate about the new row selection.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item;

/**
 *  Tells the delegate that a row for a specified item is about to be deselected.
 *
 *  @param treeView     A tree-view object informing the delegate about the impending deselection.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return An id object that confirms or alters the deselected row. Return an id object other than item if you want another cell to be deselected. Return nil if you don’t want the row deselected.
 */
- (id)treeView:(RATreeView *)treeView willDeselectRowForItem:(id)item;

/**
 *  Tells the delegate that the row for a specified item is now deselected.
 *
 *  @param treeView     A tree-view object informing the delegate about the row deselection.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item;


///------------------------------------------------
/// @name Editing Tree Rows
///------------------------------------------------

/**
 *  Tells the delegate that the tree view is about to go into editing mode.
 *
 *  @param treeView     The tree-view object providing this information.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView willBeginEditingRowForItem:(id)item;

/**
 *  Tells the delegate that the tree view has left editing mode.
 *
 *  @param treeView     The tree-view object providing this information.
 *  @param item         AAn item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didEndEditingRowForItem:(id)item;

/**
 *  Asks the delegate for the editing style of a row for a specified item.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return The editing style of the cell for the row identified by item.
 *  @discussion This method allows the delegate to customize the editing style of the cell for specified item. If the delegate does not implement this method and the UITableViewCell object is editable (that is, it has its editing property set to YES), the cell has the UITableViewCellEditingStyleDelete style set for it.
 */

- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item;

/**
 *  Changes the default title of the delete-confirmation button.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return A localized string to used as the title of the delete-confirmation button.
 *  @discussion By default, the delete-confirmation button, which appears on the right side of the cell, has the title of “Delete”. The tree view displays this button when the user attempts to delete a row, either by swiping the row or tapping the red minus icon in editing mode. You can implement this method to return an alternative title, which should be localized. Default title string ("Delete") isn't localized.
 */
- (NSString *)treeView:(RATreeView *)treeView titleForDeleteConfirmationButtonForRowForItem:(id)item;

/**
 *  Asks the delegate whether the background of the row for a specified item should be indented while the tree view is in editing mode.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return YES if the background of the row should be indented, otherwise NO.
 *  @discussion If the delegate does not implement this method, the default is YES.
 */
- (BOOL)treeView:(RATreeView *)treeView shouldIndentWhileEditingRowForItem:(id)item;


///------------------------------------------------
/// @name Tracking the Removal of Views
///------------------------------------------------

/**
 *  Tells the delegate that the cell for a specified item was removed from the tree.
 *
 *  @param treeView     The tree-view object that removed the view.
 *  @param cell         The cell that was removed.
 *  @param item         An item identifying a cell in tree view.
 */
- (void)treeView:(RATreeView *)treeView didEndDisplayingCell:(UITableViewCell *)cell forItem:(id)item;


///------------------------------------------------
/// @name Copying and Pasting Row Content
///------------------------------------------------

/**
 *  Asks the delegate if the editing menu should be shown for a row for a specified item.
 *
 *  @param treeView     The tree-view object that is making this request.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return YES if the editing menu should be shown positioned near the row and pointing to it, otherwise NO. The default value is NO.
 */
- (BOOL)treeView:(RATreeView *)treeView shouldShowMenuForRowForItem:(id)item;

/**
 *  Asks the delegate if the editing menu should omit the Copy or Paste command for a row for a specified item.
 *
 *  @param treeView     The tree-view object that is making this request.
 *  @param action       A selector type identifying the copy: or paste: method of the UIResponderStandardEditActions informal protocol.
 *  @param item         An item identifying a row in tree view.
 *  @param sender       The object that initially sent the copy: or paste: message.
 *
 *  @return YES if the command corresponding to action should appear in the editing menu, otherwise NO. The default value is NO.
 */
- (BOOL)treeView:(RATreeView *)treeView canPerformAction:(SEL)action forRowForItem:(id)item withSender:(id)sender;

/**
 *  Tells the delegate to perform a copy or paste operation on the content of a row for a specified item.
 *
 *  @param treeView     The tree-view object that is making this request.
 *  @param action       A selector type identifying the copy: or paste: method of the UIResponderStandardEditActions informal protocol.
 *  @param item         An item identifying a row in tree view.
 *  @param sender       The object that initially sent the copy: or paste: message.
 *  @discussion The tree view invokes this method for a given action if the user taps Copy or Paste in the editing menu.
 */
- (void)treeView:(RATreeView *)treeView performAction:(SEL)action forRowForItem:(id)item withSender:(id)sender;


///------------------------------------------------
/// @name Managing Tree View Highlighting
///------------------------------------------------

/**
 *  Asks the delegate if the row for a specified item should be highlighted.
 *
 *  @param treeView     The tree-view object that is making this request.
 *  @param treeNodeInfo Object including additional information about item.
 *
 *  @return YES if the row should be highlighted or NO if it should not.
 */
- (BOOL)treeView:(RATreeView *)treeView shouldHighlightRowForItem:(id)item;

/**
 *  Tells the delegate that the row for a specified item was highlighted.
 *
 *  @param treeView     The tree-view object that highlighted the cell.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didHighlightRowForItem:(id)item;

/**
 *  Tells the delegate that the highlight was removed from the row for a specified item.
 *
 *  @param treeView     The tree-view object that removed the highlight from the cell.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didUnhighlightRowForItem:(id)item;

@end


@interface RATreeView : UIView

///------------------------------------------------
/// @name Initializing a RATreeView Object
///------------------------------------------------

- (id)initWithFrame:(CGRect)frame style:(RATreeViewStyle)style;


///------------------------------------------------
/// @name Managing the Delegate and the Data Source
///------------------------------------------------

@property (weak, nonatomic) id<RATreeViewDataSource> dataSource;
@property (weak, nonatomic) id<RATreeViewDelegate> delegate;


///------------------------------------------------
/// @name Configuring the Tree View
///------------------------------------------------

- (NSInteger)numberOfRows;
@property (nonatomic, readonly) RATreeViewStyle style;
@property (nonatomic) RATreeViewCellSeparatorStyle separatorStyle;
@property (strong, nonatomic) UIColor *separatorColor;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat estimatedRowHeight NS_AVAILABLE_IOS(7_0);
@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0);
@property (strong, nonatomic) UIView *backgroundView;


///------------------------------------------------
/// @name Expanding and Collapsing Rows
///------------------------------------------------

- (void)expandRowForItem:(id)item withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)collapseRowForItem:(id)item withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)expandRowForItem:(id)item;
- (void)collapseRowForItem:(id)item;
@property (nonatomic) RATreeViewRowAnimation rowsExpandingAnimation;
@property (nonatomic) RATreeViewRowAnimation rowsCollapsingAnimation;


///------------------------------------------------
/// @name Inserting, Deleting, and Moving Rows
///------------------------------------------------

- (void)beginUpdates;
- (void)endUpdates;
- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation;
- (void)moveItemAtIndex:(NSInteger)oldIndex inParent:(id)oldParent toIndex:(NSInteger)newIndex inParent:(id)newParent;
- (void)deleteItemsAtIndexes:(NSIndexSet *)indexes inParent:(id)parent withAnimation:(RATreeViewRowAnimation)animation;


///------------------------------------------------
/// @name Creating Tree View Cells
///------------------------------------------------

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


///------------------------------------------------
/// @name Accessing Header and Footer Views
///------------------------------------------------

- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (void)registerClass:(Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
@property (strong, nonatomic) UIView *treeHeaderView;
@property (strong, nonatomic) UIView *treeFooterView;


///------------------------------------------------
/// @name Working with Expandability
///------------------------------------------------

- (BOOL)isCellForItemExpanded:(id)item;
- (BOOL)isCellExpanded:(UITableViewCell *)cell;


///------------------------------------------------
/// @name Working with Indentation
///------------------------------------------------

- (NSInteger)levelForCellForItem:(id)item;
- (NSInteger)levelForCell:(UITableViewCell *)cell;


///------------------------------------------------
/// @name Getting the Parent for an Item
///------------------------------------------------

- (id)parentForItem:(id)parent;


///------------------------------------------------
/// @name Accessing Cells
///------------------------------------------------

- (UITableViewCell *)cellForItem:(id)item;
- (NSArray *)visibleCells;
- (id)itemForCell:(UITableViewCell *)cell;
- (id)itemForRowAtPoint:(CGPoint)point;
- (id)itemsForRowsInRect:(CGRect)rect;
@property(nonatomic, readonly) NSArray *itemsForVisibleCells;


///------------------------------------------------
/// @name Scrolling the TreeView
///------------------------------------------------

- (void)scrollToRowForItem:(id)item atScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToNearestSelectedRowAtScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated;


///------------------------------------------------
/// @name Managing Selections
///------------------------------------------------

- (id)itemForSelectedRow;
- (NSArray *)itemsForSelectedRows;
- (void)selectRowForItem:(id)item animated:(BOOL)animated scrollPosition:(RATreeViewScrollPosition)scrollPosition;
- (void)deselectRowForItem:(id)item animated:(BOOL)animated;
@property (nonatomic) BOOL allowsSelection;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic) BOOL allowsSelectionDuringEditing;
@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing;


///------------------------------------------------
/// @name Managing the Editing of Tree Cells
///------------------------------------------------

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
@property (nonatomic, getter = isEditing) BOOL editing;


///------------------------------------------------
/// @name Reloading the Tree View
///------------------------------------------------

- (void)reloadData;
- (void)reloadRowsForItems:(NSArray *)items withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)reloadRows;

/////////////////////////////
// UIScrollView Staff
/////////////////////////////


///------------------------------------------------
/// @name Managing the Display of Content
///------------------------------------------------

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) UIEdgeInsets contentInset;


///------------------------------------------------
/// @name Managing Scrolling
///------------------------------------------------

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


///------------------------------------------------
/// @name Managing the Scroll Indicator
///------------------------------------------------

@property (nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
@property (nonatomic) UIEdgeInsets scrollIndicatorInsets;
@property (nonatomic) BOOL showsHorizontalScrollIndicator;
@property (nonatomic) BOOL showsVerticalScrollIndicator;
- (void)flashScrollIndicators;


///------------------------------------------------
/// @name Zooming and Panning
///------------------------------------------------

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

