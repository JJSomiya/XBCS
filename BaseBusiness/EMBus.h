//
//  EMBus.h
//  EMBussiness
//
//  Created by gjz on 15/9/1.
//  Copyright (c) 2015年 gjz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMBusObject.h"

@interface EMBus : NSObject


/**
 *  各业务BU注册busOjbect到总线，方便接收总线发起的调用
 *
 *  @param busObj     业务模块的busObject
 */
+ (void)register:(EMBusObject *)busObj;

/**
 *  数据总线，跨业务模块同步调用
 *
 *  @param binuessName   业务名
 *  @param param         调用所带参数，可变长参数，注意参数均为Object类型
 *
 *  @return 同步调用返回的结果
 */
+ (id)callData:(NSString *)buinessName param:(NSObject *)param, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  数据总线，跨业务模块异步调用
 *
 *  @param bizName   业务名
 *  @param param     调用所带参数，可变长参数，注意参数均为Object类型
 *  @param result    异步处理完成，所带的参数，出错的时候error不为空
 */
+ (void)asyncCallData:(NSString *)bizName
               result:(AsyncCallResult)result
                param:(NSObject *)paramDict,... NS_REQUIRES_NIL_TERMINATION;


/**
 *  数据总线，跨业务模块使用URL schema方式同步调用
 *
 *  @param url 业务模块的URL schema, URL的host需要和注册到Bus的一致
 *  @return 同步调用返回的结果
 */

+ (id)callURL:(NSURL *)url;


/**
 *  数据总线， 跨业务模块使用URL schema方式异步调用(不推荐使用)
 *
 *  @param url          业务URL schema, URL的host需要和注册到Bus的一致
 *  @param result       异步处理完成，回调数据
 */
+ (void)asyncCallURL:(NSURL *)url result:(AsyncCallResult)result;

@end
