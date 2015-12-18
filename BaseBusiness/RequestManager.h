//
//  RequestManager.h
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//



#import <Foundation/Foundation.h>
#define ERROR               @"error"
#define SUCCESS             @"success"
#define STATUS              @"status"
#define STATUS_EXIST        @"is_exist"
#define STATUS_NOTEXIST     @"not_exist"
#define STATUS_ISLOGIN      @"islogin"
#define STATUS_NOTLOGIN     @"notlogin"
#define KDATA               @"data"
#define KRESULT             @"result"
#define KCONTENT            @"content"
#define KCHECK              @"checkresult"

#define kMessage            @"msg"
#define kStatusCode         @"statusCode"

#define KRESPDATA           @"RespData"
#define kNotificationName   @"op"
#define kRespResult         @"RespResult"
#define kRespContent        @"ContentResult"

typedef void (^SuccessRequest)(NSString *phone);

typedef NS_ENUM(NSUInteger, ResultCode) {
    ResultCode101 = 101,
    ResultCode200 = 200,
    ResultCode500 = 500
};

@interface RequestManager : NSObject

/**
 *  初始化RequestManager的一个单例
 *
 *  @return RequestManager的一个单例
 */
+(id) sharedRequestManager;
#pragma mark ----------------获取短信验证、token----------------
/**
 *  获取token ： 有固定在代码中的appid和key
 */
- (void)requestToken;

/**
 *  获取短信验证码
 *
 *  @param phone 电话号码
 */
- (void)requestVerifyCodeWithPhone:(NSString *)phone;
#pragma mark ----------------登录/注册/注销----------------
/**
 *  注册账号
 *
 *  @param phone      用户电话
 *  @param password   密码
 *  @param code       验证码
 */
- (void)registerAccountWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code;

/**
 *  验证电话号码是否有效
 *
 *  @param phone
 */
- (void)requestVerifyPhoneNum:(NSString *)phone;

/**
 *  用户登录
 *
 *  @param phone 用户名或电话号码
 *  @param password 密码
 */
- (void)requestLoginWithPhone:(NSString *)phone password:(NSString *)password;

/**
 *  退出登录
 */
- (void)requestLoginout;

#pragma mark ----------------个人中心----------------
/**
 *  获取用户信息
 */
- (void)requestUserInfo;
/**
 *  上传头像
 *
 *  @param image
 */
- (void)requestUpdateHeaderImageWithImage:(UIImage *)image;
/**
 *  更换密码
 *
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 */
- (void)requestChangePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;
/**
 *  更换绑定手机号
 *
 *  @param phone 新手机号
 *  @param code  验证码
 */
- (void)requestChangePhoneWith:(NSString *)phone verifyCode:(NSString *)code;
/**
 *  获取订单
 */
- (void)requestMyOrders;
/**
 *  更新用户信息
 *
 *  @param companyName 公司名称
 *  @param address     服务地址
 *  @param linkMan     联系人
 *  @param userName    用户名
 */
- (void)requestUpdateUserInfoWithCompanyName:(NSString *)companyName address:(NSString *)address linkMan:(NSString *)linkMan userName:(NSString *)userName;
/**
 *  重置密码
 *
 *  @param phone    电话
 *  @param code     验证码
 *  @param password password
 */
- (void)requestRestPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password;
/**
 *  获取优惠券列表
 */
- (void)requestMyConpons;
/**
 *  反馈信息
 *
 *  @param content
 */
- (void)requestSendFeedBackWithContent:(NSString *)content;
#pragma mark ----------------产品服务----------------
/**
 *  获取产品列表
 */
- (void)requestProductList;
/**
 *  添加订单
 *
 *  @param channel  支付方式
 *  @param products 产品数组
 */
- (void)requestAddOrderWithChannel:(NSString *)channel products:(NSString *)products;
#pragma mark ----------------TEST----------------
- (void)requestTest;
-(void) cancelRequestWithObject:(id)sender;
@end
