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

@implementation MainViewController
@synthesize txtCarNum,lblCount,orderTable = _orderTable,statusImg,mainView;
@synthesize waitList;
@synthesize orderView2;
@synthesize hideView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

//返回按钮，到登录页面
- (void)rightTapped:(id)sender{
    DLog(@"logout");
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
-(void)getData {
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
    NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",kHost,kIndex]];
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
                    [DataService sharedService].reserve_count = [NSString stringWithFormat:@"%d",[arr count]];
                    [DataService sharedService].reserve_list = arr;
                    
                    if ([DataService sharedService].reserve_count && [[DataService sharedService].reserve_count intValue] > 0) {
                        self.lblCount.text = [DataService sharedService].reserve_count;
                    }else{
                        self.lblCount.text = @"0";
                    }
                }
                if ([jsonData objectForKey:@"orders"]!=nil) {
                    [DataService sharedService].workingOrders = [NSMutableArray arrayWithArray:[jsonData objectForKey:@"orders"]];
                    waitList = [DataService sharedService].workingOrders;
                    [self.orderTable reloadData];
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    _orderTable.delegate = self;
    waitList = [NSMutableArray array];
    //获取正在进行中的订单和预约信息
    [self getData];
    
    self.mainView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg"]];
    self.hideView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"open_bg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.jpg"]];
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    CGRect frame = self.txtCarNum.frame;
    frame.size.height = 48;
    self.txtCarNum.frame = frame;
    
    //下拉刷新
    __block MainViewController *manView = self;
    __block UITableView *orderTable_temp = _orderTable;
    [_orderTable addPullToRefreshWithActionHandler:^{
        [manView getData];
        [orderTable_temp.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    }];
}

//刷新按钮
- (IBAction)clickRefreshBtn:(id)sender{
    if ([DataService sharedService].store_id) {
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
            MBProgressHUD *hud = [[MBProgressHUD alloc]init];
            hud = [MBProgressHUD showHUDAddedTo:self.mainView animated:YES];
            hud.labelText = @"正在努力加载...";
            
            STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kRefresh]];
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
- (void)closeAlert:(NSTimer*)timer {
    [(AHAlertView*) timer.userInfo  dismissWithStyle:AHAlertViewDismissalStyleZoomDown];
}
- (IBAction)clickSearchBtn:(id)sender{
    [txtCarNum resignFirstResponder];
    if(self.txtCarNum.text.length==0){
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请输入车牌号"];
    
        
//        __block AHAlertView *alert = alertt;
//        [alertt setCancelButtonTitle:@"确定" block:^{
//            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
//            alert = nil;
//        }];
        [alertt show];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeAlert:) userInfo:alertt repeats:NO];
    }else{
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
            [hud showWhileExecuting:@selector(showSearchResult) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

//查看预约信息
- (IBAction)clickShowBtn:(id)sender{
    ReservationViewController *reservationView = [[ReservationViewController alloc] initWithNibName:@"ReservationViewController" bundle:nil];
    reservationView.reservList = [NSMutableArray arrayWithArray:[DataService sharedService].reserve_list];
    [self.navigationController pushViewController:reservationView animated:YES];
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 施工中",[order objectForKey:@"num"]];
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
        self.orderView2 = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
        NSDictionary *order = [waitList objectAtIndex:indexPath.row];
        orderView2.car_num = [order objectForKey:@"num"];
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.dimBackground = NO;
        [hud showWhileExecuting:@selector(showOrderView) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }
    
    //施工中的信息 
    
}

@end
