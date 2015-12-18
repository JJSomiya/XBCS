//
//  UIScrollView+FloatingHeader.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "UIScrollView+FloatingHeader.h"
#import <objc/runtime.h>

static void * FloatingTopHeaderViewKey          = &FloatingTopHeaderViewKey;
static void * FloatingTopHeaderViewContext      = &FloatingTopHeaderViewContext;
static void * FloatingLeftHeaderViewKey         = &FloatingLeftHeaderViewKey;
static void * FloatingLeftHeaderViewContext     = &FloatingLeftHeaderViewContext;
static void * FloatingTopLeftCornerViewKey      = &FloatingTopLeftCornerViewKey;
static void * FloatingTopLeftCornerViewContext  = &FloatingTopLeftCornerViewContext;

static void * FloatingLeftKey                   = &FloatingLeftKey;
#pragma mark ----------------setters/getters----------------
@implementation UIScrollView (FloatingHeader)

- (UIView *)floatingTopHeaderView {
    return objc_getAssociatedObject(self, FloatingTopHeaderViewKey);
}

- (UIView *)floatingLeftHeaderView {
    return objc_getAssociatedObject(self, FloatingLeftHeaderViewKey);
}

- (UIView *)floatingTopLeftCornerView {
    return objc_getAssociatedObject(self, FloatingTopLeftCornerViewKey);
}

- (NSNumber *)isFloatingLeft {
    return objc_getAssociatedObject(self, FloatingLeftKey);
}

- (void)setFloatingTopHeaderView:(UIView *)floatingTopHeaderView {
    [self _handlePreviousTopHeaderView];
    objc_setAssociatedObject(self, FloatingTopHeaderViewKey, floatingTopHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _handleNewTopHeaderView];
}

- (void)setFloatingLeftHeaderView:(UIView *)floatingLeftHeaderView {
    [self _handlePreviousLeftHeaderView];
    objc_setAssociatedObject(self, FloatingLeftHeaderViewKey, floatingLeftHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _handleNewLeftHeaderView];
}

- (void)setFloatingTopLeftCornerView:(UIView *)floatingTopLeftCornerView {
    [self _handlePreviousTopLeftCornerView];
    objc_setAssociatedObject(self, FloatingTopLeftCornerViewKey, floatingTopLeftCornerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _handleNewTopLeftCornerView];
}

- (void)setIsFloatingLeft:(NSNumber *)isFloatingLeft {
    NSNumber *floating = [self isFloatingLeft];
    floating = nil;
    objc_setAssociatedObject(self, FloatingLeftKey, isFloatingLeft, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark ----------------Handle add/remove of views----------------
- (void)_handlePreviousTopHeaderView {
    UIView* previousHeaderView = [self floatingTopHeaderView];
    if(previousHeaderView != nil){
        [previousHeaderView removeFromSuperview];
        @try {
            [self removeObserver:self forKeyPath:@"contentOffset"];
        }
        @catch (NSException * __unused exception) {
            
        }
        previousHeaderView = nil;
    }

}

- (void)_handlePreviousLeftHeaderView {
    UIView* previousHeaderView = [self floatingLeftHeaderView];
    if(previousHeaderView != nil){
        [previousHeaderView removeFromSuperview];
        @try {
            [self removeObserver:self forKeyPath:@"contentOffset"];
        }
        @catch (NSException * __unused exception) {
            
        }
        previousHeaderView = nil;
    }
}

- (void)_handlePreviousTopLeftCornerView {
    UIView* previousHeaderView = [self floatingTopLeftCornerView];
    if(previousHeaderView != nil){
        [previousHeaderView removeFromSuperview];
        @try {
            [self removeObserver:self forKeyPath:@"contentOffset"];
        }
        @catch (NSException * __unused exception) {
            
        }
        previousHeaderView = nil;
    }
}
- (void)_handlePreviousFloatingLeft {
    NSNumber *previousHeaderView = [self isFloatingLeft];
    if(previousHeaderView != nil){
        previousHeaderView = nil;
    }
}

- (void)_handleNewTopHeaderView {
    if(self.floatingTopHeaderView !=nil) {
        [self addSubview:self.floatingTopHeaderView];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:FloatingTopHeaderViewContext];
        self.floatingTopHeaderView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.floatingTopHeaderView.layer.shadowOffset = CGSizeMake(0, 2);
        self.floatingTopHeaderView.layer.shadowOpacity = 0.7;
    }
}

- (void)_handleNewLeftHeaderView {
    if(self.floatingLeftHeaderView !=nil){
        [self addSubview:self.floatingLeftHeaderView];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:FloatingLeftHeaderViewContext];
//        self.floatingLeftHeaderView.layer.shadowColor = [UIColor grayColor].CGColor;
//        self.floatingLeftHeaderView.layer.shadowOffset = CGSizeMake(2, 0);
//        self.floatingLeftHeaderView.layer.shadowOpacity = 0.7;
    }
}

- (void)_handleNewTopLeftCornerView {
    if(self.floatingTopLeftCornerView !=nil){
        [self addSubview:self.floatingTopLeftCornerView];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:FloatingTopLeftCornerViewContext];
//        self.floatingTopLeftCornerView.layer.shadowColor = [UIColor grayColor].CGColor;
//        self.floatingTopLeftCornerView.layer.shadowOffset = CGSizeMake(2, 2);
//        self.floatingTopLeftCornerView.layer.shadowOpacity = 0.7;
    }
}

#pragma mark ----------------Scroll Logic----------------
- (void)_scrolledYFromOffset:(CGFloat)oldYOffset toOffset:(CGFloat)newYOffset {
    CGRect floatingFrame = self.floatingTopHeaderView.frame;
    floatingFrame.origin.y = newYOffset;
    [self.floatingTopHeaderView setFrame:floatingFrame];
}

- (void)_scrolledXFromOffset:(CGFloat)oldXOffset toOffset:(CGFloat)newXOffset {

    CGRect floatingFrame = self.floatingLeftHeaderView.frame;
    floatingFrame.origin.x = newXOffset;
    [self.floatingLeftHeaderView setFrame:floatingFrame];
}

- (void)_scrolledFromOffset:(CGPoint)oldOffset toOffset:(CGPoint)newOffset {
    CGRect floatingFrame = self.floatingTopLeftCornerView.frame;
    if ([[self isFloatingLeft] boolValue]) {
        floatingFrame.origin.x = newOffset.x;
    }
    floatingFrame.origin.y = newOffset.y;
    [self.floatingTopLeftCornerView setFrame:floatingFrame];
}

#pragma mark ----------------KVO----------------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == FloatingTopHeaderViewContext) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat oldYOffset = [[change objectForKey:@"old"]CGPointValue].y;
            CGFloat newYOffset = [[change objectForKey:@"new"]CGPointValue].y;
            [self _scrolledYFromOffset:oldYOffset toOffset:newYOffset];
        }
    } else if (context == FloatingLeftHeaderViewContext) {
        CGFloat oldXOffset = [[change objectForKey:@"old"]CGPointValue].x;
        CGFloat newXOffset = [[change objectForKey:@"new"]CGPointValue].x;
        if ([self.isFloatingLeft boolValue]) {
            [self _scrolledXFromOffset:oldXOffset toOffset:newXOffset];
        }
    } else if(context == FloatingTopLeftCornerViewContext) {
        CGPoint oldOffset = [[change objectForKey:@"old"] CGPointValue];
        CGPoint newOffset = [[change objectForKey:@"new"] CGPointValue];
        [self _scrolledFromOffset:oldOffset toOffset:newOffset];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeContentOffsetObserver {
    [self removeObserver:self forKeyPath:@"contentOffset" context:FloatingTopHeaderViewContext];
    [self removeObserver:self forKeyPath:@"contentOffset" context:FloatingLeftHeaderViewContext];
}

@end
