
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//Copyright (c) 2016 Patrick Schneider
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


#import "RAScrollViewProxy.h"

#import <objc/runtime.h>

@interface RAScrollViewProxy ()
{
    __weak UITableView *_tableView;
}

@end

@implementation RAScrollViewProxy

- (instancetype)initWithTableView:(UITableView *)tableView
{
    _tableView = tableView;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    // Dual proxy functionality: forward method calls to table view and delegate calls to the delegate
    if ([RAScrollViewProxy isScrollViewDelegateSelector:selector])
        return [(NSObject *)_delegate methodSignatureForSelector:selector];
    else if ([RAScrollViewProxy isScrollViewMethodSelector:selector])
        return [_tableView methodSignatureForSelector:selector];
    else
        return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([RAScrollViewProxy isScrollViewDelegateSelector:invocation.selector]) {
        NSAssert(invocation.methodSignature.numberOfArguments > 2, nil);
        [invocation setArgument:(void *)&self atIndex:2];
        [invocation invokeWithTarget:_delegate];
    }
    else {
        [invocation invokeWithTarget:_tableView];
    }
}

+ (BOOL)isScrollViewMethodSelector:(SEL)selector
{
    Method method = class_getInstanceMethod([UIScrollView class], selector);
    
    return method != NULL;
}

+ (BOOL)isScrollViewDelegateSelector:(SEL)selector
{
    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(UIScrollViewDelegate), selector, NO, YES);
    
    return methodDescription.name != NULL;
}

@end
