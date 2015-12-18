//
//  PopView.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/18.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PopView.h"
#import "ToastMaskView.h"

static CGFloat kPopViewWith = 100;
static CGFloat const kMargin = 10;
static CGFloat kCellHeight = 44;
static CGFloat kTopMargin = 15;
static CGFloat kTrangleWidth = 20;

@interface PopView () <UITableViewDataSource, UITableViewDelegate, ToastMaskViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ToastMaskView *maskView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *trangleView;
@property (nonatomic, assign) CGFloat scale;

- (void)forceHide;
@end
static PopView *popView;
@implementation PopView
#pragma mark - --------------------退出清空--------------------
- (void)dealloc
{
    [_maskView removeFromSuperview], _maskView = nil;
}

#pragma mark ----------------inits----------------
+ (PopView *)sharedPopView {
    if (!popView) {
        popView = [[[self class] alloc] init];
    }
    return popView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kPopViewWith, 0);
        [self initBaseData];
        [self initBaseView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBaseData];
    [self initBaseView];
}

- (void)initBaseData {
    
}

- (void)initBaseView {
    [self addSubview:self.tableView];
    [self addSubview:self.trangleView];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (UIView *)trangleView {
    if (!_trangleView) {
        UIBezierPath *tranglePath = [UIBezierPath bezierPath];
        [tranglePath moveToPoint:CGPointMake(kTrangleWidth / 2, 0)];
        [tranglePath addLineToPoint:CGPointMake(0, kTopMargin)];
        [tranglePath addLineToPoint:CGPointMake(kTrangleWidth, kTopMargin)];
        [tranglePath closePath];
        CAShapeLayer *trangleMaskLayer = [CAShapeLayer layer];
        trangleMaskLayer.fillColor = RGB_HEX(0xefefef).CGColor;
        [trangleMaskLayer setPath:tranglePath.CGPath];
        _trangleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTrangleWidth, kTopMargin)];
        [_trangleView.layer addSublayer:trangleMaskLayer];
    }
    return _trangleView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.bounds.size.width, 0) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGB_HEX(0xefefef);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 4;
        _tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        _tableView.layer.shadowOpacity = 0.6;
        _tableView.layer.shadowOffset = CGSizeMake(2, 2);
        _tableView.tableHeaderView = [UIView new];
    }
    return _tableView;
}

#pragma mark ----------------functionality----------------
- (void)showWithAnchor:(CGPoint)anchor inView:(UIView *)view {
    [self setFrameWithAncohr:anchor frame:view.bounds scaleFactor:1];
    
    if (!_maskView) {
        _maskView = [[ToastMaskView alloc] initWithFrame:view.bounds];
    }
    [_maskView addSubview:self];
    
    [view addSubview:_maskView];
    
    [self fadeInAnimationAfterDelay:0];
}

- (void)setFrameWithAncohr:(CGPoint)anchor frame:(CGRect)aFrame scaleFactor:(CGFloat)scale {
    CGRect af = aFrame;
    af.size.width *= scale;
    af.size.height *= scale;
    aFrame = af;
    self.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat height = (kCellHeight * _dataSource.count + kTopMargin) * 1;
    CGRect frame = _trangleView.frame;
    frame.origin.x = anchor.x - kTrangleWidth / 2;
    frame.origin.y = 0;
    _trangleView.frame = frame;
    
    frame = self.frame;
    frame.size.height = height;
    frame.origin.y = anchor.y;
    if (anchor.x > (kPopViewWith / 2 + kMargin) * scale && anchor.x < (aFrame.size.width - (kPopViewWith / 2 + kMargin) * scale)) {
        frame.origin.x = anchor.x - kPopViewWith / 2;
    } else if (anchor.x < ((kPopViewWith / 2 + kMargin) * scale)) {
        frame.origin.x = kMargin * scale;
    } else {
        frame.origin.x = aFrame.size.width - kMargin * scale;
    }
    self.frame = frame;
    
    frame = _tableView.frame;
    frame.size.height = height - kTopMargin;
    frame.size.width = kPopViewWith;
    _tableView.frame = frame;
}

- (void)fadeInAnimationAfterDelay:(NSTimeInterval)delay
{
#warning TODO
    CGFloat height = kCellHeight * _dataSource.count + kTopMargin;
//    CABasicAnimation *
    [UIView animateWithDuration:0.3 delay:delay usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
        _maskView.alpha = 1;
//        self.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (void)fadeOutAnimation
{
//    
//     /* 动画1（在X轴方向移动） */
//    CABasicAnimation *animation1 =
//    [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//        // 终点设定
//    animation1.toValue = [NSNumber numberWithFloat:80];; // 終点
//    /* 动画2（绕Z轴中心旋转） */
//    CABasicAnimation *animation2 =
//    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        // 设定旋转角度
//    animation2.fromValue = [NSNumber numberWithFloat:0.0]; // 开始时的角度
//    animation2.toValue = [NSNumber numberWithFloat:44 * M_PI]; // 结束时的角度
//    /* 动画组 */
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//        // 动画选项设定
//    group.duration = 3.0;
//    group.repeatCount = 1;
//        // 添加动画
//    group.animations = [NSArray arrayWithObjects:animation1, animation2, nil nil];
//    [myView.layer addAnimation:group forKey:@"move-rotate-layer"];
//    
//    [CATransaction begin];
//    
//    [CATransaction setCompletionBlock:^{
//        [self forceHide];
//    }];
//    
//    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    [fadeOutAnimation setDuration:kCTToastTipViewFadeoutDuration];
//    [fadeOutAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
//    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
////    [fadeOutAnimation setRemovedOnCompletion:NO];
////    [fadeOutAnimation setFillMode:kCAFillModeForwards];
//    [fadeOutAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    
//    [self.layer addAnimation:fadeOutAnimation forKey:@"fadeOut"];
//    
//    [CATransaction commit];
}

#pragma mark ----------------ToastMaskViewDelegate----------------
- (void)maskView:(ToastMaskView *)maskView willRemoveFromSuperView:(UIView *)superView {
//    [self fadeOutAnimation];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [[_dataSource objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.backgroundColor = RGB_HEX(0xefefef);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell ;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(filterProductWithDic:)]) {
        [self.delegate filterProductWithDic:[_dataSource objectAtIndex:indexPath.row]];
        [self forceHide];
    }
}

#pragma mark ----------------APIs----------------
#pragma mark 强制消失
- (void)forceHide
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutAnimation) object:nil];
    
    [self removeFromSuperview];
    [_maskView removeFromSuperview], _maskView = nil;
}

- (void)showPopViewWithDataSource:(NSMutableArray *)dataSource atPoint:(CGPoint)point inView:(UIView *)view {
    popView.dataSource = dataSource;
    [popView.tableView reloadData];
    [popView showWithAnchor:point inView:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
