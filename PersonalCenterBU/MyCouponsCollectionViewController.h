//
//  MyCouponsCollectionViewController.h
//  PersonalCenterBU
//
//  Created by Somiya on 15/12/16.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface MyCouponsCollectionViewController : LHCollectionViewController
@property (nonatomic, assign) NSInteger from; //0从产品服务跳转  1从个人中心跳转
@property (nonatomic, strong) CouponObject *selectedCoupon;
@property (nonatomic, copy) void (^selectedConponBlock)(CouponObject *conpon);
@end
