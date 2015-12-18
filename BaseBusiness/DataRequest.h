//
//  DataRequest.h
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

@interface DataRequest : NSObject

/**
 *  创建一个访问网络的单例
 *
 *  @return 返回一个访问网络的单例
 */
+(DataRequest *)sharedDataRequest;

//检查网络
+(BOOL) checkNetwork;

//get方式访问网络
-(void) getDataWithUrl:(NSString *)urlStr delegate:(id)delegate params:(NSDictionary *)params info:(NSDictionary *)infoDic;
//post方式访问网络
-(void) postDataWithUrl:(NSString *)urlStr delegate:(id)delegate params:(NSDictionary *)params info:(NSDictionary *)infoDic;
    //上传图片
- (void)uploadImageWithUrl:(NSString *)url delegate:(id)delegate params:(NSDictionary *)params image:(UIImage *)image info:(NSDictionary *)infoDic;
/////
-(void) cancelRequest;
@end
