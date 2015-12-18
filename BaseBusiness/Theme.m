//
//  Theme.m
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "Theme.h"

@implementation Theme
- (instancetype)init{
    if (self = [super init]) {
        self.themeType = ThemeTypeDefault;
    }
    
    return self;
}

- (UIColor *)mainColor {
    switch (self.themeType) {
        case ThemeTypeDefault:
            return [UIColor colorWithRed: 87.0/255 green: 188.0/255 blue: 95.0/255 alpha: 1];
            break;
        case ThemeTypeDark:
            return [UIColor colorWithRed: 242.0/255 green: 101.0/255 blue: 34.0/255 alpha:1];
            break;
        case ThemeTypeGraphical:
            return [UIColor colorWithRed: 10.0/255 green: 10.0/255 blue: 10.0/255 alpha: 1];
            break;
    }
}

- (UIBarStyle)barStyle {
    switch (self.themeType) {
        case ThemeTypeDark:
            return UIBarStyleBlack;
            break;
        default:
            return UIBarStyleDefault;
            break;
    }
}

- (UIImage *)navigationBackgroundImage {
    return (self.themeType == ThemeTypeGraphical) ? [UIImage imageNamed:@"navBackground"] : nil;
}

- (UIImage *)tabBarBackgroundImage {
    return (self.themeType == ThemeTypeGraphical) ? [UIImage imageNamed:@"tabBarBackground"] : nil;
}

- (UIColor *)backgroundColor {
    switch (self.themeType) {
        case ThemeTypeDark:
            return [UIColor colorWithWhite:0.9 alpha:1];
            break;
        default:
            return [UIColor colorWithWhite:0.8 alpha:1];
            break;
    }
}

- (UIColor *)secondaryColor {
    switch (self.themeType) {
        case ThemeTypeDefault:
            return [UIColor colorWithRed: 242.0/255 green: 101.0/255 blue: 34.0/255 alpha: 1];
            break;
        case ThemeTypeDark:
            return [UIColor colorWithRed: 34.0/255 green: 128.0/255 blue: 66.0/255 alpha: 1];
            break;
        case ThemeTypeGraphical:
            return [UIColor colorWithRed: 140.0/255 green: 50.0/255 blue: 48.0/255 alpha: 1];
            break;
    }
}

/**
 *  设置主题
 *
 *  @param theme 主题类
 */
+ (void)appleTheme:(Theme *)theme {
    [[NSUserDefaults standardUserDefaults] setValue:@(theme.themeType) forKey:SelectedThemeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[[sharedApplication delegate] window] setTintColor:theme.mainColor];
    }];
    
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setBarStyle:theme.barStyle];
    [[UINavigationBar appearance] setBackgroundImage:theme.navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
    UIImage *image = [UIImage imageNamed:@"backArrow"];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 50, 0, 0);
    [[UINavigationBar appearance] setBackIndicatorImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[image imageWithAlignmentRectInsets:insets]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [UINavigationBar appearance] setba
    
    [[UITabBar appearance] setBarStyle:theme.barStyle];
    [[UITabBar appearance] setBackgroundImage:theme.tabBarBackgroundImage];
    [[UITabBar appearance] setTintColor:[UIColor clearColor]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
//    let controlBackground = UIImage(named: "controlBackground")?.imageWithRenderingMode(.AlwaysTemplate).resizableImageWithCapInsets(UIEdgeInsetsMake(3, 3, 3, 3))
//    let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?.imageWithRenderingMode(.AlwaysTemplate).resizableImageWithCapInsets(UIEdgeInsetsMake(3, 3, 3, 3))
//    UISegmentedControl.appearance().setBackgroundImage(controlBackground, forState: UIControlState.Normal, barMetrics: .Default)
//    UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, forState: UIControlState.Selected, barMetrics: .Default)
//    
//    UIStepper.appearance().setBackgroundImage(controlBackground, forState: .Normal)
//    UIStepper.appearance().setBackgroundImage(controlBackground, forState: .Disabled)
//    UIStepper.appearance().setBackgroundImage(controlBackground, forState: .Highlighted)
//    UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), forState: .Normal)
//    UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), forState: .Normal)
//    
//    UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), forState: .Normal)
//    UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 6)), forState: .Normal)
//    UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?.imageWithRenderingMode(.AlwaysTemplate).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 6, 0, 0)), forState: .Normal)
//    
//    UISwitch.appearance().onTintColor = theme.mainColor.colorWithAlphaComponent(0.3)
//    UISwitch.appearance().thumbTintColor = theme.mainColor
    
//    UIImage *tabIndicator = [[UIImage imageNamed:@"tabBarSelectionIndicator"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIImage *tabResizableIndicator = [tabIndicator resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
//    
//    [[UITabBar appearance] setSelectionIndicatorImage:tabResizableIndicator];
    
//    UIImage *controlBackground = [[[UIImage imageNamed:@"controlBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] resizableImageWithCapInsets:UIEdgeInsetsMake(-3, 3, 3, 3)];
//    UIImage *controlSelectedBackground = [[[UIImage imageNamed:@"controlSelectedBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
//    [[UISegmentedControl appearance] setBackgroundImage:controlBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance] setBackgroundImage:controlSelectedBackground forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

@end
