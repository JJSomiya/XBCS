//
//  ChangePhoneNumViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/27.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ChangePhoneNumViewController.h"
static NSInteger seconds = 60;
@interface ChangePhoneNumViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneNumCell;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *verifierCodeCell;
@property (weak, nonatomic) IBOutlet UITextField *verifierCodeTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *repeatPasswordCell;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerifierCodeButn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButn;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (nonatomic, assign) NSInteger leftSeconds;

@property (nonatomic, assign) BOOL validPhone;
@property (nonatomic, assign) BOOL validVerifyCode;
@end

@implementation ChangePhoneNumViewController

#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.validPhone = NO;
    [self.phoneNumTF becomeFirstResponder];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------init----------------

- (void)initViews {
//    self.nextStepButn.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    self.nextStepButn.backgroundColor = RGB_HEX(0x4FC1E9);
//    self.nextStepButn.layer.borderWidth = 1;
    self.nextStepButn.layer.masksToBounds = YES;
    self.nextStepButn.layer.cornerRadius = 5;
    
    [self.getVerifierCodeButn setTitleColor:RGB_HEX(0x5EBB33) forState:UIControlStateNormal];
    self.countDownLabel.hidden = YES;
    [self.nextStepButn setTintColor:[UIColor whiteColor]];
    if (self.type == 110) { //重置密码
        [self addNavigationBarItem];
        NSString *regx = @"^[1-9]{11}$";
        NSError* error = NULL;
        NSRegularExpression *regxE = [NSRegularExpression regularExpressionWithPattern:regx options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *arr = [regxE matchesInString:self.phone options:NSMatchingReportCompletion range:NSMakeRange(0, [self.phone length])];
        if (arr.count > 0) {
            if (self.phone) {
                self.phoneNumTF.text = self.phone;
            }
        }
        [self.nextStepButn setTitle:@"重置密码" forState:UIControlStateNormal];
        self.title = @"重置密码";
    } else {
        [self.nextStepButn setTitle:@"修改密码" forState:UIControlStateNormal];
        self.title = @"重置密码";
    }
}

- (void)addNavigationBarItem {
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
    butn.frame = CGRectMake(0, 0, 20, 20);
    [butn setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [butn addTarget:self action:@selector(backButnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:butn];
    left.imageInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark ----------------actions----------------
- (void)backButnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getVerifierCode:(id)sender {
    if (self.phoneNumTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"电话号码不能为空！"];
        return;
    } else {
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_VERIFYPHONE object:nil];
    [[RequestManager sharedRequestManager] requestVerifyPhoneNum:self.phoneNumTF.text];
}

- (IBAction)nextStepButnClicked:(id)sender {
//     [[UIResponder currentFirstResponder] resignFirstResponder];
    if (self.verifierCodeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
        return;
    } else {
        self.validVerifyCode = YES;
    }
    
    if (self.type == 110) {
        if (self.passwordTF.text.length > 0 || self.repeatPasswordTF.text.length >0) {
            if (self.validVerifyCode) {
                if ([self.passwordTF.text isEqualToString:self.repeatPasswordTF.text]) {
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_RESETPASSWORD object:nil];
                    [[RequestManager sharedRequestManager] requestRestPasswordWithPhone:self.phoneNumTF.text code:self.verifierCodeTF.text password:self.passwordTF.text];
//                    [self startAnimation];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"两次密码输入不一致！"];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:@"请检查验证码！"];
            }
            
        } else {
            [SVProgressHUD showInfoWithStatus:@"密码不能为空！"];
        }
        return;
    }
    
    if (self.validPhone) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_CHANGEPHONE object:nil];
        [[RequestManager sharedRequestManager] requestChangePhoneWith:self.phoneNumTF.text verifyCode:self.verifierCodeTF.text];
    }
}

-(void)updateSeconds {
    self.leftSeconds --;
    self.countDownLabel.text = [NSString stringWithFormat:@"(%ld)s", (long)self.leftSeconds];
    if (self.leftSeconds == 0) {
        self.countDownLabel.hidden = YES;
        self.getVerifierCodeButn.hidden = NO;
        [self stopAnimation];
    }
}


- (void)startAnimation{
//    self.beginTime = CACurrentMediaTime();
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSeconds)];
    self.displayLink.paused = YES;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.frameInterval = 60;
    
    self.leftSeconds = seconds;
    self.displayLink.paused = NO;
    self.countDownLabel.hidden = NO;
    self.getVerifierCodeButn.hidden = YES;
    self.countDownLabel.text = [NSString stringWithFormat:@"(%ld)s", (long)seconds];
}
- (void)stopAnimation{
    self.getVerifierCodeButn.hidden = NO;
    self.countDownLabel.hidden = YES;
    [self.getVerifierCodeButn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}
#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 110) {
        return 4;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.phoneNumCell;
    }
    if (indexPath.row == 1) {
        return self.verifierCodeCell;
    }
    if (indexPath.row == 2) {
        return self.passwordCell;
    }
    return self.repeatPasswordCell;
}
#pragma mark -
#pragma mark - UITableViewDelegate

//#pragma mark ----------------UITextFieldDelegate----------------
//- (BOOL)textFieldShouldClear:(UITextField *)textField {
//    if (textField == self.phoneNumTF) {
//        self.validPhone = NO;
//        self.getVerifierCodeButn.hidden = NO;
//        self.countDownLabel.hidden = YES;
//        [self.getVerifierCodeButn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
//    return YES;
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == self.phoneNumTF) {
//        self.validPhone = NO;
//        self.getVerifierCodeButn.hidden = YES;
//        [self.getVerifierCodeButn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
//    return YES;
//}
//
//
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == self.phoneNumTF) {
//        if (self.phoneNumTF.text.length == 0) {
//            self.validPhone = NO;
////            self.getVerifierCodeButn.enabled = NO;
//            [self.getVerifierCodeButn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [SVProgressHUD showInfoWithStatus:@"电话号码不能为空！"];
//            return;
//        }
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_VERIFYPHONE object:nil];
//        [[RequestManager sharedRequestManager] requestVerifyPhoneNum:self.phoneNumTF.text];
//        return;
//    }
//
//    if (textField == self.verifierCodeTF) {
//        if (self.verifierCodeTF.text.length > 0) {
//            self.validVerifyCode = YES;
//        } else {
//            [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
//            self.validVerifyCode = NO;
//        }
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark ----------------返回数据处理----------------
- (void)didRequestReceiveResponse:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[info valueForKey:kNotificationName] object:nil];
    if ([[info valueForKey:kRespResult] isEqualToString:SUCCESS]) {
        NSDictionary *respData = [info valueForKey:KRESPDATA];
        if ([[respData valueForKey:STATUS] integerValue] == ResponseCodeSuccess) {
                //更换手机号
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_CHANGEPHONE]) {
                [SVProgressHUD showSuccessWithStatus:@"已更换，请重新登录！"];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_LOGOUT object:nil];
                [[RequestManager sharedRequestManager] requestLoginout];
                [SVProgressHUD showWithStatus:@"注销..."];
            }
            
                //注销成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_LOGOUT]) {
                [[GlobalSetting shareGlobalSettingInstance] setLoginState:NO];
//                [[GlobalSetting shareGlobalSettingInstance] setUserId:0];
                [[GlobalSetting shareGlobalSettingInstance] setPassword:@""];
//                [[GlobalSetting shareGlobalSettingInstance] setLoginAccount:@""];
                [self dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD showSuccessWithStatus:@"注销成功"];
            }
                //获取验证码
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_GETVERIFYCODE]) {
                
            }
                //电话号码验证 flag=0 尚未注册   flag=1 已注册
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_VERIFYPHONE]) {
                if (self.type == 110) {
                    if ([[[respData valueForKey:KDATA] valueForKey:@"flag"] boolValue]) {
                        self.validPhone = YES;
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_GETVERIFYCODE object:nil];
                        [[RequestManager sharedRequestManager] requestVerifyCodeWithPhone:self.phoneNumTF.text];
                        [self startAnimation];
                    } else {
                        self.validPhone = NO;
                            //                self.getVerifierCodeButn.enabled = NO;
                        [self.getVerifierCodeButn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        [SVProgressHUD showSuccessWithStatus:@"电话号码尚未注册！"];
                    }
                    return;
                }
                if (![[[respData valueForKey:KDATA] valueForKey:@"flag"] boolValue]) {
                    self.validPhone = YES;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_GETVERIFYCODE object:nil];
                    [[RequestManager sharedRequestManager] requestVerifyCodeWithPhone:self.phoneNumTF.text];
                    [self startAnimation];
                } else {
                    self.validPhone = NO;
                        //                self.getVerifierCodeButn.enabled = NO;
                    [self.getVerifierCodeButn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [SVProgressHUD showSuccessWithStatus:@"电话号码已注册！"];
                }
            }
                //重置密码
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_RESETPASSWORD]) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD showSuccessWithStatus:@"密码已重置！"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}

@end
