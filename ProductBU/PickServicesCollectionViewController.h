//
//  PickServicesCollectionViewController.h
//  ProductBU
//
//  Created by Somiya on 15/12/10.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <BaseBusiness/BaseBusiness.h>

@interface PickServicesCollectionViewController : LHCollectionViewController
@property (nonatomic, strong) NSDictionary *productsDic;
@property (nonatomic, strong) BaseServiceObject *baseServiceObj;
@property (nonatomic, assign) ServiceType serviceType;
@end
