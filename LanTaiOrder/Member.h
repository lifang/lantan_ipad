//
//  Member.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-30.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *codeID;//关联订单产品
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *classify_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *product_id;
@property (nonatomic,strong) NSString *has_p_card;
@property (nonatomic,strong) NSString *products;
@property (nonatomic,strong) NSString *show_price;
@end
