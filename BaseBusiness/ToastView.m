//
//  ToastView.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ToastView.h"
#import "ToastMaskView.h"

@interface ToastView ()

@property (nonatomic, strong) ToastMaskView *maskView;
@property (nonatomic, strong) NSString *toastMessage;
@property (nonatomic, strong) UILabel *toastLabel;

- (void)forceHide;
@end
static ToastView *toastView;
@implementation ToastView
#pragma mark - --------------------退出清空--------------------

- (void)dealloc
{
    [_maskView removeFromSuperview], _maskView = nil;
}
#pragma mark - --------------------初始化--------------------

+ (ToastView *)sharedToastView {
    if (!toastView) {
        toastView = [[[self class] alloc] init];
    }
    return toastView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 250, 44)];
        [self initData];
        [self initBaseView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initData];
    [self initBaseView];
}

- (void)initData {
    self.toastType = ToastViewTypeDefault;
    self.isHiddenMaskView = NO;
    [self addObserver:self forKeyPath:@"toastType" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_toastLabel) {
        int edge = 10; 
        [_toastLabel setFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(edge, edge, edge, edge))];
    }
}

- (void)initBaseView
{
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(2, 10, 2, 10))];
        [_toastLabel setBackgroundColor:[UIColor clearColor]];
        [_toastLabel setTextAlignment:NSTextAlignmentCenter];
        [_toastLabel setTextColor:[UIColor whiteColor]];
        [_toastLabel setFont:kCTToastTipViewTextFont];
        _toastLabel.numberOfLines = INT_MAX;
    }
    
    [self addSubview:_toastLabel];
    
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:5];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (newWindow) {
        if (_toastLabel) {
            [_toastLabel setText:self.toastMessage];
        }
    }
}

- (void)setIsHiddenMaskView:(BOOL)isHiddenMaskView {
    _isHiddenMaskView = isHiddenMaskView;
    self.maskView.hidden = isHiddenMaskView;
}

#pragma mark ----------------observer----------------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"toastType"]) {
        
    }
}

#pragma mark ----------------功能函数----------------
- (void)showInView:(UIView *)view
{
    if (!_isHiddenMaskView) {
        if (!_maskView) {
            _maskView = [[ToastMaskView alloc] initWithFrame:view.bounds];
        }
        
        [_maskView addSubview:self];
        [self setCenter:CGPointMake(_maskView.bounds.size.width/2.0, _maskView.bounds.size.height/2.0)];
        self.layer.opacity = 0.0;
        [view addSubview:_maskView];
    } else {
        [self setCenter:CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0)];
        self.layer.opacity = 0.0;
        [view addSubview:self];
    }
    
    [self fadeInAnimationAfterDelay:kCTToastTipViewDisplayDuration];
}

- (void)showInView:(UIView *)view WithDisplayTime:(NSTimeInterval)iSecond
{
    if (!_maskView) {
        _maskView = [[ToastMaskView alloc] initWithFrame:view.bounds];
    }
    
    [_maskView addSubview:self];
    
    [self setCenter:CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0)];
    self.layer.opacity = 0.0;
    [view addSubview:_maskView];
    
    [self fadeInAnimationAfterDelay:iSecond];
}

- (void)fadeInAnimationAfterDelay:(NSTimeInterval)delay
{
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [self performSelector:@selector(fadeOutAnimation) withObject:nil afterDelay:kCTToastTipViewDisplayDuration];
    }];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeInAnimation setDuration:kCTToastTipViewFadeinDuration];
    [fadeInAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [fadeInAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    [fadeInAnimation setRemovedOnCompletion:NO];
    [fadeInAnimation setFillMode:kCAFillModeForwards];
    [fadeInAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:fadeInAnimation forKey:@"fadeIn"];
    
    [CATransaction commit];
}

- (void)fadeOutAnimation
{
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [self forceHide];
    }];
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setDuration:kCTToastTipViewFadeoutDuration];
    [fadeOutAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    [fadeOutAnimation setRemovedOnCompletion:NO];
    [fadeOutAnimation setFillMode:kCAFillModeForwards];
    [fadeOutAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:fadeOutAnimation forKey:@"fadeOut"];
    
    [CATransaction commit];
}

- (void)showInView1:(UIView *)view {
    if (!_maskView) {
        _maskView = [[ToastMaskView alloc] initWithFrame:view.bounds];
    }
    
    [_maskView addSubview:self];
    [self setCenter:CGPointMake(_maskView.bounds.size.width/2.0, _maskView.bounds.size.height/2.0)];
    _maskView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [view addSubview:_maskView];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _maskView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

#pragma mark ----------------接口API----------------
#pragma mark 强制消失
- (void)forceHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutAnimation) object:nil];
    
    [self removeFromSuperview];
    [_maskView removeFromSuperview], _maskView = nil;
}

#pragma mark Toast样式提示自定义内容
- (void)showToastViewWithMessage:(NSString *)message inView:(UIView *)view {
    
    if (_maskView) {
        _maskView = nil;
    }
    
    CGSize textSize =  [message boundingRectWithSize:CGSizeMake(250-30, 320) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kCTToastTipViewTextFont} context:nil].size;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.toastLabel.textColor = [UIColor blackColor];
//    if (textSize.height > 80) {
//        int viewHeight = 15 + textSize.height + 15;
//        CGRect toastFrame = toastView.frame;
//        toastFrame.size.height = viewHeight;
//        toastView.frame = toastFrame;
//    }
    CGRect frame = toastView.frame;
    frame.size.width = SCREENWIDTH - 70;
    frame.size.height = 150;
    toastView.frame = frame;
    
    toastView.toastMessage = message;
    [toastView showInView1:view];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
