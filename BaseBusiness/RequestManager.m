//
//  RequestManager.m
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import "RequestManager.h"
#import "DataRequest.h"
//#import "GlobalSetting.h"

static RequestManager *requestManager;
@implementation RequestManager

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

+(id)sharedRequestManager{
    if (!requestManager) {
        requestManager = [[self alloc] init];
    }
    return requestManager;
}
#pragma mark ----------------获取短信验证、token----------------
/**
 *  获取token ： 有固定在代码中的appid和key
 */
- (void)requestToken {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_TOKEN};
    
    NSDictionary *paramsDic = @{@"appid":kAPPID, @"secret":kAPPKEY};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_UTIL, REQUEST_POST_TOKEN) delegate:self params:paramsDic info:infoDic];
}

/**
 *  获取短信验证码
 *
 *  @param phone 电话号码
 */
- (void)requestVerifyCodeWithPhone:(NSString *)phone {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_GETVERIFYCODE};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"phone":phone, @"token":dic[@"token"]};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_UTIL, REQUEST_POST_GETVERIFYCODE) delegate:self params:paramsDic info:infoDic];
}

#pragma mark ----------------登录、注册、退出----------------
- (void)registerAccountWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code{
    NSDictionary *infoDic = @{@"op":REQUEST_POST_REGISTER};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"phone":phone, @"passwd":password, @"phonecode":code, @"token":dic[@"token"]};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_REGISTER) delegate:self params:paramsDic info:infoDic];
}

/**
 *  验证电话号码是否有效
 *
 *  @param phone
 */
- (void)requestVerifyPhoneNum:(NSString *)phone{
    NSDictionary *infoDic = @{@"op":REQUEST_POST_VERIFYPHONE};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"phone":phone, @"token":dic[@"token"]};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_UTIL, REQUEST_POST_VERIFYPHONE) delegate:self params:paramsDic info:infoDic];
}

-(void) requestLoginWithPhone:(NSString *)phone password:(NSString *)password {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_LOGIN};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"account":phone, @"password":password, @"token":dic[@"token"]};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_LOGIN) delegate:self params:paramsDic info:infoDic];
}

- (void)requestLoginout{
    NSDictionary *infoDic = @{@"op":REQUEST_POST_LOGOUT};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"id":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_LOGOUT) delegate:self params:paramsDic info:infoDic];
}
#pragma mark ----------------个人中心----------------
/**
 *  获取用户信息
 */
- (void)requestUserInfo {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_USERINFO};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"id":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_USERINFO) delegate:self params:paramsDic info:infoDic];
}

/**
 *  上传头像
 *
 *  @param image
 */
- (void)requestUpdateHeaderImageWithImage:(UIImage *)image {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_UPDATEHEADERIMAGE};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"id":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    [[DataRequest sharedDataRequest] uploadImageWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_UPDATEHEADERIMAGE) delegate:self params:paramsDic image:image info:infoDic];
}

/**
 *  更换密码
 *
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 */
- (void)requestChangePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_CHANGEPASSWORD};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"id":@([[GlobalSetting shareGlobalSettingInstance] userId]), @"oldpassword":oldPassword, @"password":newPassword};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_CHANGEPASSWORD) delegate:self params:paramsDic info:infoDic];
}
/**
 *  更换绑定手机号
 *
 *  @param phone 新手机号
 */
- (void)requestChangePhoneWith:(NSString *)phone verifyCode:(NSString *)code{
    NSDictionary *infoDic = @{@"op":REQUEST_POST_CHANGEPHONE};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"phone":phone, @"phonecode":code, @"token":dic[@"token"], @"id":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_CHANGEPHONE) delegate:self params:paramsDic info:infoDic];
}

/**
 *  获取订单
 */
- (void)requestMyOrders {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_MYORDER};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"userid":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_MYORDER) delegate:self params:paramsDic info:infoDic];
}

/**
 *  更新用户信息
 *
 *  @param companyName 公司名称
 *  @param address     服务地址
 *  @param linkMan     联系人
 *  @param userName    用户名
 */
- (void)requestUpdateUserInfoWithCompanyName:(NSString *)companyName address:(NSString *)address linkMan:(NSString *)linkMan userName:(NSString *)userName {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_UPDATEINFO};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"enterprise_name":companyName, @"service_address":address, @"linkman":linkMan, @"username":userName, @"token":dic[@"token"], @"id":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_UPDATEINFO) delegate:self params:paramsDic info:infoDic];
}

/**
 *  重置密码
 *
 *  @param phone    电话
 *  @param code     验证码
 *  @param password password
 */
- (void)requestRestPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_RESETPASSWORD};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"phone":phone, @"phonecode":code, @"password":password,  @"token":dic[@"token"]};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_RESETPASSWORD) delegate:self params:paramsDic info:infoDic];
}

/**
 *  获取优惠券列表
 */
- (void)requestMyConpons {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_GETCONPONS};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
//    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"user_id":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"user_id":@(0)};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_CONPON, REQUEST_POST_GETCONPONS) delegate:self params:paramsDic info:infoDic];
}

/**
 *  反馈信息
 *
 *  @param content
 */
- (void)requestSendFeedBackWithContent:(NSString *)content {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_FEEDBACK};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"content":content,@"user_id":@([[GlobalSetting shareGlobalSettingInstance] userId]),  @"token":dic[@"token"]};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ACCOUNT, REQUEST_POST_FEEDBACK) delegate:self params:paramsDic info:infoDic];
}
#pragma mark ----------------产品服务----------------
/**
 *  获取产品列表
 */
- (void)requestProductList {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_PRODUCTLIST};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"]};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_PRODUCT, REQUEST_POST_PRODUCTLIST) delegate:self params:paramsDic info:infoDic];
}

/**
 *  添加订单
 *
 *  @param channel  支付方式
 *  @param products 产品数组
 */
- (void)requestAddOrderWithChannel:(NSString *)channel products:(NSString *)products {
    NSDictionary *infoDic = @{@"op":REQUEST_POST_ADDORDER};
    NSDictionary *dic = [[GlobalSetting shareGlobalSettingInstance] csrfToken];
    if (!dic[@"token"]) {
        return;
    }
    NSDictionary *paramsDic = @{@"token":dic[@"token"], @"channel":channel, @"products":products, @"user_id":@([[GlobalSetting shareGlobalSettingInstance] userId])};
    [[DataRequest sharedDataRequest] postDataWithUrl:kHOST_URL(REQUEST_MODULE_ORDER, REQUEST_POST_ADDORDER) delegate:self params:paramsDic info:infoDic];
}

#pragma mark ----------------TEST----------------
- (void)requestTest {
    NSDictionary *infoDic = @{@"op":@"test"};
    [[DataRequest sharedDataRequest] postDataWithUrl:@"http://192.168.1.108/git/ios/index.php/home/pay/paymon" delegate:self params:nil info:infoDic];
}
#pragma mark -
-(void)cancelRequestWithObject:(id)sender{
    [[DataRequest sharedDataRequest] cancelRequest];
}

@end
