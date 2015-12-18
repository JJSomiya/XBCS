//
//  UserObject.m
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dic = [super JSONKeyPathsByPropertyKey];
    dic = [dic mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                             @"phone":@"phone",
                                                             @"userName":@"username",
                                                             @"password":@"password",
                                                             @"address":@"service_address",
                                                             @"company":@"enterprise_name",
                                                             @"headerImg":@"app_img",
                                                             @"linkMan":@"linkman"
                                                             }];
    return dic;
}
@end
