//
//  GlobalSetting.h
//  mobilely
//
//  Created by Victoria on 15/2/2.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#define kUserInfo       @"userInfo"
#define KUserId         @"uid"
#define KAutoLogin      @"AutoLogin"
#define KLoginState     @"LoginState"
#define KPasswordState  @"PasswordState"
#define KCsrfToken      @"CsrfToken"
#define KIsFirst        @"isfisrt"
#define kPassword       @"password"
#define kLoginAccount    @"loginAccount"

#define KUserAddressInfoId @"UserAddressInfoId"
#define KReceiverName   @"ReceiverName"
#define KReceiverPhone  @"ReceiverPhone"
#define KProvinceId     @"ProvinceId"
#define KProvince       @"Province"
#define KCityId         @"CityId"
#define KCity           @"City"
#define KDistrictId     @"DistrictId"
#define KDistrict       @"District"
#define KDetailAddress  @"DetailAddress"

#define KViolationHistory @"ViolationHistory"
#define KAccumulationFundHistory @"AccumulationFundHistory"
#define KSocialSecurityHistory @"SocialSecurityHistory"

#define KIKnow          @"IKnow"

#define KIsScroll       @"IsScroll"

#import <UIKit/UIKit.h>
#import "UserObject.h"

@interface GlobalSetting : NSObject

/**
 *  返回一个全局设置的类的单例
 *
 *  @return
 */
+(GlobalSetting *)shareGlobalSettingInstance;

/**
 *  返回一个颜色值
 *
 *  @return
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString;

/**
 *  设置登录用户信息
 *
 *  @param user
 */
- (void)setUser:(UserObject *)user;
/**
 *  获取用户信息
 *
 *  @return 
 */
- (UserObject *)getUser;

/**
 *  用户登录账号
 *
 *  @param account
 */
- (void)setLoginAccount:(NSString *)account;

- (NSString *)loginAccount;
/**
 *  获取当前的登录状态
 *
 *  @return
 */
-(BOOL) loginState;

/**
 *  设置当前的登录状态
 *
 *  @param loginState
 */
-(void) setLoginState:(BOOL)loginState;

/**
 *  获取登录密码
 *
 *  @return
 */
-(NSString *)password;

/**
 *  设置登录密码
 *
 *  @param password
 */
-(void)setPassword:(NSString *)password;

- (NSInteger)userId;
/**
 *  保存userID
 *
 *  @param userId
 */
- (void)setUserId:(NSInteger)userId;

/**
 *  获取当前记住密码的状态
 *
 *  @return  1已记住 0未记住
 */
-(BOOL)passwordState;

/**
 *  设置是否记住密码
 *
 *  @param passwordState 1记住 0记住
 */
-(void) setPasswordState:(BOOL)passwordState;

/**
 *  是否自动登录
 *
 *  @return
 */
-(BOOL)autoLogin;

/**
 *  是否设置为自动登录
 *
 *  @param autoLogin
 */
-(void)autoLoginOrNot:(BOOL)autoLogin;

/**
 *  获取当前的校验串
 *
 *  @return
 */
-(NSDictionary *)csrfToken;

/**
 *  设置检验串
 *
 *  @param csrfToken
 */
-(void)setCsrfToken:(NSDictionary *)csrfToken;

/**
 *  在我要提问的模块，设置一个字典存储各个界面的参数到userDefault，到最后发布时使用
 *
 *  @param PubQuestionDic 
 */
-(void)setPubQuestionDic:(NSDictionary *)pubQuestionDic;
/**
 *  获取存储字典
 *
 *  @return PubQuestionDic
 */


/**
 *  设置用户地址信息id
 *
 *  @param infoId infoId
 */
-(void)setUserAddressInfoId:(NSString*)infoId;

/**
 *  获取用户地址信息id
 *
 *  @return infoId
 */
-(NSString*)userAddressInfoId;

/**
 *  设置收货人姓名
 *
 *  @param name 姓名
 */
-(void)setReceiveName:(NSString*)name;

/**
 *  获取收货人姓名
 *
 *  @return 姓名
 */
-(NSString*)receiveName;

/**
 *  设置收货人电话
 *
 *  @param phone 电话
 */
-(void)setReceivePhone:(NSString*)phone;

/**
 *  获取收货人电话
 *
 *  @return 电话
 */
-(NSString*)receivePhone;

/**
 *  设置省ID
 *
 *  @param provinceId 省ID
 */
-(void)setProvinceId:(NSString*)provinceId;

/**
 *  获取省ID
 *
 *  @return 省ID
 */
-(NSString*)provinceId;

/**
 *  设置省
 *
 *  @param province 省
 */
-(void)setProvince:(NSString*)province;

/**
 *  获取省
 *
 *  @return 省
 */
-(NSString*)province;

/**
 *  设置市ID
 *
 *  @param cityId 市ID
 */
-(void)setCityId:(NSString*)cityId;

/**
 *  获取市ID
 *
 *  @return 市ID
 */
-(NSString*)cityId;

/**
 *  设置市
 *
 *  @param city 市
 */
-(void)setCity:(NSString*)city;

/**
 *  获取市
 *
 *  @return 市
 */
-(NSString*)city;

/**
 *  设置区ID
 *
 *  @param districtId 区ID
 */
-(void)setDistrictId:(NSString*)districtId;

/**
 *  获取区ID
 *
 *  @return 区ID
 */
-(NSString*)districtId;

/**
 *  设置区
 *
 *  @param district 区
 */
-(void)setDistrict:(NSString*)district;

/**
 *  获取区
 *
 *  @return 区
 */
-(NSString*)district;

/**
 *  设置详细地址
 *
 *  @param detailAddress 详细地址
 */
-(void)setDetailAddress:(NSString*)detailAddress;

/**
 *  获取详细地址
 *
 *  @return 详细地址
 */
-(NSString*)detailAddress;


/**
 *  是否是第一次进入应用
 *
 *  @return
 */
-(BOOL) isFirst;

/**
 *  设置第一次进入
 *
 *  @param isFirst
 */
-(void) setIsFirst:(BOOL)isFirst;

/**
*  设置违章查询历史记录
*
*  @param
*/
-(void)setViolationHistory:(NSArray*)history;

/**
 *  获取违章查询历史记录
 *
 *  @param
 */
-(NSArray*)violationHistory;

/**
 *  设置社保查询历史记录
 *
 *  @param
 */
-(void)setSocialSecurityHistory:(NSArray*)history;

/**
 *  获取社保查询历史记录
 *
 *  @param
 */
-(NSArray*)socialSecurityHistory;

/**
 *  设置公积金查询历史记录
 *
 *  @param
 */
-(void)setAccumulationFundHistory:(NSArray*)history;

/**
 *  获取公积金查询历史记录
 *
 *  @param
 */
-(NSArray*)accumulationFundHistory;

/**
 *  设置电子报浏览的指导视图
 *
 *  @param Iknowe 表示我知道了
 */
-(void) setIKnowGuide:(BOOL)Iknowe;

/**
 *  获取电子报浏览的指导视图知道状态
 *
 *  @return
 */
-(BOOL) IKnow;

-(void) setIsScroll:(BOOL)isScroll;

-(BOOL) isScroll;

/**
 *  移除UserDefaults
 */
-(void)removeUserDefaultsValue;

@end
