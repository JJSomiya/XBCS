//
//  JSTextView.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/21.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "JSTextView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface JSTextView () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *promptImageView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *limitNumLabel;

@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, strong) NSString *promptStr;
@property (nonatomic, strong) UIImage *promptImage;

@end

@implementation JSTextView

#pragma mark ----------------dealloc----------------
- (void)dealloc {
}

#pragma mark ----------------init----------------
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initData];
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    _promptImage = nil;
    _promptStr = @"请填写反馈内容...";
    _limitNum = 300;
}

- (void)initView {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, 100, 17)];
    }
    _promptLabel.text = _promptStr;
    _promptLabel.font = _textView.font;
    [_promptLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:_promptLabel];
    
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [self addSubview:_textView];
            //添加约束
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-15]];
    }
    
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:15];
    
    
    if (!_limitNumLabel) {
        _limitNumLabel = [[UILabel alloc] init];
        [self addSubview:_limitNumLabel];
            //添加约束
        _limitNumLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_limitNumLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_limitNumLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_limitNumLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_limitNumLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-15]];
    }
    
    _limitNumLabel.text = [NSString stringWithFormat:@"%lu个", (long)_limitNum];
    _limitNumLabel.textAlignment = NSTextAlignmentRight;
    _limitNumLabel.textColor = [UIColor colorWithWhite:0.574 alpha:0.900];
    _limitNumLabel.font = [UIFont systemFontOfSize:14];
}
#pragma mark ----------------功能函数----------------

#pragma mark ----------------delegate/kvo----------------
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _promptLabel.hidden = NO;
    } else {
        _promptLabel.hidden = YES;
    }
    
    if (textView.text.length > _limitNum) {
        _textView.text = [textView.text substringToIndex:_limitNum];
        _limitNumLabel.text = @"0个";
        return;
    }
    _limitNumLabel.text = [NSString stringWithFormat:@"%lu个", _limitNum - textView.text.length];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//        //待优化
//    if (textView.text.length == 0) {
//        _promptLabel.hidden = NO;
//    } else {
//        _promptLabel.hidden = YES;
//    }
//
//    if (textView.text.length > _limitNum) {
//        _textView.text = [textView.text substringToIndex:_limitNum];
//        _limitNumLabel.text = @"0个";
//        return NO;
//    }
//    _limitNumLabel.text = [NSString stringWithFormat:@"%lu个", _limitNum - textView.text.length];
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            [SVProgressHUD showInfoWithStatus:@"暂不支持emoji表情！"];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self resignFirstResponder];
    return YES;
}


#pragma mark ----------------API----------------
- (NSString *)content {
    return self.textView.text;
}
/**
 *  初始化自定义的textView
 *
 *  @param frame           frame
 *  @param prompt          提示语
 *  @param leftImage       左边的提示图片
 *  @param limitCharacters 限制字数
 *
 *  @return 返回自定义的textView
 */
+ (JSTextView *)textViewWithFrame:(CGRect)frame prompt:(NSString *)prompt leftImage:(UIImage *)leftImage andLimitCharacters:(NSInteger)limitCharacters {
    
    return nil;
}
/**
 *  初始化自定义的textView
 *
 *  @param frame           frame
 *  @param prompt          提示语
 *  @param limitCharacters 限制字数
 *
 *  @return 返回自定义的textView
 */
+ (JSTextView *)textViewWithFrame:(CGRect)frame prompt:(NSString *)prompt andLimitCharacters:(NSInteger)limitCharacters {
    
    JSTextView *customTextView = [[JSTextView alloc] initWithFrame:frame];
    customTextView.limitNum = limitCharacters;
    customTextView.promptStr = prompt;
    return customTextView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
