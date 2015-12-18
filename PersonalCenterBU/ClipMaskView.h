//
//  ClipMaskView.h
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClipMaskViewDelegate <NSObject>

- (void)cancelEdit;
- (void)editDone;

@end

@interface ClipMaskView : UIView

@property (nonatomic, weak) id<ClipMaskViewDelegate> delegate;

/**
 *  开始剪切
 */
- (void)startClip;
/**
 *  结束剪切
 */
- (void)endClip;
/**
 *  设置剪切形状
 *
 *  @param rec
 */
- (void)setClippingRec:(CGRect)rec;

/**
 *  开始移动
 */
//- (void)startMove;
/**
 *  停止移动
 */
//- (void)endMove;
/**
 *  移动后的位置
 *
 *  @param position <#position description#>
 */
//- (void)setMovePosition:(CGPoint)position;
@end
