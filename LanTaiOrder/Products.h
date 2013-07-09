//
//  Products.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *product_id;
@property (nonatomic,strong) NSString *classify_id;
@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *store_id;
@property (nonatomic,strong) NSString *description;
@end
