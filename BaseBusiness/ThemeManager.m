//
//  ThemeManager.m
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ThemeManager.h"
#import "Theme.h"

@implementation ThemeManager

/**
 *  返回当前主题
 *
 *  @return 主题类
 */
+ (Theme *)currentTheme {
    ThemeType themeType = [[[NSUserDefaults standardUserDefaults] valueForKey:SelectedThemeKey] integerValue];
    Theme *theme = [[Theme alloc] init];
    if (themeType) {
        theme.themeType = themeType;
        return theme;
    } else {
        return theme;
    }
}

@end
