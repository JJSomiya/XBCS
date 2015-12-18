//
//  ServiceDetailCollectionViewCell.m
//  ProductBU
//
//  Created by Somiya on 15/12/10.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ServiceDetailCollectionViewCell.h"
@interface ServiceDetailCollectionViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *baseServicebg;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation ServiceDetailCollectionViewCell
#pragma mark ----------------delloc----------------
- (void)dealloc {
}
#pragma mark ----------------system----------------
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseServicebg.layer.masksToBounds = YES;
    self.baseServicebg.layer.cornerRadius = 3;
    self.baseServicebg.backgroundColor = [UIColor whiteColor];
    self.serviceDetailImageView.layer.masksToBounds = YES;
    self.serviceDetailImageView.layer.cornerRadius = 3;
//    self.serviceDetailImageView.backgroundColor = [UIColor lightGrayColor];
    self.serviceDetailImageView.hidden = YES;
//    if (!self.imageView) {
//        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 85, SCREENWIDTH - 30, 0)];
//        self.imageView.layer.masksToBounds = YES;
//        self.imageView.layer.cornerRadius = 3;
//        self.imageView.backgroundColor = [UIColor lightGrayColor];
//        [self insertSubview:self.imageView belowSubview:self.baseServicebg];
//    }
//    self.monthsTF.delegate = self;
    NSLog(@"cba---> %@", self.monthsTF);
}

#pragma mark ----------------UITextFieldDelegate----------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.monthsValueChanged) {
        self.monthsValueChanged(self.indexPath, string);
    }
    return YES;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}
- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object {
    [super configureWithIndexPath:indexPath object:object];
    BaseServiceObject *obj = (BaseServiceObject *)object;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBASE_URL_PRODUCT_IMAGE(obj.productImg)]];
    [self.serviceDetailImageView setImageWithURL:url];
    [self.baseServicebg bringSubviewToFront:self];
    self.serviceNameLabel.text = obj.serviceName;
    self.priceLabel.text = obj.price;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
