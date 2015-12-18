//
//  AppDelegate.m
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Pingpp.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

        //获取token
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_TOKEN object:nil];
    [[RequestManager sharedRequestManager] requestToken];
    
    
    UIStoryboard *storyboardLoginOut = [UIStoryboard storyboardWithName:@"LoginOut" bundle:nil];
    UIViewController *login = [storyboardLoginOut instantiateViewControllerWithIdentifier:@"loginout"];
    self.window.rootViewController = login;
    
    Theme *theme = [Theme new];
    theme.themeType = ThemeTypeGraphical;
    [Theme appleTheme:theme];
    
        //注册总线
    [EMBusManager registerAllBuses];
        //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"4f452b01974a15e843e3ec110745bcc5"];
        //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"4f452b01974a15e843e3ec110745bcc5"];
    
    if ([[GlobalSetting shareGlobalSettingInstance] loginState]) {
        [self showMainVC];
    }
    return YES;
}

- (void)showMainVC {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LHTabBarViewController *tabBarVC = [LHTabBarViewController new];
//    LHTabBarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    tabBarVC.viewControllers = @[
                                      [UINavigationControllerWapper initializeNavigationControllerWithStoryboardID:@"FinancialStatistic" tile:nil bgimageName:[[UIImage imageNamed:@"financialstatistic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"s_financialstatistic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] index:0],
                                      [UINavigationControllerWapper initializeNavigationControllerWithStoryboardID:@"Product" tile:nil bgimageName:[[UIImage imageNamed:@"product"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"s_product"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] index:1],
                                      [UINavigationControllerWapper initializeNavigationControllerWithStoryboardID:@"PersonalCenter" tile:nil bgimageName:[[UIImage imageNamed:@"personalcenter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"s_personalcenter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] index:2]
                                      ];

    [self.window.rootViewController presentViewController:tabBarVC animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

    // iOS 8 及以下请用这个
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Pingpp handleOpenURL:url withCompletion:nil];
}

    // iOS 9 以上请用这个
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [Pingpp handleOpenURL:url withCompletion:nil];
}

#pragma mark ----------------返回数据处理----------------
- (void)didRequestReceiveResponse:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[info valueForKey:kNotificationName] object:nil];
    if ([[info valueForKey:kRespResult] isEqualToString:SUCCESS]) {
        NSDictionary *respData = [info valueForKey:KRESPDATA];
        if ([[respData valueForKey:STATUS] integerValue] == ResponseCodeSuccess) {
                //获取token
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_TOKEN]) {
                [[GlobalSetting shareGlobalSettingInstance] setCsrfToken:[respData valueForKey:KDATA]];
            }
                //登陆成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_LOGIN]) {
                [EMBus callData:[@"appdelegate/AppDelegate/showMainVC" lowercaseString] param:nil, nil];
                if ([respData valueForKey:KDATA]) {
                    [[GlobalSetting shareGlobalSettingInstance] setLoginState:YES];
                    [[GlobalSetting shareGlobalSettingInstance] setUserId:[[[respData valueForKey:KDATA] valueForKey:@"id"] integerValue]];
                    [self showMainVC];
//                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                }
            }

        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
         [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}


@end
