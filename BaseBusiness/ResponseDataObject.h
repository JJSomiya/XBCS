//
//  ResponseDataObject.h
//  BaseBusiness
//
//  Created by Somiya on 15/12/2.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface ResponseDataObject : DataObject
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *message;
@end
