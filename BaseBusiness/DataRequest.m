//
//  DataRequest.m
//  mobilely
//
//  Created by Victoria on 15/1/28.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import "DataRequest.h"
#import "Reachability.h"
#import <SVProgressHUD/SVProgressHUD.h>
//#import "WPImageView.h"

static DataRequest *dataRequest;
@implementation DataRequest

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

+(DataRequest *)sharedDataRequest{
    if (!dataRequest) {
        dataRequest = [[self alloc] init];
    }
    return dataRequest;
}

+(BOOL) checkNetwork{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            return NO;
            break;
        case ReachableViaWWAN:
            return YES;
            break;
        case ReachableViaWiFi:
            return YES;
            break;
        default:
            return NO;
    }
}

//get方式访问网络
-(void) getDataWithUrl:(NSString *)urlStr delegate:(id)delegate params:(NSDictionary *)params info:(NSDictionary *)infoDic{
    if ([DataRequest checkNetwork]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        manager.requestSerializer.timeoutInterval = 5;
        [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"success",@"RespResult",@"成功获取数据！",@"ContentResult", responseObject, @"RespData", [infoDic objectForKey:@"op"], @"op",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:userInfo];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSDictionary *userInfo = nil;
            if (error.code == -1001) {
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"error",@"RespResult",@"请求超时！",@"ContentResult",error,@"RespData",[infoDic objectForKey:@"op"], @"op", nil];
            } else {
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"error",@"RespResult",@"网络请求失败！",@"ContentResult",error,@"RespData",[infoDic objectForKey:@"op"], @"op", nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:userInfo];
        }];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"error",@"RespResult",@"网络无法连接！",@"ContentResult",[infoDic objectForKey:@"op"], @"op", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:userInfo];
    }
}

//post方式访问网络
-(void) postDataWithUrl:(NSString *)urlStr delegate:(id)delegate params:(NSDictionary *)params info:(NSDictionary *)infoDic{
    if ([DataRequest checkNetwork]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];//[manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/html",nil]];//[NSSet setWithObject:@"text/html"];//
//        manager.
//        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.requestSerializer.timeoutInterval = 5;
        [manager POST:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"success",@"RespResult",@"成功获取数据！",@"ContentResult", responseObject, @"RespData", [infoDic objectForKey:@"op"], @"op",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:userInfo];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error.description);
            NSLog(@"Error: %@", error.debugDescription);
            NSDictionary *userInfo = nil;
            if (error.code == -1001) {
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"error",@"RespResult",@"请求超时！",@"ContentResult",error,@"RespData",[infoDic objectForKey:@"op"], @"op", nil];
            } else {
                userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"error",@"RespResult",@"网络请求失败！",@"ContentResult",error,@"RespData",[infoDic objectForKey:@"op"], @"op", nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:userInfo];
        }];
    } else {
        NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"error",@"RespResult",@"网络无法连接！",@"ContentResult", [infoDic objectForKey:@"op"], @"op",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:result];
    }
}


- (void)uploadImageWithUrl:(NSString *)url delegate:(id)delegate params:(NSDictionary *)params image:(UIImage *)image info:(NSDictionary *)infoDic {
    if ([DataRequest checkNetwork]) {
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSError *error = nil;
        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            NSInteger length = imageData.length;
            if (length > 1048576) {
                CGFloat packRate = 1048576.0/length;
                imageData = UIImageJPEGRepresentation(image, packRate);
            }
            
            [formData appendPartWithFileData:imageData
                                        name:@"upimg"
                                    fileName:@"upimg.jpg"
                                    mimeType:@"image/jpeg"];
        } error:&error];
        // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:[NSArray arrayWithObjects:@"text/plain", @"text/html",nil]];
        
        AFHTTPRequestOperation *operation =
        [manager HTTPRequestOperationWithRequest:request
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             NSLog(@"Success %@", responseObject);
                                             NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"success",@"RespResult",@"上传成功！",@"ContentResult", responseObject, @"RespData", [infoDic objectForKey:@"op"], @"op",[infoDic objectForKey:@"indexPath"], @"indexPath",nil];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:userInfo];
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"Failure %@", error.description);
                                             NSDictionary *userInfo = nil;
                                             if (error.code == -1001) {
                                                 userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"error",@"RespResult",@"请求超时！",@"ContentResult",error,@"RespData",[infoDic objectForKey:@"op"], @"op",[infoDic objectForKey:@"indexPath"], @"indexPath", nil];
                                             } else {
                                                 userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"error",@"RespResult",@"上传失败！",@"ContentResult",error,@"RespData",[infoDic objectForKey:@"op"], @"op",[infoDic objectForKey:@"indexPath"], @"indexPath", nil];
                                             }
                                         }];
        
        // 4. Set the progress block of the operation.
        [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                            long long totalBytesWritten,
                                            long long totalBytesExpectedToWrite) {
            CGFloat progress = totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
            NSLog(@"Wrote %lld/%lld  %f", totalBytesWritten, totalBytesExpectedToWrite, progress);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [imageView_ setCurrentProgress:progress];
                [SVProgressHUD showProgress:progress status:@"上传图片..."];
            });
        }];
        
//        [operation setCompletionBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
//        }];
        
        // 5. Begin!
        //[operation start];
        [manager.operationQueue addOperation:operation];

    } else {
        NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"error",@"RespResult",@"网络无法连接！",@"ContentResult", [infoDic objectForKey:@"op"], @"op",[infoDic objectForKey:@"indexPath"], @"indexPath",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:[infoDic objectForKey:@"op"] object:nil userInfo:result];
    }
}

-(void)cancelRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    NSArray *operations = [manager.operationQueue operations];
}
@end
