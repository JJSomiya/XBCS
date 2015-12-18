//
//  LoginOutViewController.m
//  LoginOutBU
//
//  Created by Somiya on 15/11/25.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "LoginOutViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginOutViewController () <LoginViewControllerDelegate, RegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *registerView;

@end

@implementation LoginOutViewController
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.registerView.transform = CGAffineTransformMakeTranslation(SCREENWIDTH, 0);
    [LoginViewController sharedInstance].delegate = self;
    [RegisterViewController sharedInstance].delegate = self;
}

#pragma mark ----------------inits----------------
- (void)initBaseData {
    
}

- (void)initBaseView {
    [super initBaseView];
    self.bgImageView.image = [UIImage imageNamed:@"loginbg.png"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

#pragma mark ----------------actions----------------
- (void)handleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [[UIResponder currentFirstResponder] resignFirstResponder];
}
#pragma mark ----------------LoginViewControllerDelegate----------------
    //显示注册界面
- (void)loginViewController:(LoginViewController *)loginVC didClickedRegisterButn:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //        self.registerView.hidden = NO;
        CGRect frame = self.loginView.frame;
        frame.origin.x = -SCREENWIDTH;
        self.loginView.frame = frame;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.01 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //        self.registerView.hidden = NO;
        CGRect frame = self.registerView.frame;
        frame.origin.x = 0;
        self.registerView.frame = frame;
    } completion:nil];
}
#pragma mark ----------------RegisterViewControllerDelegate----------------
    //显示登录界面
- (void)registerViewController:(RegisterViewController *)registerVC didClickedLoginButn:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //        self.registerView.hidden = NO;
        CGRect frame = self.registerView.frame;
        frame.origin.x = SCREENWIDTH;
        self.registerView.frame = frame;
        
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.01 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //        self.registerView.hidden = NO;
        CGRect frame = self.loginView.frame;
        frame.origin.x = 0;
        self.loginView.frame = frame;
        
    } completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
