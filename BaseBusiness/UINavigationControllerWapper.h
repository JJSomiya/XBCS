//
//  UINavigationControllerWapper.h
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationControllerWapper : NSObject

+ (UINavigationController *)initializeNavigationControllerWithStoryboardID:(NSString *)storyboardID tile:(NSString *)title bgimageName:(UIImage *)imageN tag:(NSInteger)tag;
+ (UINavigationController *)initializeNavigationControllerWithStoryboardID:(NSString *)storyboardID tile:(NSString *)title bgimageName:(UIImage *)image selectedImage:(UIImage *)selectedImage index:(NSInteger)index;

@end
