//
//  LHNavigationController.h
//  LaaHo_XBCS
//
//  Created by Somiya on 15/10/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHNavigationController : UINavigationController
@property (strong, nonatomic) UIViewController *rootViewController;
@property (nonatomic, assign) NSInteger index;
@end
