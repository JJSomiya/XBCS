//
//  UINavigationControllerWapper.m
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "UINavigationControllerWapper.h"
#import "LHTabBarItem.h"
#import "Theme.h"
#import "LHNavigationController.h"

@implementation UINavigationControllerWapper

+ (UINavigationController *)initializeNavigationControllerWithStoryboardID:(NSString *)storyboardID tile:(NSString *)title bgimageName:(UIImage *)imageN  tag:(NSInteger)tag{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardID bundle:nil];
    UINavigationController *navi = [storyboard instantiateViewControllerWithIdentifier:storyboardID.lowercaseString];
    navi.tabBarItem = [[LHTabBarItem alloc] initWithTitle:title image:imageN tag:tag];
    return navi;
}

+ (UINavigationController *)initializeNavigationControllerWithStoryboardID:(NSString *)storyboardID tile:(NSString *)title bgimageName:(UIImage *)image selectedImage:(UIImage *)selectedImage index:(NSInteger)index{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardID bundle:nil];
    LHNavigationController *navi = [[LHNavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:storyboardID.lowercaseString]];
    navi.tabBarItem = [[LHTabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];

    navi.index = index;
    return navi;
}

@end
