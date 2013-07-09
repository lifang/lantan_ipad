//
//  PayStyleViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-13.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PayStyleViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PayStyleViewController ()

@end

@implementation PayStyleViewController

@synthesize delegate;
@synthesize order;
@synthesize billingBtn;
@synthesize isSuccess,codeStr;
@synthesize payStyle,phoneView,codeView,txtCode,txtPhone;
@synthesize payType;
@synthesize segBtn;
@synthesize segBtn2;
@synthesize posView,txtPos;
@synthesize posBtn,posLab,sureBtn;

#pragma mark - 支付
-(void)payWithType {
    STHTTPRequest *r  = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kPay]];
    NSString *billing = @"1";
    if (self.billingBtn.isOn) {
        billing = @"1";
    }else{	
        billing = @"0";
    }
    if (self.payType == 5) {
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[order objectForKey:@"order_id"],@"order_id",[order objectForKey:@"is_please"],@"please",[DataService sharedService].store_id,@"store_id",billing,@"billing",[NSNumber numberWithInt:self.payType],@"pay_type",self.txtCode.text,@"code",[NSNumber numberWithInt:1],@"is_free", nil]];
    }else if (self.payType == 1) {
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[order objectForKey:@"order_id"],@"order_id",[order objectForKey:@"is_please"],@"please",[DataService sharedService].store_id,@"store_id",billing,@"billing",[NSNumber numberWithInt:self.payType],@"pay_type",self.txtCode.text,@"code",[NSNumber numberWithInt:0],@"is_free",[DataService sharedService].kPosAppId,@"appid", nil]];
    }else {
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[order objectForKey:@"order_id"],@"order_id",[order objectForKey:@"is_please"],@"please",[DataService sharedService].store_id,@"store_id",billing,@"billing",[NSNumber numberWithInt:self.payType],@"pay_type",self.txtCode.text,@"code",[NSNumber numberWithInt:0],@"is_free", nil]];
    }
    
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *str = [r startSynchronousWithError:&error];
    NSDictionary *result = [str objectFromJSONString];
    DLog(@"%@",result);

    if ([[result objectForKey:@"status"] intValue]==1) {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"交易成功！"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
        isSuccess = TRUE;
    }else{
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:[NSString stringWithFormat:@"交易失败,%@！",[result objectForKey:@"content"]]];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
        isSuccess = FALSE;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePopView:)]) {
        [self.delegate closePopView:self];
    }
}
- (void)pay:(int)type{
    self.payType = type;
    if (self.order) {
        if ([[Utils connectToInternet] isEqualToString:@"locahost"] || [DataService sharedService].netWorking == NO) {
            if ([DataService sharedService].netWorking == YES) {
                [AHAlertView applyCustomAlertAppearance];
                AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:kNoReachable];
                __block AHAlertView *alert = alertt;
                [alertt setCancelButtonTitle:@"确定" block:^{
                    alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                    alert = nil;
                }];
                [alertt show];
            }else {
                //发票
                NSString *billing = @"1";
                if (self.billingBtn.isOn) {
                    billing = @"1";
                }else{
                    billing = @"0";
                }
                
                BOOL success = [[LanTaiOrderManager sharedInstance]updatetable:@"orderInfo" WithBilling:[NSString stringWithFormat:@"%@",billing] WithRequest:nil WithReason:nil WithIs_please:[NSString stringWithFormat:@"%@",[order objectForKey:@"is_please"]] WithPayType:[NSString stringWithFormat:@"%d",self.payType] WithStatus:[NSString stringWithFormat:@"%d",3] ByCarNum:[order objectForKey:@"carNum"] andCodeID:[order objectForKey:@"code"]];
                if (success) {
                    [AHAlertView applyCustomAlertAppearance];
                    AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"交易成功！"];
                    __block AHAlertView *alert = alertt;
                    [alertt setCancelButtonTitle:@"确定" block:^{
                        alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                        alert = nil;
                    }];
                    [alertt show];
                    isSuccess = TRUE;
                }else{
                    [AHAlertView applyCustomAlertAppearance];
                    AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"交易失败！"];
                    __block AHAlertView *alert = alertt;
                    [alertt setCancelButtonTitle:@"确定" block:^{
                        alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                        alert = nil;
                    }];
                    [alertt show];
                    isSuccess = FALSE;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(closePopView:)]) {
                    [self.delegate closePopView:self];
                }
            }
        }else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(payWithType) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

#pragma mark - 刷卡支付，调用钱方
- (BOOL)payPal{
    NSString *callback = @"pospal";
    NSString *appname = @"澜泰客户订单";
    float account = [[self.order objectForKey:@"price"]floatValue];
    NSString *pricr = [NSString stringWithFormat:@"%2f",account*100];
    NSString *params = [NSString stringWithFormat:@"appid=%@&amount=%@&tradetype=%@&callback=%@&appname=%@&arg=lantan",[DataService sharedService].kPosAppId,pricr,@"0",callback,appname,nil];
    NSString *strKey = [NSString stringWithFormat:@"%@qpos",params];
    NSString *md5Key = [Utils MD5:strKey];
    NSString *stringParams = [NSString stringWithFormat:@"%@&sign=%@",params,md5Key];
    NSString *unicodeText = [stringParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIApplication *applicaion = [UIApplication sharedApplication];
    NSString *posPath = [NSString stringWithFormat:@"QFPayPlug://%@",unicodeText];
    NSURL *url = [NSURL URLWithString:posPath];
    if ([applicaion canOpenURL:url]) {
        [applicaion openURL:url];
        return YES;
    }else{
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"你还没安装QFPOS安全支付插件，建议你先安装再发起交易！"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
        return NO;
    }
}

#pragma mark - 钱方支付
-(IBAction)qfPay:(id)sender {
    [self.txtPos resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCode resignFirstResponder];
    if (self.txtPos.hidden == YES) {
        [self payPal];
    }else {
        NSString *regexCall = @"((\\d{11})$)";
        NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
        if ([predicateCall evaluateWithObject:txtPos.text]) {
            [DataService sharedService].kPosAppId = [NSString stringWithFormat:@"%@",self.txtPos.text];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.txtPos.text forKey:@"qfpay"];
            [defaults synchronize];
            
            [self payPal];
        }else {
            
        }
    }
}

-(IBAction)editPressed:(id)sender {
    self.txtPos.hidden = NO;
    self.posLab.hidden = YES;
    self.posBtn.hidden = YES;
    self.posLab.text = @"";
    self.sureBtn.frame = CGRectMake(129, 77, 60, 30);
    [DataService sharedService].kPosAppId = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"qfpay"];
    [defaults synchronize];
}
#pragma mark - 根据不同的支付方式
- (IBAction)closePopup:(UISegmentedControl *)sender
{
    if ([[Utils connectToInternet] isEqualToString:@"locahost"] || [DataService sharedService].netWorking == NO) {
        if (sender.selectedSegmentIndex == 0) {
            [self pay:0];
        }else if (sender.selectedSegmentIndex == 1) {
            [AHAlertView applyCustomAlertAppearance];
            AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"确定免单？"];
            __block AHAlertView *alert = alertt;
            [alertt setCancelButtonTitle:@"取消" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                alert = nil;
            }];
            [alertt addButtonWithTitle:@"确定" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
                alert = nil;
                [self pay:5];
            }];
            [alertt show];
        }
    }else {
        if (sender.selectedSegmentIndex == 0) {
            [self pay:0];
        }else if (sender.selectedSegmentIndex == 1 && order){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *qfPay = [defaults objectForKey:@"qfpay"];
            if (qfPay != nil) {
                self.txtPos.hidden = YES;
                self.posLab.hidden = NO;
                self.posBtn.hidden = NO;
                self.sureBtn.frame = CGRectMake(173, 77, 60, 30);
                self.posLab.text = qfPay;
                [DataService sharedService].kPosAppId = [NSString stringWithFormat:@"%@",qfPay];
            }else {
                self.txtPos.hidden = NO;
                self.posLab.hidden = YES;
                self.posBtn.hidden = YES;
                self.sureBtn.frame = CGRectMake(129, 77, 60, 30);
            }
            self.posView.hidden = NO;
            self.phoneView.hidden = YES;
            self.codeView.hidden = YES;
            self.payStyle.hidden = YES;
//            [self payPal];
        }else if (sender.selectedSegmentIndex == 2){
            self.phoneView.hidden = NO;
            self.codeView.hidden = YES;
            self.payStyle.hidden = YES;
            self.posView.hidden = YES;
        }else if (sender.selectedSegmentIndex == 3) {
            [AHAlertView applyCustomAlertAppearance];
            AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"确定免单？"];
            __block AHAlertView *alert = alertt;
            [alertt setCancelButtonTitle:@"取消" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                alert = nil;
            }];
            [alertt addButtonWithTitle:@"确定" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
                alert = nil;
                [self pay:5];
            }];
            [alertt show];
        }
    }
    
}

- (void)payResult:(NSNotification *)notification{
    NSString *result = [notification object];
    if ([result isEqualToString:@"success"]) {
        [self pay:1];
    }else if ([result isEqualToString:@"fail"]){
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"交易失败！"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
    }
}

#pragma mark - 提交输入的验证码
-(void)code {
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kSendVerifyCode]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.txtPhone.text,@"mobilephone",[order objectForKey:@"price"],@"price",self.txtCode.text,@"verify_code",[order objectForKey:@"content"],@"content", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] integerValue] == 1) {
        [self pay:2];
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
- (IBAction)clickCodeBtn:(id)sender{
    [self.txtPos resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCode resignFirstResponder];
    if (self.txtCode.text.length == 0) {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请输入验证码！"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
    }else{
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            [AHAlertView applyCustomAlertAppearance];
            AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:kNoReachable];
            __block AHAlertView *alert = alertt;
            [alertt setCancelButtonTitle:@"确定" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                alert = nil;
            }];
            [alertt show];
        }else{
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(code) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

#pragma mark - 发送验证码
-(void)sendCode {
    if (self.txtPhone.text.length == 0) {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请输入手机号！"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
    }else{
        STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kSendMeg]];
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.txtPhone.text,@"mobilephone",[order objectForKey:@"price"],@"price", nil]];
        [r setPostDataEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
        DLog(@"%@",result);
        if ([[result objectForKey:@"status"] integerValue] == 1) {
            self.codeView.hidden = NO;
            self.phoneView.hidden = YES;
            self.payStyle.hidden = YES;
            self.posView.hidden = YES;
        }else{
            [AHAlertView applyCustomAlertAppearance];
            AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"当前号码未购买储值卡或余额不足！"];
            __block AHAlertView *alert = alertt;
            [alertt setCancelButtonTitle:@"确定" block:^{
                alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                alert = nil;
            }];
            [alertt show];
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickSendCode:(id)sender{
    [self.txtPos resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtCode resignFirstResponder];
    if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
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
        [hud showWhileExecuting:@selector(sendCode) onTarget:self withObject:nil animated:YES];
        hud.labelText = @"正在努力加载...";
        [self.view addSubview:hud];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setsetTotal:(NSNotification *)notification {
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.payType = -1;
    if ([[Utils connectToInternet] isEqualToString:@"locahost"] || [DataService sharedService].netWorking == NO) {
        self.segBtn.hidden = YES;
        self.segBtn2.hidden = NO;
        self.segBtn2.momentary = YES;
    }else {
        self.segBtn.hidden = NO;
        self.segBtn2.hidden = YES;
        self.segBtn.momentary = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"payQFPOS" object:nil];
    self.payStyle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
    self.phoneView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
    self.codeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
    self.posView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
}

@end
