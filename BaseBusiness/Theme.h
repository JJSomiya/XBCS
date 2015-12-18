//
//  Theme.h
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ThemeType) {
    ThemeTypeDefault,
    ThemeTypeDark,
    ThemeTypeGraphical
};

@interface Theme : NSObject
//主题类型
@property (nonatomic, assign) ThemeType themeType;
//主题色
@property (nonatomic, strong, readonly) UIColor *mainColor;
//bar类型
@property (nonatomic, assign, readonly) UIBarStyle barStyle;
//导航返回按钮图片
@property (nonatomic, strong, readonly) UIImage *navigationBackgroundImage;
//标签图片
@property (nonatomic, strong, readonly) UIImage *tabBarBackgroundImage;
//背景颜色
@property (nonatomic, strong, readonly) UIColor *backgroundColor;
//主题对应的二级颜色
@property (nonatomic, strong, readonly) UIColor *secondaryColor;

/**
 *  设置主题
 *
 *  @param theme 主题类
 */
+ (void)appleTheme:(Theme *)theme;

@end
