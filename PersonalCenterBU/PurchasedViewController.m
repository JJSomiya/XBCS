//
//  PurchasedViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PurchasedViewController.h"

@interface PurchasedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CustomSegViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *presentDataArr;
@end

@implementation PurchasedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initBaseData {
    [super initBaseData];
    [self.segView setSegViewItems:@[@"全部服务", @"已生效", @"待生效"]];
    self.segView.selectedColor = RGB_HEX(0x4fc1e9);
    self.segView.defaultColor = [UIColor blackColor];
    self.segView.bottomImageView = nil;
    self.segView.showSplitLine = YES;
    self.segView.delegate = self;
    self.segView.font = [UIFont systemFontOfSize:15];
    
    self.dataArr = [NSMutableArray array];
    self.presentDataArr = [NSMutableArray array];

}

- (void)initBaseView {
    [super initBaseView];

}
#pragma mark ----------------CustomSegViewDelegate----------------
- (void)customSegView:(CustomSegView *)segView didChangeItemsAtIndex:(NSInteger)index {

}
#pragma mark ----------------UICollectionViewDataSource----------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    OrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ordercell" forIndexPath:indexPath];
//    [cell configureWithIndexPath:indexPath object:[self.presentDataArr objectAtIndex:indexPath.item]];
//    return cell;
//}

#pragma mark ----------------UICollectionViewDelegate----------------

#pragma mark ----------------UICollectionViewDelegateFlowLayout----------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH, 125);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(25, 0, 30, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25;
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

        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}

@end
