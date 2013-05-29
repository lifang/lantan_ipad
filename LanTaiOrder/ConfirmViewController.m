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
    
    [DataService sharedService].price_id = nil;
    [DataService sharedService].price_id = [NSMutableDictionary dictionary];
    [DataService sharedService].number_id = nil;
    [DataService sharedService].number_id = [NSMutableDictionary dictionary];
    [DataService sharedService].packageCard_dic = nil;
    [DataService sharedService].packageCard_dic = [NSMutableDictionary dictionary];
    
    //套餐卡
    [DataService sharedService].row_id_countArray = nil;
    [DataService sharedService].row_id_countArray =[NSMutableArray array];
    //活动打折卡
    [DataService sharedService].row_id_numArray = nil;
    [DataService sharedService].row_id_numArray =[NSMutableArray array];
    [DataService sharedService].productList = self.productList;
    //打折卡
    [DataService sharedService].row = nil;
    [DataService sharedService].row =[NSMutableArray array];
    
    //产品，服务
    [DataService sharedService].id_count_price = nil;
    [DataService sharedService].id_count_price =[NSMutableArray array];
    //活动
    [DataService sharedService].saleArray = nil;
    [DataService sharedService].saleArray =[NSMutableArray array];
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
    //套餐卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"reloadTableView" object:nil];
    //活动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saleReloadTableView:) name:@"saleReloadTableView" object:nil];
    //打折卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scardReloadTableView:) name:@"scardReloadTableView" object:nil];
    
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
    self.confirmBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"confirm_bg"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBord)];
    [self.view addGestureRecognizer:tap];
}
-(void)hideKeyBord {
    NSArray *subViews = [self.productTable subviews];
    if (subViews.count >0) {
        for (UIView *v in subViews) {
            if ([v isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *cell = (UITableViewCell *)v;
                NSArray *subView = [cell.contentView subviews];
                if (subView.count>0) {
                    for (UIView *vv in subView) {
                        if ([vv isKindOfClass:[UITextField class]]) {
                            UITextField *txt = (UITextField *)vv;
                            [txt resignFirstResponder];
                        }
                    }
                }
                
            }
        }
    }
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
                if ([[DataService sharedService].price_id objectForKey:[product objectForKey:@"id"]]) {
                    [[DataService sharedService].price_id removeObjectForKey:[product objectForKey:@"id"]];
                    [[DataService sharedService].number_id removeObjectForKey:[product objectForKey:@"id"]];
                }
                [[DataService sharedService].price_id setObject:[product objectForKey:@"price"] forKey:[product objectForKey:@"id"]];
                [[DataService sharedService].number_id setObject:[product objectForKey:@"count"] forKey:[product objectForKey:@"id"]];
                
                NSString *str = [NSString stringWithFormat:@"%@_%@_%@",[product objectForKey:@"id"],[product objectForKey:@"count"],[product objectForKey:@"price"]];
                [[DataService sharedService].id_count_price addObject:str];
            }
        }
        DLog(@"222= %@",[DataService sharedService].id_count_price);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([product objectForKey:@"sale_id"]){
        //活动
        NSString *CellIdentifier = [NSString stringWithFormat:@"SVCardCell%d", [indexPath row]];
       
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
        CGFloat xx = [[product objectForKey:@"show_price"]floatValue];
        cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",xx];
        //纪录打折卡位置
        NSMutableArray *mutableArray = [NSMutableArray array];
        if ([DataService sharedService].row.count>0) {
            BOOL exit = NO;
            int i=0;
            while (i <[DataService sharedService].row.count) {
                int test = [[[DataService sharedService].row objectAtIndex:i]intValue];
                if (test == indexPath.row) {
                    exit = YES;
                    break;
                }
                i++;
            }
            if (exit == NO) {
                [mutableArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
            }
        }else {
            [mutableArray addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
        }
        if (mutableArray.count>0) {
            [[DataService sharedService].row addObjectsFromArray:mutableArray];
        }
        
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
        NSArray *subViews = [cell subviews];
        for (UIView *v in subViews) {
            if ([v isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)v;
                NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
                if (tagStr.length == 3) {
                    int tag_x = btn.tag - OPEN;
                    NSDictionary *dic = [[product objectForKey:@"products"] objectAtIndex:tag_x];
                    if ([[dic objectForKey:@"selected"]intValue] == 1) {
                        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                        btn.tag = tag_x + CLOSE;
                        
                        UILabel *lab_prod = (UILabel *)[cell viewWithTag:tag_x+OPEN+OPEN];
                        lab_prod.text = [NSString stringWithFormat:@"%@(%@)次",[dic objectForKey:@"name"],[dic objectForKey:@"num"]];
                        lab_prod.tag = tag_x+CLOSE+CLOSE;
                    }else {
                        [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                    }
                }
            }
        }
        if ([[product objectForKey:@"has_p_card"] integerValue]==0) {
            
            cell.lblName.text = [NSString stringWithFormat:@"%@(成本价:%.2f)",[product objectForKey:@"name"],[[product objectForKey:@"price"] floatValue]];
            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"price"] floatValue]];
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
        self.total_count_temp = f;
    }
    self.lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",self.total_count];
    NSIndexPath *idx = [dic objectForKey:@"idx"];
    [self.productList replaceObjectAtIndex:idx.row withObject:[dic objectForKey:@"prod"]];
    [DataService sharedService].productList = self.productList;
    
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
            if ([DataService sharedService].id_count_price.count>0) {
                for (int i=0; i<[DataService sharedService].id_count_price.count; i++) {
                    NSMutableString *str = [[DataService sharedService].id_count_price objectAtIndex:i];
                    str = [NSMutableString stringWithString:[str substringToIndex:str.length-1]];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    NSString *p_id = [arr objectAtIndex:0];//产品id
                    if ([p_id intValue] == [[product objectForKey:@"id"]intValue]) {
                        [prod_ids appendFormat:@"0_%@,",str];
                    }
                }
            }
        }else if([product objectForKey:@"sale_id"] && [[product objectForKey:@"selected"] intValue] == 0){
            //活动
            x += 1;
            if ([DataService sharedService].saleArray.count>0) {
                for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                    NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    NSString *s_id = [arr objectAtIndex:0];//活动id
                    if ([s_id intValue] == [[product objectForKey:@"sale_id"] intValue]) {
                        [prod_ids appendFormat:@"1_%@_%.2f,",str,0-[[product objectForKey:@"show_price"]floatValue]];
                    }
                }
            }
        
        }else if([product objectForKey:@"scard_id"] && [[product objectForKey:@"selected"] intValue] == 0){
            //打折卡
            y += 1;
            [prod_ids appendFormat:@"2_%d_%.2f,",[[product objectForKey:@"scard_id"] intValue],0-[[product objectForKey:@"show_price"]floatValue]];
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
            int has_pcard = [[product objectForKey:@"has_p_card"] intValue];
            if (has_pcard == 0) {
                [prod_ids appendFormat:@"3_%d_%d_%@,",[[product objectForKey:@"id"] intValue],[[product objectForKey:@"has_p_card"] intValue],p_str];
            }else {
                [prod_ids appendFormat:@"3_%d_%d_%@_%d,",[[product objectForKey:@"id"] intValue],[[product objectForKey:@"has_p_card"] intValue],p_str,[[product objectForKey:@"cpard_relation_id"] intValue]];
            }
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
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kDone]];
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
    
    NSMutableArray *p_arr = nil;;
    NSMutableDictionary *p_dic;
    
    CGFloat y = 0;
    NSArray *array = [[DataService sharedService].number_id allKeys];
    if ([array containsObject:product_id]) {
        y = [[dic objectForKey:@"price"] floatValue];//服务／产品的  单价
        int num_count = 0;
        int index_row = 0;
        int num = 0;
        //从找到row_id_countArray数组中找到产品id
        if ([DataService sharedService].row_id_countArray.count >0) {
            NSMutableArray *collection_temp = [NSMutableArray array];//纪录[DataService sharedService].row_id_countArray里面要删除的元素
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
                            int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                            [[DataService sharedService].number_id removeObjectForKey:product_id];
                            [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                            DLog(@"dic = %@",[DataService sharedService].number_id);
                            
                            [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"num"];
                            [p_dic setValue:@"1" forKey:@"selected"];
                            [p_arr replaceObjectAtIndex:j withObject:p_dic];
                            
                            int tag = btn.tag;
                            
                            UILabel *lab_prod = (UILabel *)[cell viewWithTag:btn.tag+OPEN];
                            lab_prod.text = [NSString stringWithFormat:@"%@(%@)次",[p_dic objectForKey:@"name"],[p_dic objectForKey:@"num"]];
                            lab_prod.tag = btn.tag- OPEN + CLOSE+ CLOSE;
                            
                            btn.tag = tag - OPEN + CLOSE;
                            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                            
                            NSString *price = [NSString stringWithFormat:@"%.2f",x];
//                            cell.lblPrice.text = price;
                            [product_dic setObject:p_arr forKey:@"products"];
                            
                            [product_dic setObject:price forKey:@"show_price"];
                            
                            NSString *p = [NSString stringWithFormat:@"%.2f",y];
                            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",product_dic,@"prod",idx,@"idx",@"2",@"type", nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
                            
                            //删除
                            [collection_temp addObject:[[DataService sharedService].row_id_countArray objectAtIndex:i]];
                        }
                    }
                }
            }
            //删除
            if (collection_temp.count>0) {
                [[DataService sharedService].row_id_countArray removeObjectsInArray:collection_temp];
            }
        }
    }
}

- (void)saleReloadTableView:(NSNotification *)notification{
    NSDictionary *dic = [notification object];
    NSString * product_id = [dic objectForKey:@"id"];//服务／产品的id
    
    NSMutableArray *collection_index = [NSMutableArray array];//单个活动消费的产品index集合
    NSMutableArray *collection_id = [NSMutableArray array];//单个活动消费的产品id集合
    NSMutableArray *collection_number = [NSMutableArray array];//单个活动消费的产品number集合
    NSMutableArray *collection = [NSMutableArray array];//纪录位置
    NSMutableArray *collection2 = [NSMutableArray array];//纪录位置
    
    NSMutableArray *p_arr = nil;
    NSMutableDictionary *p_dic=nil;
    
    CGFloat discount_x = 0;
    CGFloat discount_y = 0;
    
    NSArray *array = [[DataService sharedService].number_id allKeys];
    if ([array containsObject:product_id]) {
        discount_x = [[dic objectForKey:@"price"] floatValue];//服务／产品的  单价
        int num_count = 0;//放在单列里面此id产品消费次数
        int index_row = 0;
        int num = 0;//活动里面剩余次数
        if ([DataService sharedService].row_id_numArray.count >0) {
            for (int i=0; i<[DataService sharedService].row_id_numArray.count; i++) {
                NSMutableString *str = [[DataService sharedService].row_id_numArray objectAtIndex:i];
                str = [NSMutableString stringWithString:[str substringToIndex:str.length-1]];
                NSArray *arr = [str componentsSeparatedByString:@"_"];
                [collection_index addObject:[arr objectAtIndex:0]];
                [collection_id addObject:[arr objectAtIndex:1]];
                [collection_number addObject:[arr objectAtIndex:2]];
                
            }
        }
        //遍历 id的集合找到位置
        for (int i=0; i<collection_id.count; i++) {
            NSString *prod_id = [collection_id objectAtIndex:i];
            if ([product_id intValue] == [prod_id intValue]) {
                [collection addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        NSMutableArray *collection_temp = [NSMutableArray array];//纪录[DataService sharedService].row_id_numArray里面要删除的元素
        NSMutableArray *sale_tempArray = [NSMutableArray array];//纪录活动里面需要删除的数据
        if (collection.count>0) {
            for (int i=0; i<collection.count; i++) {
                int h = [[collection objectAtIndex:i]intValue];//位置
                //根据位置找到index
                index_row = [[collection_index objectAtIndex:h]intValue];
                //通过index找到的活动
                NSMutableDictionary *product_dic = [[DataService sharedService].productList objectAtIndex:index_row];
                
                discount_y = 0-[[product_dic objectForKey:@"show_price"]floatValue];//差价
                //通过index找到cell
                NSIndexPath *idx = [NSIndexPath indexPathForRow:index_row inSection:0];
                SVCardCell *cell = (SVCardCell *)[self.productTable cellForRowAtIndexPath:idx];
                
                p_arr = [product_dic objectForKey:@"sale_products"];//活动里面产品的集合
                for (int k=0; k<p_arr.count; k++) {
                    p_dic = [[p_arr objectAtIndex:k] mutableCopy];
                    NSString * pro_id = [p_dic objectForKey:@"product_id"];//活动包含的服务/产品id
                    num = [[p_dic objectForKey:@"prod_num"]intValue];//活动里面剩余次数
                    if ([pro_id intValue] == [product_id intValue]) {//id相同,找到服务,产品
                        num_count = [[collection_number objectAtIndex:h]intValue];//放在单列里面此id产品消费次数
                        
                        if ([DataService sharedService].saleArray.count>0) {
                            for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                                NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                                NSArray *arr = [str componentsSeparatedByString:@"_"];
                                NSString *s_id = [arr objectAtIndex:0];//活动id
                                if ([s_id intValue] == [[product_dic objectForKey:@"sale_id"] intValue]) {
                                    [sale_tempArray addObject:[[DataService sharedService].saleArray objectAtIndex:i]];
                                }
                            }
                        }

                        
                        //重置number_id数据
                        int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                        [[DataService sharedService].number_id removeObjectForKey:product_id];
                        [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                        
                        [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                        [p_arr replaceObjectAtIndex:k withObject:p_dic];
                        //删除
                        [collection_temp addObject:[[DataService sharedService].row_id_numArray objectAtIndex:h]];
                    }else {
                        //遍历 id的集合找到位置
                        for (int m=0; m<collection_id.count; m++) {
                            NSString *prod_id = [collection_id objectAtIndex:m];
                            if ([prod_id intValue] == [pro_id intValue]) {
                                [collection2 addObject:[NSString stringWithFormat:@"%d",m]];
                            }
                        }
                        if (collection2.count>0) {
                            for (int j=0; j<collection2.count; j++) {
                                int d = [[collection2 objectAtIndex:j]intValue];
                                NSString *sale_index = [collection_index objectAtIndex:d];
                                if ([sale_index intValue] == index_row) {
                                    num_count = [[collection_number objectAtIndex:d]intValue];//放在单列里面此id产品消费次数
                                    
                                    if ([DataService sharedService].saleArray.count>0) {
                                        for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                                            NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                                            NSArray *arr = [str componentsSeparatedByString:@"_"];
                                            NSString *s_id = [arr objectAtIndex:0];//活动id
                                            if ([s_id intValue] == [[product_dic objectForKey:@"sale_id"] intValue]) {
                                                [sale_tempArray addObject:[[DataService sharedService].saleArray objectAtIndex:i]];
                                            }
                                        }
                                    }
                                    
                                    //重置number_id数据
                                    int count_num = [[[DataService sharedService].number_id objectForKey:pro_id]intValue];//剩余次数
                                    [[DataService sharedService].number_id removeObjectForKey:pro_id];
                                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:pro_id];
                                    
                                    [p_dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                                    [p_arr replaceObjectAtIndex:k withObject:p_dic];
                                    //删除
                                    [collection_temp addObject:[[DataService sharedService].row_id_numArray objectAtIndex:d]];
                                }
                            }
                        }
                    }
                }
                UIButton *btn =(UIButton *)[cell viewWithTag:OPEN];
                int tag = btn.tag;
                btn.tag = tag - OPEN + CLOSE;
                [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                
                CGFloat lbl_price = [cell.lblPrice.text floatValue];
                if ((lbl_price+discount_y) <0.0001f ) {
                    cell.lblPrice.text = @"0";
                }else {
                    cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
                }
                [product_dic setValue:@"1" forKey:@"selected"];
                [product_dic setObject:p_arr forKey:@"sale_products"];
                //////////////////////////////////////////////////////////////////////////////
                [product_dic setObject:@"0" forKey:@"show_price"];
                
                NSString *p = [NSString stringWithFormat:@"%.2f",discount_y];
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:p,@"object",product_dic,@"prod",idx,@"idx",@"2",@"type", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1]; 
            }
        }
        if (collection_temp.count>0) {
            [[DataService sharedService].row_id_numArray removeObjectsInArray:collection_temp];
        }
        if (sale_tempArray.count>0) {
            [[DataService sharedService].saleArray removeObjectsInArray:sale_tempArray];
        }
    }
}
- (void)scardReloadTableView:(NSNotification *)notification {
    if ([DataService sharedService].row.count>0) {
        CGFloat price_x =0;
        for (int i=0; i<[DataService sharedService].row.count; i++) {
            
            int idx_r = [[[DataService sharedService].row objectAtIndex:i]intValue];
            NSIndexPath *idxx = [NSIndexPath indexPathForRow:idx_r inSection:0];
            SVCardCell *cell = (SVCardCell *)[self.productTable cellForRowAtIndexPath:idxx];
            //找到打折卡
            NSMutableDictionary *product_dic =[[[DataService sharedService].productList objectAtIndex:idx_r]mutableCopy];
            if ([[product_dic objectForKey:@"selected"]intValue] == 0) {
                price_x =0- [[product_dic objectForKey:@"show_price"]floatValue];
                [product_dic setValue:@"1" forKey:@"selected"];
                [product_dic setValue:@"0" forKey:@"show_price"];
                cell.lblPrice.text = @"0";
                
                UIButton *btn =(UIButton *)[cell viewWithTag:OPEN];
                int tag = btn.tag;
                btn.tag = tag - OPEN + CLOSE;
                [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                
                NSString *price = [NSString stringWithFormat:@"%.2f",price_x];
                NSDictionary *dic_scard = [NSDictionary dictionaryWithObjectsAndKeys:price,@"object",product_dic,@"prod",idxx,@"idx",@"1",@"type", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic_scard];
            }
        }
    }
}
@end
