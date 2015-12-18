//
//  HeaderCollectionViewCell.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/11/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "HeaderCollectionViewCell.h"
@interface HeaderCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *bgButn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
@implementation HeaderCollectionViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerButn.layer.masksToBounds = YES;
    self.headerButn.layer.cornerRadius = 50;
    self.headerButn.layer.borderWidth = 3;
    self.headerButn.layer.borderColor = [UIColor colorWithWhite:0.569 alpha:1.000].CGColor;
    
//        //添加阴影层
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.bgButn.frame;
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor colorWithWhite:0.667 alpha:0.700].CGColor];
//    gradientLayer.locations = @[@0, @1.0];
//    [self.bgButn.layer insertSublayer:gradientLayer atIndex:0];
}
- (IBAction)headerButnClicked:(id)sender {
    if (self.headerClickedBlock) {
        self.headerClickedBlock();
    }
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object {
    [super configureWithIndexPath:indexPath object:object];
    if (object) {
        UserObject *user = (UserObject *)object;
        NSURL *url = [NSURL URLWithString:user.headerImg];
        [self.headerButn setImageForState:UIControlStateNormal withURL:url placeholderImage:[UIImage imageNamed:@"headerimg"]];
        if (!user.userName) {
            self.userNameLabel.text = user.phone;
        }
        self.userNameLabel.text = user.userName;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
