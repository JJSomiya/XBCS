//
//  LHCollectionViewCell.m
//  BaseBusiness
//
//  Created by Somiya on 15/11/17.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "LHCollectionViewCell.h"
@interface LHCollectionViewCell ()
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) id object;
@end

@implementation LHCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
    }
    return self;
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object
{
    self.indexPath = indexPath;
    self.object = object;
}

@end
