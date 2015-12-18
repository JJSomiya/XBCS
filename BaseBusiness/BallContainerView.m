//
//  BallContainerView.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "BallContainerView.h"
#import "BallLayer.h"
#import "MotionManager.h"

@interface BallContainerView () {
    UIColor *_currentWaterColor;
    
    float _currentLinePointY;
    
    float a;
    float b;
    
    BOOL jia;
    
}
@property (nonatomic, strong) BallLayer *ballLayer;
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@end

@implementation BallContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.angle = 140;
        self.startAngle = ANGLETORADIAN((90 - self.angle/2));
        self.endAngle = ANGLETORADIAN((90 + self.angle/2));
        [self initLayers];

    }
    return self;
}

- (void)initLayers {
    self.backgroundColor = [UIColor whiteColor];
    [[MotionManager sharedInstance] startMotionWithHandler:^(NSDictionary *data) {
        float xTheta = [[data valueForKey:@"xTheta"] floatValue];
        self.startAngle = ANGLETORADIAN((xTheta - self.angle/2));
        self.endAngle = ANGLETORADIAN((xTheta + self.angle/2));
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:25.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self setNeedsDisplay];
        } completion:nil];
    }];
}

-(void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    
    if (a<=1) {
        jia = YES;
    }
    
    if (a>=1.5) {
        jia = NO;
    }
    b+=0.1;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//     Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(self.bounds.size.width / 2 - 150 / 2, self.bounds.size.height / 2 - 150 / 2, 150, 150));
    CGContextSetLineWidth(ctx, 3);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 34.0/255, 128.0/255, 66.0/255, 1);
    CGContextSetRGBFillColor(ctx, 0.6, 1, 1, 1);
    CGContextFillPath(ctx);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:150 / 2 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    [path closePath];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetRGBFillColor(ctx, 34.0/255, 128.0/255, 66.0/255, 1);
    CGContextFillPath(ctx);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGMutablePathRef path = CGPathCreateMutable();
//    
//        //画水
//    CGContextSetLineWidth(context, 1);
//    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
//    
//    float y=_currentLinePointY;
//    CGPathMoveToPoint(path, NULL, 0, y);
//    for(float x=0;x<=SCREENWIDTH;x++){
//        y= a * sin( x/180*M_PI + 8*b/M_PI ) * 10 + _currentLinePointY;
//        CGPathAddLineToPoint(path, nil, x, y);
//    }
//    
//    CGPathAddLineToPoint(path, nil, SCREENWIDTH, rect.size.height);
//    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
//        //CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
//    
//    CGContextAddPath(context, path);
//    CGContextFillPath(context);
//    CGContextDrawPath(context, kCGPathStroke);
//    CGPathRelease(path);
}


@end
