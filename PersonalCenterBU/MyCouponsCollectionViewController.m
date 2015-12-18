//
//  MyCouponsCollectionViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/12/16.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "MyCouponsCollectionViewController.h"
#import "CouponCollectionViewCell.h"
@interface MyCouponsCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *dataArr;
@end
@implementation MyCouponsCollectionViewController
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
#pragma mark ----------------inits----------------
- (void)initBaseData {
    self.dataArr = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_GETCONPONS object:nil];
    [[RequestManager sharedRequestManager] requestMyConpons];
}
- (void)initBaseView {
    [super initBaseView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    if (self.from == 0) {
        [self addNavigationBarItems];
        if (!self.selectedCoupon) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    self.title = @"我的优惠券";
}

#pragma mark ----------------functionality----------------
- (void)addNavigationBarItems {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelUseCoupon:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"使用" style:UIBarButtonItemStylePlain target:self action:@selector(useCoupon:)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
}

- (void)cancelUseCoupon:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)useCoupon:(id)sender {
    [EMBus callData:[@"product/ConfirmOrderViewController/changeCheckBoxState" lowercaseString] param:self.selectedCoupon, nil];
    [self dismissViewControllerAnimated:YES completion:nil];
//    if (self.selectedConponBlock) {
//        self.selectedConponBlock(self.selectedCoupon);
//    }
}

#pragma mark ----------------UICollectionViewDataSource----------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"couponcell" forIndexPath:indexPath];
    CouponObject *coupon = [self.dataArr objectAtIndex:indexPath.item];
    if (self.from == 0) {
        if (self.selectedCoupon && [self.selectedCoupon.couponId isEqualToString:coupon.couponId]) {
            cell.selected = YES;
        }
    }
    [cell configureWithIndexPath:indexPath object:coupon from:self.from];
    return cell;
}
#pragma mark ----------------UICollectionViewDelegate----------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCoupon = [self.dataArr objectAtIndex:indexPath.item];
    if (self.selectedCoupon) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
    // Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.from == 1) {
        return NO;
    }
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    CouponCollectionViewCell *selectedCell = (CouponCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.bgView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.000];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    CouponCollectionViewCell *selectedCell = (CouponCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.bgView.backgroundColor = [UIColor whiteColor];
}

    // Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.from == 1) {
        return NO;
    }
    return YES;
}

#pragma mark ----------------UICollectionViewDelegateFlowLayout----------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENWIDTH, 100);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 0, 0, 0);
}

#pragma mark ----------------返回数据处理----------------
- (void)didRequestReceiveResponse:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[info valueForKey:kNotificationName] object:nil];
    if ([[info valueForKey:kRespResult] isEqualToString:SUCCESS]) {
        NSDictionary *respData = [info valueForKey:KRESPDATA];
        if ([[respData valueForKey:STATUS] integerValue] == ResponseCodeSuccess) {
                //获取优惠券列表
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_GETCONPONS]) {
                if ([respData valueForKey:KDATA]) {
                    self.dataArr = (NSMutableArray *)[MTLJSONAdapter modelsOfClass:[CouponObject class] fromJSONArray:[respData valueForKey:KDATA] error:nil];
                    [self.collectionView reloadData];
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
