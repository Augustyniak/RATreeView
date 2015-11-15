
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

#import <QuartzCore/QuartzCore.h>

#import "RATreeView+TableViewDelegate.h"
#import "RATreeView_ClassExtension.h"
#import "RATreeView+Private.h"

#import "RATreeView.h"
#import "RATreeNodeCollectionController.h"
#import "RATreeNode.h"

@implementation RATreeView (TableViewDelegate)

#pragma mark - Configuring Rows for the Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:heightForRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self heightForRowForItem:treeNode.item];
  }
  return self.tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:estimatedHeightForRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self estimatedHeightForRowForItem:treeNode.item];
  }
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:indentationLevelForRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self indentationLevelForRowForItem:treeNode.item];
  }
  return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:willDisplayCell:forItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self willDisplayCell:cell forItem:treeNode.item];
  }
}


#pragma mark - Managing Accessory Views

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:accessoryButtonTappedForRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self accessoryButtonTappedForRowForItem:treeNode.item];
  }
}


#pragma mark - Managing Selection

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:willSelectRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    id item = [self.delegate treeView:self willSelectRowForItem:treeNode.item];
    if (item) {
      NSIndexPath *newIndexPath = [self indexPathForItem:item];
      return (newIndexPath.row == NSNotFound) ? indexPath : newIndexPath;
    } else {
      return nil;
    }
  }
  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
  if ([self.delegate respondsToSelector:@selector(treeView:didSelectRowForItem:)]) {
    [self.delegate treeView:self didSelectRowForItem:treeNode.item];
  }
  
  if (treeNode.expanded) {
    if ([self.delegate respondsToSelector:@selector(treeView:shouldCollapaseRowForItem:)]) {
      if ([self.delegate treeView:self shouldCollapaseRowForItem:treeNode.item]) {
        [self collapseCellForTreeNode:treeNode informDelegate:YES];
      }
    } else {
      [self collapseCellForTreeNode:treeNode informDelegate:YES];
    }
  } else {
    if ([self.delegate respondsToSelector:@selector(treeView:shouldExpandRowForItem:)]) {
      if ([self.delegate treeView:self shouldExpandRowForItem:treeNode.item]) {
        [self expandCellForTreeNode:treeNode informDelegate:YES];
      }
    } else {
      [self expandCellForTreeNode:treeNode informDelegate:YES];
    }
  }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:willDeselectRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    id item = [self.delegate treeView:self willDeselectRowForItem:treeNode.item];
    NSIndexPath *delegateIndexPath = [self indexPathForItem:item];
    return delegateIndexPath.row == NSNotFound ? indexPath : delegateIndexPath;
  } else {
    return indexPath;
  }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didDeselectRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self didDeselectRowForItem:treeNode.item];
  }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:editingStyleForRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self editingStyleForRowForItem:treeNode.item];
  }
  return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:titleForDeleteConfirmationButtonForRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self titleForDeleteConfirmationButtonForRowForItem:treeNode.item];
  }
  return @"Delete";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:shouldIndentWhileEditingRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self shouldIndentWhileEditingRowForItem:treeNode.item];
  }
  return YES;
}


#pragma mark - Editing Table Rows

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:willBeginEditingRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self willBeginEditingRowForItem:treeNode.item];
  }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didEndEditingRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self didEndEditingRowForItem:treeNode.item];
  }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:editActionsForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self editActionsForItem:treeNode.item];
  }
  return nil;
}


#pragma mark - Tracking the Removal of Views

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didEndDisplayingCell:forItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self didEndDisplayingCell:cell forItem:treeNode.item];
  }
}


#pragma mark - Copying and Pasting Row Content

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:shouldShowMenuForRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self shouldShowMenuForRowForItem:treeNode.item];
  }
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(treeView:canPerformAction:forRowForItem:withSender:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self canPerformAction:action forRowForItem:treeNode.item withSender:sender];
  }
  return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(treeView:performAction:forRowForItem:withSender:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self performAction:action forRowForItem:treeNode.item withSender:sender];
  }
}


#pragma mark - Managing Table View Highlighting

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:shouldHighlightRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    return [self.delegate treeView:self shouldHighlightRowForItem:treeNode.item];
  }
  return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didHighlightRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self didHighlightRowForItem:treeNode.item];
  }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didUnhighlightRowForItem:)]) {
    RATreeNode *treeNode = [self treeNodeForIndexPath:indexPath];
    [self.delegate treeView:self didUnhighlightRowForItem:treeNode.item];
  }
}


#pragma mark - Private Helpers

- (void)collapseCellForTreeNode:(RATreeNode *)treeNode informDelegate:(BOOL)informDelegate
{
  if (informDelegate) {
    if ([self.delegate respondsToSelector:@selector(treeView:willCollapseRowForItem:)]) {
      [self.delegate treeView:self willCollapseRowForItem:treeNode.item];
    }
  }
  
  [CATransaction begin];
  [CATransaction setCompletionBlock:^{
    if ([self.delegate respondsToSelector:@selector(treeView:didCollapseRowForItem:)] &&
        informDelegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Content size of the UITableView isn't updates when completion block of the CATransaction is called. To make it possible for the user of the RATreeView to get a correct content size in the implementation of the 'treeView:didCollapseRowForItem' RATreeView calls this method in the next run loop.
            [self.delegate treeView:self didCollapseRowForItem:treeNode.item];
        });
    }
  }];
  
  [self collapseCellForTreeNode:treeNode];
  [CATransaction commit];
}

- (void)expandCellForTreeNode:(RATreeNode *)treeNode informDelegate:(BOOL)informDelegate
{
  if (informDelegate) {
    if ([self.delegate respondsToSelector:@selector(treeView:willExpandRowForItem:)]) {
      [self.delegate treeView:self willExpandRowForItem:treeNode.item];
    }
  }
  
  [CATransaction begin];
  [CATransaction setCompletionBlock:^{
    if ([self.delegate respondsToSelector:@selector(treeView:didExpandRowForItem:)] &&
        informDelegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Content size of the UITableView isn't updates when completion block of the CATransaction is called. To make it possible for the user of the RATreeView to get a correct content size in the implementation of the 'treeView:didExpandRowForItem' RATreeView calls this method in the next run loop.
            [self.delegate treeView:self didExpandRowForItem:treeNode.item];
        });
    }
  }];
    
  [self expandCellForTreeNode:treeNode];
  [CATransaction commit];
}


@end
