//
//  ChangePasswordViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/27.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *oldPasswordCell;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *freshPasswordCell;
@property (weak, nonatomic) IBOutlet UITextField *freshPasswordTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *conformPasswordCell;
@property (weak, nonatomic) IBOutlet UITextField *conformPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *conformButn;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    UIButton *rightButn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButn.frame = CGRectMake(0, 0, 30, 30);
    rightButn.tag = 10001;
    [rightButn setImage:[UIImage imageNamed:@"openeyes.png"] forState:UIControlStateNormal];
    [rightButn addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButn1.frame = CGRectMake(0, 0, 30, 30);
    rightButn1.tag = 10002;
    [rightButn1 setImage:[UIImage imageNamed:@"openeyes.png"] forState:UIControlStateNormal];
    [rightButn1 addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    self.freshPasswordTF.rightView = rightButn;
    self.freshPasswordTF.rightViewMode = UITextFieldViewModeAlways;
    self.conformPasswordTF.rightView = rightButn1;
    self.conformPasswordTF.rightViewMode = UITextFieldViewModeAlways;
    
//    self.conformButn.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
    self.conformButn.backgroundColor = RGB_HEX(0x4FC1E9);
    [self.conformButn setTintColor:[UIColor whiteColor]];
//    self.conformButn.layer.borderWidth = 1;
    self.conformButn.layer.masksToBounds = YES;
    self.conformButn.layer.cornerRadius = 5;
}

#pragma mark ----------------actions----------------
- (IBAction)conformButnClicked:(id)sender {
    if (self.oldPasswordTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"旧密码为空"];
        return;
    }
    if (![self.conformPasswordTF.text isEqualToString:self.freshPasswordTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入密码不一致！"];
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_CHANGEPASSWORD object:nil];
    [[RequestManager sharedRequestManager] requestChangePasswordWithOldPassword:self.oldPasswordTF.text newPassword:self.freshPasswordTF.text];
}

- (void)showPassword:(id)sender {
    UIButton *butn = sender;
    if (butn.tag % 10000 == 1) {
        if (!self.freshPasswordTF.secureTextEntry) {
            self.freshPasswordTF.secureTextEntry = YES;
            [butn setImage:[UIImage imageNamed:@"openeyes.png"] forState:UIControlStateNormal];
        } else {
            [butn setImage:[UIImage imageNamed:@"closeeyes.png"] forState:UIControlStateNormal];
            self.freshPasswordTF.secureTextEntry = NO;
        }
    }
    if (butn.tag % 10000 == 2) {
        if (!self.conformPasswordTF.secureTextEntry) {
            [butn setImage:[UIImage imageNamed:@"openeyes.png"] forState:UIControlStateNormal];
            self.conformPasswordTF.secureTextEntry = YES;
        } else {
            [butn setImage:[UIImage imageNamed:@"closeeyes.png"] forState:UIControlStateNormal];
            self.conformPasswordTF.secureTextEntry = NO;
        }
    }
}
#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.oldPasswordCell;
    }
    if (indexPath.row == 0) {
        return self.freshPasswordCell;
    }
    return self.conformPasswordCell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
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
                //更换密码
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_CHANGEPASSWORD]) {
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
        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}
@end
