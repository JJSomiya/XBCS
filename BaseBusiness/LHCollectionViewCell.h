//
//  LHCollectionViewCell.h
//  BaseBusiness
//
//  Created by Somiya on 15/11/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain, readonly) NSIndexPath *indexPath;
@property (nonatomic, retain, readonly) id object;

- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object;
@end
