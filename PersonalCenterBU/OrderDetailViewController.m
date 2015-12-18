//
//  OrderDetailViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/12/8.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "OrderDetailViewController.h"
@interface OrderDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *nameLabel;
- (void)configCellContentWithDic:(NSDictionary *)dic;
@end
@implementation OrderDetailTableViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width - 30, 44)];
        [self addSubview:self.nameLabel];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width - 30, 44)];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)configCellContentWithDic:(NSDictionary *)dic {
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@", [dic valueForKey:@"title"], [dic valueForKey:@"content"]];
}
@end

@interface OrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) IBOutlet OrderButton *butn1;

@property (weak, nonatomic) IBOutlet OrderButton *butn2;

@property (weak, nonatomic) IBOutlet OrderButton *butn3;

@property (strong, nonatomic) NSArray *baseDataArr;
@end

@implementation OrderDetailViewController

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
    
}
- (void)initBaseView {
    [super initBaseView];
    self.bgImageView.image = nil;
    self.view.backgroundColor = RGB_HEX(0xdce1e2);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (645.0 / 1500) * SCREENWIDTH)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (645.0 / 1500) * SCREENWIDTH)];
    imageView.image = [UIImage imageNamed:@"orderdetailheaderbg.png"];
    [view addSubview:imageView];
    self.tableView.tableHeaderView = view;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[OrderDetailTableViewCell class] forCellReuseIdentifier:@"orderdetailcell"];
    [self.view addSubview:self.tableView];
    
    self.baseDataArr = @[@{@"title":@"订单编号：", @"content":self.orderObj.code}, @{@"title":@"服务内容：", @"content":((BaseServiceObject *)[self.orderObj.services objectAtIndex:0]).serviceName}, @{@"title":@"上门服务地址：", @"content":@""}, @{@"title":@"下单时间：", @"content":self.orderObj.createTime}, @{@"title":@"服务时效：", @"content":@"3个月"}, @{@"title":@"支付金额：", @"content":self.orderObj.price}];
    [self initButnsWithOrderStatus:[self.orderObj.status integerValue]];
}

- (void)initButnsWithOrderStatus:(OrderStatus)status {
    switch (status) {
        case OrderStatusPaid: {
            self.butn1.hidden = YES;
            self.butn2.hidden = YES;
            [self.butn3 setTitle:@"  联系客服  " forState:UIControlStateNormal];
            [self.butn3 setCustomButntintColor:RGB_HEX(0x4a4a4a)];
            [self.butn3 setBackgroundColor:[UIColor whiteColor]];
            break;
        }
        case OrderStatusUnpaid: {
            [self.butn1 setTitle:@"  更换订单  " forState:UIControlStateNormal];
            [self.butn1 setCustomButntintColor:RGB_HEX(0x4a4a4a)];
            self.butn1.hidden = NO;
            [self.butn2 setTitle:@"  取消订单  " forState:UIControlStateNormal];
            [self.butn2 setCustomButntintColor:RGB_HEX(0x4a4a4a)];
            self.butn2.hidden = NO;
            [self.butn3 setTitle:@"  立即支付  " forState:UIControlStateNormal];
            [self.butn3 setCustomButntintColor:[UIColor whiteColor]];
            [self.butn3 setBackgroundColor:RGB_HEX(0x80c269)];
            break;
        }
        case OrderStatusRefund: {
            self.butn1.hidden = YES;
            self.butn2.hidden = YES;
            [self.butn3 setTitle:@"  删除  " forState:UIControlStateNormal];
            [self.butn3 setBackgroundColor:[UIColor whiteColor]];
            [self.butn3 setCustomButntintColor:RGB_HEX(0x4a4a4a)];
            break;
        }
        default:
            break;
    }
}
#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderdetailcell" forIndexPath:indexPath];
    if (!cell) {
        cell = (OrderDetailTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderdetailcell"];
    }
    [cell configCellContentWithDic:[self.baseDataArr objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
