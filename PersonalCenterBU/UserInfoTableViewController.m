//
//  UserInfoTableViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/22.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "UserInfoTableViewController.h"

@interface UserInfoTableViewController () <UIPickerViewDelegate,  UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *headerImageCell;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *userNameCell;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;

@property (weak, nonatomic) IBOutlet UITableViewCell *companyNameCell;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;

@property (weak, nonatomic) IBOutlet UITableViewCell *companyAddressCell;
@property (weak, nonatomic) IBOutlet UITextField *companyAddresstTF;

@property (weak, nonatomic) IBOutlet UITableViewCell *linkManCell;
@property (weak, nonatomic) IBOutlet UITextField *linkManTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *contactCell;
@property (weak, nonatomic) IBOutlet UITextField *contactTF;

@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation UserInfoTableViewController
#pragma mark ----------------dealloc----------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 30;
    self.headerImageView.layer.borderWidth = 3;
    self.headerImageView.layer.borderColor =  [UIColor colorWithWhite:0.569 alpha:1.000].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmRegionInfo:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
        UIBarButtonItem *flexibleSpaceBarButn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIButton *butnYes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [butnYes setTitle:@"确定" forState:UIControlStateNormal];
        [butnYes setFrame:CGRectMake(0, 0, 50, 44)];
        [butnYes addTarget:self action:@selector(confirmRegionInfo:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *butnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [butnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [butnCancel setFrame:CGRectMake(0, 0, 50, 44)];
        [butnCancel addTarget:self action:@selector(cancelSetRegionInfo:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButnYes = [[UIBarButtonItem alloc] initWithCustomView:butnYes];
        UIBarButtonItem *barButnCancel = [[UIBarButtonItem alloc] initWithCustomView:butnCancel];
        
        _toolBar.items = @[barButnCancel, flexibleSpaceBarButn, barButnYes];
        _toolBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _toolBar.barStyle = UIBarStyleDefault;
        
    }
    return _toolBar;
}
#pragma mark ----------------functionality----------------
- (void)setDatas {
    NSURL *url = [NSURL URLWithString:self.userInfo.headerImg];
    [self.headerImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headerimg"]];
    self.sexTF.text = self.userInfo.sex;
    self.sexTF.userInteractionEnabled = NO;
    if (self.userInfo.address.length > 0) {
        self.companyAddresstTF.text = self.userInfo.address;
    }
    self.companyAddresstTF.inputAccessoryView = self.toolBar;
    if (self.userInfo.company.length > 0) {
        self.companyNameTF.text = self.userInfo.company;
    }
    self.companyNameTF.inputAccessoryView = self.toolBar;
    if (self.userInfo.phone.length > 0) {
        self.contactTF.text = self.userInfo.phone;
    }
    self.contactTF.userInteractionEnabled = NO;
    if (self.userInfo.userName.length > 0) {
        self.userNameTF.text = self.userInfo.userName;
    }
    self.userNameTF.inputAccessoryView = self.toolBar;
    if (self.userInfo.linkMan.length > 0) {
        self.linkManTF.text = self.userInfo.linkMan;
    }
    self.linkManTF.inputAccessoryView = self.toolBar;
}

- (void)cancelSetRegionInfo:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
}

- (void)confirmRegionInfo:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_UPDATEINFO object:nil];
    [[RequestManager sharedRequestManager] requestUpdateUserInfoWithCompanyName:self.companyNameTF.text address:self.companyAddresstTF.text linkMan:self.linkManTF.text userName:self.userNameTF.text];
    [SVProgressHUD showWithStatus:@"更新信息..."];
}
#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.headerImageCell;
    }
    if (indexPath.row == 1) {
        return self.userNameCell;
    }
    if (indexPath.row == 2) {
        return self.sexCell;
    }
    if (indexPath.row == 3) {
        return self.companyNameCell;
    }
    if (indexPath.row == 4) {
        return self.companyAddressCell;
    }
    if (indexPath.row == 5) {
        return self.linkManCell;
    }
    return self.contactCell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self.sexTF becomeFirstResponder];
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 256) ];
        picker.delegate = self;
        picker.dataSource = self;
        self.sexTF.inputView = picker;
    }
}

#pragma mark ----------------picker delegate----------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"男";
    }
    if (row == 1) {
        return @"女";
    }
    return @"保密";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.sexTF.text = @"男";
    }
    if (row == 1) {
        self.sexTF.text = @"女";
    }
    if (row == 2) {
        self.sexTF.text = @"保密";
    }
}
#pragma mark ----------------picker datasource----------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

#pragma mark ----------------UITextfieldDelegate----------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.sexTF) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 256) ];
        picker.delegate = self;
        picker.dataSource = self;
        self.sexTF.inputView = picker;
    }
    return YES;
}
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
                //注销成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_UPDATEINFO]) {
//                [[UIResponder currentFirstResponder] resignFirstResponder];
                [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}
@end
