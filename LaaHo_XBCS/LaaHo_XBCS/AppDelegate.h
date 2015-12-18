//
//  AppDelegate.h
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarVC;

- (void)showMainVC;
@end

