//
//  WaterballView.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/11/4.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "WaterballView.h"
#define left 20
#define R1 (CGRectGetWidth(self.waveProgressView.frame) / 2) //大半径
#define R2 (CGRectGetWidth(self.waveProgressView.frame) / 2 - 15) //小半径
#define CenterY (CGRectGetMidY(self.waveProgressView.frame))
#define CenterX (CGRectGetMidY(self.waveProgressView.frame))
#define MaxX (CGRectGetMaxX(self.waveProgressView.frame))
#define MaxY (CGRectGetMaxX(self.waveProgressView.frame))
#define LineSection1 20
#define LineSection2 80

@interface WaterballView () {
    NSUInteger currentNum;
}
@property (nonatomic, strong) TYWaveProgressView *waveProgressView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *pointLayer;
@property (nonatomic, strong) CAShapeLayer *pointLayer1;
@property (nonatomic, strong) UILabel *healthLevelLabel;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer1;
@property (nonatomic, strong) UILabel *diagnosticResultLabel; //诊断结果
@end

@implementation WaterballView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    self.waveProgressView = [[TYWaveProgressView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 150)/2, 20, 150, 150)];
    self.waveProgressView.waveViewMargin = UIEdgeInsetsMake(15, 15, 15, 15);
    self.waveProgressView.backgroundImageView.image = [UIImage imageNamed:@"bg_tk_003"];
    self.waveProgressView.numberLabel.font = [UIFont boldSystemFontOfSize:70];
    self.waveProgressView.numberLabel.textColor = [UIColor whiteColor];
    self.waveProgressView.explainLabel.text = @"评分";
    self.waveProgressView.explainLabel.font = [UIFont systemFontOfSize:20];
    self.waveProgressView.explainLabel.textColor = [UIColor whiteColor];
    
    self.waveProgressView.percent = 0.68;
    [self addSubview:self.waveProgressView];
    [self.waveProgressView startWave];
    
    if (_displayLink) {
        [self stopChangeText];
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTextOfNumberLabel:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self drawPoint];
    
}


/**
 *  更换numberlabel的text
 */
- (void)changeTextOfNumberLabel:(CADisplayLink *)displayLink {
    if (currentNum <= self.waveProgressView.percent * 100) {
        self.waveProgressView.numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)currentNum];
        currentNum ++;
        return;
    }
    [self stopChangeText];
}
- (void)stopChangeText{
    [_displayLink invalidate];
    _displayLink = nil;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.waveProgressView.frame;
        self.waveProgressView.transform = CGAffineTransformMakeTranslation(-(frame.origin.x - left), 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _pointLayer.opacity = 1;
            _pointLayer1.opacity = 1;
        } completion:^(BOOL finished) {
            [self drawLine];
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _healthLevelLabel.alpha = 1;
                _diagnosticResultLabel.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];

}

- (void)drawPoint {
    CGPoint center = CGPointMake((left + R1 + R2 + (R1 - R2) / 2), (CenterY - (R1 + (R1 - R2) / 2) / 2));
    UIBezierPath *path_ = [UIBezierPath bezierPathWithArcCenter:center radius:5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _pointLayer = [CAShapeLayer layer];
    [_pointLayer setPath:path_.CGPath];
    _pointLayer.opacity = 0;
    [self.layer addSublayer:_pointLayer];
    [_pointLayer setFillColor:[UIColor greenColor].CGColor];
    
    UIBezierPath *path1_ = [UIBezierPath bezierPathWithArcCenter:CGPointMake(center.x, (CenterY + (R1 + (R1 - R2) / 2) / 2)) radius:5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _pointLayer1 = [CAShapeLayer layer];
    [_pointLayer1 setPath:path1_.CGPath];
    _pointLayer1.opacity = 0;
    [self.layer addSublayer:_pointLayer1];
    [_pointLayer1 setFillColor:[UIColor greenColor].CGColor];
}

- (void)drawLine {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    UIBezierPath *path1 = [[UIBezierPath alloc] init];
    CGPoint center = CGPointMake((left + R1 + R2 + (R1 - R2) / 2) + 5, (CenterY - (R1 + (R1 - R2) / 2) / 2) - 2);
    CGPoint center_ = CGPointMake(center.x, (CenterY + (R1 + (R1 - R2) / 2) / 2) - 2);

    [path moveToPoint:center];
    [path1 moveToPoint:center_];
    
    CGPoint point = CGPointMake(center.x + LineSection1, center.y - LineSection1 * sqrt(3));
    CGPoint point_ = CGPointMake(center.x + 2 * LineSection1, center_.y - 2 *LineSection1 * sqrt(3));
    [path addLineToPoint:point];
    [path1 addLineToPoint:point_];
    
    CGPoint point1 = CGPointMake( center.x + LineSection2, center.y - LineSection1 * sqrt(3));
    CGPoint point1_ = CGPointMake(center.x + LineSection2, center_.y - 2 * LineSection1 * sqrt(3));
    [path addLineToPoint:point1];
    [path1 addLineToPoint:point1_];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = [UIColor greenColor].CGColor;
    lineLayer.fillColor = [UIColor whiteColor].CGColor;
    lineLayer.lineWidth = 2;
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinRound;
    lineLayer.path = path.CGPath;
    lineLayer.strokeStart = 0;
    lineLayer.strokeEnd = 0.001;
    [self.layer addSublayer:lineLayer];
    _lineLayer = lineLayer;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 2;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.path = path1.CGPath;
    layer.strokeStart = 0;
    layer.strokeEnd = 0.001;
    [self.layer addSublayer:layer];
    _lineLayer1 = layer;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _lineLayer1.speed       = 1;
        _lineLayer1.strokeStart = 0.0;
        _lineLayer1.strokeEnd   = 1.0f;
        _lineLayer.speed       = 1;
        _lineLayer.strokeStart = 0.0;
        _lineLayer.strokeEnd   = 1.0f;
    });
        // 给这个layer添加动画效果
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.3;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_lineLayer addAnimation:pathAnimation forKey:nil];
    [_lineLayer1 addAnimation:pathAnimation forKey:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(point1.x + 3, point1.y - 8, 80, 16)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"健康";
    label.textColor = [UIColor greenColor];
    label.alpha = 0;
    [self addSubview:label];
    _healthLevelLabel = label;
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(point1_.x + 3, point1_.y - 8, 80, 100)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"诊断结果：财政状况良好，建议xxxxxxxxxxxxx";
    label1.numberOfLines = 0;
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.textColor = [UIColor colorWithRed:1.000 green:0.444 blue:0.480 alpha:1.000];
    label1.alpha = 0;
    [self addSubview:label1];
    _diagnosticResultLabel = label1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
