//
//  PayViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PayViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ComplaintViewController.h"
#import "PayStyleViewController.h"
#import "Order.h"

@interface PayViewController ()<PayStyleViewDelegate>{
    PayStyleViewController *payStyleView;
}

@end

@implementation PayViewController

@synthesize lblBrand,lblCarNum,lblEnd,lblPhone,lblStart,lblTotal,lblUsername;
@synthesize productTable,productList,orderInfo,total_count;
@synthesize segBtn,pleaseView,orderBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)rightTapped:(id)sender{
    [DataService sharedService].refreshing = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    self.segBtn.momentary = YES;
    //生成订单，插入正在进行中的订单
    [DataService sharedService].refreshing = YES;
    if (orderInfo) {
        DLog(@"%@",orderInfo);
        lblBrand.text = [orderInfo objectForKey:@"code"];
        lblCarNum.text = [orderInfo objectForKey:@"car_num"];
        lblUsername.text = [orderInfo objectForKey:@"username"];
        lblStart.text = [orderInfo objectForKey:@"start"];
        if (lblStart.text.length <= 0) {
            self.start_lab.hidden = YES;
        }else {
            self.start_lab.hidden = NO;
        }
        lblEnd.text = [orderInfo objectForKey:@"end"];
        if (lblEnd.text.length <= 0) {
            self.end_lab.hidden = YES;
        }else {
            self.end_lab.hidden = NO;
        }
        lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",[[orderInfo objectForKey:@"total"] floatValue]];
        
        self.productList = [NSMutableArray array];
        if ([orderInfo objectForKey:@"products"]) {
            [productList addObjectsFromArray:[orderInfo objectForKey:@"products"]];
        }
        if ([orderInfo objectForKey:@"sale"]) {
            [productList addObject:[orderInfo objectForKey:@"sale"]];
        }
        if ([orderInfo objectForKey:@"c_svc_relation"]) {
            [productList addObjectsFromArray:[orderInfo objectForKey:@"c_svc_relation"]];
        }
        if ([orderInfo objectForKey:@"c_pcard_relation"]) {
            [productList addObjectsFromArray:[orderInfo objectForKey:@"c_pcard_relation"]];
        }
    }
    DLog(@"%@",productList);
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemsWithImage:@"back" andImage:nil];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
    self.orderBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"confirm_bg"]];
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
    DLog(@"%@",product);
    if ([[product objectForKey:@"type"] intValue] == 0) {
        static NSString *CellIdentifier = @"ServiceCell";
        ServiceCell *cell = (ServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:1];
        }
        cell.lblName.text = [product objectForKey:@"name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"price"]];
        if ([product objectForKey:@"num"] != nil && ![[product objectForKey:@"num"] isKindOfClass:[NSNull class]]) {
            cell.lblCount.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"num"]];
        }
        
        cell.stepBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[product objectForKey:@"type"] intValue] == 1){
        static NSString *CellIdentifier = @"SVCardCell";
        SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }

        cell.lblName.text = [product objectForKey:@"name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"-%.2f",[[product objectForKey:@"price"]floatValue]];
        cell.switchBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[product objectForKey:@"type"] intValue] == 2){
        static NSString *CellIdentifier = @"SVCardCell";
        SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }
        if ([[product objectForKey:@"card_type"]intValue] == 0 && [[product objectForKey:@"is_new"]intValue] == 0){
            cell.lblName.text = [NSString stringWithFormat:@"%@(%@)折",[product objectForKey:@"name"],[product objectForKey:@"discount"]];
            cell.lblPrice.text = [NSString stringWithFormat:@"-%.2f",[[product objectForKey:@"price"]floatValue]];
            
        }else {
            cell.lblName.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"name"]];
            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"price"]floatValue]];
        }
        cell.switchBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[product objectForKey:@"type"] intValue] == 3){
        static NSString *CellIdentifier = @"PackageCardCell";
        PackageCardCell *cell = (PackageCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PackageCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:1];
        }
        CGFloat pp = [[product objectForKey:@"price"] floatValue];
        if (pp <0 ) {
            cell.lblName.text = [NSString stringWithFormat:@"%@(优惠:%.2f)",[product objectForKey:@"name"],[[product objectForKey:@"price"] floatValue]];
            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"price"] floatValue]];
        }else {
            cell.lblName.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"name"]];
            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"price"] floatValue]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (IBAction)clickSegBtn:(UISegmentedControl *)sender{
    self.segBtn = (UISegmentedControl *)sender;
    //评价，不满意
    if (sender.selectedSegmentIndex == 0) {
        ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.lblUsername.text forKey:@"name"];
        [dic setObject:self.lblCarNum.text forKey:@"carNum"];
        [dic setObject:[orderInfo objectForKey:@"code"] forKey:@"code"];
        if (![[orderInfo objectForKey:@"id"] isKindOfClass:[NSNull class]] && [orderInfo objectForKey:@"id"]!= nil){
            [dic setObject:[orderInfo objectForKey:@"id"] forKey:@"order_id"];
        }
        [dic setObject:@"0" forKey:@"from"];
        NSMutableString *prods = [NSMutableString string];
        for (NSDictionary *prod in productList) {
            if ([[prod objectForKey:@"type"] intValue]==0) {
               [prods appendFormat:@"%@,",[prod objectForKey:@"name"]]; 
            }
        }
        if (prods.length>0) {
            [dic setObject:[prods substringToIndex:prods.length - 1] forKey:@"prods"];
        }
        
        complaint.info = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:complaint animated:YES];
    }else if (sender.selectedSegmentIndex == 1 || sender.selectedSegmentIndex == 2 || sender.selectedSegmentIndex == 3){
        //评价，弹出框
        payStyleView = nil;
        payStyleView = [[PayStyleViewController alloc] initWithNibName:@"PayStyleViewController" bundle:nil];
        payStyleView.delegate = self;
        payStyleView.codeStr = self.lblBrand.text;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (![[orderInfo objectForKey:@"id"] isKindOfClass:[NSNull class]] && [orderInfo objectForKey:@"id"]!= nil){
            [dic setObject:[orderInfo objectForKey:@"id"] forKey:@"order_id"];
        }else {
            [dic setObject:self.lblCarNum.text forKey:@"carNum"];
            [dic setObject:[orderInfo objectForKey:@"code"] forKey:@"code"];
        }
        [dic setObject:[NSNumber numberWithInt:sender.selectedSegmentIndex] forKey:@"is_please"];
        [dic setObject:[orderInfo objectForKey:@"total"] forKey:@"price"];
        if (![[orderInfo objectForKey:@"content"] isKindOfClass:[NSNull class]] && [orderInfo objectForKey:@"content"]!= nil) {
            [dic setObject:[orderInfo objectForKey:@"content"] forKey:@"content"];
        }
        payStyleView.order = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        [self presentPopupViewController:payStyleView animationType:MJPopupViewAnimationSlideBottomBottom];
    }else {
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
            //取消订单
            if ([[Utils connectToInternet] isEqualToString:@"locahost"] || [DataService sharedService].netWorking == NO) {
                NSArray *array = [[LanTaiOrderManager sharedInstance]loadDataFromTableName:@"orderInfo" CarNum:nil andCodeID:[orderInfo objectForKey:@"code"] andStore_id:[DataService sharedService].store_id];
                if (array.count >0) {
                    for (Order *order in array) {
                        BOOL successful = NO;
                        NSString *code = order.codeID;
                        NSArray *code_arr = [code componentsSeparatedByString:@"-"];
                        if (code_arr.count == 1) {//原有订单=====修改
                            successful = [[LanTaiOrderManager sharedInstance]updatetable:@"orderInfo" WithBilling:@"" WithRequest:nil WithReason:nil WithIs_please:@"" WithPayType:@"" WithStatus:[NSString stringWithFormat:@"%d",5] ByCarNum:[NSString stringWithFormat:@"%@",order.carNum] andCodeID:[NSString stringWithFormat:@"%@",order.codeID]];
                            
                        }else {//删除
                            successful = [[LanTaiOrderManager sharedInstance]deleteTable:@"orderInfo" WithName:nil andPassWord:nil andCarNum:nil andProduct_id:nil andCodeID:code];
                        }
                        if (successful) {
                            //设置  判断是否要上传数据
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSString *syncStr = [defaults objectForKey:@"sync"];
                            int syncValue = 0;
                            if (syncStr==nil) {
                                syncValue -= 1;
                                [defaults setObject:[NSString stringWithFormat:@"%d",syncValue] forKey:@"sync"];
                            }else {
                                syncValue = [[defaults objectForKey:@"sync"]intValue];
                                syncValue -= 1;
                                [defaults removeObjectForKey:@"sync"];
                                [defaults setObject:[NSString stringWithFormat:@"%d",syncValue] forKey:@"sync"];
                            }
                            DLog(@"sync = %@",[defaults objectForKey:@"sync"]);
                            [defaults synchronize];
                            
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
                }else {//本地无相关数据
                    NSString *code = self.lblBrand.text;
                    NSArray *code_arr = [code componentsSeparatedByString:@"-"];
                    if (code_arr.count == 1) {
                        NSArray *paramarray = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",[NSString stringWithFormat:@"%@",[DataService sharedService].store_id],@"",@"",code,[NSString stringWithFormat:@"%d",5],nil];
                        BOOL success = [[LanTaiOrderManager sharedInstance]addDataToTable:@"orderInfo" WithArray:paramarray];
                        if (success) {
                            //设置  判断是否要上传数据
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSString *syncStr = [defaults objectForKey:@"sync"];
                            int syncValue = 0;
                            if (syncStr==nil) {
                                syncValue += 1;
                                [defaults setObject:[NSString stringWithFormat:@"%d",syncValue] forKey:@"sync"];
                            }else {
                                syncValue = [[defaults objectForKey:@"sync"]intValue];
                                syncValue += 1;
                                [defaults removeObjectForKey:@"sync"];
                                [defaults setObject:[NSString stringWithFormat:@"%d",syncValue] forKey:@"sync"];
                            }
                            DLog(@"sync = %@",[defaults objectForKey:@"sync"]);
                            [defaults synchronize];
                            
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
            }else {//有网
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                hud.dimBackground = NO;
                [hud showWhileExecuting:@selector(cancleOrderr) onTarget:self withObject:nil animated:YES];
                hud.labelText = @"正在努力加载...";
                [self.view addSubview:hud];
            }
        }];
        [alertt show];
    }
}
#pragma mark -取消订单（排队等待中）
-(void)cancleOrderr {
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kPayOrder]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[orderInfo objectForKey:@"id"],@"order_id",@"1",@"opt_type", nil]];
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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DataService sharedService].payNumber == 1) {
        //评价，弹出框
        payStyleView = nil;
        payStyleView = [[PayStyleViewController alloc] initWithNibName:@"PayStyleViewController" bundle:nil];
        payStyleView.delegate = self;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (![[orderInfo objectForKey:@"id"] isKindOfClass:[NSNull class]] && [orderInfo objectForKey:@"id"]!= nil) {
            [dic setObject:[orderInfo objectForKey:@"id"] forKey:@"order_id"];
        }else {
            [dic setObject:self.lblCarNum.text forKey:@"carNum"];
            [dic setObject:[orderInfo objectForKey:@"code"] forKey:@"code"];
        }
        [dic setObject:[orderInfo objectForKey:@"code"] forKey:@"code"];
        [dic setObject:[NSNumber numberWithInt:0] forKey:@"is_please"];
        [dic setObject:[orderInfo objectForKey:@"total"] forKey:@"price"];
        if (![[orderInfo objectForKey:@"content"] isKindOfClass:[NSNull class]] && [orderInfo objectForKey:@"content"]!= nil) {
            [dic setObject:[orderInfo objectForKey:@"content"] forKey:@"content"];
        }
        
        payStyleView.order = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self presentPopupViewController:payStyleView animationType:MJPopupViewAnimationSlideBottomBottom];
        
        [DataService sharedService].payNumber = 0;
    }
}

- (void)closePopVieww:(PayStyleViewController *)payStyleViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    [payStyleView.timer invalidate];
    payStyleView.timer = nil;
    if (payStyleViewController.isSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    payStyleView = nil;
}

@end
