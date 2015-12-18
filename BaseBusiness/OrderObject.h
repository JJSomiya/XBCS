//
//  OrderObject.h
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>
typedef NS_ENUM(NSUInteger, OrderStatus) {
    OrderStatusPaid = 1, //已付款
    OrderStatusUnpaid = 2,//未付款
    OrderStatusRefund = 3 //已退款
};

@interface OrderObject : DataObject
@property (nonatomic, strong) NSString *code; //订单唯一标识
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSArray *services;

@end
