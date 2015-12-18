//
//  PayResultViewController.m
//  ProductBU
//
//  Created by Somiya on 15/12/15.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PayResultViewController.h"
static NSInteger seconds = 5;
@interface PayResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *jumpMyOrderButn;

@property (nonatomic, assign) NSInteger leftSeconds;
@end
@implementation PayResultViewController
#pragma mark ----------------System----------------

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark ----------------init----------------
/**
 * 初始化数据
 */
- (void)initBaseData {
    self.leftSeconds = seconds;
}

/**
 *  初始化视图
 */
- (void)initBaseView {
    [super initBaseView];
    
    [self addLeftBarButn];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if (self.result == 1) {//支付成功
        self.resultImageView.image = [UIImage imageNamed:@"paysuccess.png"];
        self.desLabel.text = @"您的订单已完成，我们会尽快与您取得联系！";
        self.bgImageView.image = [UIImage imageNamed:@"paysuccessbg.png"];
    } else { //支付失败
        self.resultImageView.image = [UIImage imageNamed:@"payfailed.png"];
        self.desLabel.text = @"您的订单支付失败，请前往我的订单继续支付！";
        self.bgImageView.image = nil;
        self.view.backgroundColor = RGB_HEX(0xeaeaea);
    }
    self.jumpMyOrderButn.layer.masksToBounds = YES;
    self.jumpMyOrderButn.layer.cornerRadius = 5;
    self.jumpMyOrderButn.layer.borderWidth = 1;
    
    self.countDownLabel.text = [NSString stringWithFormat:@"%ld秒后自动跳转产品详情页", (long)self.leftSeconds];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandle:) userInfo:nil repeats:YES];
}

- (void)addLeftBarButn {
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    butn.frame = CGRectMake(0, 0, 20, 20);
    [butn setImage:[[UIImage imageNamed:@"product"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [butn addTarget:self action:@selector(backServicesPage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:butn];
    self.navigationItem.leftBarButtonItem = left;
}
#pragma mark ----------------functionality----------------
- (IBAction)jumpMyOrderButnClicked:(id)sender {
    [self performSelector:@selector(jumpToMyOrder)];
}

- (void)jumpToMyOrder {
    LHNavigationController *navi = (LHNavigationController *)[[self.tabBarController viewControllers] objectAtIndex:2];
    UIViewController *vc = [[navi viewControllers] objectAtIndex:0];//navi.rootViewController;//
    [self.tabBarController setSelectedViewController:navi];
    [EMBus callData:[@"personalcenter/MyOrdersViewController/showMyOrders" lowercaseString] param:vc, nil];
    
    [self backServicesPage:nil];

}

- (void)timerHandle:(NSTimer *)timer {
    if (self.leftSeconds > 0) {
        self.leftSeconds --;
        self.countDownLabel.text = [NSString stringWithFormat:@"%ld秒后自动跳转产品详情页", (long)self.leftSeconds];
    } else {
        [timer invalidate];
            //跳转
        [self performSelector:@selector(jumpToMyOrder)];
    }
}

- (void)backServicesPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
