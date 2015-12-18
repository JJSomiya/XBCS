//
//  JSGridViewCell.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/11.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSGridViewCell : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, readonly) NSString *reuseIdentifier;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
