//
//  ServiceDetailCollectionViewCell.h
//  ProductBU
//
//  Created by Somiya on 15/12/10.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface ServiceDetailCollectionViewCell : LHCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *serviceDetailImageView;
@property (nonatomic, strong) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *monthsTF;
@property (nonatomic, copy) void (^monthsValueChanged)(NSIndexPath *indePath, NSString *value);
@end
