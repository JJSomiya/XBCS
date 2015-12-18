
    //
//  LoginViewController.m
//  LoginOutBU
//
//  Created by Somiya on 15/11/23.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButn;
@property (weak, nonatomic) IBOutlet UIButton *registerButn;
@property (weak, nonatomic) IBOutlet UIImageView *tfBgImageView;

@property (nonatomic, assign) BOOL validAccount;
@property (nonatomic, assign) BOOL validPwd;
@end
static LoginViewController *loginVCInstance = nil;
@implementation LoginViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if (!loginVCInstance) {
            loginVCInstance = self;
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[GlobalSetting shareGlobalSettingInstance] loginAccount]) {
        self.accountTF.text = [[GlobalSetting shareGlobalSettingInstance] loginAccount];
        self.validAccount = YES;
    } else {
        self.accountTF.text = @"";
        self.validAccount = NO;
    }
    if ([[GlobalSetting shareGlobalSettingInstance] password]) {
        self.passwordTF.text = [[GlobalSetting shareGlobalSettingInstance] password];
        self.validPwd = YES;
    } else {
        self.passwordTF.text = @"";
        self.validPwd = NO;
    }
}
#pragma mark ----------------inits----------------
- (void)initBaseData {

}
- (void)initBaseView {
    self.bgImageView.image = nil;
    self.tfBgImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tfBgImageView.layer.borderWidth = 0.5;
    self.tfBgImageView.layer.masksToBounds = YES;
    self.tfBgImageView.layer.cornerRadius = 5;
    
    self.loginButn.layer.masksToBounds = YES;
    self.loginButn.layer.cornerRadius = 5;
}

+ (instancetype)sharedInstance {
    if (!loginVCInstance) {
        loginVCInstance = [[[self class] alloc] init];
    }
    return loginVCInstance;
}
#pragma mark ----------------actions----------------
- (IBAction)fogotPasswordButnClicked:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    [EMBus callData:[@"personalcenter/ChangePhoneNumViewController/changeRestPassword" lowercaseString] param:self, self.accountTF.text, nil];
}
- (IBAction)loginButnClicked:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    if (self.validAccount && self.validPwd) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_LOGIN object:nil];
        [[RequestManager sharedRequestManager] requestLoginWithPhone:self.accountTF.text password:self.passwordTF.text];
        [SVProgressHUD showWithStatus:@"登录..."];
    }
;

}
- (IBAction)registerButnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loginViewController:didClickedRegisterButn:)]) {
        [self.delegate loginViewController:self didClickedRegisterButn:sender];
//        [[RegisterViewController sharedInstance].phoneTF becomeFirstResponder];
    }
}
#pragma mark ----------------UITextFieldDelegate----------------
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.accountTF) {
        if (textField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"用户名不能为空！"];
            return;
        }
        self.validAccount = YES;
    }
    if (textField == self.passwordTF) {
        if (textField.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"密码不能为空！"];
            return;
        }
        self.validPwd = YES;
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
                //登陆成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_LOGIN]) {
                [EMBus callData:[@"appdelegate/AppDelegate/showMainVC" lowercaseString] param:nil, nil];
                if ([respData valueForKey:KDATA]) {
//                    UserObject *user = [MTLJSONAdapter modelOfClass:[UserObject class] fromJSONDictionary:[respData valueForKey:KDATA] error:nil];
//                    user.sex = @"保密";
                    [[GlobalSetting shareGlobalSettingInstance] setLoginAccount:self.accountTF.text];
                    [[GlobalSetting shareGlobalSettingInstance] setPassword:self.passwordTF.text];
                    [[GlobalSetting shareGlobalSettingInstance] setLoginState:YES];
                    [[GlobalSetting shareGlobalSettingInstance] setUserId:[[[respData valueForKey:KDATA] valueForKey:@"id"] integerValue]];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
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
