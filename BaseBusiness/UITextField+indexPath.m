//
//  UITextField+indexPath.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/14.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "UITextField+indexPath.h"
#import <objc/runtime.h>

static void * IndexPathKey          = &IndexPathKey;
static void * IndexPathContent          = &IndexPathContent;

@implementation UITextField (indexPath)
- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, IndexPathKey);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *indexPath1 = [self indexPath];
    indexPath1 = nil;
    objc_setAssociatedObject(self, IndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

