//
//  BallLayer.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "BallLayer.h"
#import <UIKit/UIKit.h>
@interface BallLayer ()

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

@end

@implementation BallLayer

- (void)wavingWithStartAngle:(CGFloat)startAngle andEndAngle:(CGFloat)endAngle {
    self.startAngle = startAngle;
    self.endAngle = endAngle;

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self setNeedsDisplay];
    [CATransaction commit];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    CGContextAddEllipseInRect(ctx, self.bounds);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 34.0/255, 128.0/255, 66.0/255, 1);
    CGContextSetRGBFillColor(ctx, 0.6, 1, 1, 1);
    CGContextFillPath(ctx);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:self.bounds.size.width / 2 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    [path closePath];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetRGBFillColor(ctx, 34.0/255, 128.0/255, 66.0/255, 1);
    CGContextFillPath(ctx);
}

@end
