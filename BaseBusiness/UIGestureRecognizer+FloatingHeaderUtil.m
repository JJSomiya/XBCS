//
//  UIGestureRecognizer+FloatingHeaderUtil.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "UIGestureRecognizer+FloatingHeaderUtil.h"
#import <objc/runtime.h>

@interface UIGestureRecognizer (Private)

- (void)executeCallback:(id)sender;

@end

@implementation UIGestureRecognizer (FloatingHeaderUtil)
+ (id)withCallback:(FloatingHeaderGestureCallback)aCallback {
    return [[[self class] alloc] initWithCallback:aCallback];
}

- (id)initWithCallback:(FloatingHeaderGestureCallback)aCallback {
    self = [self initWithTarget:self action:@selector(executeCallback:)];
    objc_setAssociatedObject(self, @"FL_CONTROL_CALLBACK", aCallback, OBJC_ASSOCIATION_COPY);
    return self;
}

- (void)executeCallback:(id)sender {
    FloatingHeaderGestureCallback tmpCallback = objc_getAssociatedObject(self, @"FL_CONTROL_CALLBACK");
    if (tmpCallback) {
        tmpCallback(self);
    }
}
@end
