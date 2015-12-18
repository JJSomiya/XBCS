//
//  OtherServiceCollectionCell.m
//  ProductBU
//
//  Created by Somiya on 15/12/10.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "OtherServiceCollectionCell.h"
@interface OtherServiceCollectionCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectedButn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end
@implementation OtherServiceCollectionCell
#pragma mark ----------------delloc----------------
- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self.monthsTF name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark ----------------system----------------
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.isSelected = NO;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"cba---> %@", self.monthsTF);
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        [self.selectedButn setImage:[UIImage imageNamed:@"checkboxselected"] forState:UIControlStateNormal];
    } else {
        [self.selectedButn setImage:[UIImage imageNamed:@"checkboxunselected"] forState:UIControlStateNormal];
    }

}

- (IBAction)selectedButnClicked:(id)sender {
    if (self.isSelected) {
        self.isSelected = NO;
    } else {
        self.isSelected = YES;
    }
    BaseServiceObject *obj = (BaseServiceObject *)self.object;

    if (self.selectedProductBlock) {
        self.selectedProductBlock(self.indexPath, self.isSelected, obj.serviceId);
    }
}
- (IBAction)showInfo:(id)sender {
    BaseServiceObject *obj = (BaseServiceObject *)self.object;

    [[ToastView sharedToastView] showToastViewWithMessage:obj.serviceContent inView:[[[UIApplication sharedApplication] delegate] window]];
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object {
    [super configureWithIndexPath:indexPath object:object];

    if (indexPath.section == 1) {
        self.monthsTF.hidden = YES;
        self.monthLabel.hidden = YES;
    } else {
        self.monthsTF.hidden = NO;
        self.monthLabel.hidden = NO;
    }
    BaseServiceObject *obj = (BaseServiceObject *)object;
    self.titleLabel.text = obj.serviceName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", obj.price];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
