
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


#import "RATreeView+TableViewDelegate.h"
#import "RATreeView+Private.h"

#import "RATreeView.h"
#import "RATreeNodeCollectionController.h"
#import "RATreeNode.h"

@implementation RATreeView (TableViewDelegate)

#pragma mark Configuring Rows for the Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:heightForRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self heightForRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  return self.tableView.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:indentationLevelForRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self indentationLevelForRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:willDisplayCell:forItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self willDisplayCell:cell forItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}

#pragma mark Managin Accessory Views

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:accessoryButtonTappedForRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self accessoryButtonTappedForRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}

#pragma mark Managing Selection

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.treeNodeCollectionController respondsToSelector:@selector(treeView:willSelectRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    id item = [self.delegate treeView:self willSelectRowForItem:treeNode treeNodeInfo:[treeNode treeNodeInfo]];
    NSIndexPath *delegateIndexPath = [self indexPathForItem:item];
    return delegateIndexPath.row == -1 ? indexPath : delegateIndexPath;
  } else {
    return indexPath;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
  if ([self.delegate respondsToSelector:@selector(treeView:didSelectRowForItem:treeNodeInfo:)]) {
    [self.delegate treeView:self didSelectRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  if ([[treeNode treeNodeInfo].children count] == 0) {
    return;
  }
  
  if (treeNode.expanded) {
    if ([self.delegate respondsToSelector:@selector(treeView:shouldCollapaseRowForItem:treeNodeInfo:)]) {
      if ([self.delegate treeView:self shouldCollapaseRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]]) {
        [self collapseCellForTreeNode:treeNode informDelegate:YES];
      }
    } else {
      [self collapseCellForTreeNode:treeNode informDelegate:YES];
    }
  } else {
    if ([self.delegate respondsToSelector:@selector(treeView:shouldExpandRowForItem:treeNodeInfo:)]) {
      if ([self.delegate treeView:self shouldExpandRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]]) {
        [self expandCellForTreeNode:treeNode informDelegate:YES];
      }
    } else {
      [self expandCellForTreeNode:treeNode informDelegate:YES];
    }
  }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:willDeselectRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    id item = [self.delegate treeView:self willDeselectRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
    NSIndexPath *delegateIndexPath = [self indexPathForItem:item];
    return delegateIndexPath.row == -1 ? indexPath : delegateIndexPath;
  } else {
    return indexPath;
  }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didDeselectRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self didDeselectRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:editingStyleForRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self editingStyleForRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:titleForDeleteConfirmationButtonForRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self titleForDeleteConfirmationButtonForRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  return @"Delete";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:shouldIndentWhileEditingRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self shouldIndentWhileEditingRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  return YES;
}

#pragma mark Editing Table Rows

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:willBeginEditingRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self willBeginEditingRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didEndEditingRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self didEndEditingRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}


#pragma mark Tracking the Removal of Views

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didEndDisplayingCell:forItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self didEndDisplayingCell:(RATreeViewCell *)cell forItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}

#pragma mark Copying and Pasting Row Content

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:shouldShowMenuForRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self shouldShowMenuForRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(treeView:canPerformAction:forRowForItem:treeNodeInfo:withSender:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self canPerformAction:action forRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo] withSender:sender];
  }
  return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(treeView:performAction:forRowForItem:treeNodeInfo:withSender:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self performAction:action forRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo] withSender:sender];
  }
}

#pragma mark Managing Table View Highlighting

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:shouldHighlightRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    return [self.delegate treeView:self shouldHighlightRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
  return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didHighlightRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self didHighlightRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(treeView:didUnhighlightRowForItem:treeNodeInfo:)]) {
    RATreeNode *treeNode = [self treeNodeForIndex:indexPath.row];
    [self.delegate treeView:self didUnhighlightRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
  }
}

#pragma mark Private Helpers

- (void)collapseCellForTreeNode:(RATreeNode *)treeNode informDelegate:(BOOL)informDelegate
{
  if (informDelegate) {
    if ([self.delegate respondsToSelector:@selector(treeView:willCollapseRowForItem:treeNodeInfo:)]) {
      [self.delegate treeView:self willCollapseRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
    }
  }
  [self collapseCellForTreeNode:treeNode];
}

- (void)expandCellForTreeNode:(RATreeNode *)treeNode informDelegate:(BOOL)informDelegate
{
  if (informDelegate) {
    if ([self.delegate respondsToSelector:@selector(treeView:willExpandRowForItem:treeNodeInfo:)]) {
      [self.delegate treeView:self willExpandRowForItem:treeNode.item treeNodeInfo:[treeNode treeNodeInfo]];
    }
  }
  [self expandCellForTreeNode:treeNode];
}


@end
