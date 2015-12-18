//
//  CustomButton.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/4.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.layer.borderColor = RGB(146, 187, 65).CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    [self setTitleColor:RGB_HEX(0x4a4a4a) forState:UIControlStateNormal];
}

- (void)setCustomButntintColor:(UIColor *)tintColor {
    [self setTitleColor:tintColor forState:UIControlStateNormal];
    self.layer.borderColor = RGB_HEX(0x4a4a4a).CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
