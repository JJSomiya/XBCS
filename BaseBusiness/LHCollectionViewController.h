//
//  LHCollectionViewController.h
//  BaseBusiness
//
//  Created by Somiya on 15/10/30.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCollectionViewController : UICollectionViewController
@property (nonatomic, strong) UIImageView *placeholderView;
@property (nonatomic, strong) UIImageView *bgImageView;

/**
 *  初始化数据
 */
- (void)initBaseData;

/**
 *  初始化视图
 */
- (void)initBaseView;
@end
