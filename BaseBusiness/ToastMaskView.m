//
//  ToastMaskView.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ToastMaskView.h"

@implementation ToastMaskView

@synthesize delegate;
@synthesize isHideWhenTouchBackground;

#pragma mark - --------------------退出清空--------------------

- (void)dealloc
{
    delegate = nil;
}

#pragma mark - --------------------初始化--------------------


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
        [self initData];
            //添加模糊蒙层
        self.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        CGRect frame = CGRectMake(0, SCREENHEIGHT * 0.4/2, SCREENWIDTH, SCREENHEIGHT * 0.4);
        [self.blurEffectView setFrame:self.bounds];
//        self.blurEffectView.center = self.center;
        self.blurEffectView.alpha = 0.95;

        [self addSubview:self.blurEffectView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

#pragma mark 初始化数据
- (void)initData
{
    self.isHideWhenTouchBackground = YES;
}

#pragma mark - --------------------System--------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (YES == self.isHideWhenTouchBackground) {
        [self hide];
    }
}
#pragma mark - --------------------接口API--------------------

#pragma mark 隐藏遮罩view
- (void)hide
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(maskView:willRemoveFromSuperView:)]) {
        [self.delegate maskView:self willRemoveFromSuperView:self.superview];
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.layer.opacity = 0.0;
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
