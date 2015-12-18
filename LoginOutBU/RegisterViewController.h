//
//  RegisterViewController.h
//  LoginOutBU
//
//  Created by Somiya on 15/11/25.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>
@protocol RegisterViewControllerDelegate;
@interface RegisterViewController : LHRootViewController
@property (nonatomic, weak) id<RegisterViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneTF;

+ (instancetype)sharedInstance;
@end

@protocol RegisterViewControllerDelegate <NSObject>

- (void)registerViewController:(RegisterViewController *)registerVC didClickedLoginButn:(id)sender;

@end