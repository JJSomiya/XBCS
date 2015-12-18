//
//  ConfirmOrderViewController.h
//  ProductBU
//
//  Created by Somiya on 15/11/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface ConfirmOrderViewController : LHRootViewController
@property (nonatomic, strong) NSArray *productsArr;
@property (nonatomic, assign) float totalMoney;
@property (nonatomic, strong) CheckBoxView *checkBoxView;

+ (instancetype)sharedInstance;
- (void)changeCheckBoxSelectedState:(CouponObject *)coupon;
@end
