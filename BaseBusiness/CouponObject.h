//
//  CouponObject.h
//  BaseBusiness
//
//  Created by Somiya on 15/12/16.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface CouponObject : DataObject
@property (nonatomic, strong) NSString *couponId; //优惠券ID
@property (nonatomic, strong) NSString *typeId; //类型ID
@property (nonatomic, strong) NSString *status; //有无被领取，有无使用，1为未领取，2为已领取，3为已使用
@property (nonatomic, strong) NSString *code; //优惠码
@property (nonatomic, strong) NSString *parvalue; //面额
@property (nonatomic, strong) NSString *createTime; //优惠券生成时间
@property (nonatomic, strong) NSString *startTime; //生效时间
@property (nonatomic, strong) NSString *endTime; //截止时间
@property (nonatomic, strong) NSString *type; //发送方式 ：1为二维码，2为优惠码
@end
