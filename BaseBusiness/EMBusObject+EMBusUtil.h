//
//  EMBusObject+EMBusUtil.h
//  EMBusiness
//
//  Created by gjz on 15/9/21.
//  Copyright (c) 2015年 gjz. All rights reserved.
//

#import "EMBusObject.h"

@interface EMBusObject (EMBusUtil)

/**
 *  获取NSObject属性
 *
 *  @param source           NSObject
 *  @param requestString    属性循环请求列表，如“a/b/c/d” 代表a.b.c.d
 *
 *  @return NSObject的属性值
 */
-(NSObject *)retrievalProperty:(NSObject *)source
                  withProperty:(NSString *)requestString;

/**
 *  设置NSObject属性
 *
 *  @param source           NSObject
 *  @param requestString    属性循环请求列表，如“a/b/c/d” 代表a.b.c.d
 *  @param value            设置的NSObject属性值
 *
 *  @return 执行是否成功
 */
-(NSObject *)setObject:(NSObject *)source
          withProperty:(NSString *)requestString
             withValue:(NSObject *)value;

@end
