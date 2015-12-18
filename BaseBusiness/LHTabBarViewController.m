//
//  LHTabBarViewController.m
//  LaaHo_XBCS
//
//  Created by Somiya on 15/11/27.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#define kItemWidth (SCREENWIDTH / 3)
#define kBGWidth (SCREENWIDTH * 4 / 15)

#define kDiff (kItemWidth - kBGWidth)/2
#define kTopMargin -4
#define kItemHeight 53

#import "LHTabBarViewController.h"
#import "LHNavigationController.h"

@interface LHTabBarViewController () <UITabBarControllerDelegate, UITabBarDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation LHTabBarViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDiff, kTopMargin, kBGWidth, kItemHeight)];
    self.bgImageView.image = [UIImage imageNamed:@"tabselectedbg"];
    self.bgImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgImageView.layer.shadowOffset = CGSizeMake(2, -2);
    [self.tabBar addSubview:self.bgImageView];
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.tabBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController {
    [super setSelectedViewController:selectedViewController];
    LHNavigationController *navi = (LHNavigationController *)selectedViewController;
    CGRect frame = self.bgImageView.frame;
    frame.origin.x = navi.index * kItemWidth + kDiff;
    [self moveAnimationWithFrame:frame];
}

#pragma mark ----------------UITabBarControllerDelegate----------------
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    LHNavigationController *navi = (LHNavigationController *)viewController;
//    CGRect frame = self.bgImageView.frame;
//    frame.origin.x = navi.index * kItemWidth + kDiff;
//    [self moveAnimationWithFrame:frame];
    return YES;
}

#warning TODO 可以优化动画视觉效果
- (void)moveAnimationWithFrame:(CGRect)frame {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgImageView.frame = frame;
    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
