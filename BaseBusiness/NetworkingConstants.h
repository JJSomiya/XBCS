//
//  NetworkingConstants.h
//  BaseBusiness
//
//  Created by Somiya on 15/12/1.
//  Copyright © 2015年 Somiya. All rights reserved.
//
/**
 *  网络相关常量
 */
#import <Foundation/Foundation.h>
#ifndef NetworkingConstants_h
#define NetworkingConstants_h

/*
'CODE'    =>      Array(
        1       =>      '请求失败',
        -1      =>      '未知错误',
        20000   =>      'TOKEN 验证失败错误',
        0       =>      '成功',
 
        // 1**** 表示与查询数据库有关，定义产品服务代码
        10000   =>      '数据库查询成功',
        10001   =>      '数据库查询失败',
        10002   =>      '没有这个服务，请检查ID是否错误',
 
        // 2**** 定义与用户个人相关代码
        20001   =>      '没有这个用户，请检查id',
        20002   =>      '没有图片',
        20003   =>      '更换头像失败',
        20004   =>      '用户名或密码错误',
        20005   =>      '请先登录',
        20006   =>      '您还没有订单',
 
        // 9**** 定义其他杂项代码
        90001   =>      '发送短信验证码成功',
        90002   =>      '电话号码有误',
        90003   =>      '短信验证码填写不争取',
        90004   =>      '无效的appid或者secret',
        90005   =>      'token已过期'
 )
 */

typedef NS_ENUM(NSUInteger, ResponseCode) {
    ResponseCodeFailure             = 1,
    ResponseCodeUnknown             = -1,
    ResponseCodeSuccess             = 0,
    ResponseCode10000               = 10000,
    ResponseCode10001               = 10001,
    ResponseCode10002               = 10002,
    ResponseCode20001               = 20001,
    ResponseCode20002               = 20002,
    ResponseCode20003               = 20003,
    ResponseCode20004               = 20004,
    ResponseCode20005               = 20005,
    ResponseCode20006               = 20006,
    ResponseCode90001               = 90001,
    ResponseCode90002               = 90002,
    ResponseCode90003               = 90003,
    ResponseCode90004               = 90004,
    ResponseCode90005               = 90005
};

/** 用来请求token **/
#define kAPPID                                  @"laaho"
#define kAPPKEY                                 @"laaho"

/** host **/
#define kBASE_URL_TEST                          @"http://139.196.111.194/api/index.php/home"
#define kBASE_URL                               @"http://www.laaho.com/app_front/index.php/home"
#define kHOST_URL(module, op)                   ([NSString stringWithFormat:@"%@/%@/%@", kBASE_URL_TEST, module, op])
#define kBASE_URL_PRODUCT_IMAGE(name)           ([NSString stringWithFormat:@"http://139.196.111.194/api/Public/uploads/products/%@", name])

/** 登录/注册/注销/用户中心 **/
#define REQUEST_MODULE_ACCOUNT                  @"user"
    //module --> user
#define REQUEST_POST_LOGIN                      @"login"
#define REQUEST_POST_REGISTER                   @"register"
#define REQUEST_POST_LOGOUT                     @"logout"
#define REQUEST_POST_GETUSERINFO                @"getUserInfo"
#define REQUEST_POST_UPDATEHEADERIMAGE          @"updateHeaderImg"
#define REQUEST_POST_MYORDER                    @"myorder"
#define REQUEST_POST_CHANGEPASSWORD             @"changePasswd"
#define REQUEST_POST_CHANGEPHONE                @"changePhone"
#define REQUEST_POST_VERIFYPHONE                @"validatephone"
#define REQUEST_POST_USERINFO                   @"getUserInfo"
#define REQUEST_POST_UPDATEINFO                 @"updateInfo"
#define REQUEST_POST_RESETPASSWORD              @"resetPasswd"
#define REQUEST_POST_FEEDBACK                   @"feedback"

#define REQUEST_MODULE_UTIL                     @"Util"
    //module --> util
#define REQUEST_POST_GETVERIFYCODE              @"sendVerifyCode"
#define REQUEST_POST_TOKEN                      @"token"

#define REQUEST_MODULE_CONPON                   @"coupon"
    //module --> coupon
#define REQUEST_POST_GETCONPONS                 @"getCoupons"
/** 财务分析 **/
/** 产品服务 **/
#define REQUEST_MODULE_PRODUCT                  @"products"
    //module --> product
#define REQUEST_POST_PRODUCTLIST                @"productslist"

#define REQUEST_MODULE_ORDER                    @"order"
    //module --> order
#define REQUEST_POST_ADDORDER                   @"addOrder"
#endif /* NetworkingConstants_h */
