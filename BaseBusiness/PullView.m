//
//  PullView.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PullView.h"

static CGFloat kMaxTop = 200;
static CGFloat kMinTop = 40;

@interface PullView ()
@property (nonatomic, strong) UIImageView *pullImageView;
@property (nonatomic, strong) UIButton *hidenButn;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
static PullView *pullView;
@implementation PullView
#pragma mark ----------------inits----------------
+ (instancetype)sharedPullView {
    if (!pullView) {
        pullView = [[[self class] alloc] init];
    }
    return pullView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, -SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    
}
- (void)initView {
//    self.backgroundColor = [UIColor redColor];
//    [self addSubview:self.hidenButn];
//    [self addSubview:self.pullImageView];
    [self addSubview:self.scrollView];
}

- (UIButton *)hidenButn {
    if (!_hidenButn) {
        _hidenButn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _hidenButn.frame = CGRectMake(SCREENWIDTH - 100, SCREENHEIGHT - 100, 50, 50);
        _hidenButn.backgroundColor = [UIColor greenColor];
        [_hidenButn setTitle:@"隐藏" forState:UIControlStateNormal];
        [_hidenButn addTarget:self action:@selector(hidenButnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hidenButn;
}

- (UIImageView *)pullImageView {
    if (!_pullImageView) {
        _pullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 100, SCREENHEIGHT - 100, 70, 70)];
        _pullImageView.backgroundColor = [UIColor redColor];
    }
    return _pullImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        UIImage *image = [UIImage imageNamed:@"productdetail.jpg"];
        CGFloat scale = image.size.width / SCREENWIDTH;
        CGFloat height = image.size.height / scale;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, height)];
        imageView.image = image;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenButnClicked:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(0, height);
    }
    return _scrollView;
}
#pragma mark ----------------functionality----------------
- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

- (void)hideAnimation {

    CGRect frame = self.frame;
    frame.origin.y = -SCREENHEIGHT;
    if (pullView.hidenPullViewBlock) {
        pullView.hidenPullViewBlock();
    }
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = frame;
    } completion:nil];
}

- (void)showAnimation {
    if (pullView.showPullViewBlock) {
        pullView.showPullViewBlock();
    }
    CGRect frame = self.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = frame;
    } completion:nil];
}

#pragma mark ----------------actions----------------

- (void)hidenButnClicked:(id)sender {
    [self hideAnimation];
}

#pragma mark ----------------APIs----------------
- (void)showPullViewWithObject:(id)object inView:(UIView *)view {
    [pullView showInView:view];
}

- (void)changeTy:(CGFloat)ty {
//    pullView.transform = CGAffineTransformMakeTranslation(0, ty);
    CGRect frame = self.frame;
    frame.origin.y += ty * 0.3;
    self.frame = frame;
}

- (void)changeEnd:(CGFloat)y {
    CGRect frame = self.frame;
    CGFloat fabsVar = fabs(frame.origin.y + SCREENHEIGHT);
    NSLog(@"%f", fabsVar);
    if (fabsVar > kMinTop) {
        [self showAnimation];
    } else {
        [self hideAnimation];
    }
}

- (void)hidenPullView {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
