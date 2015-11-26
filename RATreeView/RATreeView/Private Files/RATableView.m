//
//  RATableView.m
//  Pods
//
//  Created by Rafal Augustyniak on 15/11/15.
//
//


#import "RATableView.h"
#import <objc/runtime.h>


@interface RATableView () <UITableViewDelegate>

@end


@implementation RATableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
  self = [super initWithFrame:frame style:style];
  if (self) {
    [self commonInit];
  }

  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }

  return self;
}

- (void)commonInit
{
  [super setDelegate:self];
}

- (void)setTableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
{
  if (_tableViewDelegate == tableViewDelegate) {
    return;
  }
  [super setDelegate:nil];
  _tableViewDelegate = tableViewDelegate;
  [super setDelegate:self];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
  if (self.scrollViewDelegate == delegate) {
    return;
  }
  [super setDelegate:nil];
  self.scrollViewDelegate = delegate;
  [super setDelegate:self];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [super respondsToSelector:aSelector]
  || (SelectorBelongsToProtocol(@protocol(UIScrollViewDelegate), aSelector) && [self.scrollViewDelegate respondsToSelector:aSelector])
  || (SelectorBelongsToProtocol(@protocol(UITableViewDelegate), aSelector) && [self.tableViewDelegate respondsToSelector:aSelector]);
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
  if (SelectorBelongsToProtocol(@protocol(UIScrollViewDelegate), aSelector)) {
    return self.scrollViewDelegate;
  } else if (SelectorBelongsToProtocol(@protocol(UITableViewDelegate), aSelector)) {
    return self.tableViewDelegate;
  } else {
    return nil;
  }
}


#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [self.scrollViewDelegate scrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView];
  }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
    [self.scrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
  }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
    return [self.scrollViewDelegate scrollViewShouldScrollToTop:scrollView];
  }
  return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
    [self.scrollViewDelegate scrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
    [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
  }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
    return [self.scrollViewDelegate viewForZoomingInScrollView:scrollView];
  }
  return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
    [self.scrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
  }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
    [self.scrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
  }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
    [self.scrollViewDelegate scrollViewDidZoom:scrollView];
  }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
    [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
  }
}


#pragma mark -

static BOOL SelectorBelongsToProtocol(Protocol *protocol, SEL selector)
{
  struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);

  return NULL != methodDescription.name;
}

@end
