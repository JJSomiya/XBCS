//
//  CheckBoxCell.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxCell : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, assign) NSInteger index;

- (void)configCellContentWithDic:(NSDictionary *)dic;
@end