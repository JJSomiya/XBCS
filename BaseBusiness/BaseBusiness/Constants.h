//
//  Constants.h
//  BaseBusiness
//
//  Created by Somiya on 15/10/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


/** 色值 RGBA **/
#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]

/** 色值 RGB **/
#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)

    //系统版本判断
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

    //width
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
    //height
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#ifndef DEBUG
//#undef NSLog
//#define NSLog(args, ...)
//#endif
#define ANGLETORADIAN(angle) (angle * M_PI / 180)
#define SelectedThemeKey @"SelectedTheme"


#endif /* Constants_h */
