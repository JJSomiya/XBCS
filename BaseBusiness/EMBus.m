//
//  EMBus.m
//  EMBussiness
//
//  Created by gjz on 15/9/1.
//  Copyright (c) 2015年 gjz. All rights reserved.
//

#import "EMBus.h"
#import <libkern/OSAtomic.h>

@interface EMBus  ()

@property (nonatomic, strong) NSMutableDictionary *dataBusObjectMap;

@end

static EMBus *g_bus;

@implementation EMBus
+ (void)initializeBusIfNeed {
    if (g_bus == NULL) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            g_bus = [[EMBus alloc] init];
        });
    }
}

+ (EMBus *)sharedInstance {
    [EMBus initializeBusIfNeed];
    return g_bus;
}

+ (EMBusObject *)busObjectForName:(NSString *)bizName {
    OSSpinLock spinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&spinLock);
    
    NSDictionary *busObjectMap = [EMBus sharedInstance].dataBusObjectMap;
    
    NSArray *hostList = [busObjectMap allKeys];
    NSString *findKey = nil;
    for (NSString *aKey in hostList) {
        if ([[bizName lowercaseString] hasPrefix:[aKey lowercaseString]]) {
            findKey = aKey;
            break;
        }
    }
    EMBusObject *busObj = [busObjectMap valueForKey:findKey];
    OSSpinLockUnlock(&spinLock);
    
    if (![busObj isKindOfClass:[EMBusObject class]]) {
//        NSAssert(false, @"找不到bizName:[%@]对应的busObject",bizName);
    }
    
    return busObj;
}

- (id)init {
    if (self = [super init]) {
        self.dataBusObjectMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (void)register:(EMBusObject *)busObj {
    OSSpinLock spinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&spinLock);
    if ([[EMBus sharedInstance].dataBusObjectMap valueForKey:busObj.businessNamePrefixAndURLHost]) {
        NSAssert(false, @"host名=[%@]已注册，不可重复注册", busObj.businessNamePrefixAndURLHost);
    }
    [[EMBus sharedInstance].dataBusObjectMap setValue:busObj forKey:busObj.businessNamePrefixAndURLHost];
    OSSpinLockUnlock(&spinLock);
}

+ (id)callData:(NSString *)bizName param:(NSObject *)param, ... NS_REQUIRES_NIL_TERMINATION {
    EMBusObject *busObj = [EMBus busObjectForName:bizName];
    
    NSMutableArray *paramArr = nil;
    id eachItem;
    va_list argumentList;
    if (param != nil) {
        paramArr = [NSMutableArray array];
        
        [paramArr addObject: param];
        va_start(argumentList, param);
        while((eachItem = va_arg(argumentList, id))) {
            [paramArr addObject: eachItem];
        }
        va_end(argumentList);
    }
    
    id ret = [busObj doDataJob:bizName params:paramArr];
    return ret;
}

+ (void)asyncCallData:(NSString *)bizName
               result:(AsyncCallResult)result
                param:(NSObject *)param,... NS_REQUIRES_NIL_TERMINATION {
    
    EMBusObject *busObj = [EMBus busObjectForName:bizName];
    
    NSMutableArray *paramArr = nil;
    id eachItem;
    va_list argumentList;
    if (param != nil) {
        paramArr = [NSMutableArray array];
        [paramArr addObject: param];
        va_start(argumentList, param);
        while((eachItem = va_arg(argumentList, id))) {
            [paramArr addObject: eachItem];
        }
        va_end(argumentList);
    }
    
    [busObj doAsyncDataJob:bizName params:paramArr resultBlock:result];
}


+ (id)callURL:(NSURL *)url {
    
    NSString *host = [url host];
    EMBusObject *busObj = [EMBus busObjectForName:host];
    return [busObj doURLJob:url];
}

+ (void)asyncCallURL:(NSURL *)url result:(AsyncCallResult)result {
    NSString *host = [url host];
    EMBusObject *busObj = [EMBus busObjectForName:host];
    [busObj doAsyncURLJob:url resultBlock:result];
}

@end

