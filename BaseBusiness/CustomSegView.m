//
//  CustomSegView.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/16.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "CustomSegView.h"
static CGFloat kCustomSegViewHeight = 44;
static const NSInteger kBaseNumber = 10000;
static CGFloat kSplitLineH = 20;
static CGFloat kSplitLineW = 1;

@interface CustomSegView ()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *butns;
@end

@implementation CustomSegView
#pragma mark ----------------inits----------------
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initViews];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, kCustomSegViewHeight);
        [self initData];
        [self initViews];
    }
    return self;
}

- (void)initData {
    self.showSplitLine = NO;
    self.butns = [NSMutableArray array];
    self.currentIndex = 0;
    self.defaultColor = [UIColor whiteColor];
    self.selectedColor = [UIColor whiteColor];
    self.font = [UIFont boldSystemFontOfSize:17];
}
- (void)initViews {
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, SCREENWIDTH, 0.5)];
    bottomLine.backgroundColor = [UIColor clearColor];
    self.bottomImageView = [UIImageView new];
    [self addSubview:self.bottomImageView];
}

- (void)setShowSplitLine:(BOOL)showSplitLine {
    _showSplitLine = showSplitLine;
    [self updateSplitLines];
}
- (void)setDefaultColor:(UIColor *)defaultColor {
    _defaultColor = defaultColor;
    [self updateTitleColor];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self updateTitleColor];
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self updateTitleColor];
    [self moveBottomImageViewToIndex:currentIndex];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self updateFont];
}
#pragma mark ----------------功能函数----------------
- (void)updateFont {
    if (self.butns.count <= 0)
        return;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *butn = (UIButton *)view;
            butn.titleLabel.font = _font;
        }
    }
}
- (void)updateTitleColor {
    if (_selectedColor == _defaultColor) {
        return;
    }
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *butn = (UIButton *)view;
            [butn setTitleColor:_defaultColor forState:UIControlStateNormal];
        }
    }
    if (self.butns.count <= 0) {
        return;
    }
    UIButton *butn = [self.butns objectAtIndex:self.currentIndex];
    [butn setTitleColor:_selectedColor forState:UIControlStateNormal];

}

- (void)updateSplitLines {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (_showSplitLine) {
        CGFloat width = SCREENWIDTH / [self.items count];
        for (int i = 1; i < self.items.count; i++) {
            UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(i * width - 1, (self.bounds.size.height - kSplitLineH) / 2, kSplitLineW, kSplitLineH)];
            line.backgroundColor = [UIColor grayColor];
            
            [self addSubview:line];
        }
    }
}

- (void)moveBottomImageViewToIndex:(NSInteger)toIndex {
    CGFloat width = SCREENWIDTH / [self.items count];
    CGRect fromFrame = self.bottomImageView.frame;
    CGRect toFrame = fromFrame;
    toFrame.origin.x = width * toIndex;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomImageView.frame = toFrame;
//        self.bottomImageView.transform = CGAffineTransformMakeTranslation(-x, 0);
    } completion:nil];
}
#pragma mark ----------------actions----------------

- (void)customSegViewValueChanged:(id)sender {
    UIButton *butn = sender;
    NSInteger index = butn.tag % kBaseNumber;
    if (self.currentIndex == index) {
        return;
    }
    self.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(customSegView:didChangeItemsAtIndex:)]) {
        [self.delegate customSegView:self didChangeItemsAtIndex:index];
    }
}

#pragma mark ----------------APIs----------------
- (void)setSegViewItems:(NSArray *)items {
    self.items = items;
    CGFloat width = SCREENWIDTH / [items count];
    for (int i = 0; i < [items count]; i++) {
        UIButton *butn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        butn.frame = CGRectMake(i * width, 5, width - 1, self.bounds.size.height - 10);
        [butn setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
        butn.titleLabel.font = _font;
        butn.tag = kBaseNumber + i;
        [butn setTitleColor:_defaultColor forState:UIControlStateNormal];
        [butn addTarget:self action:@selector(customSegViewValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [self.butns addObject:butn];
        [self addSubview:butn];
    }
    self.bottomImageView.frame = CGRectMake(0, self.bounds.size.height - 4, width, 4);
//    self.bottomImageView.backgroundColor = [UIColor redColor];
    self.bottomImageView.image = [UIImage imageNamed:@"segbottomindicator"];
}

- (void)changeSelectedSegIndex:(NSInteger)index {
    self.currentIndex = index;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
