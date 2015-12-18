//
//  ToastMaskView.h
//  BaseBusiness
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ToastMaskView;

/**
 *  遮罩层类委托
 */
@protocol ToastMaskViewDelegate <NSObject>

@optional
- (void)maskView:(ToastMaskView *)maskView willRemoveFromSuperView:(UIView *)superView;

@end
/**
 *  全屏遮罩类
 */
@interface ToastMaskView : UIView
@property (nonatomic, weak) id<ToastMaskViewDelegate> delegate;
    //点击背景时是否消失
@property (nonatomic, assign) BOOL isHideWhenTouchBackground;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
/**
 *  隐藏遮罩层
 */
- (void)hide;
@end
