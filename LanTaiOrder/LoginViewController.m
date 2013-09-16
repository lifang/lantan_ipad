//
//  LoginViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "InitViewController.h"
#import "EmployeeInfo.h"
#import "MainViewController.h"

@implementation LoginViewController

@synthesize txtName,txtPwd,loginView;


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
}
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.jpg"]];
    self.loginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    CGRect frame = self.txtName.frame;
    frame.size.height = 45;
    self.txtName.frame = frame;
    frame = txtPwd.frame;
    frame.size.height = 45;
    txtPwd.frame = frame;
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
   
    UILabel *versionLab = [[UILabel alloc]initWithFrame:CGRectMake(170, 10, 60, 30)];
    versionLab.text = @"V2.1";
    versionLab.backgroundColor = [UIColor clearColor];
    versionLab.font = [UIFont boldSystemFontOfSize:16];
    versionLab.textColor = [UIColor colorWithRed:0.80784341 green:0.57647059 blue:0.58039216 alpha:1.0];
    [self.loginView addSubview:versionLab];
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        
    }else{
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)closeAlert:(NSTimer*)timer {
    [(AHAlertView*) timer.userInfo  dismissWithStyle:AHAlertViewDismissalStyleZoomDown];
}
- (BOOL)checkForm{
    NSString *passport = [[NSString alloc] initWithString: self.txtName.text];
    NSString *password = [[NSString alloc] initWithString: self.txtPwd.text];
    NSString *msgStr = @"";
    if (passport.length == 0){
        msgStr = @"请输入用户名";
    }else if (password.length == 0){
        msgStr = @"请输入密码";
    }
    
    if (msgStr.length > 0){
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:msgStr];
        [alertt show];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeAlert:) userInfo:alertt repeats:NO];
        return FALSE;
    }
    return TRUE;
}

-(void)login {
    STHTTPRequest *request = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kLogin]];
    [request setPOSTDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.txtName.text,@"user_name",self.txtPwd.text,@"user_password", nil]];
    [request setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *result = [request startSynchronousWithError:&error];
    NSDictionary *jsonData = [result objectFromJSONString];
    DLog(@"%@",jsonData);
    NSString *text = [jsonData objectForKey:@"info"];
    if (jsonData != nil) {
        if (text.length == 0) {
            NSDictionary *staff = [jsonData objectForKey:@"staff"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@",[staff objectForKey:@"id"]] forKey:@"userId"];
            [defaults setObject:[NSString stringWithFormat:@"%@",[staff objectForKey:@"store_id"]] forKey:@"storeId"];
            [defaults synchronize];
            
            [DataService sharedService].user_id = [NSString stringWithFormat:@"%@",[staff objectForKey:@"id"]];
            [DataService sharedService].store_id = [NSString stringWithFormat:@"%@",[staff objectForKey:@"store_id"]];
            //保存员工信息到数据库
            NSArray *array = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"employee" WithName:self.txtName.text andPassWord:self.txtPwd.text andCarNum:nil andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:nil andStore_id:nil];
            if (array.count == 0) {
                NSArray *paramarray = [[NSArray alloc] initWithObjects:self.txtName.text,self.txtPwd.text,[NSString stringWithFormat:@"%@",[staff objectForKey:@"store_id"]],[NSString stringWithFormat:@"%@",[staff objectForKey:@"id"]],nil];
                [[LanTaiOrderManager sharedInstance]addDataToTable:@"employee" WithArray:paramarray];
            }else {
                //数据改动
                for (EmployeeInfo *employee in array) {
                    if (![employee.store_id isEqualToString:[NSString stringWithFormat:@"%@",[staff objectForKey:@"store_id"]]] || ![employee.user_id isEqualToString:[NSString stringWithFormat:@"%@",[staff objectForKey:@"id"]]]) {
                       BOOL success = [[LanTaiOrderManager sharedInstance]deleteTable:@"employee" WithName:self.txtName.text andPassWord:self.txtPwd.text andCarNum:nil andProduct_id:nil andCodeID:nil];
                        if (success) {
                            NSArray *paramarray = [[NSArray alloc] initWithObjects:self.txtName.text,self.txtPwd.text,[NSString stringWithFormat:@"%@",[staff objectForKey:@"store_id"]],[NSString stringWithFormat:@"%@",[staff objectForKey:@"id"]],nil];
                            [[LanTaiOrderManager sharedInstance]addDataToTable:@"employee" WithArray:paramarray];
                        }
                    }
                }
            }
            [(AppDelegate *)[UIApplication sharedApplication].delegate showRootView];
        }else{
            [AHAlertView applyCustomAlertAppearance];
            AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:text];
            __block AHAlertView *alert = alertt;
            [alertt setCancelButtonTitle:@"确定" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                alert = nil;
            }];
            [alertt show];
        }
    }else {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"出错了"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
        
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickLogin:(id)sender{
    
    [self.txtName resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    if ([self checkForm]) {
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            NSArray *array = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"employee" WithName:self.txtName.text andPassWord:self.txtPwd.text andCarNum:nil andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:nil andStore_id:nil];
            if (array.count != 0) {
                for (EmployeeInfo *employee in array) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[NSString stringWithFormat:@"%@",employee.user_id] forKey:@"userId"];
                    [defaults setObject:[NSString stringWithFormat:@"%@",employee.store_id] forKey:@"storeId"];
                    [defaults synchronize];
                    
                    [DataService sharedService].user_id = [NSString stringWithFormat:@"%@",employee.user_id];
                    [DataService sharedService].store_id = [NSString stringWithFormat:@"%@",employee.store_id];
                    
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showRootView];
                }
            }else {
                //本地数据库没有此用户
                [AHAlertView applyCustomAlertAppearance];
                AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:kNoReachable];
                __block AHAlertView *alert = alertt;
                [alertt setCancelButtonTitle:@"确定" block:^{
                    alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                    alert = nil;
                }];
                [alertt show];
            }
        }else{
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(login) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

- (void)keyBoardWillShow:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.loginView.frame;
    if (frame.origin.y==100) {
        frame.origin.y = -30;
    }
    self.loginView.frame = frame;
    [UIView commitAnimations];
}

- (void)keyBoardWillHide:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.loginView.frame;
    if (frame.origin.y==-30) {
        frame.origin.y = 100;
    }
    self.loginView.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}
@end
