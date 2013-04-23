//
//  ConfirmViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-7.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ConfirmViewController.h"
#import "ServiceCell.h"
#import "SVCardCell.h"
#import "PackageCardCell.h"
#import "ProductHeader.h"
#import "PayViewController.h"
#import "AppDelegate.h"

#define OPEN 100
#define CLOSE 1000
@interface ConfirmViewController ()

@end

@implementation ConfirmViewController
@synthesize lblBrand,lblCarNum,lblEnd,lblPhone,lblStart,lblTotal,lblUsername;
@synthesize productTable,productList,orderInfo,total_count,total_count_temp;
@synthesize confirmView,confirmBgView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DataService sharedService].first = YES;
    [DataService sharedService].temp_dictionary = nil;
    [DataService sharedService].temp_dictionary = [NSMutableDictionary dictionary];
    
    [DataService sharedService].row_id_countArray = nil;
    [DataService sharedService].row_id_countArray =[NSMutableArray array];
    
    [DataService sharedService].productList = self.productList;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DataService sharedService].productList = nil;
    [DataService sharedService].productList = [NSMutableArray array];
}
- (void)viewDidLoad
{
    if (orderInfo) {
        lblBrand.text = [orderInfo objectForKey:@"car_brand"];
        lblCarNum.text = [orderInfo objectForKey:@"car_num"];
        lblPhone.text = [orderInfo objectForKey:@"phone"];
        lblUsername.text = [orderInfo objectForKey:@"c_name"];
        lblStart.text = [orderInfo objectForKey:@"start"];
        if ([lblStart.text isEqualToString:@""]) {
            self.start_lab.hidden = YES;
        }else {
            self.start_lab.hidden = NO;
        }
        lblEnd.text = [orderInfo objectForKey:@"end"];
        if ([lblEnd.text isEqualToString:@""]) {
            self.end_lab.hidden = YES;
        }else {
            self.end_lab.hidden = NO;
        }
        
        lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",self.total_count];
    }
    //更新总价
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTotal:) name:@"update_total" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTableView" object:nil];
    
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
    self.confirmBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"confirm_bg"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *product = [productList objectAtIndex:indexPath.row];
    
    //产品，服务
    if ([product objectForKey:@"id"] && ![product objectForKey:@"has_p_card"]) {
        static NSString *CellIdentifier = @"ServiceCell";
        ServiceCell *cell = (ServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }
        cell.lblName.text = [product objectForKey:@"name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"price"]];
        if ([product objectForKey:@"count"]) {
            cell.lblCount.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"count"]];
            cell.stepBtn.value = [[product objectForKey:@"count"] doubleValue];
            
            //第一次加载tableView
            if ([DataService sharedService].first == YES) {
                if ([[DataService sharedService].temp_dictionary objectForKey:[product objectForKey:@"id"]]) {
                    [[DataService sharedService].temp_dictionary removeObjectForKey:[product objectForKey:@"id"]];
                }
                [[DataService sharedService].temp_dictionary setObject:[product objectForKey:@"count"] forKey:[product objectForKey:@"id"]];
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([product objectForKey:@"sale_id"]){
        //活动
        static NSString *CellIdentifier = @"SVCardCell";
        SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }
        cell.lblName.text = [product objectForKey:@"sale_name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"show_price"]];
        if ([[product objectForKey:@"selected"] intValue]== 0) {
            cell.switchBtn.tag = OPEN;
            [cell.switchBtn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];

        }else{
            cell.switchBtn.tag = CLOSE;
            [cell.switchBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([product objectForKey:@"scard_id"]){
        //打折卡
        static NSString *CellIdentifier = @"SVCardCell";
        SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }
        cell.lblName.text = [NSString stringWithFormat:@"%@(%@)折",[product objectForKey:@"scard_name"],[product objectForKey:@"scard_discount"]];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"show_price"]];
        if ([[product objectForKey:@"selected"] intValue]== 0) {
            cell.switchBtn.tag = OPEN;
            [cell.switchBtn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
        }else{
            cell.switchBtn.tag = CLOSE;
            [cell.switchBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([product objectForKey:@"products"]){
        //套餐卡
        NSString *CellIdentifier = [NSString stringWithFormat:@"PackageCardCell%d", [indexPath row]];
        PackageCardCell *cell = (PackageCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PackageCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:0];
        }
        if ([[product objectForKey:@"has_p_card"] integerValue]==0) {
            cell.lblName.text = [NSString stringWithFormat:@"%@(成本价:%.2f)",[product objectForKey:@"name"],[[product objectForKey:@"price"] floatValue]];
            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"show_price"] floatValue]];
        }else{
            cell.lblName.text = [product objectForKey:@"name"];
            cell.lblPrice.text = [NSString stringWithFormat:@"0.00"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据套餐卡相关产品的数量，设置cell 高度
    NSDictionary *product = [productList objectAtIndex:indexPath.row];
    int count = [[product objectForKey:@"products"] count];
    count = count == 0 ? 1 : count;
    return count * 44;
}

- (void)updateTotal:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    //dic套餐卡剩余
    CGFloat f = 0;
    if (self.total_count == 0) {
        f = self.total_count_temp + [[dic objectForKey:@"object"] floatValue];
    }else {
        f = self.total_count + [[dic objectForKey:@"object"] floatValue];
    }
    
    if (f < 0) {
        self.total_count = 0.0;
        self.total_count_temp = f;
    }else {
        self.total_count = f;
    }
    
    self.lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",self.total_count];
    NSIndexPath *idx = [dic objectForKey:@"idx"];
    [self.productList replaceObjectAtIndex:idx.row withObject:[dic objectForKey:@"prod"]];
    [DataService sharedService].productList = self.productList;
//    [[DataService sharedService].productList replaceObjectAtIndex:idx.row withObject:[dic objectForKey:@"prod"]];
//    [self.productTable reloadData];
}

- (IBAction)clickCancel:(id)sender{
    [AHAlertView applyCustomAlertAppearance];
    AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"确定取消订单？"];
    __block AHAlertView *alert = alertt;
    [alertt setCancelButtonTitle:@"取消" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
        alert = nil;
    }];
    [alertt addButtonWithTitle:@"确定" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
        alert = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertt show];
}
- (NSString *)checkForm{
    NSMutableString *prod_ids = [NSMutableString string];
    int x=0,y=0,z=0;
    for (NSDictionary *product in self.productList) {
        if ([product objectForKey:@"id"] && ![product objectForKey:@"has_p_card"]){
            //服务
            [prod_ids appendFormat:@"0_%d_%d,",[[product objectForKey:@"id"] intValue],[[product objectForKey:@"count"] intValue]];
        }else if([product objectForKey:@"sale_id"] && [[product objectForKey:@"selected"] intValue] == 0){
            //活动
            x += 1;
           [prod_ids appendFormat:@"1_%d,",[[product objectForKey:@"sale_id"] intValue]]; 
        }else if([product objectForKey:@"scard_id"] && [[product objectForKey:@"selected"] intValue] == 0){
            //打折卡
            y += 1;
            [prod_ids appendFormat:@"2_%d,",[[product objectForKey:@"scard_id"] intValue]];
        }else if([product objectForKey:@"products"]){
            //套餐卡
            NSMutableString *p_str = [NSMutableString string];
            for (NSDictionary *pro in [product objectForKey:@"products"]) {
                if([[pro objectForKey:@"selected"] intValue]==0){
                    
                    int num = [[pro objectForKey:@"Total_num"]intValue] - [[pro objectForKey:@"num"]intValue];
                    [p_str appendFormat:@"%d=%d-",[[pro objectForKey:@"product_id"] intValue],num];
                }
            }
            z += 1;
           [prod_ids appendFormat:@"3_%d_%d_%@,",[[product objectForKey:@"id"] intValue],[[product objectForKey:@"has_p_card"] intValue],p_str];
        }
    }
    if (x>1 || y>1) {
        return @"";
    }
    return prod_ids;
}
//确认核对信息
-(void)confirm {
    NSString *str = [self checkForm];
    //确定生成订单后进入订单详情页面
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kDone]];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[orderInfo objectForKey:@"c_id"] forKey:@"c_id"];
    [data setObject:[orderInfo objectForKey:@"car_num_id"] forKey:@"car_num_id"];
    [data setObject:[orderInfo objectForKey:@"start"] forKey:@"start"];
    [data setObject:[orderInfo objectForKey:@"end"] forKey:@"end"];
    [data setObject:[orderInfo objectForKey:@"station_id"] forKey:@"station_id"];
    [data setObject:[DataService sharedService].store_id forKey:@"store_id"];
    [data setObject:[DataService sharedService].user_id forKey:@"user_id"];
    [data setObject:[NSString stringWithFormat:@"%.2f",self.total_count] forKey:@"price"];
    [data setObject:[str substringToIndex:str.length - 1] forKey:@"prods"];
    [r setPOSTDictionary:data];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *strr = [r startSynchronousWithError:&error];
    NSDictionary *result = [strr objectFromJSONString];
//    DLog(@"dicc = %@",dicc);
//    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] intValue]==1) {
        PayViewController *payView  = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
        payView.orderInfo = [result objectForKey:@"order"];
        [self.navigationController pushViewController:payView animated:YES];
    }else{
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:[result objectForKey:@"content"]];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickConfirm:(id)sender{
    NSString *str = [self checkForm];
    DLog(@"%@",[DataService sharedService].user_id);
    if ([str length]>0 && [[DataService sharedService].user_id intValue] > 0) {
        //确定生成订单后进入订单详情页面
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [AHAlertView applyCustomAlertAppearance];
            AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:kNoReachable];
            __block AHAlertView *alert = alertt;
            [alertt setCancelButtonTitle:@"确定" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                alert = nil;
            }];
            [alertt show];
        }else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(confirm) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }else if([[DataService sharedService].user_id intValue] == 0){
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请登录"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
            
            [DataService sharedService].user_id = nil;
            [DataService sharedService].reserve_list = nil;
            [DataService sharedService].reserve_count = nil;
            [DataService sharedService].store_id = nil;
            [DataService sharedService].car_num = nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeId"];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showRootView];
        }];
        [alertt show];

    }else{
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"活动，打折卡每类最多可以选择一个"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
    }
}
- (void)reloadTableView:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    NSString * product_id = [dic objectForKey:@"id"];//服务／产品的id
    
    NSMutableArray *p_arr = [NSMutableArray array];
    NSMutableDictionary *p_dic;
    
    CGFloat y = 0;
    NSArray *array = [[DataService sharedService].temp_dictionary allKeys];
    if ([array containsObject:product_id]) {
        y = [[dic objectForKey:@"price"] floatValue];//服务／产品的  单价
        int num_count = 0;
        int index_row = 0;
        int num = 0;
        //从找到row_id_countArray数组中找到产品id
        if ([DataService sharedService].row_id_countArray.count >0) {
            for (int i=0; i<[DataService sharedService].row_id_countArray.count; i++) {
                NSString *str = [[DataService sharedService].row_id_countArray objectAtIndex:i];
                NSArray *arr = [str componentsSeparatedByString:@"_"];
                
                int p_id = [[arr objectAtIndex:1]intValue];//放在单列里面消费的服务/产品id
                if (p_id == [product_id intValue]) {//id相同
                    //通过id找到index
                    index_row = [[arr objectAtIndex:0]intValue];
                    //通过index找到cell
                    NSIndexPath *idx = [NSIndexPath indexPathForRow:index_row inSection:0];
                    NSMutableDictionary *product_dic = [[DataService sharedService].productList objectAtIndex:index_row];
                    PackageCardCell *cell = (PackageCardCell *)[self.productTable cellForRowAtIndexPath:idx];
                    CGFloat x = [cell.lblPrice.text floatValue];
                    
                    p_arr = [product_dic objectForKey:@"products"];
                    DLog(@"p_arr = %@",p_arr);
                    
                    for (int j=0; j<p_arr.count; j++) {
                        
                        p_dic = [[p_arr objectAtIndex:j] mutableCopy];
                        NSString * pro_id = [p_dic objectForKey:@"product_id"];//套餐卡包含的服务/产品id
                        
                        if ([product_id intValue] == [pro_id intValue]) {//id相同  找到服务  产品
                            UIButton *btn = (UIButton *)[cell viewWithTag:OPEN+j];
                            num = [[p_dic objectForKey:@"num"]intValue];//套餐卡剩余次数
                            
                            num_count = [[arr objectAtIndex:2]intValue];//放在单列里面此id产品消费次数
                            y = y * num_count;
                            x =x + y ;
                            
                            //重置temp—dic数据
                            int count_num = [[[DataService sharedService].temp_dictionary objectForKey:product_id]intValue];//剩余次数
                            [[DataService sharedService].temp_dictionary removeObjectForKey:product_id];
                            [[DataService sharedService].temp_dictionary setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                            DLog(@"dic = %@",[DataService sharedService].temp_dictionary);
                            
                            [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"num"];
                            [p_dic setValue:@"1" forKey:@"selected"];
                            [p_arr replaceObjectAtIndex:j withObject:p_dic];
                            
                            int tag = btn.tag;
                            btn.tag = tag - OPEN + CLOSE;
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            
                            NSString *price = [NSString stringWithFormat:@"%.2f",x];
                            cell.lblPrice.text = price;
                            [product_dic setObject:p_arr forKey:@"products"];
                            
                            [product_dic setObject:price forKey:@"show_price"];
                            
                            NSString *p = [NSString stringWithFormat:@"%.2f",y];
                            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",product_dic,@"prod",idx,@"idx",@"2",@"type", nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
                            
                            //删除
                            [[DataService sharedService].row_id_countArray removeObjectAtIndex:i];
                        }
                    }
                }
            }
        }
        
    }
}
@end
