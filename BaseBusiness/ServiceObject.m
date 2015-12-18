//
//  ServiceObject.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ServiceObject.h"

@implementation ServiceObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    dic = [dic mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                             @"serviceName":@"title",
                                                             @"serviceContent":@"content",
                                                             @"serviceId":@"id",
                                                             @"price":@"price",
                                                             @"imageUrl":@"product_img",
                                                             @"serviceType":@"type",
                                                             @"hederIcon":@"header_icon",
                                                             @"productImg":@"product_img"
                                                             }];
    return dic;
}
@end
