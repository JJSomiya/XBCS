//
//  CheckBoxView.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "CheckBoxView.h"
#import "UIGestureRecognizer+FloatingHeaderUtil.h"
#import "CheckBoxCell.h"
//static CGFloat const kH = 50;
static CGFloat const kDiff = 20;
static CGFloat const kTopMargin = 35;
@interface CheckBoxView () {
    NSInteger _numberOfItems;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation CheckBoxView
#pragma mark ----------------inits----------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)initViews {
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.bounds.size.width, self.bounds.size.height - kTopMargin)];
    self.backgroundImageView.image = [UIImage imageNamed:@"checkboxbg.png"];
    [self addSubview:self.backgroundImageView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.bounds.size.width, self.bounds.size.height - kTopMargin)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-40, 0, SCREENWIDTH - 100, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.titleLabel.textColor = [UIColor grayColor];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[CheckBoxCell class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.titleLabel.text = [self.dataSource titleForCheckBoxView];

    _numberOfItems = [self.dataSource numberOfItems];
    CGFloat width = self.bounds.size.width / _numberOfItems;
    CGFloat height = self.bounds.size.height - kTopMargin;
    CGFloat x = 0;
    for (int i = 0; i < _numberOfItems; i ++) {
        CheckBoxCell *cell = [self.dataSource checkBoxView:self cellAtIndex:i];
        x = i * width;
        cell.frame = CGRectMake(x, 0, width - 2, height);
        if ([self.delegate respondsToSelector:@selector(checkBoxView:didSelectedAtIndex:)]) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithCallback:^(id sender) {
                [self.delegate checkBoxView:self didSelectedAtIndex:i];
//                if (cell.selected) {
//                    cell.selected = NO;
//                } else {
//                    cell.selected = YES;
//                }
            }];
            cell.gestureRecognizers = @[tap];
        }
        [self.items addObject:cell];
        [self.contentView addSubview:cell];
    }
}

- (CheckBoxCell *)cellAtIndex:(NSInteger)index {
    return [self.items objectAtIndex:index];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
