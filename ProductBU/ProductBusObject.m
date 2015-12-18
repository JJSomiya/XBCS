//
//  ProductBusObject.m
//  ProductBU
//
//  Created by Somiya on 15/11/23.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ProductBusObject.h"
#import "ConfirmOrderViewController.h"

@implementation ProductBusObject
-(id)initWithHost:(NSString *)host {
    if (self = [super initWithHost:host]) {
        {
        
        }
    }
    return self;
}

- (id)doDataJob:(NSString *)businessName params:(NSArray *)params {
    NSObject *result = NULL;
    if ([businessName isEqualToString:[@"product/ConfirmOrderViewController/changeCheckBoxState" lowercaseString]]) {
        CouponObject *coupon = params[0];
        ConfirmOrderViewController *confirmOrderVC = [ConfirmOrderViewController sharedInstance];
        [confirmOrderVC changeCheckBoxSelectedState:coupon];
    }
    return result;
}
@end
