//
//  MainViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "MainViewController.h"
#import "OrderViewController.h"
#import "ReservationViewController.h"
#import "AppDelegate.h"
#import "SVPullToRefresh.h"
#import "Customer.h"//客户
#import "Order.h"//订单
#import "AddViewController.h"
#import "CarBrand.h"//车辆
#import "CarModel.h"//车辆
#import "Products.h"
#import "CarCapital.h"

@implementation MainViewController
@synthesize txtCarNum,lblCount,orderTable = _orderTable,statusImg,mainView;
@synthesize waitList;
@synthesize orderView2;
@synthesize hideView;
@synthesize sxView;
@synthesize letterArray;
@synthesize postString;
@synthesize timer;
@synthesize addViewBtn;
@synthesize addOrderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -保存车辆品牌／型号到数据库
-(void)addDataToBrandAndmodel {
    NSArray *array = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"carCapital" WithName:nil andPassWord:nil andCarNum:nil andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:nil];
    if (array.count == 0) {
        //保存车辆品牌／型号到数据库
        if (self.addOrderView.brandList.count>0) {
            NSMutableArray *tempArray_capital = [NSMutableArray array];
            NSMutableArray *tempArray_brand = [NSMutableArray array];
            NSMutableArray *tempArray_model = [NSMutableArray array];
            for (int i = 0; i<self.addOrderView.brandList.count; i++) {
                NSDictionary *dic = [self.addOrderView.brandList objectAtIndex:i];
                //capital
                NSString *capital_name = [dic objectForKey:@"name"];
                NSString *capital_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                NSArray *array_capital = [NSArray arrayWithObjects:capital_name,[NSString stringWithFormat:@"%@",capital_id], nil];
                [tempArray_capital addObject:array_capital];
                
                //品牌
                if (![[dic objectForKey:@"brands"]isKindOfClass:[NSNull class]]) {
                    NSArray *brand_array = [dic objectForKey:@"brands"];
                    if (brand_array.count > 0) {
                        for (int j=0; j<brand_array.count; j++) {
                            NSDictionary *brand_dic = [brand_array objectAtIndex:j];
                            NSString *name_brand = [brand_dic objectForKey:@"name"];
                            NSString *brand_id = [NSString stringWithFormat:@"%@",[brand_dic objectForKey:@"id"]];
                            NSString *car_capital_id = [NSString stringWithFormat:@"%@",[brand_dic objectForKey:@"capital_id"]];
                            NSArray *array_brand = [NSArray arrayWithObjects:name_brand,[NSString stringWithFormat:@"%@",brand_id],[NSString stringWithFormat:@"%@",car_capital_id], nil];
                            [tempArray_brand addObject:array_brand];
                            
                            //型号
                            if (![[brand_dic objectForKey:@"models"]isKindOfClass:[NSNull class]]) {
                                NSArray *models_array = [brand_dic objectForKey:@"models"];
                                if (models_array.count >0) {
                                    for (int k=0; k<models_array.count; k++) {
                                        NSDictionary *model_dic = [models_array objectAtIndex:k];
                                        NSString *name_model = [model_dic objectForKey:@"name"];
                                        NSString *model_id = [NSString stringWithFormat:@"%@",[model_dic objectForKey:@"id"]];
                                        NSString *car_brand_id = [NSString stringWithFormat:@"%@",[model_dic objectForKey:@"car_brand_id"]];
                                        NSArray *array_model = [NSArray arrayWithObjects:name_model,[NSString stringWithFormat:@"%@",model_id],[NSString stringWithFormat:@"%@",car_brand_id], nil];
                                        [tempArray_model addObject:array_model];
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            if (tempArray_brand.count>0) {
                for (int i=0; i<tempArray_brand.count; i++) {
                    NSArray *array_brand = [tempArray_brand objectAtIndex:i];
                    [[LanTaiOrderManager sharedInstance]addDataToTable:@"carBrand" WithArray:array_brand];
                }
                for (int j=0; j<tempArray_model.count; j++) {
                    NSArray *array_model = [tempArray_model objectAtIndex:j];
                    [[LanTaiOrderManager sharedInstance]addDataToTable:@"carModel" WithArray:array_model];
                }
                for (int k=0; k<tempArray_capital.count; k++) {
                    NSArray *array_capital = [tempArray_capital objectAtIndex:k];
                    [[LanTaiOrderManager sharedInstance]addDataToTable:@"carCapital" WithArray:array_capital];
                }
            }
            
        }
    }
}
#pragma mark -数据库获取车辆品牌／型号
-(void)getDataFromBrandAndmodel {
    NSArray *array = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"carCapital" WithName:nil andPassWord:nil andCarNum:nil andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:nil];
    if (array.count != 0) {
        NSMutableArray *tempArray_capital = [NSMutableArray array];
        for (CarCapital *carCapital in array) {
            NSMutableArray *tempArray_brand = [NSMutableArray array];
            NSString *car_capital_id = [NSString stringWithFormat:@"%@",carCapital.capital_id];
            NSArray *array_brand = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"carBrand" WithName:nil andPassWord:nil andCarNum:nil andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:car_capital_id];
            for (CarBrand *carBrand in array_brand) {
                NSMutableArray *tempArray_model = [NSMutableArray array];
                NSString *car_brand_id = [NSString stringWithFormat:@"%@",carBrand.brand_id];
                NSArray *array_model = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"carModel" WithName:nil andPassWord:nil andCarNum:nil andBrand_id:nil andCar_brand_id:car_brand_id andProduct_id:nil andClassify_id:nil andCar_capital_id:nil];
                for (CarModel *carModel in array_model) {
                    NSDictionary *model_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",carModel.car_brand_id],@"car_brand_id",[NSString stringWithFormat:@"%@",carModel.model_id],@"id",[NSString stringWithFormat:@"%@",carModel.name],@"name",nil];
                    [tempArray_model addObject:model_dic];
                }
                NSDictionary *brand_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",carBrand.name],@"name",[NSString stringWithFormat:@"%@",carBrand.brand_id],@"id",tempArray_model,@"models",[NSString stringWithFormat:@"%@",carBrand.car_capital_id],@"capital_id", nil];
                [tempArray_brand addObject:brand_dic];
            }
            NSDictionary *capital_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",carCapital.name],@"name",[NSString stringWithFormat:@"%@",carCapital.capital_id],@"id",tempArray_brand,@"brands",nil];
            [tempArray_capital addObject:capital_dic];
        }
        self.addOrderView.brandList = [NSMutableArray arrayWithArray:tempArray_capital];
    }
}
#pragma mark -保存产品到数据库
-(void)addDataToProducts {
    NSArray *array = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"products" WithStore_id:[DataService sharedService].store_id andClassify_id:nil andProduct_id:nil andType:nil];
    if (array.count == 0) {
        //保存产品到数据库
        if (self.addOrderView.productList.count>0) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 0; i<self.addOrderView.productList.count-1; i++) {
                NSArray *productArray = [self.addOrderView.productList objectAtIndex:i];
                if (productArray.count>0) {
                    for (int j=0; j<productArray.count; j++) {
                        NSDictionary *p_dic = [productArray objectAtIndex:j];
                        NSString *type = nil;
                        if (![[p_dic objectForKey:@"type"] isKindOfClass:[NSNull class]] && [p_dic objectForKey:@"type"] != nil) {
                            type = [NSString stringWithFormat:@"%@",[p_dic objectForKey:@"type"]];
                        }else {
                            type = [NSString stringWithFormat:@"%d",0];
                        }
                        
                        NSArray * array_product = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"price"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"id"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"img"]],type,[NSString stringWithFormat:@"%d",i],[NSString stringWithFormat:@"%@",[DataService sharedService].store_id],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"description"]],@"description", nil];
                        [tempArray addObject:array_product];
                    }
                }
            }
            if (tempArray.count >0) {
                for (int i=0; i<tempArray.count; i++) {
                    NSArray *arr = [tempArray objectAtIndex:i];
                    [[LanTaiOrderManager sharedInstance]addDataToTable:@"products" WithArray:arr];
                }
            }
        }
    }else {
        if (self.addOrderView.productList.count>0) {
            for (int i=0; i<self.addOrderView.productList.count-1; i++) {
                NSArray *productArray = [self.addOrderView.productList objectAtIndex:i];
                if (productArray.count>0) {
                    for (int j=0; j<productArray.count; j++) {
                        NSDictionary *p_dic = [productArray objectAtIndex:j];
                        
                        NSString *type = nil;
                        if (![[p_dic objectForKey:@"type"] isKindOfClass:[NSNull class]] && [p_dic objectForKey:@"type"] != nil) {
                            type = [NSString stringWithFormat:@"%@",[p_dic objectForKey:@"type"]];
                        }else {
                            type = [NSString stringWithFormat:@"%d",0];
                        }
                        
                        NSString *product_id = [p_dic objectForKey:@"id"];
                        NSString *classify_id = [NSString stringWithFormat:@"%d",i];
                        
                        NSArray *a_pro = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"products" WithStore_id:[DataService sharedService].store_id andClassify_id:classify_id andProduct_id:product_id andType:type];
                        if (a_pro.count>0) {
                            for (Products *products in a_pro) {
                                if (![products.name isEqualToString:[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"name"]]] || ![products.price isEqualToString:[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"price"]]]) {
                                    BOOL success = [[LanTaiOrderManager sharedInstance]deleteTable:@"products" WithName:nil andPassWord:nil andCarNum:nil andProduct_id:product_id andCodeID:nil];
                                    if (success) {
                                        NSArray *paramarray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"price"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"id"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"img"]],type,[NSString stringWithFormat:@"%d",i],[NSString stringWithFormat:@"%@",[DataService sharedService].store_id],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"description"]],@"description", nil];
                                        [[LanTaiOrderManager sharedInstance]addDataToTable:@"products" WithArray:paramarray];
                                    }
                                }
                            }
                        }else {
                            NSArray *paramarray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"price"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"id"]],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"img"]],type,[NSString stringWithFormat:@"%d",i],[NSString stringWithFormat:@"%@",[DataService sharedService].store_id],[NSString stringWithFormat:@"%@",[p_dic objectForKey:@"description"]],@"description", nil];
                            [[LanTaiOrderManager sharedInstance]addDataToTable:@"products" WithArray:paramarray];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark -数据库获取产品
-(void)getDataFromProducts {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) [tempArray addObject:[NSMutableArray array]];
    for (int i=0; i<4; i++) {
        NSString *classify_id = [NSString stringWithFormat:@"%d",i];
        NSArray *array = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"products" WithStore_id:[DataService sharedService].store_id andClassify_id:classify_id andProduct_id:nil andType:nil];
        if (array.count>0) {
            for (Products *products in array) {
                NSDictionary *p_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",products.type],@"type",[NSString stringWithFormat:@"%@",products.product_id],@"id",[NSString stringWithFormat:@"%@",products.img],@"img",[NSString stringWithFormat:@"%@",products.name],@"name",[NSString stringWithFormat:@"%@",products.price],@"price",[NSString stringWithFormat:@"%@",products.classify_id],@"classify_id",[NSString stringWithFormat:@"%@",products.description],@"description", nil];
                [[tempArray objectAtIndex:i]addObject:p_dic];
            }
        }
    }
    int count =0;
    for (int j=0; j<tempArray.count; j++) {
        NSArray *arrr = [tempArray objectAtIndex:j];
        int num = arrr.count;
        if (num > count) {
            count = num;
        }
    }
    NSString *str = [NSString stringWithFormat:@"%d",count];
    [tempArray addObject:str];
    self.addOrderView.productList = [NSMutableArray arrayWithArray:tempArray];
}

-(void)getDataFromm {
    [self getDataFromBrandAndmodel];
    [self getDataFromProducts];
    
    [self.navigationController pushViewController:self.addOrderView animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)addVieww {
    self.addOrderView.step = @"0";
    [DataService sharedService].number = 0;
    //下单获取数据
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kBrandProduct]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *str = [r startSynchronousWithError:&error];
    NSDictionary *result = [str objectFromJSONString];
    if ([[result objectForKey:@"status"] intValue]==1) {

        self.addOrderView.brandList = [NSMutableArray arrayWithArray:[result objectForKey:@"brands"]];
        self.addOrderView.productList = [NSMutableArray arrayWithArray:[result objectForKey:@"products"]];
        [self addDataToBrandAndmodel];
        [self addDataToProducts];
        
    }
    [self.navigationController pushViewController:self.addOrderView animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(IBAction)addViewBtnPressed:(id)sender {
    [txtCarNum resignFirstResponder];
    self.addOrderView = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];

    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        self.addOrderView.step = @"0";
        [DataService sharedService].number = 0;
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [hud showWhileExecuting:@selector(getDataFromm) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }else {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.dimBackground = NO;
        [hud showWhileExecuting:@selector(addVieww) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }
}
//返回按钮，到登录页面
- (void)rightTapped:(id)sender{
    [DataService sharedService].user_id = nil;
    [DataService sharedService].reserve_list = nil;
    [DataService sharedService].reserve_count = nil;
    [DataService sharedService].store_id = nil;
    [DataService sharedService].car_num = nil;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userId"];
    [defaults removeObjectForKey:@"storeId"];
    [defaults synchronize];
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate showRootView];
}
#pragma mark -正在进行中的订单和预约列表
-(void)getData {
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
    NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kIndex]];
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,
                                                                                     NSData *data,
                                                                                     NSError *error)
     {
         if ([data length]>0 && error==nil) {
             [self performSelectorOnMainThread:@selector(setRespondtext:) withObject:data waitUntilDone:NO];
             
         }
     }
     ];
}
-(void)setRespondtext:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if ([[jsonData objectForKey:@"status"] intValue] == 1) {
                if ([jsonData objectForKey:@"reservations"]!=nil) {
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[jsonData objectForKey:@"reservations"]];
                    [DataService sharedService].reserve_count = nil;
                    [DataService sharedService].reserve_count = [NSString stringWithFormat:@"%d",[arr count]];
                    [DataService sharedService].reserve_list = nil;
                    [DataService sharedService].reserve_list = arr;
                    
                    if ([DataService sharedService].reserve_count && [[DataService sharedService].reserve_count intValue] > 0) {
                        self.lblCount.text = [DataService sharedService].reserve_count;
                    }else{
                        self.lblCount.text = @"0";
                    }
                }
                if ([jsonData objectForKey:@"orders"]!=nil) {
                    self.waitList = nil;
                    [DataService sharedService].workingOrders = nil;
                    [DataService sharedService].workingOrders = [NSMutableArray arrayWithArray:[jsonData objectForKey:@"orders"]];
                    waitList = [DataService sharedService].workingOrders;
                    [self.orderTable reloadData];
                }
            }
        }
    }
}

#pragma mark -同步本地信息

- (void)syncData:(id)sender {
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        
    }else {
        NSArray *array_customer = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"customer" WithName:nil andPassWord:nil andCarNum:nil andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:nil];
        NSMutableArray *tempArray = [NSMutableArray array];
        if (array_customer.count > 0) {//本地有客户信息
            for (Customer *ctomer in array_customer) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ctomer.carNum,@"carNum",ctomer.name,@"name",ctomer.phone,@"phone",ctomer.email,@"email",ctomer.birth,@"birth",ctomer.year,@"year",ctomer.brand,@"brand",ctomer.sex,@"sex", nil];
                [tempArray addObject:dic];
            }
        }
        NSMutableArray *tempArray2 = [NSMutableArray array];
        NSMutableArray *tempArray3 = [NSMutableArray array];
        NSArray *array_orderInfo = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"orderInfo" CarNum:nil andCodeID:nil];
        if (array_orderInfo.count > 0) {//本地有订单
            for (Order *order in array_orderInfo) {
                NSDictionary *dic_code = nil;
                NSString *code = order.codeID;
                NSArray *code_arr = [code componentsSeparatedByString:@"-"];
                if (code_arr.count == 1) {//原有订单
                    NSDictionary *c_dic = nil;//投诉
                    if (![order.reason isEqualToString:@""]) {
                        c_dic = [NSDictionary dictionaryWithObjectsAndKeys:order.reason,@"reason",order.request,@"request", nil];
                    }
                    if (c_dic.count>0) {
                        dic_code = [NSDictionary dictionaryWithObjectsAndKeys:order.codeID,@"code",order.payType,@"pay_type",order.billing,@"billing",order.is_please,@"is_please",order.status,@"status",c_dic,@"complaint",nil];
                    }else {
                        if (![order.payType isEqualToString:@""]) {
                            dic_code = [NSDictionary dictionaryWithObjectsAndKeys:order.codeID,@"code",order.payType,@"pay_type",order.billing,@"billing",order.is_please,@"is_please",order.status,@"status",nil];
                        }else {
                            dic_code = [NSDictionary dictionaryWithObjectsAndKeys:order.codeID,@"code",order.status,@"status",nil];
                        }
                    }

                    [tempArray3 addObject:dic_code];
                }else {//本地下的订单
                    NSDictionary *c_dic = nil;//投诉
                    if (![order.reason isEqualToString:@""]) {
                        c_dic = [NSDictionary dictionaryWithObjectsAndKeys:order.reason,@"reason",order.request,@"request", nil];
                    }
                    NSDictionary *dic = nil;
                    if (c_dic.count>0) {
                        dic = [NSDictionary dictionaryWithObjectsAndKeys:order.carNum,@"carNum",order.price,@"price",order.prods,@"prods",order.payType,@"pay_type",order.status,@"status",order.store_id,@"store_id",order.is_please,@"is_please",order.time,@"time",order.billing,@"billing",order.user_id,@"user_id",c_dic,@"complaint", nil];
                    }else {
                        dic = [NSDictionary dictionaryWithObjectsAndKeys:order.carNum,@"carNum",order.price,@"price",order.prods,@"prods",order.payType,@"pay_type",order.status,@"status",order.store_id,@"store_id",order.is_please,@"is_please",order.time,@"time",order.billing,@"billing",order.user_id,@"user_id", nil];
                    }
                    
                    [tempArray2 addObject:dic];
                }
            }
        }
        NSMutableDictionary *dicc = [NSMutableDictionary dictionary];
        
        [dicc setObject:tempArray forKey:@"customer"];
        [dicc setObject:tempArray2 forKey:@"order"];
        [dicc setObject:tempArray3 forKey:@"code"];
        
        NSString *str = [dicc JSONString];
        DLog(@"str = %@",str);
        if (str) {
            self.postString = str;
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(syncByString) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}
-(void)syncByString {
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,ksync]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.postString,@"syncInfo", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *str = [r startSynchronousWithError:&error];
    NSDictionary *result = [str objectFromJSONString];
    NSLog(@"result = %@",result);
    if ([[result objectForKey:@"status"] isEqualToString:@"success"]) {
        BOOL success1 = [[LanTaiOrderManager sharedInstance]deleteTable:@"orderInfo"];
        BOOL success2 = [[LanTaiOrderManager sharedInstance]deleteTable:@"customer"];
        BOOL success3 = [[LanTaiOrderManager sharedInstance]deleteTable:@"member"];
        if (success1 && success2 && success3) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int sync = [[defaults objectForKey:@"sync"]intValue];
            if (sync != 0) {
                [defaults removeObjectForKey:@"sync"];
                [defaults setObject:@"0" forKey:@"sync"];
            }
            [defaults synchronize];
            [self setRightBtnWith:YES];
            [self getData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self errorAlert:@"数据上传成功"];
        }
    }
}
#pragma mark - View lifecycle
-(void)netWork:(id)sender {
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        [DataService sharedService].netWorking = NO;
        if ([DataService sharedService].refreshing) {
            [self getDataFromDB];
        }
        [self setRightBtnWith:YES];
    }else {
        [DataService sharedService].netWorking = YES;
        if ([DataService sharedService].refreshing)  {
            [self getData];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int sync = [[defaults objectForKey:@"sync"]intValue];
        if (sync != 1) {
            [self setRightBtnWith:YES];
        }else {
            [self setRightBtnWith:NO];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        [self getDataFromDB];
    }else {
        [self getData];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(netWork:) userInfo:nil repeats:YES];
}

-(void)setRightBtnWith:(BOOL)success {
    self.navigationItem.rightBarButtonItems = nil;
    if (success) {
        [self addRightnaviItemsWithImage:@"back" andImage:@"ip" andImage:nil];
    }else {
        [self addRightnaviItemsWithImage:@"back" andImage:@"ip" andImage:@"data"];
    }
}


- (void)viewDidLoad
{
    _orderTable.delegate = self;
    waitList = [NSMutableArray array];
    //获取正在进行中的订单和预约信息
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        [self getDataFromDB];
    }else {
//        [DataService sharedService].netWorking = YES;
        [self getData];
    }
    [self setRightBtnWith:YES];
    self.mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg"]];
    self.hideView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"open_bg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.jpg"]];
    [super viewDidLoad];
    
    CGRect frame = self.txtCarNum.frame;
    frame.size.height = 48;
    self.txtCarNum.frame = frame;
    
    //字母数组
    self.letterArray = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    //下拉刷新
    __block MainViewController *manView = self;
    __block UITableView *orderTable_temp = _orderTable;
    [_orderTable addPullToRefreshWithActionHandler:^{
        [manView getData];
        [orderTable_temp.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
    
//    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.txtCarNum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sure:) name:@"sure" object:nil];
    
}

#pragma mark -本地获取信息
-(void)getDataFromDB {
    self.waitList = nil;
    NSArray *array = [[LanTaiOrderManager sharedInstance]loadDataFromTable];
    if (array.count>0) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (Order *orderInfo in array) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderInfo.carNum,@"num",orderInfo.status,@"status",orderInfo.codeID,@"codeID", nil];
            [tempArray addObject:dic];
        }
        self.waitList = [NSMutableArray arrayWithArray:tempArray];
        [self.orderTable reloadData];
    }
}

- (void)sure:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    NSString *str = [dic objectForKey:@"name"];
    self.txtCarNum.text = str;
    [UIView animateWithDuration:0.35 animations:^{
        self.sxView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.sxView.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.sxView.view removeFromSuperview];
            self.sxView = nil;
        }
    }];
}
//刷新按钮
- (IBAction)clickRefreshBtn:(id)sender{
    [txtCarNum resignFirstResponder];
    if ([DataService sharedService].store_id) {
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            [DataService sharedService].netWorking = NO;
            [self errorAlert:kNoReachable];
        }else {
            [DataService sharedService].netWorking = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int sync = [[defaults objectForKey:@"sync"]intValue];
            if (sync != 1) {
                [self setRightBtnWith:YES];
            }else {
                [self setRightBtnWith:NO];
            }
            
            MBProgressHUD *hud = [[MBProgressHUD alloc]init];
            hud = [MBProgressHUD showHUDAddedTo:self.mainView animated:YES];
            hud.labelText = @"正在努力加载...";
            
            STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kRefresh]];
            [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id", nil]];
            [r setPostDataEncoding:NSUTF8StringEncoding];
            r.completionBlock = ^(NSDictionary *headers,NSString *boby){
                NSDictionary *result = [boby objectFromJSONString];
                DLog(@"%@",result);
                if ([[result objectForKey:@"status"] intValue]==1) {
                    [DataService sharedService].reserve_list = [result objectForKey:@"reservation"];
                    self.lblCount.text = [NSString stringWithFormat:@"%d",[[DataService sharedService].reserve_list count]];
                    [MBProgressHUD hideHUDForView:self.mainView animated:YES];
                }
            };
            r.errorBlock = ^(NSError *error){
                DLog(@"%@",error);
            };
            [r startAsynchronous];
        }
    }
}
//根据车牌号查询
-(void)showSearchResult {
    OrderViewController *orderView = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    orderView.car_num = self.txtCarNum.text;
    [self.navigationController pushViewController:orderView animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)closeAlert:(NSTimer*)timerr {
    [(AHAlertView*) timerr.userInfo  dismissWithStyle:AHAlertViewDismissalStyleZoomDown];
}
- (IBAction)clickSearchBtn:(id)sender{
    [txtCarNum resignFirstResponder];
    if(self.txtCarNum.text.length==0){
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请输入车牌号"];
        [alertt show];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeAlert:) userInfo:alertt repeats:NO];
    }else{
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            OrderViewController *orderView = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
            orderView.car_num = self.txtCarNum.text;
            [self.navigationController pushViewController:orderView animated:YES];
        }else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(showSearchResult) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

//查看预约信息
- (IBAction)clickShowBtn:(id)sender{
    [txtCarNum resignFirstResponder];
    int count = [self.lblCount.text intValue];
    if (count == 0) {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"暂没有预约信息"];
        [alertt show];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeAlert:) userInfo:alertt repeats:NO];
    }else {
        ReservationViewController *reservationView = [[ReservationViewController alloc] initWithNibName:@"ReservationViewController" bundle:nil];
        reservationView.reservList = [NSMutableArray arrayWithArray:[DataService sharedService].reserve_list];
        [self.navigationController pushViewController:reservationView animated:YES];
    }
}

//显示隐藏正在进行中的订单
- (IBAction)clickStatusImg:(UIButton *)sender{
    [txtCarNum resignFirstResponder];
    CGRect frame = self.view.bounds;
    [UIView beginAnimations:nil context:nil];
    CGRect btnFrame = self.statusImg.frame;
    CGRect tFrame = self.hideView.frame;
    if (btnFrame.origin.x + btnFrame.size.width == frame.size.width) {
        btnFrame.origin.x -= tFrame.size.width;
        tFrame.origin.x -= tFrame.size.width;
        [sender setImage:[UIImage imageNamed:@"open_btn"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"open_btn"] forState:UIControlStateHighlighted];
    }else{
        btnFrame.origin.x += tFrame.size.width;
        tFrame.origin.x += tFrame.size.width;
        [sender setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateHighlighted];
    }
    self.statusImg.frame = btnFrame;
    self.hideView.frame = tFrame;
    [UIView commitAnimations];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return waitList.count;
}
//进行中订单
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *order = [waitList objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int status = [[order objectForKey:@"status"]intValue];
    if (status == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 未施工",[order objectForKey:@"num"]];
    }else if (status == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 施工中",[order objectForKey:@"num"]];
    }else if (status == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 等待付款",[order objectForKey:@"num"]];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}
//施工中的信息
-(void)showOrderView {
    [self.navigationController pushViewController:self.orderView2 animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [txtCarNum resignFirstResponder];
    self.orderView2 = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        NSDictionary *order = [waitList objectAtIndex:indexPath.row];
        orderView2.car_num = [order objectForKey:@"num"];
        orderView2.car_id = [order objectForKey:@"codeID"];
        [self.navigationController pushViewController:self.orderView2 animated:YES];
        
    }else {
        NSDictionary *order = [waitList objectAtIndex:indexPath.row];
        orderView2.car_num = [order objectForKey:@"num"];
        orderView2.car_id = [order objectForKey:@"id"];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.dimBackground = NO;
        [hud showWhileExecuting:@selector(showOrderView) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }
    //施工中的信息 
    
}

#pragma mark - 匹配车牌

-(void)addDataWithString:(NSString *)string  {
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([DataService sharedService].matchArray.count >0) {
        int i=0;
        BOOL exit = NO;
        while (i<[DataService sharedService].matchArray.count) {
            NSString *str = [[DataService sharedService].matchArray objectAtIndex:i];
            if ([str isEqualToString:string]) {
                NSLog(@"在数组里");
                exit = YES;
                break;
            }
            i++;
        }
        if (exit == NO) {
            [tempArray addObject:string];
        }
    }else {
        [tempArray addObject:string];
    }
    if (tempArray.count>0) {
        [[DataService sharedService].matchArray addObjectsFromArray:tempArray];
        [DataService sharedService].sectionArray = [Utils matchArray];
    }
}
-(void)checkData {
    NSString *car = [self.txtCarNum.text substringToIndex:2];
    NSString *string = [self.txtCarNum.text substringToIndex:1];
    NSString *regexCall = @"[\u4E00-\u9FFF]+$";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:string]) {
        NSRange range = NSMakeRange (1, 2);
        NSString *string2 = [self.txtCarNum.text substringWithRange:range];
        NSString *regexCall2 = @"[a-z A-Z]+$";
        NSPredicate *predicateCall2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall2];
        if ([predicateCall2 evaluateWithObject:string2]) {
            [self addDataWithString:car];
        }
    }
}

- (void)keyBoardWillShow:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.mainView.frame;
    if (frame.origin.y==92) {
        frame.origin.y = -70;
    }
    self.mainView.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyBoardWillHide:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.mainView.frame;
    if (frame.origin.y==-70) {
        frame.origin.y = 92;
    }
    self.mainView.frame = frame;
    if (self.txtCarNum.text.length >2) {
        [self checkData];
    }
    [UIView commitAnimations];
}
-(void)textFieldChanged:(NSNotification *)sender {
    UITextField *txtField = (UITextField *)sender.object;

    if (txtField.text.length == 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.sxView.view removeFromSuperview];
        self.sxView = nil;
        [UIView commitAnimations];

    }else if (txtField.text.length == 1) {
        for (int i=0; i<self.letterArray.count; i++) {
            NSString *str = [self.letterArray objectAtIndex:i];
            if ([str isEqualToString:txtField.text] || ([[str lowercaseString] isEqualToString:txtField.text])) {
                NSArray *array = [[DataService sharedService].sectionArray objectAtIndex:i];
                if (array.count>0 && self.sxView == nil) {
                    self.sxView = [[ShaixuanView alloc]initWithNibName:@"ShaixuanView" bundle:nil];
                    self.sxView.view.frame = CGRectMake(120, 210, 0, 0);
                    self.sxView.dataArray = array;
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.35];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    self.sxView.view.frame = CGRectMake(120, 210, 200, 110);
                    [self.mainView addSubview:self.sxView.view];
                    [UIView commitAnimations];

                }
            }
        }
    }
}
@end
