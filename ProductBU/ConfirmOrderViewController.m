//
//  ConfirmOrderViewController.m
//  ProductBU
//
//  Created by Somiya on 15/11/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "PayWayCollectionViewCell.h"
#import "PayResultViewController.h"

static NSString *const identifier = @"paywaycell";
static CGFloat kMarginLeft = 20;
@interface ConfirmOrderViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, CheckBoxViewDelegate, CheckBoxViewDataSource, UIPickerViewDelegate,  UIPickerViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *serviceLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *deadLineLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *totalMoneyLabel;
@property (nonatomic, strong) UIButton *commitOrderButn;

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSString *payChannel;

@property (nonatomic, strong) CouponObject *selectedCoupon;

@property (nonatomic, strong) NSArray *checkBoxDataArr;
@end
static ConfirmOrderViewController *confirmOrderVCInstance;
@implementation ConfirmOrderViewController
+ (instancetype)sharedInstance {
    return confirmOrderVCInstance;
}
#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------inits----------------
- (void)initBaseData {
    self.payChannel = nil;
    self.checkBoxDataArr = @[@{@"name":@"优惠券", @"identifier":@"coupon", @"selected":@(NO)}, @{@"name":@"积分", @"identifier":@"points", @"selected":@(NO)}, @{@"name":@"活动", @"identifier":@"activity", @"selected":@(NO)}];
}

- (void)initBaseView {
    [super initBaseView];
    [self.view addSubview:self.scrollView];
    
    UILabel *label1 = [self createLabelWithText:@"确认信息"];
    label1.textColor = [UIColor blackColor];
//    label1.font = [UIFont systemFontOfSize:17];
    label1.frame = CGRectMake(10, 20, SCREENWIDTH - 20, 20);
    [self.scrollView addSubview:label1];
    
    UIView *view1 = [self createView];
    view1.frame = CGRectMake(10, CGRectGetMaxY(label1.frame) + 5, SCREENWIDTH - 20, 200);
    [self.scrollView addSubview:view1];
    
    self.serviceLabel = [self createLabelWithText:@"服务名称："];
    self.serviceLabel.frame = CGRectMake(kMarginLeft, 10, view1.frame.size.width - 10, 20);
    [view1 addSubview:self.serviceLabel];
    
    UIImageView *cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(view1.frame.size.width - 35, 5, 30, 30)];
    cornerImageView.image = [UIImage imageNamed:@"checkboxselected"];
    cornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [view1 addSubview:cornerImageView];
    
    self.deadLineLabel = [self createLabelWithText:@"服务期限：6个月"];
    self.deadLineLabel.frame = CGRectMake(kMarginLeft, CGRectGetMaxY(self.serviceLabel.frame) + 20, [self calculateTextSizeWithText:self.deadLineLabel.text andBaseSize:CGSizeMake(1000, 20)].width, 20);
    [view1 addSubview:self.deadLineLabel];
    
    UIButton *changeButn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    changeButn.frame = CGRectMake(CGRectGetMaxX(self.deadLineLabel.frame) + 10, CGRectGetMaxY(self.serviceLabel.frame) + 20, 50, 20);
    [changeButn setTitle:@"修改" forState:UIControlStateNormal];
    [changeButn setBackgroundColor:RGB_HEX(0x80c269)];
    [changeButn setTintColor:[UIColor whiteColor]];
    changeButn.layer.cornerRadius = 3;
    changeButn.layer.masksToBounds = YES;
    [changeButn addTarget:self action:@selector(changeDeadLineButnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //去掉修改
//    [view1 addSubview:changeButn];
//    欺骗TextField
//    self.textField = [UITextField new];
//    self.textField.inputAccessoryView = self.toolBar;
//    self.textField.inputView = self.pickerView;
//    [view1 addSubview:self.textField];
    
    self.priceLabel = [self createLabelWithText:@"服务单价："];
    self.priceLabel.frame = CGRectMake(kMarginLeft, CGRectGetMaxY(self.deadLineLabel.frame) + 20, view1.frame.size.width - 10, 20);
    [view1 addSubview:self.priceLabel];
    
    UILabel *label = [self createLabelWithText:@"服务内容："];
    label.frame = CGRectMake(kMarginLeft, CGRectGetMaxY(self.priceLabel.frame) + 20, 75, 20);
    [view1 addSubview:label];
    self.contentLabel = [self createLabelWithText:@"hahahaha"];
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(self.priceLabel.frame) + 20, view1.frame.size.width - 90, [self calculateTextSizeWithText:self.contentLabel.text andBaseSize:CGSizeMake(view1.frame.size.width - 90, CGFLOAT_MAX)].height);
    
    [view1 addSubview:self.contentLabel];

    CGRect frame = self.checkBoxView.frame;
    frame.origin.y = CGRectGetMaxY(view1.frame) + 20;
    self.checkBoxView.frame = frame;
    [self.scrollView addSubview:self.checkBoxView];
    
    UILabel *label2 = [self createLabelWithText:@"选择支付方式"];
    label2.textColor = [UIColor blackColor];
//    label2.font = [UIFont systemFontOfSize:17];
    label2.frame = CGRectMake(10, CGRectGetMaxY(self.checkBoxView.frame) + 20, SCREENWIDTH - 40, 20);
    [self.scrollView addSubview:label2];
    
    CGRect frame1 = self.collectionView.frame;
    frame1.origin.y = CGRectGetMaxY(label2.frame) - 10;
    self.collectionView.frame = frame1;
    [self.scrollView addSubview:self.collectionView];
    
    [self.scrollView addSubview:self.totalMoneyLabel];
    [self.scrollView addSubview:self.commitOrderButn];
    CGFloat top = CGRectGetMaxY(self.commitOrderButn.frame) + 100;
    self.scrollView.contentSize = CGSizeMake(0, top);
    
    if (confirmOrderVCInstance) {
        confirmOrderVCInstance = nil;
    }
    confirmOrderVCInstance = self;
}

- (UIButton *)commitOrderButn {
    if (!_commitOrderButn) {
        _commitOrderButn = [[UIButton alloc] initWithFrame:CGRectMake((1 - 0.7) * SCREENWIDTH / 2, CGRectGetMaxY(self.totalMoneyLabel.frame) + 50, 0.7 * SCREENWIDTH, 40)];
        [_commitOrderButn setTitle:@"提交订单" forState:UIControlStateNormal];
        [_commitOrderButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _commitOrderButn.layer.borderColor = [UIColor colorWithRed: 34.0/255 green: 128.0/255 blue: 66.0/255 alpha: 1].CGColor;
//        _commitOrderButn.layer.borderWidth = 1;
        [_commitOrderButn setBackgroundColor:RGB_HEX(0x4FC1E9)];
        _commitOrderButn.layer.masksToBounds = YES;
        _commitOrderButn.layer.cornerRadius = 5;
        [_commitOrderButn addTarget:self action:@selector(commitOrderButnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitOrderButn;
}
- (UILabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.collectionView.frame) + 20, SCREENWIDTH - 20, 20)];
        NSString *moneyStr = [NSString stringWithFormat:@"%0.2f", self.totalMoney];
        _totalMoneyLabel.text = [NSString stringWithFormat:@"实付款：%@", moneyStr];
        _totalMoneyLabel.textAlignment = NSTextAlignmentCenter;

        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:_totalMoneyLabel.text];
        NSArray *arr = [moneyStr componentsSeparatedByString:@"."];
        if (arr.count > 0) {
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:23] range:[_totalMoneyLabel.text rangeOfString:[arr objectAtIndex:0]]];
        }
        if (arr.count > 1) {
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[_totalMoneyLabel.text rangeOfString:[arr objectAtIndex:1]]];
        }
        _totalMoneyLabel.attributedText = attributedStr;
    }
    return _totalMoneyLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _scrollView;
}

- (CheckBoxView *)checkBoxView {
    if (!_checkBoxView) {
        _checkBoxView = [[CheckBoxView alloc] initWithFrame:CGRectMake(50, 0, SCREENWIDTH - 100, 100)];
        _checkBoxView.delegate = self;
        _checkBoxView.dataSource = self;
//        [_checkBoxView setCheckBoxViewItems:@[@{@"name":@"活动", @"identifier":@"activity"}, @{@"name":@"积分", @"identifier":@"points"}, @{@"name":@"优惠券", @"identifier":@"coupon"}]];
    }
    return _checkBoxView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[PayWayCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        [self.scrollView addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
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
 * 计算文本大小
 *
 *  @param text
 *  @param baseSize
 *
 *  @return
 */
- (CGSize)calculateTextSizeWithText:(NSString *)text andBaseSize:(CGSize)baseSize {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};

    CGRect rect = [text boundingRectWithSize:baseSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    return rect.size;
}
/**
 *  提交订单
 *
 *  @param sender
 */
- (void)commitOrderButnClicked:(id)sender {
//    NSArray *arr = @[@{@"product_id":@(1), @"num":@(2)}, @{@"product_id":@(2), @"num":@(4)}, @{@"product_id":@(5), @"num":@(2)}, @{@"product_id":@(3), @"num":@(2)}];
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    if (self.payChannel && self.productsArr) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRequestReceiveResponse:) name:REQUEST_POST_ADDORDER object:nil];
//        [[RequestManager sharedRequestManager] requestAddOrderWithChannel:self.payChannel products:jsonString];
//    } else {
//        [SVProgressHUD showInfoWithStatus:@"请选择支付方式！"];
//    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Product" bundle:nil];
    PayResultViewController *payResultVC = [storyboard instantiateViewControllerWithIdentifier:@"payresultvc"];
    payResultVC.result = 0;
    [self.navigationController pushViewController:payResultVC animated:YES];
}

- (UIView *)createView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
//    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    return view;
}

- (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB_HEX(0x585858);
    return label;
}

- (void)changeDeadLineButnClicked:(id)sender {
    [self.textField becomeFirstResponder];
}

- (void)cancelSetRegionInfo:(id)sender {
    [self.textField resignFirstResponder];
}

- (void)confirmRegionInfo:(id)sender {
     [self.textField resignFirstResponder];
}

- (void)changeCheckBoxSelectedState:(CouponObject *)coupon {
    self.selectedCoupon = coupon;
    self.checkBoxDataArr = @[@{@"name":@"优惠券", @"identifier":@"coupon", @"selected":@(YES)}, @{@"name":@"积分", @"identifier":@"points", @"selected":@(NO)}, @{@"name":@"活动", @"identifier":@"activity", @"selected":@(NO)}];
    [self.checkBoxView layoutSubviews];
}
#pragma mark ----------------picker delegate----------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *arr = @[@"1个月", @"2个月", @"3个月", @"4个月", @"5个月", @"6个月", @"7个月", @"8个月", @"9个月", @"10个月", @"11个月", @"一年"];
    return [arr objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}
#pragma mark ----------------picker datasource----------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 12;
}

#pragma mark ----------------CheckBoxViewDelegate----------------
- (void)checkBoxView:(CheckBoxView *)checkBoxView didSelectedAtIndex:(NSInteger)index {
    [EMBus callData:[@"personalcenter/MyCouponsCollectionViewController/showMyCoupons" lowercaseString] param:self, self.selectedCoupon, nil];
}
#pragma mark ----------------CheckBoxViewDataSource----------------
- (CheckBoxCell *)checkBoxView:(CheckBoxView *)checkBoxView cellAtIndex:(NSInteger)index {
    CheckBoxCell *cell = [[CheckBoxCell alloc] init];
    [cell configCellContentWithDic:[self.checkBoxDataArr objectAtIndex:index]];
    return cell;
}

- (NSInteger)numberOfItems {
    return 3;
}

- (NSString *)titleForCheckBoxView {
    return @"优惠券/积分/活动";
}
#pragma mark ----------------UICollectionViewDataSource----------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        //    if ([collectionView == [self.collectionViews objectAtIndex:self.currentPage]]) {
        //
        //    }
    PayWayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *arr = @[@{@"payway":@"支付宝", @"image":@"zhifubao", @"channel":@"alipay", @"maskimage":@"zhifubao_s"}, @{@"payway":@"微信支付", @"image":@"weizhifu", @"channel":@"wx", @"maskimage":@"weizhifu_s"}];
    [cell configureWithIndexPath:indexPath object:[arr objectAtIndex:indexPath.item]];
    return cell;
}


#pragma mark ----------------UICollectionViewDelegate----------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = @[@{@"payway":@"支付宝", @"image":@"zhifubao", @"channel":@"alipay", @"maskimage":@"zhifubao_s"}, @{@"payway":@"微信支付", @"image":@"weizhifu", @"channel":@"wx", @"maskimage":@"weizhifu_s"}];
    self.payChannel = [[arr objectAtIndex:indexPath.item] valueForKey:@"channel"];
}
#pragma mark ----------------UICollectionViewDelegateFlowLayout----------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 50, 20, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
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
                //生成支付订单
            if ([[info valueForKey:kNotificationName] isEqualToString:REQUEST_POST_ADDORDER]) {
                
                ConfirmOrderViewController * __weak weakSelf = self;
//                [EMBus callData:[@"appdelegate/AppDelegate/payOrder" lowercaseString] param:, nil]
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[respData valueForKey:kMessage]];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:[info valueForKey:kRespContent]];
    }
}

@end
