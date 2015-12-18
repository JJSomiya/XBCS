//
//  LHRootViewController.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "LHRootViewController.h"

@interface LHRootViewController ()

@end

@implementation LHRootViewController

#pragma mark ----------------初始化----------------
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initBaseData];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBaseData];
    }
    return self;
}
/**
 * 初始化数据
 */
- (void)initBaseData {
    
}

/**
 *  初始化视图
 */
- (void)initBaseView {
    self.navigationController.navigationBar.translucent = NO; //修改view的原点
    self.view.backgroundColor = RGB_HEX(0xefefef);
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.bgImageView.layer.zPosition = -1;
    [self.view insertSubview:self.bgImageView atIndex:0];
    self.bgImageView.image = [UIImage imageNamed:@"bg.png"];

}

#pragma mark ----------------System----------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
