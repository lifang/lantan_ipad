//
//  Order.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-30.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString * prods;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * store_id;
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * payType;
@property (nonatomic,strong) NSString * carNum;
@property (nonatomic,strong) NSString * status;//付款情况
@property (nonatomic,strong) NSString * codeID;//关联订单产品
@property (nonatomic,strong) NSString * time;//下单时间
@property (nonatomic,strong) NSString * is_please;
@property (nonatomic,strong) NSString *reason;
@property (nonatomic,strong) NSString *request;
@property (nonatomic,strong) NSString *billing;//发票
@end
