//
//  PullView.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHRootView.h"
@interface PullView : LHRootView
+ (instancetype)sharedPullView;
@property (nonatomic, copy) void (^hidenPullViewBlock)(void);
@property (nonatomic, copy) void (^showPullViewBlock)(void);

- (void)showPullViewWithObject:(id)object inView:(UIView *)view;
- (void)changeTy:(CGFloat)ty;
- (void)changeEnd:(CGFloat)y;
- (void)hidenPullView;
@end
