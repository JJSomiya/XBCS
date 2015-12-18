//
//  CouponCollectionViewCell.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/12/16.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "CouponCollectionViewCell.h"
@interface CouponCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *couponDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *parvalueLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDesLabel;
@property (nonatomic, assign) BOOL isSelected;
@end
@implementation CouponCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 3;
    self.isSelected = NO;
}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        self.selectedImageView.image = [UIImage imageNamed:@"checkboxselected.png"];
    } else {
        self.selectedImageView.image = [UIImage imageNamed:@"checkboxunselected.png"];
    }
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (self.isSelected) {
        self.isSelected = NO;
    } else {
        self.isSelected = YES;
    }
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object from:(NSInteger)from {
    [super configureWithIndexPath:indexPath object:object];
    
    if (from == 1) {
        self.selectedImageView.image = nil;
    }
    
    CouponObject *coupon = (CouponObject *)object;
    self.couponDesLabel.text = @"试用金额不限";
    self.deadLineLabel.text = @"2015.12.12-2016.2.12";
    self.parvalueLabel.text = [NSString stringWithFormat:@"%@元", coupon.parvalue];
    self.typeDesLabel.text = @"现金抵用券";
}

@end
