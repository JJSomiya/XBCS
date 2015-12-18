//
//  CustomTextField.m
//  mobilely
//
//  Created by Victoria on 15/2/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(id)initWithFrame:(CGRect)frame leftView:(NSString *)leftImage placeholder:(NSString *)placeholder{
    if (self = [super initWithFrame:frame]) {
        if (leftImage) {
            self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImage]];
            self.leftViewMode = UITextFieldViewModeAlways;
        }
        self.placeholder = placeholder;
        self.font = [UIFont systemFontOfSize:17];
        self.borderStyle = UITextBorderStyleNone;
        
        self.layer.borderColor = [UIColor colorWithWhite:0.756 alpha:1.000].CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    [super placeholderRectForBounds:bounds];
    CGRect frame = CGRectMake(self.leftView.frame.size.width + 15, 0, bounds.size.width, bounds.size.height);
    return frame;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    [super textRectForBounds:bounds];
    CGRect frame = CGRectMake(self.leftView.frame.size.width + 15, 0, bounds.size.width, bounds.size.height);
    return frame;
}


-(CGRect)editingRectForBounds:(CGRect)bounds{
    [super editingRectForBounds:bounds];
    CGRect frame = CGRectMake(self.leftView.frame.size.width + 15, 0, bounds.size.width, bounds.size.height);
    return frame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
