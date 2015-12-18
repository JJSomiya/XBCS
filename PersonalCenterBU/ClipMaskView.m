//
//  ClipMaskView.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ClipMaskView.h"

@interface ClipMaskView ()

@property (nonatomic, strong) UIButton *cancelEditButn;
@property (nonatomic, strong) UIButton *editDoneButn;
@property (nonatomic, assign) CGRect clipRec;
@property (nonatomic, assign) BOOL isClipping;
@property (nonatomic, assign) BOOL isMoving;

@end

@implementation ClipMaskView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//        self.layer.opacity = 0.8f;
        self.isClipping = NO;
        self.isMoving = NO;
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        self.layer.opacity = 0.8f;
        self.isClipping = NO;
        self.isMoving = NO;
        [self initView];
    }
    return self;
}

- (void)initView {
    self.cancelEditButn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.cancelEditButn.frame = CGRectMake(SCREENWIDTH/2 - 103, SCREENHEIGHT - 130, 63, 30);
    [self.cancelEditButn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelEditButn addTarget:self action:@selector(cancelEditButnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelEditButn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.cancelEditButn.hidden = YES;
    [self addSubview:self.cancelEditButn];
    
    self.editDoneButn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.editDoneButn.frame = CGRectMake(SCREENWIDTH/2 + 70, SCREENHEIGHT - 130, 63, 30);
    [self.editDoneButn setTitle:@"完成" forState:UIControlStateNormal];
    [self.editDoneButn addTarget:self action:@selector(editDoneButnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.editDoneButn setTintColor:[UIColor greenColor]];
    self.editDoneButn.hidden = YES;
    [self addSubview:self.editDoneButn];
}

- (void)cancelEditButnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelEdit)]) {
        [self.delegate cancelEdit];
    }
}

- (void)editDoneButnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editDone)]) {
        [self.delegate editDone];
    }
}

- (void)startClip {
    self.cancelEditButn.hidden = YES;
    self.editDoneButn.hidden = YES;
    self.isClipping = YES;
}

- (void)endClip {
    self.cancelEditButn.hidden = NO;
    self.editDoneButn.hidden = NO;
    self.isClipping = NO;
}

//- (void)startMove {
//    self.isMoving = YES;
//}
//
//- (void)endMove {
//    self.isMoving = NO;
//}
- (void)setClippingRec:(CGRect)rec {
    self.clipRec = rec;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.isClipping) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 2);
        CGContextAddRect(context, self.clipRec);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokePath(context);

        CGContextClearRect(context, self.clipRec);
        CGContextDrawPath(context, kCGPathFillStroke);//最后一个参数是填充类型
    }
}


@end
