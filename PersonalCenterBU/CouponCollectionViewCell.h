//
//  CouponCollectionViewCell.h
//  PersonalCenterBU
//
//  Created by Somiya on 15/12/16.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface CouponCollectionViewCell : LHCollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object from:(NSInteger)from;
@end
