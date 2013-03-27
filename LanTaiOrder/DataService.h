//
//  DataService.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataService : NSObject

@property (nonatomic,strong) NSString *user_id,*reserve_count,*store_id,*car_num;
@property (nonatomic,strong) NSMutableArray *workingOrders,*reserve_list;

@property (nonatomic,assign) int number;//判断是下单还是登记信息:1登记，0下单
@property (nonatomic,assign) int payNumber;//判断是否弹出pay的popView:1弹出，0不弹出


+ (DataService *)sharedService;

@end
