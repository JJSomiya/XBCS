//
//  LoginViewController.h
//  LoginOutBU
//
//  Created by Somiya on 15/11/23.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>
@protocol LoginViewControllerDelegate;
@interface LoginViewController : LHRootViewController
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet CustomTextField *accountTF;
+ (instancetype)sharedInstance;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewController:(LoginViewController *)loginVC didClickedRegisterButn:(id)sender;

@end