//
//  EMBusObject+EMBusUtil.m
//  EMBusiness
//
//  Created by gjz on 15/9/21.
//  Copyright (c) 2015年 gjz. All rights reserved.
//

#import "EMBusObject+EMBusUtil.h"

@implementation EMBusObject (EMBusUtil)

-(NSObject *)retrievalProperty:(NSObject *)source
                  withProperty:(NSString *)requestString {
    NSObject *result = NULL;
    
    //获取请求数组
    NSMutableArray *destinationArray = [self retrievalRequestArray:requestString];
    
    if ([destinationArray count] == 0) {
        //只是单纯请求passportUtility
        return source;
    }
    else {
        //取出第一个请求参数，并获取结果放入result
        NSString *requestString = [destinationArray objectAtIndex:0];
        result = [source valueForKey:requestString];
        [destinationArray removeObjectAtIndex:0];
        
        //循环取出下层的请求参数，并放入result
        while ([destinationArray count] > 0) {
            requestString = [destinationArray objectAtIndex:0];
            
            result = [result valueForKey:requestString];
            
            [destinationArray removeObjectAtIndex:0];
        }
    }
    
    
    return result;
}

-(NSObject *)setObject:(NSObject *)source
          withProperty:(NSString *)requestString
             withValue:(NSObject *)value{
    
    //获取请求数组
    NSMutableArray *destinationArray = [self retrievalRequestArray:requestString];
    
    if ([destinationArray count] == 0) {
        //只是单纯请求passportUtility
        return @(NO);
    }
    else {
        
        NSObject *result = source;
        //循环取出下层的请求参数，并放入result
        while ([destinationArray count] > 1) {
            requestString = [destinationArray objectAtIndex:0];
            
            result = [result valueForKey:requestString];
            
            [destinationArray removeObjectAtIndex:0];
        }

        requestString = [destinationArray objectAtIndex:0];
        
        [result setValue:value forKey:requestString];
        
        
    }
    
    return @(YES);

}

-(NSMutableArray *)retrievalRequestArray:(NSString *)requestString {
    //获取请求数组
    NSArray *requestArray = [requestString componentsSeparatedByString:@"/"];
    //对请求数组进行处理
    NSMutableArray *destinationArray = [requestArray mutableCopy];
    //删除前两个请求的内容
    [destinationArray removeObjectAtIndex:0];
    [destinationArray removeObjectAtIndex:0];
    return destinationArray;
}

@end
