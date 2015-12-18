//
//  MotionManager.h
//  BaseBusiness
//
//  Created by Somiya on 15/10/29.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

typedef void (^MotionHandler)(NSDictionary *data);

@interface MotionManager : NSObject

+ (id)sharedInstance;
- (void)startMotionWithHandler:(MotionHandler)motionHandler;
- (void)stopMotion;
@end
