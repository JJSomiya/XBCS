//
//  PayWayCollectionViewCell.m
//  ProductBU
//
//  Created by Somiya on 15/11/19.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "PayWayCollectionViewCell.h"
@interface PayWayCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *maskImageView;
@end
@implementation PayWayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(5, 5, 5, 5))];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = (frame.size.width - 10) / 2;
//        self.imageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.imageView];
        
        self.maskImageView = [[UIImageView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(5, 5, 5, 5))];
        self.maskImageView.layer.masksToBounds = YES;
        self.maskImageView.layer.cornerRadius = (frame.size.width - 10) / 2;
//        self.maskImageView.backgroundColor = [UIColor blackColor];
        self.maskImageView.alpha = 0.6;
        self.maskImageView.hidden = YES;
        [self addSubview:self.maskImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskImageView.hidden = NO;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskImageView.hidden = YES;
        }];
    }
}

-(void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object {
    [super configureWithIndexPath:indexPath object:object];
    NSDictionary *dic = (NSDictionary *)object;
    self.imageView.image = [UIImage imageNamed:[dic valueForKey:@"image"]];
    self.maskImageView.image = [UIImage imageNamed:[dic valueForKey:@"maskimage"]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
