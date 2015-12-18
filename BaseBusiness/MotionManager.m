//
//  MotionManager.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/29.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "MotionManager.h"
@interface MotionManager ()

@property (nonatomic, copy) MotionHandler motionHandler;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation MotionManager

+ (id)sharedInstance {
    static MotionManager *this = nil;
    if (!this) {
        this = [[MotionManager alloc] init];
    }
    return this;
}

- (instancetype)init {
    if (self = [super init]) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)startMotionWithHandler:(MotionHandler)motionHandler {
    self.motionHandler = motionHandler;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
    float updateInterval = 1/60.0;
    CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryCorrectedZVertical;
    [self.motionManager setDeviceMotionUpdateInterval:updateInterval];
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:frame
                                                           toQueue:[NSOperationQueue currentQueue]
                                                       withHandler:
     ^(CMDeviceMotion* motion, NSError* error){
         [self outputGravityData:motion];
     }];
    
}

- (void)stopMotion {
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopGyroUpdates];
}

#pragma mark ----------------功能函数----------------

- (void)outputGravityData:(CMDeviceMotion *)motion {
        //. Gravity 获取手机的重力值在各个方向上的分量，根据这个就可以获得手机的空间位置，倾斜角度等
    double gravityX = motion.gravity.x;
    double gravityY = motion.gravity.y;
    double gravityZ = motion.gravity.z;
    
        //获取手机的倾斜角度：    zTheta是手机与水平面的夹角， xyTheta是手机绕自身旋转的角度, xTheta是手机与水平面的夹角
//    double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
////    NSLog(@"x:%lf y:%lf z:%lf", gravityX, gravityY, gravityZ);
//
//    double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
    double xTheta = acos(gravityX)/M_PI*180.0;
//    NSLog(@"zTheta%lf  xyTheta%lf", zTheta, xyTheta);
//    NSLog(@"xTheta%lf", xTheta);
    NSDictionary *dic = @{@"xTheta": @(xTheta)};
    if (self.motionHandler) {
        self.motionHandler(dic);
    }
}
-(void)outputAccelertionData:(CMAcceleration)acceleration
{
//    NSLog(@"x:%lf y:%lf z:%lf", acceleration.x, acceleration.y, acceleration.z);
}
-(void)outputRotationData:(CMRotationRate)rotation
{
//    NSLog(@"x1:%.3lf y1:%.3lf z1:%.3lf", rotation.x, rotation.y, rotation.z);

}

@end
