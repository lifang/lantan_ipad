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
@synthesize sxView;
@synthesize letterArray;

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
                    [DataService sharedService].workingOrders = nil;
                    [DataService sharedService].workingOrders = [NSMutableArray arrayWithArray:[jsonData objectForKey:@"orders"]];
                    waitList = [DataService sharedService].workingOrders;
                    [self.orderTable reloadData];
                }
            }
        }
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DataService sharedService].refreshing == YES) {
        [self getData];
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
        [self addRightnaviItemsWithImage:@"back" andImage:@"ip"];
    }
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
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    //输入框添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.txtCarNum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sure:) name:@"sure" object:nil];
    
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
- (void)closeAlert:(NSTimer*)timer {
    [(AHAlertView*) timer.userInfo  dismissWithStyle:AHAlertViewDismissalStyleZoomDown];
}
- (IBAction)clickSearchBtn:(id)sender{
    [txtCarNum resignFirstResponder];
    if(self.txtCarNum.text.length==0){
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请输入车牌号"];
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
        orderView2.car_id = [order objectForKey:@"id"];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.dimBackground = NO;
        [hud showWhileExecuting:@selector(showOrderView) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }
    //施工中的信息 
    
}
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
        [UIView setAnimationDuration:1];
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
                    [UIView setAnimationDuration:1];
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
