//
//  ServiceObject.h
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>
typedef NS_ENUM(NSUInteger, ServiceType) {
    ServiceTypeOnce = 1, //一次性服务
    ServiceTypeBase = 2, //基本服务
    ServiceTypeValueAdded = 3 //增值服务
};

@interface ServiceObject : DataObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *serviceContent;
@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *hederIcon;
@property (nonatomic, strong) NSString *productImg;
@property (nonatomic, assign) NSInteger months;
@end
