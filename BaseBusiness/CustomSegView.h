//
//  CustomSegView.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/16.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegViewDelegate;

@interface CustomSegView : UIView

@property (nonatomic, weak) id<CustomSegViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL showSplitLine; //默认为隐藏
@property (nonatomic, strong) UIColor *selectedColor; //选中颜色
@property (nonatomic, strong) UIColor *defaultColor; //默认颜色
@property (nonatomic, strong) UIFont *font;
- (void)setSegViewItems:(NSArray *)items;
- (void)changeSelectedSegIndex:(NSInteger)index;
@end

@protocol CustomSegViewDelegate <NSObject>

@optional
- (void)customSegView:(CustomSegView *)segView didChangeItemsAtIndex:(NSInteger)index;
@end
