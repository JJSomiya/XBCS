//
//  FeedBackViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/21.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet JSTextView *feedbackTV;
@property (weak, nonatomic) IBOutlet UIButton *commitButn;
@end

@implementation FeedBackViewController

#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------init----------------
- (void)initBaseView {
    [super initBaseView];
//    self.commitButn.layer.borderColor = self.navigationController.navigationBar.tintColor.CGColor;
//    self.commitButn.layer.borderWidth = 1;
    self.commitButn.backgroundColor = RGB_HEX(0x4FC1E9);
    self.commitButn.layer.cornerRadius = 3;
    self.commitButn.layer.masksToBounds = YES;
    [self.commitButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
#pragma mark ----------------functionality----------------
- (IBAction)commitFeedBack:(id)sender {
    if (self.feedbackTV.content.length > 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_FEEDBACK object:nil];
        [[RequestManager sharedRequestManager] requestSendFeedBackWithContent:self.feedbackTV.content];
    } else {
        [SVProgressHUD showInfoWithStatus:@"请填写反馈内容！"];
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
                //反馈
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_FEEDBACK]) {
                [SVProgressHUD showSuccessWithStatus:@"感谢您的支持，Have a nick day!😊"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}
@end
