//
//  PersonalCenterBusObject.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/11/23.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PersonalCenterBusObject.h"
#import "ChangePhoneNumViewController.h"
#import "MyOrdersViewController.h"
#import "MeCollectionViewController.h"
#import "MyCouponsCollectionViewController.h"

@implementation PersonalCenterBusObject
-(id)initWithHost:(NSString *)host {
    if (self = [super initWithHost:host]) {
        {
        
        }
    }
    return self;
}

- (id)doDataJob:(NSString *)businessName params:(NSArray *)params {
    NSObject *result = NULL;
    if ([businessName isEqualToString:[@"personalcenter/ChangePhoneNumViewController/changeRestPassword" lowercaseString]]) {
        UIViewController *vc = params[0];
        NSString *phone = params[1];
//        NSInteger type = [params[2] integerValue];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
        ChangePhoneNumViewController *resetPasswoerdVC = [storyboard instantiateViewControllerWithIdentifier:@"changephonevc"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:resetPasswoerdVC];
        resetPasswoerdVC.phone = phone;
        resetPasswoerdVC.type = 110;
        [vc presentViewController:navi animated:YES completion:nil];
    }
    if ([businessName isEqualToString:[@"personalcenter/MyOrdersViewController/showMyOrders" lowercaseString]]) {
        MeCollectionViewController *meVC = (MeCollectionViewController *)params[0];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
        MyOrdersViewController *orderVC = [storyboard instantiateViewControllerWithIdentifier:@"ordervc"];
        
        [meVC.navigationController pushViewController:orderVC animated:YES];
    }
    if ([businessName isEqualToString:[@"personalcenter/MyCouponsCollectionViewController/showMyCoupons" lowercaseString]]) {
        UIViewController *vc = params[0];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil];
        MyCouponsCollectionViewController *myCoupons = [storyboard instantiateViewControllerWithIdentifier:@"couponsvc"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:myCoupons];
        myCoupons.from = 0;
        if (params.count > 1) {
            CouponObject *coupon = params[1];
            myCoupons.selectedCoupon = coupon;
        }
        [vc presentViewController:navi animated:YES completion:nil];
    }
    return result;
}
@end
