//
//  MenuCollectionViewCell.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/11/26.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "MenuCollectionViewCell.h"
@interface MenuCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *menuIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation MenuCollectionViewCell
- (void)configureWithIndexPath:(NSIndexPath *)indexPath object:(id)object {
    [super configureWithIndexPath:indexPath object:object];
    NSDictionary *dic = (NSDictionary *)object;
    
    self.menuIcon.image = [UIImage imageNamed:[dic valueForKey:@"img"]];
    self.name.text = [dic valueForKey:@"name"];
    self.storyboardId = [dic valueForKey:@"id"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
