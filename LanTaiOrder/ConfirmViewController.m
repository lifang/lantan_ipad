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

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

@synthesize lblBrand,lblCarNum,lblEnd,lblPhone,lblStart,lblTotal,lblUsername;
@synthesize productTable,productList,orderInfo,total_count;
@synthesize confirmView,confirmBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if (orderInfo) {
        lblBrand.text = [orderInfo objectForKey:@"car_brand"];
        lblCarNum.text = [orderInfo objectForKey:@"car_num"];
        lblPhone.text = [orderInfo objectForKey:@"phone"];
        lblUsername.text = [orderInfo objectForKey:@"c_name"];
        lblStart.text = [orderInfo objectForKey:@"start"];
        lblEnd.text = [orderInfo objectForKey:@"end"];
        lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",self.total_count];
    }
    //更新总价
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTotal:) name:@"update_total" object:nil];
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
    self.confirmBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"confirm_bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [cell.switchBtn setOn:YES animated:NO];
        }else{
            [cell.switchBtn setOn:NO animated:NO];
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
            [cell.switchBtn setOn:YES animated:NO];
        }else{
            [cell.switchBtn setOn:NO animated:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([product objectForKey:@"products"]){
        //套餐卡
        static NSString *CellIdentifier = @"PackageCardCell";
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
    CGFloat f = self.total_count + [[dic objectForKey:@"object"] floatValue];
    self.total_count = f;
    self.lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",f];
    NSIndexPath *idx = [dic objectForKey:@"idx"];
    [self.productList replaceObjectAtIndex:idx.row withObject:[dic objectForKey:@"prod"]];
    [self.productTable reloadData];
}

- (IBAction)clickCancel:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *)checkForm{
    NSMutableString *prod_ids = [NSMutableString string];
    int x=0,y=0,z=0;
    for (NSDictionary *product in self.productList) {
        if ([product objectForKey:@"id"] && ![product objectForKey:@"has_p_card"]){
            [prod_ids appendFormat:@"0_%d_%d,",[[product objectForKey:@"id"] intValue],[[product objectForKey:@"count"] intValue]];
        }else if([product objectForKey:@"sale_id"] && [[product objectForKey:@"selected"] intValue] == 0){
            x += 1;
           [prod_ids appendFormat:@"1_%d,",[[product objectForKey:@"sale_id"] intValue]]; 
        }else if([product objectForKey:@"scard_id"] && [[product objectForKey:@"selected"] intValue] == 0){
            y += 1;
            [prod_ids appendFormat:@"2_%d,",[[product objectForKey:@"scard_id"] intValue]];
        }else if([product objectForKey:@"products"]){
            NSMutableString *p_str = [NSMutableString string];
            for (NSDictionary *pro in [product objectForKey:@"products"]) {
                if([[pro objectForKey:@"selected"] intValue]==0){
                    [p_str appendFormat:@"%d=%d-",[[pro objectForKey:@"product_id"] intValue],[[pro objectForKey:@"num"] intValue]];
                }
            }
            z += 1;
           [prod_ids appendFormat:@"3_%d_%d_%@,",[[product objectForKey:@"id"] intValue],[[product objectForKey:@"has_p_card"] intValue],p_str];
        }
    }
    if (x>1 || y>1 || z>1) {
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
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] intValue]==1) {
        PayViewController *payView  = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
        payView.orderInfo = [result objectForKey:@"order"];
        [self.navigationController pushViewController:payView animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:[result objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)clickConfirm:(id)sender{
    NSString *str = [self checkForm];
    DLog(@"%@",[DataService sharedService].user_id);
    if ([str length]>0 && [[DataService sharedService].user_id intValue] > 0) {
        //确定生成订单后进入订单详情页面
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.dimBackground = NO;
        [hud showWhileExecuting:@selector(confirm) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }else if([[DataService sharedService].user_id intValue] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"请登录" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alert show];
        [DataService sharedService].user_id = nil;
        [DataService sharedService].reserve_list = nil;
        [DataService sharedService].reserve_count = nil;
        [DataService sharedService].store_id = nil;
        [DataService sharedService].car_num = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeId"];
        [(AppDelegate *)[UIApplication sharedApplication].delegate showRootView];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"活动，打折卡，套餐卡每类最多可以选择一个" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
