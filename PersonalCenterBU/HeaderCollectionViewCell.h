//
//  HeaderCollectionViewCell.h
//  PersonalCenterBU
//
//  Created by Somiya on 15/11/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface HeaderCollectionViewCell : LHCollectionViewCell
@property (nonatomic, copy) void (^headerClickedBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *headerButn;

@end
