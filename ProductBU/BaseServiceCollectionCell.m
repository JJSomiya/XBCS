//
//  BaseServiceCollectionCell.m
//  ProductBU
//
//  Created by Somiya on 15/11/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "BaseServiceCollectionCell.h"
static CGFloat kMarginLeft  = 20;
static CGFloat kImgW        = 35;
static CGFloat kImgH        = 40;

@interface BaseServiceCollectionCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *serviceNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation BaseServiceCollectionCell
#pragma mark ----------------init----------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.serviceNameLabel];
    [self addSubview:self.priceLabel];
//    self.backgroundColor = [UIColor redColor];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, (self.bounds.size.height - kImgW)/2 + 3, kImgW, kImgW)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"cellbg"];
    }
    return _backgroundImageView;
}

- (UILabel *)serviceNameLabel {
    if (!_serviceNameLabel) {
        _serviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 3, 140, self.bounds.size.height)];
        _serviceNameLabel.font = [UIFont systemFontOfSize:17];
        _serviceNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _serviceNameLabel.numberOfLines = 2;
//        _serviceNameLabel.backgroundColor = [UIColor redColor];
//        _serviceNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    return _serviceNameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.serviceNameLabel.frame), 0, self.frame.size.width - 50 - 120 - 50, self.bounds.size.height)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont systemFontOfSize:17];
//        _priceLabel.backgroundColor = [UIColor greenColor];
        _priceLabel.textColor = [UIColor blackColor];
    }
    return _priceLabel;
}
#pragma mark ----------------API----------------
- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object {
    [super configureWithIndexPath:indexPath object:object];
    BaseServiceObject *obj = (BaseServiceObject *)object;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", kBASE_URL_PRODUCT_IMAGE(obj.hederIcon)]];
    [self.imageView setImageWithURL:url];
    if ([obj.serviceType integerValue] == ServiceTypeBase) {
        self.serviceNameLabel.textColor = RGB_HEX(0x4fc1e9);
    }
    if ([obj.serviceType integerValue] == ServiceTypeValueAdded) {
        self.serviceNameLabel.textColor = RGB_HEX(0x2fcec5);
    }
    self.serviceNameLabel.text = obj.serviceName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@元/月", obj.price];
    NSDictionary *attributeDic = @{
                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir-Heavy" size:28],
                                   NSBaselineOffsetAttributeName:@(-5),
                                   NSForegroundColorAttributeName:RGB_HEX(0x444a66)
                                   };
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
    [attributeStr addAttributes:attributeDic range:NSMakeRange(1, obj.price.length)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[self.priceLabel.text rangeOfString:@"元/月"]];
    self.priceLabel.attributedText = attributeStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
