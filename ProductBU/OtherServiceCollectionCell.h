//
//  OtherServiceCollectionCell.h
//  ProductBU
//
//  Created by Somiya on 15/12/10.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface OtherServiceCollectionCell : LHCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextField *monthsTF;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) void (^selectedProductBlock)(NSIndexPath *indePath, BOOL isSelected, NSString *serviceId);
@end
