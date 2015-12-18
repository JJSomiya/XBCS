//
//  JSTextView.h
//  BaseBusiness
//
//  Created by Somiya on 15/10/21.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSTextView : UIView
- (NSString *)content;
/**
 *  初始化自定义的textView
 *
 *  @param frame           frame
 *  @param prompt          提示语
 *  @param leftImage       左边的提示图片
 *  @param limitCharacters 限制字数
 *
 *  @return 返回自定义的textView
 */
//+ (JSTextView *)textViewWithFrame:(CGRect)frame prompt:(NSString *)prompt leftImage:(UIImage *)leftImage andLimitCharacters:(NSInteger)limitCharacters;
/**
 *  初始化自定义的textView
 *
 *  @param frame           frame
 *  @param prompt          提示语
 *  @param limitCharacters 限制字数
 *
 *  @return 返回自定义的textView
 */
+ (JSTextView *)textViewWithFrame:(CGRect)frame prompt:(NSString *)prompt andLimitCharacters:(NSInteger)limitCharacters;

@end
