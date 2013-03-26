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

@interface PayStyleViewController ()

@end

@implementation PayStyleViewController

@synthesize delegate;
@synthesize order;
@synthesize billingBtn;
@synthesize isSuccess,codeStr;
@synthesize payStyle,phoneView,codeView,txtCode,txtPhone;

//支付
- (void)pay:(int)type{
    if (self.order) {
        STHTTPRequest *r  = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kPay]];
        NSString *billing = @"1";
        if (self.billingBtn.isOn) {
            billing = @"1";
        }else{
            billing = @"0";
        }
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[order objectForKey:@"order_id"],@"order_id",[order objectForKey:@"is_please"],@"please",[DataService sharedService].store_id,@"store_id",billing,@"billing",[NSNumber numberWithInt:type],@"pay_type",self.txtCode.text,@"code", nil]];
        [r setPostDataEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
        DLog(@"%@",result);
        if ([[result objectForKey:@"status"] intValue]==1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"交易成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            isSuccess = TRUE;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:[NSString stringWithFormat:@"交易失败,%@！",[result objectForKey:@"content"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            isSuccess = FALSE;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePopView:)]) {
        [self.delegate closePopView:self];
    }
}

//刷卡支付，调用钱方
- (BOOL)payPal{
//    NSString *busicode = @"";
    NSString *callback = @"pospal";//[[[NSBundle mainBundle] infoDictionary] objectForKey:@"C"];
    NSString *appname = @"lantan";
    NSString *params = [NSString stringWithFormat:@"appid=%@&amount=%@&tradetype=%@&callback=%@&appname=%@",kPosAppId,@"1",@"0",callback,appname,nil];
    NSString *strKey = [NSString stringWithFormat:@"%@qfpos",params];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"你还没安装QFPOS安全支付插件，建议你先安装再发起交易！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
}

- (IBAction)closePopup:(UISegmentedControl *)sender
{
    //根据不同的支付方式
    if (sender.selectedSegmentIndex == 0) {
        [self pay:sender.selectedSegmentIndex];
    }else if (sender.selectedSegmentIndex == 1 && order){
        [self payPal];
    }else if (sender.selectedSegmentIndex == 2){
        self.phoneView.hidden = NO;
        self.codeView.hidden = YES;
        self.payStyle.hidden = YES;
    }
}

- (void)payResult:(NSNotification *)notification{
    NSString *result = [notification object];
    if ([result isEqualToString:@"success"]) {
        [self pay:1];
    }else if ([result isEqualToString:@"fail"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"交易失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

//提交输入的验证码
- (IBAction)clickCodeBtn:(id)sender{
    if (self.txtCode.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"请输入验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",kSendVerifyCode]];
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.txtPhone.text,@"mobilephone",[order objectForKey:@"price"],@"price",self.txtCode.text,@"verify_code",[order objectForKey:@"content"],@"content", nil]];
        [r setPostDataEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
        DLog(@"%@",result);
        if ([[result objectForKey:@"status"] integerValue] == 1) {
            [self pay:2];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:[result objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}

//发送验证码
- (IBAction)clickSendCode:(id)sender{
    if (self.txtPhone.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"请输入手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@",kSendMeg]];
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.txtPhone.text,@"mobilephone",[order objectForKey:@"price"],@"price", nil]];
        [r setPostDataEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
        DLog(@"%@",result);
        if ([[result objectForKey:@"status"] integerValue] == 1) {
            self.codeView.hidden = NO;
            self.phoneView.hidden = YES;
            self.payStyle.hidden = YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"输入的号码有误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"payQFPOS" object:nil];
    self.payStyle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
    self.phoneView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
    self.codeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
