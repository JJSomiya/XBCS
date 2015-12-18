//
//  UIGestureRecognizer+FloatingHeaderUtil.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FloatingHeaderGestureCallback)(id sender);
@interface UIGestureRecognizer (FloatingHeaderUtil)

+ (id)withCallback:(FloatingHeaderGestureCallback)aCallback;
- (id)initWithCallback:(FloatingHeaderGestureCallback)aCallback;

@end
