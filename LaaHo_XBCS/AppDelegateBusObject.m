//
//  AppDelegateBusObject.m
//  LaaHo_XBCS
//
//  Created by Somiya on 15/11/23.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "AppDelegateBusObject.h"
#import "AppDelegate.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Pingpp.h"

@implementation AppDelegateBusObject
-(id)initWithHost:(NSString *)host {
    if (self = [super initWithHost:host]) {
        {
        
        }
    }
    return self;
}

- (id)doDataJob:(NSString *)businessName params:(NSArray *)params {
    NSObject *result = NULL;
    if ([businessName isEqualToString:[@"appdelegate/AppDelegate/showMainVC" lowercaseString]]) {
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        [appdelegate showMainVC];
    }
    if ([businessName isEqualToString:[@"appdelegate/AppDelegate/payOrder" lowercaseString]]) {
        NSString *charge = params[0];
        LHRootViewController *viewController = params[1];
        [Pingpp createPayment:charge viewController:viewController appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
            if ([result isEqualToString:@"success"]) {
                    // 支付成功
                
            } else {
                    // 支付失败或取消
                NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
            }
            NSLog(@"completion block: %@", result);
        }];
    }
    return result;
}

@end
