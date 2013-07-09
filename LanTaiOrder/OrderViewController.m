//
//  OrderViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-1.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "OrderViewController.h"
#import "AddViewController.h"
#import "ProductCell.h"
#import "OldProductCell.h"
#import "ComplaintViewController.h"
#import "PicViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "PayViewController.h"
#import "TabHeader.h"
#import "Customer.h"//客户
#import "CarBrand.h"//车辆
#import "CarModel.h"//车辆
#import "Products.h"
#import "Order.h"//订单
#import "Member.h"//订单关联的产品
#import "EmployeeInfo.h"
#import "CarCapital.h"

@interface OrderViewController ()<PicViewDelegate>{
    PicViewController *picView;
}

@end

@implementation OrderViewController

@synthesize lblBrand,lblCarNum,lblPhone,lblProduct,lblTime,lblUserName;
@synthesize btnCheckIn,btnDone,btnOldRecord,btnOrderRecord,btnCancel,btnPay;
@synthesize orderView,carInfoBgView,noInfoView,carInfoView,orderTable,workingTable;
@synthesize orderList,orderItems;
@synthesize lblOrderNum,lblReceiver,lblStatus,lblWorkingCar,lblWorkingName,lblTotal;
@synthesize car_num,customer,workingOrder;
@synthesize addOrderView;
@synthesize timeLabel,productLabel;
@synthesize car_id;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - 本地获取客户信息
- (void)getOrderByCarNumWithCar_id:(NSString *)carid {
    NSArray *array = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"customer" WithName:nil andPassWord:nil andCarNum:self.car_num andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:nil];
    if (array.count != 0) {
        self.carInfoView.hidden = NO;
        self.noInfoView.hidden = YES;
        
        for (Customer *ctomer in array) {
            self.lblCarNum.text = ctomer.carNum;
            self.lblBrand.text = [NSString stringWithFormat:@"%@-%@",ctomer.brand_name,ctomer.model_name];
            self.lblUserName.text = ctomer.name;
            self.lblPhone.text = ctomer.phone;
            
            //客户信息
            [self.customer setObject:ctomer.carNum forKey:@"carNum"];
            [self.customer setObject:ctomer.name forKey:@"name"];
            [self.customer setObject:ctomer.phone forKey:@"phone"];
            [self.customer setObject:ctomer.email forKey:@"email"];
            [self.customer setObject:ctomer.birth forKey:@"birth"];
            [self.customer setObject:ctomer.year forKey:@"year"];
            [self.customer setObject:ctomer.brand_name forKey:@"brand_name"];
            [self.customer setObject:ctomer.model_name forKey:@"model_name"];
            [self.customer setObject:ctomer.sex forKey:@"sex"];
        }
    }else {
        self.carInfoView.hidden = YES;
        self.noInfoView.hidden = NO;
    }
    //本地获取订单信息
    NSMutableArray *orderWorking = [NSMutableArray array];//正在进行
    NSMutableArray *orderOld = [NSMutableArray array];//消费纪录
    if (array.count != 0) {//有客户信息之后查看有没有订单
        
        NSArray *orderArray = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"orderInfo" CarNum:self.car_num andCodeID:nil];
        if (orderArray.count>0) {
            for (int i =0; i<orderArray.count; i++) {
                Order *orderInfo = (Order *)[orderArray objectAtIndex:i];
                if ([orderInfo.status intValue]<3) {
                    [orderWorking addObject:orderInfo];
                }else {
                    [orderOld addObject:orderInfo];
                }
            }
            if (orderWorking.count>0) {
                Order *orderInfo = nil;
                if (self.car_id) {
                    for (Order *order in orderWorking) {
                        //点击正在进行中的订单
                        if ([order.codeID isEqualToString:self.car_id] && [order.carNum isEqualToString:self.car_num]) {
                            orderInfo = order;
                        }
                    }
                }else {
                    //搜索车牌后显示的订单
                    orderInfo = (Order *)[orderWorking objectAtIndex:orderWorking.count-1];
                }
                self.timeLabel.hidden = YES;
                self.workingView.hidden = NO;
                self.noWorkingView.hidden = YES;
                self.orderTable.hidden = YES;
                
                self.lblOrderNum.text = [NSString stringWithFormat:@"%@",orderInfo.codeID];
                self.lblStatus.text = [Utils orderStatus:[orderInfo.status intValue]];
                self.lblWorkingName.text = self.lblUserName.text;
                self.lblWorkingCar.text = [NSString stringWithFormat:@"%@",orderInfo.carNum];
                self.lblTotal.text = [NSString stringWithFormat:@"%@",orderInfo.price];
                
                //接待
                NSArray *re_array = [[LanTaiOrderManager sharedInstance]loadDataFromTableWithUser_id:orderInfo.user_id];
                if (re_array.count != 0) {
                    for (EmployeeInfo *employee in re_array) {
                        self.lblReceiver.text = [NSString stringWithFormat:@"%@",employee.name];
                    }
                }
                //关联产品
                NSArray *product_array = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"member" CarNum:nil andCodeID:orderInfo.codeID];
                if (product_array.count>0) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    NSMutableString *prods = [NSMutableString string];
                    for (Member *member in product_array) {
                        NSDictionary *p_dic = nil;
                        if ([member.classify_id intValue]<3) {
                            p_dic = [NSDictionary dictionaryWithObjectsAndKeys:member.name,@"name",member.price,@"price",member.product_id,@"id",member.num,@"num",[NSString stringWithFormat:@"%d",0],@"type", nil];
                        }else {
                            p_dic = [NSDictionary dictionaryWithObjectsAndKeys:member.name,@"name",member.price,@"price",member.product_id,@"id",member.num,@"num",[NSString stringWithFormat:@"%d",3],@"type", nil];
                        }
                        [tempArray addObject:p_dic];
                        [prods appendFormat:@"%@,",member.name];
                    }
                    self.orderItems = [NSMutableArray arrayWithArray:tempArray];
                    self.lblProduct.text = [prods substringWithRange:NSMakeRange(0, prods.length-1)];
                }
                
                [self.workingOrder setObject:orderInfo.price forKey:@"price"];
                [self.workingOrder setObject:self.orderItems forKey:@"products"];
                [self.workingOrder setObject:orderInfo.carNum forKey:@"carNum"];
                [self.workingOrder setObject:orderInfo.codeID forKey:@"code"];
                [self.workingOrder setObject:orderInfo.codeID forKey:@"created_at"];
                [self.workingOrder setObject:self.lblUserName.text forKey:@"username"];
                
               
                self.btnCancel.hidden = NO;
                self.btnPay.hidden = NO; 
            }else {
                self.lblProduct.text = @"";
                self.lblTime.text = @"";
                self.workingView.hidden = YES;
                self.noWorkingView.hidden = NO;
                self.orderTable.hidden = YES;
                self.timeLabel.hidden = YES;//没有时间  隐藏label
                self.productLabel.hidden = YES;//服务lab
                self.btnCancel.hidden = YES;
                self.btnPay.hidden = YES;
            }
            
            if (orderOld.count>0) {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i=orderOld.count-1; i>=0; i--) {
                    Order *orderInfo = (Order *)[orderOld objectAtIndex:i];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    
                    if ([orderInfo.payType intValue] == 5) {
                        [dic setObject:@"免单" forKey:@"pay_type"];
                    }else {
                        [dic setObject:@"现金" forKey:@"pay_type"];
                    }
                    [dic setObject:orderInfo.carNum forKey:@"carNum"];
                    [dic setObject:orderInfo.price forKey:@"price"];
                    [dic setObject:orderInfo.codeID forKey:@"code"];
                    [dic setObject:orderInfo.codeID forKey:@"created_at"];
                    
                    //关联产品
                    NSArray *product_array = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"member" CarNum:nil andCodeID:orderInfo.codeID];
                    if (product_array.count>0) {
                        NSMutableArray *p_arr = [NSMutableArray array];
                        for (Member *member in product_array) {
                            NSDictionary *p_dic = nil;
                            if ([member.classify_id intValue]<3) {
                                p_dic = [NSDictionary dictionaryWithObjectsAndKeys:member.name,@"name",member.price,@"price",member.product_id,@"id",member.num,@"num",[NSString stringWithFormat:@"%d",0],@"type", nil];
                            }else {
                                p_dic = [NSDictionary dictionaryWithObjectsAndKeys:member.name,@"name",member.price,@"price",member.product_id,@"id",member.num,@"num",[NSString stringWithFormat:@"%d",3],@"type", nil];
                            }
                            [p_arr addObject:p_dic];
                        }
                        [dic setObject:p_arr forKey:@"products"];
                    }
                    
                    [tempArray addObject:dic];
                }
                self.orderList = [NSMutableArray arrayWithArray:tempArray];
            }
        }else {
            self.timeLabel.hidden = YES;//没有时间  隐藏label
            self.productLabel.hidden = YES;//服务lab
        }
    }
}

#pragma mark -发送查询请求
- (void)searchOrderByCarNumWithCar_id:(NSString *)carid{
    if (car_num) {
        NSDictionary *result = nil;
        if (self.car_id) {
            STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kShowCar]];
            [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id",car_num,@"car_num",car_id,@"car_id", nil]];
            [r setPostDataEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSString *str = [r startSynchronousWithError:&error];
            result = [str objectFromJSONString];
        }else {
            STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kSearchCar]];
            [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id",car_num,@"car_num", nil]];
            [r setPostDataEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSString *str = [r startSynchronousWithError:&error];
            result = [str objectFromJSONString];
        }

        DLog(@"%@",result);
        if ([[result objectForKey:@"status"] intValue]==1) {
            if ([[result objectForKey:@"customer"] count]==0) {
                self.carInfoView.hidden = YES;
                self.noInfoView.hidden = NO;
            }else{
                self.carInfoView.hidden = NO;
                self.noInfoView.hidden = YES;
                self.lblCarNum.text = [[result objectForKey:@"customer"] objectForKey:@"num"];
                NSString *brand = [NSString stringWithFormat:@"%@-%@",[[result objectForKey:@"customer"] objectForKey:@"brand_name"],[[result objectForKey:@"customer"] objectForKey:@"model_name"]];
                self.lblBrand.text = brand;
                self.lblUserName.text = [[result objectForKey:@"customer"] objectForKey:@"name"];
                self.lblPhone.text = [[result objectForKey:@"customer"] objectForKey:@"mobilephone"];
                //客户信息
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"num"] forKey:@"carNum"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"name"] forKey:@"name"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"mobilephone"] forKey:@"phone"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"car_num_id"] forKey:@"car_num_id"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"customer_id"] forKey:@"customer_id"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"email"] forKey:@"email"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"birth"] forKey:@"birth"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"year"] forKey:@"year"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"model_name"] forKey:@"model_name"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"brand_name"] forKey:@"brand_name"];
                [self.customer setObject:[[result objectForKey:@"customer"] objectForKey:@"sex"] forKey:@"sex"];
                
                //正在进行中的订单
                self.workingOrder = [result objectForKey:@"working"];
                
                if ([[result objectForKey:@"working"] count]==0) {
                    //没有正在进行中的订单
                    self.lblProduct.text = @"";
                    self.lblTime.text = @"";
                    self.workingView.hidden = YES;
                    self.noWorkingView.hidden = NO;
                    self.orderTable.hidden = YES;
                    self.timeLabel.hidden = YES;//没有时间  隐藏label
                    self.productLabel.hidden = YES;//服务lab
                    self.btnCancel.hidden = YES;
                    self.btnPay.hidden = YES;
                }else{
                    if (![[[result objectForKey:@"working"] objectForKey:@"started_at"] isEqual:[NSNull null]]) {
                        NSString *str = [Utils formateDate:[[result objectForKey:@"working"] objectForKey:@"started_at"]];
                        NSString *time = [NSString stringWithFormat:@"%@--%@",str,[Utils formateDate:[[result objectForKey:@"working"] objectForKey:@"ended_at"]]];
                        self.lblTime.text = time;
                        self.timeLabel.hidden = NO;//有时间  不隐藏label
                    }else {
                        self.timeLabel.hidden = YES;//没有时间  隐藏label
                    }
                    
                    NSMutableString *prod = [NSMutableString string];
                    NSArray *products = [[result objectForKey:@"working"] objectForKey:@"products"];
                    for (int x=0; x<products.count; x++) {
                        if (x==products.count-1) {
                          [prod appendFormat:@"%@",[[products objectAtIndex:x] objectForKey:@"name"]];  
                        }else{
                        [prod appendFormat:@"%@,",[[products objectAtIndex:x] objectForKey:@"name"]];
                        }
                    }
                    self.lblProduct.text = prod;
                    self.workingView.hidden = NO;
                    self.noWorkingView.hidden = YES;
                    self.orderTable.hidden = YES;
                    self.lblReceiver.text = [[result objectForKey:@"working"] objectForKey:@"staff"];
                    self.lblOrderNum.text = [[result objectForKey:@"working"] objectForKey:@"code"];
                    self.lblStatus.text = [Utils orderStatus:[[[result objectForKey:@"working"] objectForKey:@"status"] intValue]];
                    self.lblWorkingName.text = [[result objectForKey:@"customer"] objectForKey:@"name"];
                    self.lblWorkingCar.text = [[result objectForKey:@"customer"] objectForKey:@"num"];
                    self.lblTotal.text = [NSString stringWithFormat:@"%@(元)",[[result objectForKey:@"working"] objectForKey:@"price"]];
                    self.orderItems = [[result objectForKey:@"working"] objectForKey:@"products"];
                    if (self.orderItems.count == 0) {
                        self.productLabel.hidden = YES;//服务lab
                    }else {
                        self.productLabel.hidden = NO;//服务lab
                    }
                    
                    self.btnCancel.hidden = NO;
                    self.btnPay.hidden = NO;
                }
                //过往订单
                if ([[result objectForKey:@"old"] count]>0) {
                    self.orderList = [result objectForKey:@"old"];
                }
            }
        }
    }
}
#pragma mark -View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.orderTable reloadData];
    [self.workingTable reloadData];
}
- (void)viewDidLoad
{
    self.orderList = [NSMutableArray array];
    self.orderItems = [NSMutableArray array];
    self.customer = [NSMutableDictionary dictionary];
    self.workingOrder = [NSMutableDictionary dictionary];
    
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        [self getOrderByCarNumWithCar_id:self.car_id];
    }else {
        [self searchOrderByCarNumWithCar_id:self.car_id];
    }
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order_bg"]];
    self.carInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot_bg"]];
    self.noInfoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot_bg"]];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemsWithImage:@"back" andImage:nil andImage:nil];
    }
    
    //加摄像头
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 37, 37)];
    UIImage *image = [UIImage imageNamed:@""];
    imageView.image = image;
    [self.btnCheckIn addSubview:imageView];
    
    
    self.orderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:orderTable]) {
        return orderList.count;
    }else if([tableView isEqual:workingTable]){
        return orderItems.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:workingTable]) {
        return 0;
    }else {
        return 44;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
   
    CGRect frame = CGRectMake(0, 0, 844, 43);
    TabHeader *tabHeader = [[TabHeader alloc] initWithFrame:frame];
    return tabHeader;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:workingTable]) {
        static NSString *CellIdentifier = @"ProductCell";
        NSDictionary *product = [orderItems objectAtIndex:indexPath.row];
        ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.lblName.text = [product objectForKey:@"name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"price"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSString *CellIdentifier = [NSString stringWithFormat:@"OldProductCell%d", [indexPath row]];
        OldProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSDictionary *order = [orderList objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[OldProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier items:[order objectForKey:@"products"]];
        }
        cell.lblCode.text = [order objectForKey:@"code"];
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            NSArray *arr = [[order objectForKey:@"code"] componentsSeparatedByString:@" "];
            cell.lblDate.text = [arr objectAtIndex:0];
        }else {
            //时间格式化
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
            [inputFormatter setLocale:[[NSLocale alloc] init]];
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
            NSDate* createdDate = [inputFormatter dateFromString:[order objectForKey:@"created_at"]];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setLocale:[NSLocale currentLocale]];
            [outputFormatter setDateFormat:@"yyyy.MM.dd"];
            NSString *str = [outputFormatter stringFromDate:createdDate];
            cell.lblDate.text = str;
        }
        
        cell.lblTotal.text = [NSString stringWithFormat:@"%.2f",[[order objectForKey:@"price"] floatValue]];
        cell.lblPay.text = [order objectForKey:@"pay_type"];
        [cell.btnComplaint addTarget:self action:@selector(clickComplaint:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnComplaint.tag = 200 + indexPath.row;
        
        NSString *btnTag = [NSString stringWithFormat:@"%d",cell.btnComplaint.tag];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[DataService sharedService].doneArray];
        if ([array containsObject:btnTag]) {
            if ([DataService sharedService].payNumber == 1) {
                [cell.btnComplaint setBackgroundImage:[UIImage imageNamed:@"btn_cancel.jpg"] forState:UIControlStateNormal];
                [cell.btnComplaint setBackgroundImage:[UIImage imageNamed:@"btn_cancel_active"] forState:UIControlStateHighlighted];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:workingTable]) {
        return 44;
    }else{
        NSDictionary *order = [orderList objectAtIndex:indexPath.row];
        int count = [[order objectForKey:@"products"] count];
        if (count == 0) {
            return 44+20;
        }
        return count * 44 +20;
        }
}

#pragma mark -点击投诉按钮
- (void)clickComplaint:(id)sender{
    UIButton *btn = (UIButton *)sender;
    ////////////////////////////////////////////
    NSString *btnTag = [NSString stringWithFormat:@"%d",btn.tag];
    NSDictionary *order = [orderList objectAtIndex:btn.tag - 200];
    ComplaintViewController *complaintView = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.lblUserName.text forKey:@"name"];
    [dic setObject:self.lblCarNum.text forKey:@"carNum"];
    [dic setObject:[order objectForKey:@"code"] forKey:@"code"];//订单号
    [dic setObject:btnTag forKey:@"tag"];/////////////////////////////////////
    if (![[order objectForKey:@"id"] isKindOfClass:[NSNull class]] && [order objectForKey:@"id"]!= nil) {
        [dic setObject:[order objectForKey:@"id"] forKey:@"order_id"];
    }
    
    [dic setObject:@"1" forKey:@"from"]; // 进入投诉页面的来源
    NSMutableString *prods = [NSMutableString string];
    for (NSDictionary *prod in [order objectForKey:@"products"]) {
        [prods appendFormat:@"%@,",[prod objectForKey:@"name"]];
    }
    if (prods.length != 0) {
        [dic setObject:[prods substringToIndex:prods.length - 1] forKey:@"prods"];
    }
    
    complaintView.info = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self.navigationController pushViewController:complaintView animated:YES];
}

#pragma mark -取消订单（未施工）
-(void)cancleOrder {
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kPayOrder]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[workingOrder objectForKey:@"id"],@"order_id",@"1",@"opt_type", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    if ([[result objectForKey:@"status"] intValue]==1) {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"订单已取消"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertt show];
        
    }else{
        [self errorAlert:@"订单取消失败"];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickCancel:(id)sender{
    if ([workingOrder objectForKey:@"id"] != NULL) {
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            NSArray *paramarray = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",[NSString stringWithFormat:@"%@",[self.workingOrder objectForKey:@"code"]],[NSString stringWithFormat:@"%d",5],nil];
            BOOL success = [[LanTaiOrderManager sharedInstance]addDataToTable:@"orderInfo" WithArray:paramarray];
            if (success) {
                [DataService sharedService].refreshing = YES;
                [AHAlertView applyCustomAlertAppearance];
                AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"订单已取消"];
                __block AHAlertView *alert = alertt;
                [alertt setCancelButtonTitle:@"确定" block:^{
                    alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                    alert = nil;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alertt show];
            }else {
                [self errorAlert:@"订单取消失败"];
            }
        }else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(cancleOrder) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }else {
        NSString *codeID = [self.workingOrder objectForKey:@"code"];
        BOOL success = [[LanTaiOrderManager sharedInstance]deleteTable:@"orderInfo" WithName:nil andPassWord:nil andCarNum:nil andProduct_id:nil andCodeID:codeID];
        if (success) {
            BOOL success2 = [[LanTaiOrderManager sharedInstance]deleteTable:@"member" WithName:nil andPassWord:nil andCarNum:nil andProduct_id:nil andCodeID:codeID];
            if (success2) {
                [DataService sharedService].refreshing = YES;
                [AHAlertView applyCustomAlertAppearance];
                AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"订单已取消"];
                __block AHAlertView *alert = alertt;
                [alertt setCancelButtonTitle:@"确定" block:^{
                    alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                    alert = nil;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alertt show];
            }else {
                [self errorAlert:@"订单取消失败"];
            }
        }
    }
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
            if (array_brand.count >0) {
                for (CarBrand *carBrand in array_brand) {
                    NSMutableArray *tempArray_model = [NSMutableArray array];
                    NSString *car_brand_id = [NSString stringWithFormat:@"%@",carBrand.brand_id];
                    NSArray *array_model = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"carModel" WithName:nil andPassWord:nil andCarNum:nil andBrand_id:nil andCar_brand_id:car_brand_id andProduct_id:nil andClassify_id:nil andCar_capital_id:nil];
                    if (array_model.count>0) {
                        for (CarModel *carModel in array_model) {
                            NSDictionary *model_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",carModel.car_brand_id],@"car_brand_id",[NSString stringWithFormat:@"%@",carModel.model_id],@"id",[NSString stringWithFormat:@"%@",carModel.name],@"name",nil];
                            [tempArray_model addObject:model_dic];
                        }
                    }else {
                        [tempArray_model addObject:@""];
                    }
                    NSDictionary *brand_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",carBrand.name],@"name",[NSString stringWithFormat:@"%@",carBrand.brand_id],@"id",tempArray_model,@"models",[NSString stringWithFormat:@"%@",carBrand.car_capital_id],@"capital_id", nil];
                    [tempArray_brand addObject:brand_dic];
                }
            }else {
                [tempArray_brand addObject:@""];
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
#pragma mark -点击下单按钮
-(void)showAddView {
    self.addOrderView.customer = [NSMutableDictionary dictionaryWithDictionary:self.customer];
    [DataService sharedService].car_num = self.lblCarNum.text;
    [DataService sharedService].number = 0;
    self.addOrderView.step = @"0";
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

//点击下单按钮－登记
-(void)addView {
    self.addOrderView.step = @"0";
    self.addOrderView.car_num = self.car_num;//车牌号
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
-(void)getDataFrom {
    [self getDataFromBrandAndmodel];
    [self getDataFromProducts]; 
    [self.navigationController pushViewController:self.addOrderView animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickDone:(id)sender{
    UIButton *btn = (UIButton *)sender;
    self.addOrderView = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    if (btn.tag==101) {
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            self.addOrderView.step = @"0";
            self.addOrderView.car_num = self.car_num;//车牌号
            [DataService sharedService].number = 0;
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            [hud showWhileExecuting:@selector(getDataFrom) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(addView) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }else if (btn.tag==100){
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            self.addOrderView.customer = [NSMutableDictionary dictionaryWithDictionary:self.customer];
            [DataService sharedService].car_num = self.lblCarNum.text;
            [DataService sharedService].number = 0;
            self.addOrderView.step = @"0";
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            [hud showWhileExecuting:@selector(getDataFrom) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
            
        }else{
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(showAddView) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

- (IBAction)clickOld:(id)sender{
    self.orderTable.hidden = NO;
    self.workingView.hidden = YES;
    self.noWorkingView.hidden = YES;
    UIColor *c = [UIColor colorWithRed:147.0/255.0 green:2.0/255.0 blue:5.0/255.0 alpha:1.0];
    [btnOldRecord setTitleColor:c forState:UIControlStateNormal];
    [btnOldRecord setTitleColor:c forState:UIControlStateHighlighted];
    [btnOrderRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnOrderRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

#pragma mark -付款
-(void)pay {
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kPayOrder]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[workingOrder objectForKey:@"id"],@"order_id",@"0",@"opt_type", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    if ([[result objectForKey:@"status"] intValue]==1) {
        PayViewController *payView  = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
        payView.orderInfo = [result objectForKey:@"order"];
        [self.navigationController pushViewController:payView animated:YES];
    }else {
        [self errorAlert:@"加载失败"];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickPay:(id)sender{
    if ([workingOrder objectForKey:@"id"] != NULL) {
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            [DataService sharedService].netWorking = NO;
            
            NSArray *paramarray = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",[NSString stringWithFormat:@"%@",self.lblCarNum.text],@"",@"",@"",@"",@"",@"",[NSString stringWithFormat:@"%@",[self.workingOrder objectForKey:@"code"]],@"",nil];
            BOOL success = [[LanTaiOrderManager sharedInstance]addDataToTable:@"orderInfo" WithArray:paramarray];
            if (success) {
                //判断同步按钮，避免访问数据库
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                int sync = [[defaults objectForKey:@"sync"]intValue];
                if (sync != 1) {
                    [defaults removeObjectForKey:@"sync"];
                    [defaults setObject:@"1" forKey:@"sync"];
                }
                [defaults synchronize];
                
                NSMutableDictionary *confirmDic = [NSMutableDictionary dictionary];
                [confirmDic setObject:[self.workingOrder objectForKey:@"products"] forKey:@"products"];
                
                [confirmDic setObject:self.lblCarNum.text forKey:@"car_num"];
                //时间格式化
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setLocale:[[NSLocale alloc] init]];
                [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
                NSDate* createdDate = [inputFormatter dateFromString:[self.workingOrder objectForKey:@"created_at"]];
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setLocale:[NSLocale currentLocale]];
                [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *str = [outputFormatter stringFromDate:createdDate];
                [confirmDic setObject:str forKey:@"start"];
                
                [confirmDic setObject:@"" forKey:@"end"];
                [confirmDic setObject:self.lblUserName.text forKey:@"username"];
                [confirmDic setObject:[self.workingOrder objectForKey:@"price"] forKey:@"total"];
                [confirmDic setObject:[self.workingOrder objectForKey:@"code"] forKey:@"code"];
                [confirmDic setObject:@"1" forKey:@"num"];
                PayViewController *payView  = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
                payView.orderInfo = [NSMutableDictionary dictionaryWithDictionary:confirmDic];
                [self.navigationController pushViewController:payView animated:YES];
            }else {
                //插入本地失败
            }
            
        }else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(pay) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }else {
        NSMutableDictionary *confirmDic = [NSMutableDictionary dictionary];
        NSMutableArray *p_array = [NSMutableArray array];//产品
        NSMutableArray *c_array = [NSMutableArray array];//套餐卡
        
        NSArray *products = [self.workingOrder objectForKey:@"products"];
        if (products.count>0) {
            for (NSDictionary *product in products) {
                int  classify_id = [[product objectForKey:@"type"]intValue];
                if (classify_id < 3) {
                    [p_array addObject:product];
                }else {
                    [c_array addObject:product];
                }
            }
            [confirmDic setObject:p_array forKey:@"products"];
            [confirmDic setObject:c_array forKey:@"c_pcard_relation"];
            [confirmDic setObject:[self.workingOrder objectForKey:@"carNum"] forKey:@"car_num"];
            [confirmDic setObject:[self.workingOrder objectForKey:@"created_at"] forKey:@"start"];
            [confirmDic setObject:@"" forKey:@"end"];
            [confirmDic setObject:[self.workingOrder objectForKey:@"username"] forKey:@"username"];
            [confirmDic setObject:[self.workingOrder objectForKey:@"price"] forKey:@"total"];
            [confirmDic setObject:[self.workingOrder objectForKey:@"code"] forKey:@"code"];
        }
        
        
        PayViewController *payView  = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
        payView.orderInfo = [NSMutableDictionary dictionaryWithDictionary:confirmDic];
        [self.navigationController pushViewController:payView animated:YES];
    }
}


- (IBAction)clickPic:(id)sender{
    picView = [[PicViewController alloc] initWithNibName:@"PicViewController" bundle:nil];
    picView.parentController = self;
    picView.delegate = self;
    [self presentPopupViewController:picView animationType:MJPopupViewAnimationSlideBottomBottom];
}

#pragma mark -或登记信息
-(void)reg {
    self.addOrderView.step = @"1";
    self.addOrderView.car_num = self.car_num;//车牌号
    [DataService sharedService].number = 1;
    //下单获取数据
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kBrandProduct]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    
    if ([[result objectForKey:@"status"] intValue]==1) {
        self.addOrderView.brandList = [NSMutableArray arrayWithArray:[result objectForKey:@"brands"]];
        self.addOrderView.productList = [NSMutableArray arrayWithArray:[result objectForKey:@"products"]];
        [self addDataToBrandAndmodel];
        [self addDataToProducts];
    }
    
    [self.navigationController pushViewController:self.addOrderView animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickReg:(id)sender{
    self.addOrderView = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
        self.addOrderView.step = @"1";
        self.addOrderView.car_num = self.car_num;//车牌号
        [DataService sharedService].number = 1;
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [hud showWhileExecuting:@selector(getDataFrom) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
    }else {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.dimBackground = NO;
        [hud showWhileExecuting:@selector(reg) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }
}

- (IBAction)clickWorking:(id)sender{
    UIColor *c = [UIColor colorWithRed:147.0/255.0 green:2.0/255.0 blue:5.0/255.0 alpha:1.0];
    [btnOrderRecord setTitleColor:c forState:UIControlStateNormal];
    [btnOrderRecord setTitleColor:c forState:UIControlStateHighlighted];
    [btnOldRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnOldRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    if(self.workingOrder.count != 0){
        self.workingView.hidden = NO;
        self.noWorkingView.hidden = YES;
    }else{
        self.workingView.hidden = YES;
        self.noWorkingView.hidden = NO;
    }
    self.orderTable.hidden = YES;
}

//关闭弹出框
- (void)closePopView:(PicViewController *)picViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    picView = nil;
}

@end
