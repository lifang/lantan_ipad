//
//  LanTaiOrderManager.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-5-27.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "LanTaiOrderManager.h"
#import "RJFileUtils.h"
#import "RJDBKit.h"
#import "EmployeeInfo.h"//员工信息
#import "CarBrand.h"//车辆品牌
#import "CarModel.h"//车辆型号
#import "Products.h"//产品
#import "Customer.h"//客户信息
#import "Order.h"//订单
#import "Member.h"/////
#import "CarCapital.h"

@interface LanTaiOrderManager(XDPrivate)
- (EmployeeInfo *)employeeInfoDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
- (CarCapital *)carCapitalDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
- (CarBrand *)carBrandDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
- (CarModel *)carModelDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
- (Products *)productsDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
- (Customer *)carDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
- (Order *)orderDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
- (Member *)memberDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index;
@end
@implementation LanTaiOrderManager(XDPrivate)
- (EmployeeInfo *)employeeInfoDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index {
    EmployeeInfo *itemCatInfo = [[[EmployeeInfo alloc] init] autorelease];
    NSInteger employeeID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", employeeID];
    itemCatInfo.name = [aRecord columnString:1];
    itemCatInfo.password = [aRecord columnString:2];
    itemCatInfo.store_id = [aRecord columnString:3];
    itemCatInfo.user_id = [aRecord columnString:4];
    return itemCatInfo;
}
- (CarCapital *)carCapitalDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index; {
    CarCapital *itemCatInfo = [[[CarCapital alloc] init] autorelease];
    NSInteger carBrandID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", carBrandID];
    itemCatInfo.name = [aRecord columnString:1];
    itemCatInfo.capital_id = [aRecord columnString:2];
    return itemCatInfo;
}
- (CarBrand *)carBrandDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index {
    CarBrand *itemCatInfo = [[[CarBrand alloc] init] autorelease];
    NSInteger carBrandID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", carBrandID];
    itemCatInfo.name = [aRecord columnString:1];
    itemCatInfo.brand_id = [aRecord columnString:2];
    itemCatInfo.car_capital_id = [aRecord columnString:3];
    return itemCatInfo;
}
- (CarModel *)carModelDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index {
    CarModel *itemCatInfo = [[[CarModel alloc] init] autorelease];
    NSInteger carModelID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", carModelID];
    itemCatInfo.name = [aRecord columnString:1];
    itemCatInfo.model_id = [aRecord columnString:2];
    itemCatInfo.car_brand_id = [aRecord columnString:3];
    return itemCatInfo;
}
- (Products *)productsDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index {
    Products *itemCatInfo = [[[Products alloc] init] autorelease];
    NSInteger productsID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", productsID];
    itemCatInfo.name = [aRecord columnString:1];
    itemCatInfo.price = [aRecord columnString:2];
    itemCatInfo.product_id = [aRecord columnString:3];
    itemCatInfo.img = [aRecord columnString:4];
    itemCatInfo.type = [aRecord columnString:5];
    itemCatInfo.classify_id = [aRecord columnString:6];
    itemCatInfo.store_id = [aRecord columnString:7];
    itemCatInfo.description = [aRecord columnString:8];
    return itemCatInfo;
}
- (Customer *)carDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index {
    Customer *itemCatInfo = [[[Customer alloc] init] autorelease];
    NSInteger productsID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", productsID];
    itemCatInfo.carNum = [aRecord columnString:1];
    itemCatInfo.name = [aRecord columnString:2];
    itemCatInfo.phone = [aRecord columnString:3];
    itemCatInfo.brand = [aRecord columnString:4];
    itemCatInfo.email = [aRecord columnString:5];
    itemCatInfo.birth = [aRecord columnString:6];
    itemCatInfo.year = [aRecord columnString:7];
    itemCatInfo.brand_name = [aRecord columnString:8];
    itemCatInfo.model_name = [aRecord columnString:9];
    itemCatInfo.sex = [aRecord columnString:10];
    return itemCatInfo;
}

- (Order *)orderDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index {
    Order *itemCatInfo = [[[Order alloc] init] autorelease];
    NSInteger productsID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", productsID];
    itemCatInfo.billing = [aRecord columnString:1];
    itemCatInfo.request = [aRecord columnString:2];
    itemCatInfo.reason = [aRecord columnString:3];
    itemCatInfo.is_please = [aRecord columnString:4];
    itemCatInfo.carNum = [aRecord columnString:5];
    itemCatInfo.prods = [aRecord columnString:6];
    itemCatInfo.price = [aRecord columnString:7];
    itemCatInfo.payType = [aRecord columnString:8];
    itemCatInfo.store_id = [aRecord columnString:9];
    itemCatInfo.user_id = [aRecord columnString:10];
    itemCatInfo.time = [aRecord columnString:11];
    itemCatInfo.codeID = [aRecord columnString:12];
    itemCatInfo.status = [aRecord columnString:13];
    return itemCatInfo;
}

- (Member *)memberDetailInfoFromDBRecord:(RJDbRecordSet*)aRecord AndTemIndex:(NSString *)index {
    Member *itemCatInfo = [[[Member alloc] init] autorelease];
    NSInteger productsID = [aRecord columnInteger:0];
    itemCatInfo.ID = [NSString stringWithFormat:@"%d", productsID];
    itemCatInfo.products = [aRecord columnString:1];
    itemCatInfo.show_price = [aRecord columnString:2];
    itemCatInfo.has_p_card = [aRecord columnString:3];
    itemCatInfo.num = [aRecord columnString:4];
    itemCatInfo.product_id = [aRecord columnString:5];
    itemCatInfo.name = [aRecord columnString:6];
    itemCatInfo.price = [aRecord columnString:7];
    itemCatInfo.codeID = [aRecord columnString:8];
    itemCatInfo.classify_id = [aRecord columnString:9];
    return itemCatInfo;
}
@end


@implementation LanTaiOrderManager

static LanTaiOrderManager * _sDBManager = nil;
+ (LanTaiOrderManager *)sharedInstance {
    if (nil == _sDBManager)
    {
        _sDBManager = [[LanTaiOrderManager alloc] init];
    }
    return _sDBManager;
}
+ (void)releaseSharedInstance
{
    [_sDBManager release];
    _sDBManager = nil;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        NSString* path = [RJFileUtils shopListDBPath];
        _db = [[RJDBKit alloc] initWithPath:path];
    }
    return self;
}
- (NSArray*)loadDataFromTableName:(NSString *)tableName WithStore_id:(NSString *)store_id andClassify_id:(NSString *)classify_id andProduct_id:(NSString *)product_id andType:type{
    BOOL ret = [_db open];
    if (!ret)
    {
        return nil;
    }
    NSString *sql =nil;
    if (store_id != nil && classify_id != nil && product_id == nil && type == nil) {
        sql = [NSString stringWithFormat:@"select * from %@ where store_id = '%@' and classify_id = '%@'",tableName,store_id,classify_id];
    }else if (store_id != nil && product_id != nil && classify_id == nil && type == nil) {
        sql = [NSString stringWithFormat:@"select * from %@ where store_id = '%@' and product_id = '%@'",tableName,store_id,product_id];
    }else if (store_id != nil && product_id != nil && classify_id != nil && type != nil) {
        sql = [NSString stringWithFormat:@"select * from %@ where store_id = '%@' and product_id = '%@' and classify_id = '%@' and type = '%@'",tableName,store_id,product_id,classify_id,type];
    }else  {
        sql = [NSString stringWithFormat:@"select * from %@ where store_id = '%@'",tableName,store_id];
    }
    
    RJDbRecordSet* set = [_db sqlQuery:sql];
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    while ([set next])
    {
        if ([tableName isEqualToString:@"employee"]) {
            EmployeeInfo* detailInfo = [self employeeInfoDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"carCapital"]) {
            CarCapital* detailInfo = [self carCapitalDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"carBrand"]) {
            CarBrand* detailInfo = [self carBrandDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"carModel"]) {
            CarModel* detailInfo = [self carModelDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"products"]) {
            Products* detailInfo = [self productsDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"customer"]) {
            Customer* detailInfo = [self carDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"orderInfo"]) {
            Order* detailInfo = [self orderDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"member"]) {
            Member* detailInfo = [self memberDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }
        
    }
    [set close];
    [_db close];
    return [dataArray autorelease];
}
//读取数据
- (NSArray*)loadDataFromTableName:(NSString *)tableName WithName:(NSString *)name andPassWord:(NSString *)password andCarNum:(NSString *)carNum andBrand_id:(NSString *)brand_id andCar_brand_id:(NSString *)car_brand_id andProduct_id:(NSString *)product_id andClassify_id:(NSString *)classify_id andCar_capital_id:car_capital_id{
    BOOL ret = [_db open];
    if (!ret)
    {
        return nil;
    }
    NSString *sql = nil;
    if (name==nil && password==nil && carNum==nil && brand_id==nil && car_brand_id==nil && product_id==nil &&classify_id==nil && car_capital_id==nil) {
        sql = [NSString stringWithFormat:@"select * from %@",tableName];
    }else if (name!=nil && password!=nil) {//登陆
        sql = [NSString stringWithFormat:@"select * from %@ where name = '%@' and password = '%@'",tableName,name,password];
    }else if (carNum != nil) {//搜索车牌
        sql = [NSString stringWithFormat:@"select * from %@ where carNum = '%@'",tableName,carNum];
    }else if (brand_id != nil) {//车品牌
        sql = [NSString stringWithFormat:@"select * from %@ where brand_id = '%@'",tableName,brand_id];
    }else if (car_brand_id != nil) {//车型号
        sql = [NSString stringWithFormat:@"select * from %@ where car_brand_id = '%@'",tableName,car_brand_id];
    }else if (product_id != nil) {
        sql = [NSString stringWithFormat:@"select * from %@ where product_id = '%@'",tableName,product_id];
    }else if (classify_id != nil) {
        sql = [NSString stringWithFormat:@"select * from %@ where classify_id = '%@'",tableName,classify_id];
    }else if (car_capital_id != nil){
        sql = [NSString stringWithFormat:@"select * from %@ where car_capital_id = '%@'",tableName,car_capital_id];
    }

    
    RJDbRecordSet* set = [_db sqlQuery:sql];
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    while ([set next])
    {
        if ([tableName isEqualToString:@"employee"]) {
            EmployeeInfo* detailInfo = [self employeeInfoDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"carCapital"]) {
            CarCapital* detailInfo = [self carCapitalDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"carBrand"]) {
            CarBrand* detailInfo = [self carBrandDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"carModel"]) {
            CarModel* detailInfo = [self carModelDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"products"]) {
            Products* detailInfo = [self productsDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"customer"]) {
            Customer* detailInfo = [self carDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"orderInfo"]) {
            Order* detailInfo = [self orderDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"member"]) {
            Member* detailInfo = [self memberDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }
        
    }
    [set close];
    [_db close];
    return [dataArray autorelease];
}
//接待信息
- (NSArray*)loadDataFromTableWithUser_id:(NSString *)user_id  {
    BOOL ret = [_db open];
    if (!ret)
    {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from employee where user_id = '%@'",user_id];
    RJDbRecordSet* set = [_db sqlQuery:sql];
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    while ([set next]) {
        EmployeeInfo* detailInfo = [self employeeInfoDetailInfoFromDBRecord:set AndTemIndex:nil];
        if (nil != detailInfo)
        {
            [dataArray addObject:detailInfo];
        }
    }
    [set close];
    [_db close];
    return [dataArray autorelease];
}
- (NSArray*)loadDataFromTable{
    BOOL ret = [_db open];
    if (!ret)
    {
        return nil;
    }
    NSString *sql = @"select * from orderInfo where status != '3'";
    RJDbRecordSet* set = [_db sqlQuery:sql];
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    while ([set next]) {
        Order* detailInfo = [self orderDetailInfoFromDBRecord:set AndTemIndex:nil];
        if (nil != detailInfo)
        {
            [dataArray addObject:detailInfo];
        }
    }
    [set close];
    [_db close];
    return [dataArray autorelease];
}

//读取订单数据
- (NSArray*)loadDataFromTableName:(NSString *)tableName CarNum:(NSString *)carNum andCodeID:(NSString *)codeID {
    BOOL ret = [_db open];
    if (!ret)
    {
        return nil;
    }
    NSString *sql = nil;
    if (carNum == nil && codeID == nil) {
        sql = [NSString stringWithFormat:@"select * from %@",tableName];
    }else if (carNum != nil && codeID == nil) {//
        sql = [NSString stringWithFormat:@"select * from %@ where carNum = '%@'",tableName,carNum];
    }else if (codeID != nil && carNum == nil) {//关联产品
        sql = [NSString stringWithFormat:@"select * from %@ where codeID = '%@'",tableName,codeID];
    }else if (carNum != nil && codeID != nil) {
        sql = [NSString stringWithFormat:@"select * from %@ where codeID = '%@' and carNum = '%@'",tableName,codeID,carNum];
    }
    
    RJDbRecordSet* set = [_db sqlQuery:sql];
    
    NSMutableArray* dataArray = [[NSMutableArray alloc] init];
    while ([set next])
    {
        if ([tableName isEqualToString:@"orderInfo"]) {
            Order* detailInfo = [self orderDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }else if ([tableName isEqualToString:@"member"]) {
            Member* detailInfo = [self memberDetailInfoFromDBRecord:set AndTemIndex:nil];
            if (nil != detailInfo)
            {
                [dataArray addObject:detailInfo];
            }
        }
        
    }
    [set close];
    [_db close];
    return [dataArray autorelease];
}

//添加数据
-(BOOL)addDataToTable:(NSString *)tableName WithArray:(NSArray *)array {
    BOOL ret = [_db open];
    if (!ret)
    {
        return NO;
    }
    NSString *sql = nil;
    if ([tableName isEqualToString:@"employee"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (name, password, store_id, user_id) VALUES (?, ?, ?, ?)",tableName];
    }else if ([tableName isEqualToString:@"carCapital"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (name, capital_id) VALUES (?, ?)",tableName];
    }else if ([tableName isEqualToString:@"carBrand"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (name, brand_id, car_capital_id) VALUES (?, ?, ?)",tableName];
    }else if ([tableName isEqualToString:@"carModel"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (name, model_id, car_brand_id) VALUES (?, ?, ?)",tableName];
    }else if ([tableName isEqualToString:@"products"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (name, price, product_id, img, type, classify_id, store_id, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",tableName];
    }else if ([tableName isEqualToString:@"customer"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (carNum, name, phone, brand, email, birth, year, brand_name, model_name, sex) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",tableName];
    }else if ([tableName isEqualToString:@"orderInfo"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (billing, request, reason, is_please, carNum, prods, price, payType, store_id, user_id, time, codeID, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",tableName];
    }else if ([tableName isEqualToString:@"member"]) {
        sql = [NSString stringWithFormat:@"insert into %@ (products, show_price, has_p_card, num, product_id, name, price, codeID, classify_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",tableName];
    }
    
    return [_db dealData:sql paramArray:array];
}

//删除表中的某条记录
-(BOOL)deleteTable:(NSString *)tableName WithName:(NSString *)name andPassWord:(NSString *)password andCarNum:(NSString *)carNum andProduct_id:(NSString *)product_id andCodeID:(NSString *)codeID{
    BOOL ret = [_db open];
    if (!ret)
    {
        return NO;
    }
    NSString *sql = nil;
    if (name!=nil && password!=nil) {
        sql = [NSString stringWithFormat:@"delete from %@ where name = '%@' and password = '%@'",tableName,name,password];
    }else if (carNum != nil) {
        sql = [NSString stringWithFormat:@"delete from %@ where carNum = '%@'",tableName,carNum];
    }else if (product_id != nil) {
        sql = [NSString stringWithFormat:@"delete from %@ where product_id = '%@'",tableName,product_id];
    }else if (codeID != nil) {
        sql = [NSString stringWithFormat:@"delete from %@ where codeID = '%@'",tableName,codeID];
    }
    
    return [_db insertOrUpdateUser:sql];
}
//更新订单数据
-(BOOL)updatetable:(NSString *)tableName WithBilling:(NSString *)billing WithRequest:(NSString *)request WithReason:(NSString *)reason WithIs_please:(NSString *)is_please WithPayType:(NSString *)payType WithStatus:(NSString *)status ByCarNum:(NSString *)carNum andCodeID:(NSString *)codeID{
    BOOL ret = [_db open];
    if (!ret)
    {
        return NO;
    }
    NSString *sql = @"";
    if (request!=nil && reason!=nil) {
        sql = [NSString stringWithFormat:@"update %@ set request= '%@',reason= '%@',is_please= '%@' where carNum= '%@' and codeID= '%@'",tableName,request,reason,is_please,carNum,codeID];
    }else {
        sql = [NSString stringWithFormat:@"update %@ set billing= '%@',payType= '%@',status= '%@',is_please= '%@' where carNum= '%@' and codeID= '%@'",tableName,billing,payType,status,is_please,carNum,codeID];
    }
    
    
    return [_db insertOrUpdateUser:sql];
}

//删除表中的记录
-(BOOL)deleteTable:(NSString *)tableName {
    BOOL ret = [_db open];
    if (!ret)
    {
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"delete from %@ ",tableName];
    
    return [_db insertOrUpdateUser:sql];
}
@end
