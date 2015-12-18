//
//  LHTabBarItem.m
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/21.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "LHTabBarItem.h"

@implementation LHTabBarItem
#pragma mark ----------------init----------------
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag {
    if (self = [super initWithTitle:title image:image tag:tag]) {
        [self initData];
        [self initView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    if (self = [super initWithTitle:title image:image selectedImage:selectedImage]) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    
}

- (void)select:(id)sender {
    [super select:sender];
}

- (void)initView {
//    NSDictionary * attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
//    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    [self setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    [self setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
}

@end
