//
//  MyOrdersViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/23.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "OrderDetailViewController.h"
@interface MyOrdersViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CustomSegViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *presentDataArr;
@end

@implementation MyOrdersViewController

#pragma mark ---------------- system----------------
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)initBaseData {
    [super initBaseData];
    [self.segView setSegViewItems:@[@"全部订单", @"已付款", @"未付款"]];
    self.segView.selectedColor = RGB_HEX(0x4fc1e9);
    self.segView.defaultColor = [UIColor blackColor];
    self.segView.bottomImageView = nil;
    self.segView.showSplitLine = YES;
    self.segView.delegate = self;
    self.segView.font = [UIFont systemFontOfSize:15];
    
    self.dataArr = [NSMutableArray array];
    self.presentDataArr = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_MYORDER object:nil];
    [[RequestManager sharedRequestManager] requestMyOrders];
}

- (void)initBaseView {
    [super initBaseView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"OrderCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ordercell"];
}
#pragma mark ----------------CustomSegViewDelegate----------------
- (void)customSegView:(CustomSegView *)segView didChangeItemsAtIndex:(NSInteger)index {
    [self.presentDataArr removeAllObjects];
    if (segView.currentIndex == 0) {
        [self.presentDataArr addObjectsFromArray:self.dataArr];
    } else {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status MATCHES %d", segView.currentIndex];
//        [self.presentDataArr addObjectsFromArray:(NSMutableArray *)[self.dataArr filteredArrayUsingPredicate:predicate]];
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OrderObject *orderObj = (OrderObject *)obj;
            if ([orderObj.status integerValue] == segView.currentIndex) {
                [self.presentDataArr addObject:orderObj];
            }
        }];
    }

    [self.collectionView reloadData];
}
#pragma mark ----------------UICollectionViewDataSource----------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.presentDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ordercell" forIndexPath:indexPath];
    [cell configureWithIndexPath:indexPath object:[self.presentDataArr objectAtIndex:indexPath.item]];
    return cell;
}

#pragma mark ----------------UICollectionViewDelegate----------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderCollectionViewCell *cell = (OrderCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
    OrderDetailViewController *orderDetailVC = (OrderDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"orderdetail"];
    orderDetailVC.orderObj = (OrderObject *)cell.object;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
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
                //获取订单列表
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_MYORDER]) {
                [self.dataArr removeAllObjects];
                [self.presentDataArr removeAllObjects];
                self.dataArr = (NSMutableArray *)[MTLJSONAdapter modelsOfClass:[OrderObject class] fromJSONArray:[respData valueForKey:KDATA] error:nil];
                [self.presentDataArr addObjectsFromArray:self.dataArr];
                [self.collectionView reloadData];
                [SVProgressHUD dismiss];
            }
                //上传头像成功
//            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_UPDATEHEADERIMAGE]) {
//
//            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}
@end
