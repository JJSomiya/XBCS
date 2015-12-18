//
//  JSGridViewCell.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "JSGridViewCell.h"

@interface JSGridViewCell ()

@end

@implementation JSGridViewCell
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize titleLabel = _titleLabel;

- (instancetype)init
{
    self = [super initWithFrame:CGRectNull];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.000];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = CGRectInset(self.bounds, 1.0f, 1.0f);
    self.contentView.frame = CGRectInset(self.bounds, 1.0f, 1.0f);
    _titleLabel.frame = self.contentView.frame;//CGRectInset(self.bounds, 10.0f, 10.0f);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
