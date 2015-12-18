//
//  MeCollectionViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/11/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "MeCollectionViewController.h"
#import "MenuCollectionViewCell.h"
#import "HeaderCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "EditImageViewController.h"
#import "UserInfoTableViewController.h"
#import "MyCouponsCollectionViewController.h"


@interface MeCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UserObject *user;
@end

@implementation MeCollectionViewController
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
    //    [SVProgressHUD showWithStatus:@"Loading..."];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar setShadowImage:nil];
        // "Pixel" is a solid white 1x1 image.
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_USERINFO object:nil];
    [[RequestManager sharedRequestManager] requestUserInfo];
}
#pragma mark ----------------inits----------------
- (void)initBaseData {
    self.dataArr = @[@[@{@"img":@"order.png", @"name":@"我的订单", @"id":@"ordervc"}, @{@"img":@"info.png", @"name":@"基本信息", @"id":@"infovc"}, @{@"img":@"message.png", @"name":@"我的消息", @"id":@"messagevc"}, @{@"img":@"yigou.png", @"name":@"已购服务", @"id":@"servericevc"}, @{@"img":@"yhq.png", @"name":@"我的卡券", @"id":@"couponsvc"}], @[@{@"img":@"feedback.png", @"name":@"用户反馈", @"id":@"feedbackvc"}, @{@"img":@"suggest.png", @"name":@"投诉建议"}, @{@"img":@"aboutus.png", @"name":@"关于我们", @"id":@"aboutusvc"}]];
}

- (void)initBaseView {
    [super initBaseView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 251 + 10, SCREENWIDTH - 40, (SCREENWIDTH - 40) * 0.487)];
    imageView.image = [UIImage imageNamed:@"menubg"];
    imageView.layer.zPosition= -1;
    [self.collectionView insertSubview:imageView atIndex:0];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(27, 251 + (SCREENWIDTH - 54) * 0.487 + 30 + 10, SCREENWIDTH - 54, (SCREENWIDTH - 40) * 0.487 / 2)];
    imageView1.image = [UIImage imageNamed:@"menubg1"];
    imageView1.layer.zPosition= -1;
    [self.collectionView insertSubview:imageView1 atIndex:0];
}
#pragma mark ----------------functionality----------------
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

#pragma mark ----------------image picker delegate----------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
    EditImageViewController *editVC = [storyboard instantiateViewControllerWithIdentifier:@"editimagevc"];
    editVC.sourceImage = originalImage;
    [editVC setImageEditBlock:^(UIImage *editedImage){
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//        MenuCollectionViewCell *cell = (MenuCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//        [cell configureWithIndexPath:indexPath object:editedImage];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_UPDATEHEADERIMAGE object:nil];
        [[RequestManager sharedRequestManager] requestUpdateHeaderImageWithImage:editedImage];
        }];
    [picker pushViewController:editVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----------------UICollectionViewDataSource----------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 5;
    } else {
        return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headercell" forIndexPath:indexPath];
        [cell setHeaderClickedBlock:^{
#ifdef DEBUG
            NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
            if (SYSTEM_VERSION_LESS_THAN(@"8.3")) {
//                UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"更换头像"];
//                [actionSheet bk_addButtonWithTitle:@"相册" handler:^{
//                    [self pickImageFrom:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//                }];
//                [actionSheet bk_addButtonWithTitle:@"相机" handler:^{
//                    if ([self isCameraAvailable]) {
//                        [self pickImageFrom:UIImagePickerControllerSourceTypeCamera];
//                    } else {
//                        [[ToastView sharedToastView] showToastViewWithMessage:@"相机无法使用" inView:[[[UIApplication sharedApplication] delegate] window]];
//                    }
//                }];
//                [actionSheet showInView:self.view];
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

        }];
        [cell configureWithIndexPath:indexPath object:self.user];
        return cell;
    }
    NSArray *arr = [self.dataArr objectAtIndex:indexPath.section - 1];
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menucell" forIndexPath:indexPath];
    [cell configureWithIndexPath:indexPath object:[arr objectAtIndex:indexPath.item]];
    return cell;
}
#pragma mark ----------------UICollectionViewDelegate----------------
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

#pragma mark ----------------UICollectionViewDelegateFlowLayout----------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH - 10, 210);
    }
    CGFloat width = (SCREENWIDTH - 66)/3;
    return CGSizeMake(width, (SCREENWIDTH - 40) * 0.45 / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MenuCollectionViewCell *cell = (MenuCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
   
    if (cell.storyboardId) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
        UIViewController *pushvc = [storyboard instantiateViewControllerWithIdentifier:cell.storyboardId];
        pushvc.hidesBottomBarWhenPushed = YES;
        if ([cell.storyboardId isEqualToString:@"infovc"]) {
            UserInfoTableViewController *userInfoVC = (UserInfoTableViewController *)pushvc;
            userInfoVC.userInfo = self.user;
        }
        if ([cell.storyboardId isEqualToString:@"couponsvc"]) {
            MyCouponsCollectionViewController *couponVC = (MyCouponsCollectionViewController *)pushvc;
            couponVC.from = 1;
        }
        
        [self.navigationController pushViewController:pushvc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }
    
    if (indexPath.section == 2 && indexPath.item == 1) {
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
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 0, 0, 0);
    }
    if (section == 1) {
        return UIEdgeInsetsMake(50, 30, 0, 30);
    }
    return UIEdgeInsetsMake(30, 30, 60, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    if ([segue.identifier isEqualToString:@"userinfo"]) {
        UserInfoTableViewController *userInfoVC = segue.destinationViewController;
        userInfoVC.userInfo = self.user;
    }
}

#pragma mark ----------------返回数据处理----------------
- (void)didRequestReceiveResponse:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[info valueForKey:kNotificationName] object:nil];
    if ([[info valueForKey:kRespResult] isEqualToString:SUCCESS]) {
        NSDictionary *respData = [info valueForKey:KRESPDATA];
        if ([[respData valueForKey:STATUS] integerValue] == ResponseCodeSuccess) {
                //注销成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_USERINFO]) {
                self.user = [MTLJSONAdapter modelOfClass:[UserObject class] fromJSONDictionary:[respData valueForKey:KDATA] error:nil];
                self.user.sex = @"保密";
                [self.collectionView reloadData];
                [SVProgressHUD dismiss];
            }
                //上传头像成功
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_UPDATEHEADERIMAGE]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                self.user.headerImg = [[respData valueForKey:KDATA] valueForKey:@"app_img"];
//                HeaderCollectionViewCell *cell = (HeaderCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                [SVProgressHUD dismiss];
            }

        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}
@end
