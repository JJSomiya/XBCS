
    //
//  PickServicesCollectionViewController.m
//  ProductBU
//
//  Created by Somiya on 15/12/10.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PickServicesCollectionViewController.h"
#import "ServiceDetailHeaderCollectionReusableView.h"
#import "OtherServiceCollectionCell.h"
#import "ServiceDetailCollectionViewCell.h"
#import "ServiceDetailFooterCollectionReusableView.h"
#import "ConfirmOrderViewController.h"

static CGFloat kFirstCellH = 88;
//static CGFloat k
@interface PickServicesCollectionViewController () <UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *generateOrderButn;
@property (nonatomic, assign) BOOL isHiden;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) NSMutableArray *selectedIds;
@end

@implementation PickServicesCollectionViewController
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"服务下单";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----------------inits----------------
- (void)initBaseData {
    [super initBaseData];
    self.isHiden = YES;
    self.selectedIds = [NSMutableArray array];
}

- (void)initBaseView {
    [super initBaseView];
    self.collectionView.backgroundColor = [UIColor clearColor];

    [self.selectedIds addObject:self.baseServiceObj.serviceId];
    kFirstCellH = 88;
}
/**
 *  init generate order button
 *
 *  @return
 */
- (UIButton *)generateOrderButn {
    if (!_generateOrderButn) {
        _generateOrderButn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _generateOrderButn.frame = CGRectMake((1 - 0.7) * SCREENWIDTH / 2, 5, 0.7 * SCREENWIDTH, 40);
        [_generateOrderButn addTarget:self action:@selector(generateOrderButnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_generateOrderButn setTitle:@"生成订单" forState:UIControlStateNormal];
        [_generateOrderButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_generateOrderButn setBackgroundColor:RGB_HEX(0x4FC1E9)];
        _generateOrderButn.layer.masksToBounds = YES;
        _generateOrderButn.layer.cornerRadius = 5;
    }
    return _generateOrderButn;
}
/**
 *  init tool bar
 *
 *  @return
 */
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
/**
 *  init picker view
 *
 *  @return
 */
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 256) ];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

#pragma mark ----------------functionality----------------
/**
 *  生成订单
 *
 *  @param sender
 */
- (void)generateOrderButnClicked:(id)sender {
    NSMutableArray *productArr = [NSMutableArray array];
    float totalMoney = 0.0;
    for (NSString *serviceId in self.selectedIds) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:serviceId forKey:@"product_id"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId like %@", serviceId];
        NSMutableArray *filterArr = [NSMutableArray array];
        for (NSArray *arr in [self.productsDic allValues]) {
            if (arr) {
                [filterArr addObjectsFromArray:arr];
            }
        }
        NSArray *resultArr = [filterArr filteredArrayUsingPredicate:predicate];
        if (resultArr.count > 0) {
            BaseServiceObject *obj = (BaseServiceObject *)[resultArr objectAtIndex:0];
            [dic setObject:@(obj.months) forKey:@"num"];
            totalMoney += ([obj.price floatValue] * obj.months);
        } else {
            continue;
        }
        [productArr addObject:dic];
    }
    if (productArr.count > 0) {
        ConfirmOrderViewController *confirmVC = [ConfirmOrderViewController new];
        confirmVC.productsArr = productArr;
        confirmVC.totalMoney = totalMoney;
        [self.navigationController pushViewController:confirmVC animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"没有选中任何服务！"];
    }
   
}

/**
 *  取消
 *
 *  @param sender
 */
- (void)cancelSetRegionInfo:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
}
/**
 *  确定
 *
 *  @param sender
 */
- (void)confirmRegionInfo:(id)sender {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
}

#pragma mark ----------------picker delegate----------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *arr = @[@{@"title":@"1个月", @"num":@"1"},@{@"title":@"2个月", @"num":@"2"}, @{@"title":@"3个月", @"num":@"3"}, @{@"title":@"4个月", @"num":@"4"}, @{@"title":@"5个月", @"num":@"5"}, @{@"title":@"6个月", @"num":@"6"}, @{@"title":@"6个月", @"num":@"7"}, @{@"title":@"8个月", @"num":@"8"}, @{@"title":@"9个月", @"num":@"9"}, @{@"title":@"10个月", @"num":@"10"}, @{@"title":@"11个月", @"num":@"11"}, @{@"title":@"一年", @"num":@"12"}];
    return [[arr objectAtIndex:row] valueForKey:@"title"];;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *arr = @[@{@"title":@"1个月", @"num":@"1"},@{@"title":@"2个月", @"num":@"2"}, @{@"title":@"3个月", @"num":@"3"}, @{@"title":@"4个月", @"num":@"4"}, @{@"title":@"5个月", @"num":@"5"}, @{@"title":@"6个月", @"num":@"6"}, @{@"title":@"6个月", @"num":@"7"}, @{@"title":@"8个月", @"num":@"8"}, @{@"title":@"9个月", @"num":@"9"}, @{@"title":@"10个月", @"num":@"10"}, @{@"title":@"11个月", @"num":@"11"}, @{@"title":@"一年", @"num":@"12"}];
    
    UITextField *textTF = [UIResponder currentFirstResponder];
    textTF.text = [[arr objectAtIndex:row] valueForKey:@"num"];
    NSIndexPath *indexPath = textTF.indexPath;
    if (self.serviceType == ServiceTypeValueAdded) {
        if (indexPath.section == 0) {
            NSString *key = nil;
            if (indexPath.section == 1) {
                key = @"1";
            } else {
                key = @"3";
            }
            NSArray *arr = [self.productsDic valueForKey:key];
            BaseServiceObject *obj = [arr objectAtIndex:indexPath.item];
            obj.months = [[[arr objectAtIndex:row] valueForKey:@"num"] integerValue];
            return;
        } else {
            return;
        }
    }
    
    if (indexPath.section == 0) {
        self.baseServiceObj.months = [[[arr objectAtIndex:row] valueForKey:@"num"] integerValue];
    }
    if (indexPath.section == 3) {
        return;
    }
    NSString *key = nil;
    if (indexPath.section == 1) {
        key = @"1";
    } else {
        key = @"3";
    }
    NSArray *arr1 = [self.productsDic valueForKey:key];
    BaseServiceObject *obj = [arr1 objectAtIndex:indexPath.item];
    obj.months = [[[arr objectAtIndex:row] valueForKey:@"num"] integerValue];
}

#pragma mark ----------------picker datasource----------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 12;
}

#pragma mark ----------------UICollectionViewDataSource----------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (ServiceTypeBase == self.serviceType) {
        if (section == 0 || section == 3) {
            return 1;
        }
        NSString *key = nil;
        if (section == 1) {
            key = @"1";
        } else {
            key = @"3";
        }
        NSArray *arr = [self.productsDic valueForKey:key];
        return arr.count;
    }
    if (ServiceTypeValueAdded == self.serviceType) {
        if (section == 1) {
            NSArray *arr = [self.productsDic valueForKey:@"3"];
            return arr.count;
        }
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (ServiceTypeBase == self.serviceType) {
        return 4;
    }
    if (ServiceTypeValueAdded == self.serviceType) {
        return 3;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.serviceType == ServiceTypeValueAdded) {
        if (indexPath.section == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
            return cell;
        }
        if (indexPath.section == 1) {
            OtherServiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"otherservicecell" forIndexPath:indexPath];
            NSString *key = @"3";
            NSArray *arr = [self.productsDic valueForKey:key];
            BaseServiceObject *obj = [arr objectAtIndex:indexPath.item];
            
            cell.bgImageView.backgroundColor = [UIColor whiteColor];
            cell.monthsTF.inputView = self.pickerView;
            cell.monthsTF.inputAccessoryView = self.toolBar;
            cell.monthsTF.text = [NSString stringWithFormat:@"%ld", (long)obj.months];
            cell.monthsTF.indexPath = indexPath;
            [cell configureWithIndexPath:indexPath object:obj];
            [cell setSelectedProductBlock:^(NSIndexPath *indexPath, BOOL isSelected, NSString *serviceId) {
                if (isSelected) {
                    [self.selectedIds addObject:serviceId];
                } else {
                    if ([self.selectedIds containsObject:serviceId]) {
                        [self.selectedIds removeObject:serviceId];
                    }
                }
            }];
            if ([self.selectedIds containsObject:obj.serviceId]) {
                cell.isSelected = YES;
            }
            return cell;
        } else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
            [cell addSubview:self.generateOrderButn];
            return cell;
        }
    }
    
    if (indexPath.section == 0) {
        ServiceDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseservicedetailcell" forIndexPath:indexPath];
        cell.monthsTF.inputView = self.pickerView;
        cell.monthsTF.inputAccessoryView = self.toolBar;
        cell.monthsTF.indexPath = indexPath;
        [cell configureWithIndexPath:indexPath object:self.baseServiceObj];
        return cell;
    }
    if (indexPath.section == 3) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
        [cell addSubview:self.generateOrderButn];
        return cell;
    }
    OtherServiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"otherservicecell" forIndexPath:indexPath];
    NSString *key = nil;
    if (indexPath.section == 1) {
        key = @"1";
    } else {
        key = @"3";
    }
    NSArray *arr = [self.productsDic valueForKey:key];
    BaseServiceObject *obj = [arr objectAtIndex:indexPath.item];
    
    cell.bgImageView.backgroundColor = [UIColor whiteColor];
    cell.monthsTF.inputView = self.pickerView;
    cell.monthsTF.inputAccessoryView = self.toolBar;
    cell.monthsTF.text = [NSString stringWithFormat:@"%ld", (long)obj.months];
    cell.monthsTF.indexPath = indexPath;
    [cell configureWithIndexPath:indexPath object:obj];
    [cell setSelectedProductBlock:^(NSIndexPath *indexPath, BOOL isSelected, NSString *serviceId) {
        if (isSelected) {
            [self.selectedIds addObject:serviceId];
        } else {
            if ([self.selectedIds containsObject:serviceId]) {
                [self.selectedIds removeObject:serviceId];
            }
        }
    }];
    if ([self.selectedIds containsObject:obj.serviceId]) {
        cell.isSelected = YES;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (ServiceTypeValueAdded == self.serviceType) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            ServiceDetailHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"servicedetailheaderview" forIndexPath:indexPath];
            headerView.bgImageView.layer.masksToBounds = YES;
            headerView.bgImageView.layer.cornerRadius = 3;
            headerView.bgImageView.backgroundColor = [UIColor whiteColor];
            if (indexPath.section == 1) {
                headerView.titleLabel.text = @"增值服务";
            }
            return headerView;
        } else {
            ServiceDetailFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"servicedetailfooterview" forIndexPath:indexPath];
            footerView.bgImageView.layer.masksToBounds = YES;
            footerView.bgImageView.layer.cornerRadius = 3;
            footerView.bgImageView.backgroundColor = [UIColor whiteColor];
            return footerView;
        }
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ServiceDetailHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"servicedetailheaderview" forIndexPath:indexPath];
        headerView.bgImageView.layer.masksToBounds = YES;
        headerView.bgImageView.layer.cornerRadius = 3;
        headerView.bgImageView.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 1) {
            headerView.titleLabel.text = @"首次财税记账前需办理";
        }
        if (indexPath.section == 2) {
            headerView.titleLabel.text = @"增值服务";
        }
        return headerView;
    } else {
        ServiceDetailFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"servicedetailfooterview" forIndexPath:indexPath];
        footerView.bgImageView.layer.masksToBounds = YES;
        footerView.bgImageView.layer.cornerRadius = 3;
        footerView.bgImageView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }
}

#pragma mark ----------------UICollectionViewDelegate----------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.serviceType == ServiceTypeValueAdded) {
        return;
    }
    if (indexPath.section == 0) {
        ServiceDetailCollectionViewCell *cell = (ServiceDetailCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIImage *image = cell.serviceDetailImageView.image;
        if (self.isHiden) {
            CGFloat width = SCREENWIDTH - 40;
            CGFloat height = width / image.size.width * image.size.height;
            kFirstCellH = 88 + height;
            self.isHiden = NO;
        } else {
            kFirstCellH = 88;
            self.isHiden = YES;
        }
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finish){
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.serviceDetailImageView.hidden = NO;
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            } completion:nil];
        }];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

    // Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
//    selectedCell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.000];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
//    selectedCell.backgroundColor = [UIColor whiteColor];
}

#pragma mark ----------------UICollectionViewDelegateFlowLayout----------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.serviceType == ServiceTypeValueAdded) {
        if (section == 0) {
            return UIEdgeInsetsMake(30, 0, 0, 0);;
        }
        if (section == 1) {
            return  UIEdgeInsetsMake(0, 0, 0, 0);
        }
        return UIEdgeInsetsMake(50, 0, 30, 0);
    }
    if (section == 0) {
        return UIEdgeInsetsMake(30, 0, 10, 0);
    }
    if (section == 3) {
        return UIEdgeInsetsMake(50, 0, 30, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0001;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.serviceType == ServiceTypeValueAdded) {
        if (indexPath.section == 0) {
            return CGSizeMake(SCREENWIDTH, 0.01);
        }
        return CGSizeMake(SCREENWIDTH, 50);
    }
    
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH, kFirstCellH);
    }
    return CGSizeMake(SCREENWIDTH, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.serviceType == ServiceTypeValueAdded) {
        if (section == 0) {
            return CGSizeMake(0.01, 0.01);
        }
        if (section == 1) {
           return CGSizeMake(SCREENWIDTH, 50);
        }
        return CGSizeMake(0.01, 0.01);
    }
    
    if (section == 0 || section == 3) {
        return CGSizeMake(0.01, 0.01);
    }
    return CGSizeMake(SCREENWIDTH, 50);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.serviceType == ServiceTypeValueAdded) {
        if (section == 0) {
            return CGSizeMake(0.01, 0.01);
        }
        if (section == 1) {
           return CGSizeMake(SCREENWIDTH, 70);
        }
        return CGSizeMake(0.01, 0.01);
    }
    
    if (section == 0 || section == 3) {
        return CGSizeMake(0.01, 0.01);
    }
    return CGSizeMake(SCREENWIDTH, 55);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
