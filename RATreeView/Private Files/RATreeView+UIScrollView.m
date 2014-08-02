
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

#import "RATreeView+UIScrollView.h"
#import "RATreeView+Private.h"
#import "RATreeView_ClassExtension.h"

@implementation RATreeView (UIScrollView)


#pragma mark Managing the Display of Content

- (void)setContentOffset:(CGPoint)contentOffset
{
  self.tableView.contentOffset = contentOffset;
}

- (CGPoint)contentOffset
{
  return self.tableView.contentOffset;
}


- (void)setContentSize:(CGSize)contentSize
{
  self.tableView.contentSize = contentSize;
}

- (CGSize)contentSize
{
  return self.tableView.contentSize;
}


- (void)setContentInset:(UIEdgeInsets)contentInset
{
  self.tableView.contentInset = contentInset;
}

- (UIEdgeInsets)contentInset
{
  return self.tableView.contentInset;
}

#pragma mark Managing Scrolling

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
  self.tableView.scrollEnabled = scrollEnabled;
}

- (BOOL)scrollEnabled
{
  return self.tableView.scrollEnabled;
}


- (void)setDirectionalLockEnabled:(BOOL)directionalLockEnabled
{
  self.tableView.directionalLockEnabled = directionalLockEnabled;
}

- (BOOL)directionalLockEnabled
{
  return self.tableView.directionalLockEnabled;
}


- (void)setScrollsToTop:(BOOL)scrollsToTop
{
  self.tableView.scrollsToTop = scrollsToTop;
}

-(BOOL)scrollsToTop
{
  return self.tableView.scrollsToTop;
}


- (void)setPagingEnabled:(BOOL)pagingEnabled
{
  self.tableView.pagingEnabled = pagingEnabled;
}

- (BOOL)pagingEnabled
{
  return self.tableView.pagingEnabled;
}


- (void)setBounces:(BOOL)bounces
{
  self.tableView.bounces = bounces;
}

- (BOOL)bounces
{
  return self.tableView.bounces;
}


- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical
{
  self.tableView.alwaysBounceVertical = alwaysBounceVertical;
}

- (BOOL)alwaysBounceVertical
{
  return self.tableView.alwaysBounceVertical;
}


- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal
{
  self.tableView.alwaysBounceHorizontal = alwaysBounceHorizontal;
}

- (BOOL)alwaysBounceHorizontal
{
  return self.tableView.alwaysBounceHorizontal;
}


- (void)setCanCancelContentTouches:(BOOL)canCancelContentTouches
{
  self.tableView.canCancelContentTouches = canCancelContentTouches;
}

- (BOOL)canCancelContentTouches
{
  return self.tableView.canCancelContentTouches;
}


- (void)setDelaysContentTouches:(BOOL)delaysContentTouches
{
  self.tableView.delaysContentTouches = delaysContentTouches;
}

- (BOOL)delaysContentTouches
{
  return self.tableView.delaysContentTouches;
}


- (void)setDecelerationRate:(BOOL)decelerationRate
{
  self.tableView.decelerationRate = decelerationRate;
}

- (BOOL)decelerationRate
{
  return self.tableView.decelerationRate;
}

- (BOOL)dragging
{
  return self.tableView.dragging;
}


- (BOOL)tracking
{
  return self.tableView.tracking;
}

- (BOOL)decelerating
{
  return self.tableView.decelerating;
}

#pragma mark Managin the Scroll Indicator

- (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle
{
  self.tableView.indicatorStyle = indicatorStyle;
}

- (UIScrollViewIndicatorStyle)indicatorStyle
{
  return self.tableView.indicatorStyle;
}


- (void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets
{
  self.tableView.scrollIndicatorInsets = scrollIndicatorInsets;
}

- (UIEdgeInsets)scrollIndicatorInsets
{
  return self.tableView.scrollIndicatorInsets;
}


- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
  self.tableView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (BOOL)showsHorizontalScrollIndicator
{
  return self.tableView.showsHorizontalScrollIndicator;
}


- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
  self.tableView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (BOOL)showsVerticalScrollIndicator
{
  return self.tableView.showsVerticalScrollIndicator;
}

#pragma mark Zooming and Panning

- (UIPanGestureRecognizer *)panGestureRecognizer
{
  return self.panGestureRecognizer;
}

- (UIPinchGestureRecognizer *)pinchGestureRecognizer
{
  return self.pinchGestureRecognizer;
}


- (void)setZoomScale:(CGFloat)zoomScale
{
  self.tableView.zoomScale = zoomScale;
}

- (CGFloat)zoomScale
{
  return self.tableView.zoomScale;
}


- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale
{
  self.tableView.maximumZoomScale = maximumZoomScale;
}

- (CGFloat)maximumZoomScale
{
  return self.tableView.maximumZoomScale;
}


- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale
{
  self.tableView.minimumZoomScale = minimumZoomScale;
}

- (CGFloat)minimumZoomScale
{
  return self.tableView.minimumZoomScale;
}


- (BOOL)zoomBouncing
{
  return self.tableView.zoomBouncing;
}

- (BOOL)zooming
{
  return self.tableView.zooming;
}

- (void)setBouncesZoom:(BOOL)bouncesZoom
{
  self.tableView.bouncesZoom = bouncesZoom;
}

- (BOOL)bouncesZoom
{
  return self.tableView.bouncesZoom;
}

#pragma mark Responding to Scrolling and Dragging

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [self.delegate scrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [self.delegate scrollViewWillBeginDragging:scrollView];
  }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
    [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
  }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
    return [self.delegate scrollViewShouldScrollToTop:scrollView];
  }
  return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [self.delegate scrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
    [self.delegate scrollViewWillBeginDecelerating:scrollView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [self.delegate scrollViewDidEndDecelerating:scrollView];
  }
}

//Managing Zooming

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
    return [self.delegate viewForZoomingInScrollView:scrollView];
  }
  return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
  if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
    [self.delegate scrollViewWillBeginZooming:scrollView withView:view];
  }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
  if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
    [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
  }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
    [self.delegate scrollViewDidZoom:scrollView];
  }
}

//Responding and Scrolling Animations

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
    [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
  }
}

@end
