//
//  OrderCollectionViewCell.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/4.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "OrderCollectionViewCell.h"
@interface OrderCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet OrderButton *butn1;
@property (weak, nonatomic) IBOutlet OrderButton *butn2;
@property (weak, nonatomic) IBOutlet OrderButton *butn3;

@end
@implementation OrderCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object {
    [super configureWithIndexPath:indexPath object:object];
    OrderObject *order = (OrderObject *)self.object;
    self.createTimeLabel.text = order.createTime;
    ServiceObject *serviceObj = [order.services objectAtIndex:0];
    self.serviceNameLabel.text = serviceObj.serviceName;
    switch ([order.status integerValue]) {
        case OrderStatusPaid: {
            self.statusLabel.text = @"已付款";
            self.statusLabel.textColor = RGB_HEX(0x80c269);
            self.butn1.hidden = YES;
            self.butn2.hidden = YES;
            [self.butn3 setTitle:@"  联系客服  " forState:UIControlStateNormal];
            [self.butn3 setCustomButntintColor:RGB_HEX(0x4a4a4a)];
            [self.butn3 setBackgroundColor:[UIColor whiteColor]];
            break;
        }
        case OrderStatusUnpaid: {
            self.statusLabel.text = @"未付款";
            self.statusLabel.textColor = RGB_HEX(0x4a4a4a);
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
            self.statusLabel.text = @"已退款";
            self.statusLabel.textColor = RGB_HEX(0x4a4a4a);
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
