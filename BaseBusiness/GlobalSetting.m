//
//  GlobalSetting.m
//  mobilely
//
//  Created by Victoria on 15/2/2.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import "GlobalSetting.h"
static GlobalSetting *globalSetting;
@implementation GlobalSetting

-(instancetype)init{
    if ([super init]) {
        
    }
    return self;
}

+(GlobalSetting *)shareGlobalSettingInstance{
    if (!globalSetting) {
        globalSetting = [[self alloc] init];
    }
    return globalSetting;
}

+ (UIColor *) colorWithHexString: (NSString *) hexString

{
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    
    CGFloat alpha = 0.0f;
    CGFloat red = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat green = 0.0f;
    
    switch ([colorString length]) {
            
        case 3: // #RGB
            
            alpha = 1.0f;
            
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            
            break;
            
        case 4: // #ARGB
            
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            
            break;
            
        case 6: // #RRGGBB
            
            alpha = 1.0f;
            
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            
            break;
            
        case 8: // #AARRGGBB
            
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            
            break;
            
        default:
            alpha = 1.0f;
            red = 0.0f;
            blue = 0.0f;
            green = 0.0f;
            break;
            
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length

{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}

- (void)setUser:(UserObject *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user forKey:kUserInfo];
    [userDefaults synchronize];
}

- (UserObject *)getUser {
    NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kUserInfo];
}

/**
 *  用户登录账号
 *
 *  @param account
 */
- (void)setLoginAccount:(NSString *)account {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:kLoginAccount];
    [userDefaults synchronize];
}

- (NSString *)loginAccount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kLoginAccount];
}

-(BOOL)loginState{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:KLoginState] boolValue];
}

-(void)setLoginState:(BOOL)loginState{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:loginState] forKey:KLoginState];
    [userDefaults synchronize];
}

/**
 *  获取登录密码
 *
 *  @return
 */
-(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kPassword];
}

/**
 *  设置登录密码
 *
 *  @param password
 */
-(void)setPassword:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:password forKey:kPassword];
    [userDefaults synchronize];
}

- (NSInteger)userId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:KUserId] integerValue];
}
/**
 *  保存userID
 *
 *  @param userId
 */
- (void)setUserId:(NSInteger)userId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(userId) forKey:KUserId];
    [userDefaults synchronize];
}


-(BOOL)passwordState{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:KPasswordState] boolValue];
}

-(void)setPasswordState:(BOOL)passwordState{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:passwordState] forKey:KPasswordState];
    [userDefaults synchronize];
}

-(BOOL)autoLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:KAutoLogin] boolValue];
}

-(void)autoLoginOrNot:(BOOL)autoLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:autoLogin] forKey:KAutoLogin];
    [userDefaults synchronize];
}

-(NSDictionary *)csrfToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KCsrfToken];
}

-(void)setCsrfToken:(NSDictionary *)csrfToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:csrfToken forKey:KCsrfToken];
    [userDefaults synchronize];
}

////我要提问模块存储的字典
//-(void)setPubQuestionDic:(NSDictionary *)pubQuestionDic
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:pubQuestionDic forKey:KPubQuestionDic];
//    [userDefaults synchronize];
//}
//-(NSDictionary *)pubQuestionDic{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    return [userDefaults valueForKey:KPubQuestionDic];
//}


-(void)setUserAddressInfoId:(NSString*)infoId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:infoId forKey:KUserAddressInfoId];
    [userDefaults synchronize];

}

-(NSString*)userAddressInfoId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KUserAddressInfoId];
}

-(void)setReceiveName:(NSString*)name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:KReceiverName];
    [userDefaults synchronize];
}

-(NSString*)receiveName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KReceiverName];
}

-(void)setReceivePhone:(NSString*)phone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phone forKey:KReceiverPhone];
    [userDefaults synchronize];
}

-(NSString*)receivePhone{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KReceiverPhone];
}

-(void)setProvinceId:(NSString *)provinceId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:provinceId forKey:KProvinceId];
    [userDefaults synchronize];
}

-(NSString *)provinceId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KProvinceId];
}

-(void)setProvince:(NSString*)province{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:province forKey:KProvince];
    [userDefaults synchronize];
}

-(NSString*)province{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KProvince];
}

-(void)setCityId:(NSString *)cityId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cityId forKey:KCityId];
    [userDefaults synchronize];
}

-(NSString *)cityId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KCityId];
}

-(void)setCity:(NSString*)city{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:city forKey:KCity];
    [userDefaults synchronize];
}

-(NSString*)city{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KCity];
}

-(void)setDistrictId:(NSString *)districtId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:districtId forKey:KDistrictId];
    [userDefaults synchronize];
}

-(NSString *)districtId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KDistrictId];
}

-(void)setDistrict:(NSString*)district{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:district forKey:KDistrict];
    [userDefaults synchronize];
}

-(NSString*)district{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KDistrict];
}

-(void)setDetailAddress:(NSString*)detailAddress{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:detailAddress forKey:KDetailAddress];
    [userDefaults synchronize];
}

-(NSString*)detailAddress{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KDetailAddress];
}

-(BOOL)isFirst{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults valueForKey:KIsFirst] boolValue];
}

-(void)setIsFirst:(BOOL)isFirst{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:isFirst] forKey:KIsFirst];
    [userDefaults synchronize];
}

-(void)setViolationHistory:(NSArray*)history{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:history forKey:KViolationHistory];
    [userDefaults synchronize];
}

-(NSArray*)violationHistory{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KViolationHistory];
}

-(void)setSocialSecurityHistory:(NSArray*)history{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:history forKey:KSocialSecurityHistory];
    [userDefaults synchronize];
}

-(NSArray*)socialSecurityHistory{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KSocialSecurityHistory];
}

-(void)setAccumulationFundHistory:(NSArray*)history{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:history forKey:KAccumulationFundHistory];
    [userDefaults synchronize];
}

-(NSArray*)accumulationFundHistory{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:KAccumulationFundHistory];
}

-(void) setIKnowGuide:(BOOL)Iknowe{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:Iknowe] forKey:KIKnow];
    [userDefaults synchronize];
}
-(BOOL) IKnow{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KIKnow];
}

-(void) setIsScroll:(BOOL)isScroll{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:isScroll] forKey:KIsScroll];
    [userDefaults synchronize];
}

-(BOOL) isScroll{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KIsScroll];
}

-(void)removeUserDefaultsValue{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@"-1" forKey:KUserId];//表示未登录
    
    [userDefaults removeObjectForKey:KUserAddressInfoId];
    
    [userDefaults removeObjectForKey:KReceiverName];
    [userDefaults removeObjectForKey:KReceiverPhone];
    
    [userDefaults removeObjectForKey:KProvince];
    [userDefaults removeObjectForKey:KProvinceId];
    
    [userDefaults removeObjectForKey:KCity];
    [userDefaults removeObjectForKey:KCityId];
    
    [userDefaults removeObjectForKey:KDistrict];
    [userDefaults removeObjectForKey:KDistrictId];
    
    [userDefaults removeObjectForKey:KDetailAddress];
    
    [userDefaults removeObjectForKey:KViolationHistory];
    [userDefaults removeObjectForKey:KAccumulationFundHistory];
    
    [userDefaults synchronize];
}

@end
