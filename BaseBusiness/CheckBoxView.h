//
//  CheckBoxView.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckBoxCell;
@protocol CheckBoxViewDelegate;
@protocol CheckBoxViewDataSource;
@interface CheckBoxView : UIView
@property (nonatomic, weak) id<CheckBoxViewDelegate>delegate;
@property (nonatomic, weak) id<CheckBoxViewDataSource>dataSource;

//- (void)setCheckBoxViewItems:(NSArray *)items;
- (CheckBoxCell *)cellAtIndex:(NSInteger)index;
@end

@protocol CheckBoxViewDataSource <NSObject>

- (NSInteger)numberOfItems;

- (CheckBoxCell *)checkBoxView:(CheckBoxView *)checkBoxView cellAtIndex:(NSInteger)index;

- (NSString *)titleForCheckBoxView;
@end
@protocol CheckBoxViewDelegate <NSObject>

- (void)checkBoxView:(CheckBoxView *)checkBoxView didSelectedAtIndex:(NSInteger)index;

@end