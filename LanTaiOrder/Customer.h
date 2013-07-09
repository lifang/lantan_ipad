//
//  Customer.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *carNum;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *birth;
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *brand_name;
@property (nonatomic,strong) NSString *model_name;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *brand;
@end
