//
//  EMBusManager.m
//  EMBussiness
//
//  Created by gjz on 15/9/1.
//  Copyright (c) 2015年 gjz. All rights reserved.
//

#import "EMBusManager.h"
#import "EMBusObject.h"
#import "EMBus.h"

@implementation EMBusManager

+ (void)registerAllBuses {
    NSDictionary *busMap = @{    @"LoginOutBusObject":@"loginout",
                                 @"PersonalCenterBusObject":@"personalcenter",
                                 @"ProductBusObject":@"product",
                                 @"FinancialStatisticBusObject":@"financialstatistic",
                                 @"AppDelegateBusObject":@"appdelegate"
                                 };
    
    [busMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {        
        EMBusObject *busObject = [[NSClassFromString((NSString *)key) alloc] initWithHost:(NSString *)obj];
        [EMBus register:busObject];
    }];
}

@end
