//
//  UIScrollView+FloatingHeader.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FloatingHeader)  <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *floatingTopHeaderView;
@property (nonatomic, strong) UIView *floatingLeftHeaderView;
@property (nonatomic, strong) UIView *floatingTopLeftCornerView;
@property (nonatomic, strong) NSNumber *isFloatingLeft;
- (void)removeContentOffsetObserver;

@end
