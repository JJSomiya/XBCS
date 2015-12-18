//
//  OrderObject.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "OrderObject.h"

@implementation OrderObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    dic = [dic mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                            @"code":@"code",
                                                            @"status":@"pay_or_not",
                                                            @"price":@"price",
                                                            @"userId":@"user_id",
                                                            @"createTime":@"create_time",
                                                            @"startTime":@"starttime",
                                                            @"endTime":@"endtime",
                                                            @"services":@"products"
                                                             }];
    return dic;
}

+ (NSValueTransformer *)servicesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ServiceObject class]];
}
@end
