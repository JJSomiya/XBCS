//
//  BaseServiceObject.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "BaseServiceObject.h"

@implementation BaseServiceObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
//    dic = [dic mtl_dictionaryByAddingEntriesFromDictionary:@{
//                                                             @"type":@"type"
//                                                             }];
    return dic;
}

@end
