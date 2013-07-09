//
//  DataService.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataService : NSObject

@property (nonatomic,strong) NSString *kHost;
@property (nonatomic,strong) NSString *kDomain;
@property (nonatomic,strong) NSString *kPosAppId;
@property (nonatomic,strong) NSString *str_ip;
@property (nonatomic,strong) NSString *user_id,*reserve_count,*store_id,*car_num;
@property (nonatomic,strong) NSMutableArray *workingOrders,*reserve_list;

@property (nonatomic,assign) int number;//判断是下单还是登记信息:1登记，0下单
@property (nonatomic,assign) int payNumber;//判断是否弹出pay的popView:1弹出，0不弹出
@property (nonatomic,strong) NSMutableArray *doneArray;//已投诉得数组
@property (nonatomic,assign) int tagOfBtn;//判断生日按钮

@property (nonatomic,assign) BOOL first;//判断 number_id 是否加载数据；
@property (nonatomic,strong) NSMutableArray *row_id_countArray;//套餐卡
@property (nonatomic,strong) NSMutableArray *row_id_numArray;//活动打折卡
@property (nonatomic,strong) NSMutableDictionary *price_id;//选择产品价格／服务的id 
@property (nonatomic,strong) NSMutableDictionary *number_id;//选择产品服务的id 和数量
@property (nonatomic,strong) NSMutableArray *productList;

@property (nonatomic,assign) BOOL ReservationFirst;//判断预约是否是第一次；
@property (nonatomic,assign) BOOL refreshing;//判断跟页面刷新

@property (nonatomic,strong) NSMutableDictionary *packageCard_dic;//套餐卡
//总价
@property (nonatomic,assign) CGFloat total_count;
@property (nonatomic,strong) NSMutableArray *row;

@property (nonatomic,strong) NSMutableArray *matchArray;//匹配车牌号前2位数组
@property (nonatomic,strong) NSMutableArray *sectionArray;

//产品／服务 id_count_price
@property (nonatomic,strong) NSMutableArray *id_count_price;
//活动
@property (nonatomic,strong) NSMutableArray *saleArray;
@property (nonatomic,assign) BOOL netWorking;//判定网络

+ (DataService *)sharedService;

@end
