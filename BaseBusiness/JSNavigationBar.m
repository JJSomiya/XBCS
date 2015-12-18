//
//  JSNavigationBar.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "JSNavigationBar.h"
const CGFloat JSNavigationBarHeightIncrease = 38.f;
@implementation JSNavigationBar

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += JSNavigationBarHeightIncrease;
    
    return amendedSize;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
