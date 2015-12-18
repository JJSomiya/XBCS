//
//  UserObject.h
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface UserObject : DataObject
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *headerImg;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *linkMan;
@end
