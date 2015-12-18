//
//  LHRootViewController.h
//  BaseBusiness
//
//  Created by Somiya on 15/10/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHRootViewController : UIViewController
@property (nonatomic, strong) UIImageView *bgImageView;
/**
 *  初始化数据
 */
- (void)initBaseData;

/**
 *  初始化视图
 */
- (void)initBaseView;

//#pragma mark 返回按钮点击
///**
// 返回按钮点击
// 特殊情况可以重载此方法
// 
// @param sender     返回按钮对象
// */
//- (void)backBarButtonClicked:(id)sender;
@end
