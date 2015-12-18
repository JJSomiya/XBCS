//
//  PersonalCenterViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EditImageViewController.h"

@interface PersonalCenterViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *menu1Cell;

@property (weak, nonatomic) IBOutlet UITableViewCell *feedBackCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *aboutUsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *complaintCell;
@property (weak, nonatomic) IBOutlet UIButton *headerBView;
@property (weak, nonatomic) IBOutlet UIView *segToolView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *bgBView;

@end

@implementation PersonalCenterViewController


#pragma mark ----------------System----------------
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
    self.headerBView.layer.masksToBounds = YES;
    self.headerBView.layer.cornerRadius = 50;
    self.headerBView.layer.borderWidth = 3;
    self.headerBView.layer.borderColor = [UIColor colorWithRed: 34.0/255 green: 128.0/255 blue: 66.0/255 alpha: 1].CGColor;
    
        //添加阴影层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bgBView.frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor colorWithWhite:0.667 alpha:0.700].CGColor];
    gradientLayer.locations = @[@0, @1.0];
    [self.bgBView.layer insertSublayer:gradientLayer atIndex:0];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar setShadowImage:nil];
        // "Pixel" is a solid white 1x1 image.
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
#pragma mark ----------------self methods----------------
/**
 *  根据不同的来源获取图片
 *
 *  @param sourceType 图片来源
 */
- (void)pickImageFrom:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]  init];
    imagePickerController.delegate = self;
    imagePickerController.editing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

/**
 *  检查相机是否可用
 *
 *  @return YES：可用
             NO：不可用。
            优化：在需要切换前后摄像头的时候都检查
 */
- (BOOL)isCameraAvailable {

    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > 0) {
        NSLog(@"相机可用");
        return YES;
    }
    return NO;
}

#pragma mark ----------------Action----------------
/**
 *  更换头像
 *
 *  @param sender
 */
- (IBAction)changeHeaderImage:(id)sender {
#ifdef DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    if (SYSTEM_VERSION_LESS_THAN(@"8.3")) {
//        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"更换头像"];
//        [actionSheet bk_addButtonWithTitle:@"相册" handler:^{
//            [self pickImageFrom:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//        }];
//        [actionSheet bk_addButtonWithTitle:@"相机" handler:^{
//            if ([self isCameraAvailable]) {
//                [self pickImageFrom:UIImagePickerControllerSourceTypeCamera];
//            } else {
//                [[ToastView sharedToastView] showToastViewWithMessage:@"相机无法使用" inView:[[[UIApplication sharedApplication] delegate] window]];
//            }
//        }];
//        [actionSheet showInView:self.view];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pickImageFrom:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self isCameraAvailable]) {
                [self pickImageFrom:UIImagePickerControllerSourceTypeCamera];
            } else {
                [[ToastView sharedToastView] showToastViewWithMessage:@"相机无法使用" inView:[[[UIApplication sharedApplication] delegate] window]];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark ----------------image picker delegate----------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
    EditImageViewController *editVC = [storyboard instantiateViewControllerWithIdentifier:@"editimagevc"];
    editVC.sourceImage = originalImage;
    [editVC setImageEditBlock:^(UIImage *editedImage){
        [self.headerBView setBackgroundImage:editedImage forState:UIControlStateNormal];
    }];
    [picker pushViewController:editVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    if ([segue.identifier isEqualToString:@""]) {
        
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 1) {
//        return 1;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            return self.feedBackCell;
//        } else {
//            return self.complaintCell;
//        }
//    }
//    if (indexPath.section == 1) {
//        return self.aboutUsCell;
//    }
    return self.menu1Cell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIAlertController *alerC = [UIAlertController alertControllerWithTitle:nil message:@"太生气了😤😤，我要投诉! \n 400-600-123456" preferredStyle:UIAlertControllerStyleAlert];
        [alerC addAction:[UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //拨打电话
////            NSString* path = [[NSBundle mainBundle] pathForResource:@"phonecall" ofType:@"html"];
////            NSURL* url = [NSURL fileURLWithPath:path];
//            UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//            [self.view addSubview:phoneCallWebView];
//            [phoneCallWebView loadHTMLString:@"<!DOCTYPE html>\
//             <html lang=\"en\">\
//             <head>\
//             <meta charset=\"UTF-8\">\
//             <title></title>\
//             </head>\
//             <body>\
//             <a id=\"target\" href=\"tel:13761328443\">jjj</a>\
//             <script>\
//             var target = document.getElementById(\"target\");\
//             var fakeEvent = document.createEvent(\"MouseEvents\");\
//             fakeEvent.initEvent(\"click\", true, false);\
//             target.dispatchEvent(fakeEvent);\
//             </script>\
//             </body>\
//             </html>" baseURL:nil];
////            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:url]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://13761328443"]];
        }]];
        [alerC addAction:[UIAlertAction actionWithTitle:@"气已消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alerC animated:YES completion:nil];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
