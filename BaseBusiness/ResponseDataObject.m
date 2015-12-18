//
//  ResponseDataObject.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ResponseDataObject.h"

@implementation ResponseDataObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    dic = [dic mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                             @"status":@"status",
                                                             @"message":@"msg"
                                                             }];
    return dic;
}
@end
