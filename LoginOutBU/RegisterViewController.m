//
//  RegisterViewController.m
//  LoginOutBU
//
//  Created by Somiya on 15/11/25.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
static NSInteger seconds = 30;
@interface RegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageVIew;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordTF;
@property (weak, nonatomic) IBOutlet CustomTextField *verifyCode;
@property (weak, nonatomic) IBOutlet CustomTextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyButn;
@property (weak, nonatomic) IBOutlet UIButton *xieyiButn;
@property (weak, nonatomic) IBOutlet UIButton *registerButn;
@property (weak, nonatomic) IBOutlet UIButton *checkButn;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL validPassword;
@property (nonatomic, assign) BOOL validVerifyCode;
@property (nonatomic, assign) BOOL validPhone;

@end
static RegisterViewController *registerVCInstance = nil;
@implementation RegisterViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if (!registerVCInstance) {
            registerVCInstance = self;
        }
    }
    return self;
}
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)sharedInstance {
    if (!registerVCInstance) {
        registerVCInstance = [[[self class] alloc] init];
    }
    return registerVCInstance;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.countDownLabel) {
        self.countDownLabel = [[UILabel alloc] initWithFrame:self.verifyButn.frame];
        [self.view addSubview:self.countDownLabel];
    }
    self.countDownLabel.hidden = YES;
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    self.countDownLabel.textColor = [UIColor lightGrayColor];
    self.countDownLabel.font = [UIFont boldSystemFontOfSize:17];
    self.countDownLabel.text = [NSString stringWithFormat:@"获取验证码(%ld)", (long)seconds];
}



#pragma mark ----------------inits----------------
- (void)initBaseData {
    self.validPassword = NO;
    self.validPhone = NO;
    self.validVerifyCode = NO;
}

- (void)initBaseView {
    self.bgImageView.image = nil;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 32)];
//    label.backgroundColor = [UIColor lightGrayColor];
//    self.verifyCode.rightView = label;
//    self.verifyCode.rightViewMode = UITextFieldViewModeAlways;
    self.verifyButn.layer.masksToBounds = YES;
    self.verifyButn.layer.cornerRadius = 4;
    
    self.bgImageVIew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgImageVIew.layer.borderWidth = 0.5;
    self.bgImageVIew.layer.masksToBounds = YES;
    self.bgImageVIew.layer.cornerRadius = 5;
    
    self.registerButn.layer.masksToBounds = YES;
    self.registerButn.layer.cornerRadius = 5;
    
    NSDictionary *attributeDic = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSUnderlineColorAttributeName:[UIColor blackColor]};
    NSString *str = self.xieyiButn.titleLabel.text;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttributes:attributeDic range:NSMakeRange(6, 10)];
    self.xieyiButn.titleLabel.attributedText = attributeStr;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    if (!self.validPhone) {
        self.verifyButn.enabled = NO;
        self.countDownLabel.hidden = YES;
        [self.verifyButn setBackgroundColor:[UIColor lightGrayColor]];
        [self.verifyButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    self.registerButn.enabled = NO;
    [self.registerButn setBackgroundColor:[UIColor lightGrayColor]];
    [self.registerButn setTintColor:[UIColor grayColor]];
    self.checkButn.selected = NO;
    if (!self.checkButn.selected) {
        [self.checkButn setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
}
#pragma mark ----------------functionality----------------
- (void)timerHandle:(NSTimer *)timer {
    self.countDown --;
    self.countDownLabel.text = [NSString stringWithFormat:@"获取验证码(%ld)", (long)self.countDown];
    if (self.countDown == 0) {
        self.countDownLabel.hidden = YES;
        self.verifyButn.hidden = NO;
        [self.timer invalidate];
    }
}

#pragma mark ----------------actions----------------
- (IBAction)getVerifyCodeButnClicked:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    if (self.validPhone) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_GETVERIFYCODE object:nil];
        [[RequestManager sharedRequestManager] requestVerifyCodeWithPhone:self.phoneTF.text];
        self.countDown = seconds;
        self.countDownLabel.hidden = NO;
        self.verifyButn.hidden = YES;
        self.countDownLabel.text = [NSString stringWithFormat:@"获取验证码(%ld)", (long)seconds];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerHandle:) userInfo:nil repeats:YES];
    }
}

- (IBAction)checkButnClicked:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    if (self.checkButn.selected) {
        [self.checkButn setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        self.checkButn.selected = NO;
        self.registerButn.enabled = NO;
        [self.registerButn setBackgroundColor:[UIColor lightGrayColor]];
        [self.registerButn setTintColor:[UIColor grayColor]];
    } else {
        [self.checkButn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        self.checkButn.selected = YES;
        self.registerButn.enabled = YES;
        [self.registerButn setBackgroundColor:RGB_HEX(0x4FC1E9)];
        [self.registerButn setTintColor:[UIColor whiteColor]];
    }
}
- (IBAction)checkXieyiButnClicked:(id)sender {
    
}

- (IBAction)registerButnClicked:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    if (self.validPhone && self.validPassword && self.validVerifyCode) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_REGISTER object:nil];
        [[RequestManager sharedRequestManager] registerAccountWithPhone:self.phoneTF.text password:self.passwordTF.text code:self.verifyCode.text];
    }
}

- (IBAction)quickLoginButnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registerViewController:didClickedLoginButn:)]) {
        [self.delegate registerViewController:self didClickedLoginButn:sender];
//        [[LoginViewController sharedInstance].accountTF becomeFirstResponder];
    }
}

#pragma mark ----------------UITextFieldDelegate----------------
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.phoneTF) {
        self.validPhone = NO;
        self.verifyButn.enabled = YES;
        [self.verifyButn setBackgroundColor:[UIColor lightGrayColor]];
        [self.verifyButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTF) {
        self.validPhone = NO;
        self.verifyButn.enabled = NO;
        [self.verifyButn setBackgroundColor:[UIColor lightGrayColor]];
        [self.verifyButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.phoneTF) {
        if (self.phoneTF.text.length == 0) {
            self.validPhone = NO;
            self.verifyButn.enabled = NO;
            [self.verifyButn setBackgroundColor:[UIColor lightGrayColor]];
            [self.verifyButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [SVProgressHUD showInfoWithStatus:@"电话号码不能为空！"];
            return;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_VERIFYPHONE object:nil];
        [[RequestManager sharedRequestManager] requestVerifyPhoneNum:self.phoneTF.text];
        return;
        
    }
    if (textField == self.confirmPasswordTF) {
        if ([self.confirmPasswordTF.text isEqualToString:self.passwordTF.text] && self.confirmPasswordTF.text.length > 0) {
            self.validPassword = YES;
        } else {
            if (self.confirmPasswordTF.text.length == 0) {
                 [SVProgressHUD showInfoWithStatus:@"密码不能为空！"];
                return;
            }
            [SVProgressHUD showInfoWithStatus:@"密码输入不一致！"];
            self.validPassword = NO;
        }
    }
    if (textField == self.verifyCode) {
        if (self.verifyCode.text.length > 0) {
            self.validVerifyCode = YES;
        } else {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
            self.validVerifyCode = NO;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark ----------------返回数据处理----------------
- (void)didRequestReceiveResponse:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[info valueForKey:kNotificationName] object:nil];
    if ([[info valueForKey:kRespResult] isEqualToString:SUCCESS]) {
        NSDictionary *respData = [info valueForKey:KRESPDATA];
        if ([[respData valueForKey:STATUS] integerValue] == ResponseCodeSuccess) {
                //获取验证码
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_GETVERIFYCODE]) {
                
            }
                //注册
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_REGISTER]) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功，快去登录吧！"];
            }
                //电话号码验证 flag=0 尚未注册   flag=1 已注册
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_VERIFYPHONE]) {
                if (![[[respData valueForKey:KDATA] valueForKey:@"flag"] boolValue]) {
                    self.validPhone = YES;
                    self.verifyButn.enabled = YES;
                    [self.verifyButn setBackgroundColor:RGB_HEX(0x80c269)];
                    [self.verifyButn setTitleColor:RGB_HEX(0xffffff) forState:UIControlStateNormal];
                } else {
                    self.validPhone = NO;
                    self.verifyButn.enabled = NO;
                    [self.verifyButn setBackgroundColor:[UIColor lightGrayColor]];
                    [self.verifyButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [SVProgressHUD showSuccessWithStatus:@"电话号码已注册！"];
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
