//
//  CheckBoxCell.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "CheckBoxCell.h"
static CGFloat iconW = 20;
static CGFloat marginL = 5;
static CGFloat inset = 17;
@interface CheckBoxCell ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *checkImageView;
@end
@implementation CheckBoxCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selected = NO;
        self.userInteractionEnabled = YES;
        [self initViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selected = NO;
        self.userInteractionEnabled = YES;
        [self initViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self updateCheckImage];
}

- (void)initViews {
//    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
//    self.backgroundView.userInteractionEnabled = YES;
//    [self addSubview:self.backgroundView];
    [self addSubview:self.checkImageView];
    [self insertSubview:self.imageView atIndex:0];
}

- (UIImageView *)imageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(inset, inset, inset, iconW + marginL))];
//        _backgroundImageView.center = self.center;
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.backgroundColor = [UIColor greenColor];
    }
    return _backgroundImageView;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - iconW - marginL, marginL, iconW, iconW)];
        _checkImageView.image = [UIImage imageNamed:@"checkboxunselected.png"];
        _checkImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _checkImageView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundImageView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(inset, inset, inset, iconW + marginL));
//    self.backgroundImageView.center = self.center;
    self.checkImageView.frame = CGRectMake(self.frame.size.width - iconW - marginL, marginL, iconW, iconW);
}

- (void)updateCheckImage {
    if (!_selected) {
        self.checkImageView.image = [UIImage imageNamed:@"checkboxunselected.png"];
    } else {
        self.checkImageView.image = [UIImage imageNamed:@"checkboxselected.png"];
    }
    [self.layer display];
}

- (void)configCellContentWithDic:(NSDictionary *)dic {
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [dic valueForKey:@"identifier"]]];
    if ([[dic valueForKey:@"selected"] boolValue]) {
        self.selected = YES;
    } else {
        self.selected = NO;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
