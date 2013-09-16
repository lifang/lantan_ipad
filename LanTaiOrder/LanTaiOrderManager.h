//
//  LanTaiOrderManager.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJDBKit;
@interface LanTaiOrderManager : NSObject{
    RJDBKit* _db;
}
+ (LanTaiOrderManager *)sharedInstance;
+ (void)releaseSharedInstance;
//读取数据
- (NSArray*)loadDataFromTableName:(NSString *)tableName WithName:(NSString *)name andPassWord:(NSString *)password andCarNum:(NSString *)carNum andBrand_id:(NSString *)brand_id andCar_brand_id:(NSString *)car_brand_id andProduct_id:(NSString *)product_id andClassify_id:(NSString *)classify_id andCar_capital_id:car_capital_id andStore_id:(NSString *)store_id;
//添加数据
-(BOOL)addDataToTable:(NSString *)tableName WithArray:(NSArray *)array;
//删除纪录
-(BOOL)deleteTable:(NSString *)tableName WithName:(NSString *)name andPassWord:(NSString *)password andCarNum:(NSString *)carNum andProduct_id:(NSString *)product_id andCodeID:(NSString *)codeID;
//更新订单数据
-(BOOL)updatetable:(NSString *)tableName WithBilling:(NSString *)billing WithRequest:(NSString *)request WithReason:(NSString *)reason WithIs_please:(NSString *)is_please WithPayType:(NSString *)payType WithStatus:(NSString *)status ByCarNum:(NSString *)carNum andCodeID:(NSString *)codeID;
//读取订单数据
- (NSArray*)loadDataFromTableName:(NSString *)tableName CarNum:(NSString *)carNum andCodeID:(NSString *)codeID andStore_id:(NSString *)store_id;
- (NSArray*)loadDataFromTableWithUser_id:(NSString *)user_id;
- (NSArray*)loadDataFromTable;

-(BOOL)deleteTable:(NSString *)tableName;
- (NSArray*)loadDataFromTableName:(NSString *)tableName WithStore_id:(NSString *)store_id andClassify_id:(NSString *)classify_id andProduct_id:(NSString *)product_id andType:type;


//读取数据
- (NSArray*)loadDataFromTableWithWrong:(NSString *)wrongName;
//读取数据
- (NSArray*)loadDataFromTableWithWrong:(NSString *)wrongName WithRight:(NSString *)rightName;
//添加数据
-(BOOL)addDataToTableWithArray:(NSArray *)array;
//更新订单数据
-(BOOL)updatetableWithWrong:(NSString *)wrongName WithRight:(NSString *)rightName WithNumber:(NSString *)number;

@end
