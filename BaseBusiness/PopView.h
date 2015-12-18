//
//  PopView.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/18.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
    //渐入动画时间
#define kCTToastTipViewFadeinDuration 0.2
    //停留显示时间
#define kCTToastTipViewDisplayDuration 2.5
    //渐出动画时间
#define kCTToastTipViewFadeoutDuration 0.3

@protocol PopViewDelegate <NSObject>

- (void)filterProductWithDic:(NSDictionary *)dic;

@end

@interface PopView : UIView
@property (nonatomic, weak) id<PopViewDelegate>delegate;
+ (PopView *)sharedPopView;
- (void)forceHide;
- (void)showPopViewWithDataSource:(NSMutableArray *)dataSource atPoint:(CGPoint)point inView:(UIView *)view;
@end
