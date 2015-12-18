//
//  ThemeManager.h
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Theme;

@interface ThemeManager : NSObject

/**
 *  返回当前主题
 *
 *  @return 主题类
 */
+ (Theme *)currentTheme;

@end
