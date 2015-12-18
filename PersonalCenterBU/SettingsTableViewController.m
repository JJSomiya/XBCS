//
//  SettingsTableViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "SettingsTableViewController.h"
static NSInteger notificationCellRows = 3;
@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *changePasswordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *changePhoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *notificationSwitchCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *soundSwitchCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *shakeSwitchCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoutCell;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----------------action methods----------------
- (IBAction)switchValueChanged:(id)sender {
    UISwitch *aSwitch = sender;
    NSInteger tag = aSwitch.tag % 1000;
    if (tag == 0) {
        if (aSwitch.on) {
            notificationCellRows = 3;
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:1], [NSIndexPath indexPathForItem:2 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } else {
            notificationCellRows = 1;
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:1], [NSIndexPath indexPathForItem:2 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];

        }
    }
}


#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return notificationCellRows;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.changePasswordCell;
        } else {
            return self.changePhoneCell;
        }
    }
    if (indexPath.section == 1) {
        if (notificationCellRows > 1) {
            if (indexPath.row == 0) {
                return self.notificationSwitchCell;
            } else if (indexPath.row == 1) {
                return self.soundSwitchCell;
            } else {
                return self.shakeSwitchCell;
            }
        } else {
            return self.notificationSwitchCell;
        }
    }
    if (indexPath.section == 2) {
        return self.logoutCell;
    }
    return nil;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"登出" message:@"您真的要离开了吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //注销
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_LOGOUT object:nil];
            [[RequestManager sharedRequestManager] requestLoginout];
            [SVProgressHUD showWithStatus:@"注销..."];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----------------返回数据处理----------------
- (void)didRequestReceiveResponse:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[info valueForKey:kNotificationName] object:nil];
    if ([[info valueForKey:kRespResult] isEqualToString:SUCCESS]) {
        NSDictionary *respData = [info valueForKey:KRESPDATA];
        if ([[respData valueForKey:STATUS] integerValue] == ResponseCodeSuccess) {
                //注销成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_LOGOUT]) {
                [[GlobalSetting shareGlobalSettingInstance] setLoginState:NO];
                [[GlobalSetting shareGlobalSettingInstance] setPassword:@""];
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
