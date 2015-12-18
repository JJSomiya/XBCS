//
//  EMBusObject.m
//  EMBussiness
//
//  Created by gjz on 15/9/1.
//  Copyright (c) 2015年 gjz. All rights reserved.
//

#import "EMBusObject.h"

@interface EMBusObject (){
    NSString *bizNamePrefix;
    NSString *urlHost;
}

@end

@implementation EMBusObject

- (id)initWithHost:(NSString *)host {
    if (self = [super init]) {
        urlHost = [host lowercaseString];
    }
    return self;
}

- (NSString *)businessNamePrefixAndURLHost {
    return urlHost;
}

- (id)doDataJob:(NSString *)businessName params:(NSArray *)params {
    //TO BE OVERRIDE
    return NULL;
}

- (void)doAsyncDataJob:(NSString *)businessName params:(NSArray *)params resultBlock:(AsyncCallResult)result {
    
    //TO BE OVERRIDE
}

- (id)doURLJob:(NSURL *)url {
    //TO BE OVERRIDE
    return NULL;
}

- (void)doAsyncURLJob:(NSURL *)url resultBlock:(AsyncCallResult)result {
    //TO BE OVERRIDE
}

@end
