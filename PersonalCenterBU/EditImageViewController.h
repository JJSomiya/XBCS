//
//  EditImageViewController.h
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

typedef void (^ImageEditBlock)(UIImage *editedImage);


#import <UIKit/UIKit.h>

@interface EditImageViewController : LHRootViewController

@property (nonatomic, strong) ImageEditBlock imageEditBlock;
@property (nonatomic, strong) UIImage *sourceImage;

@end
