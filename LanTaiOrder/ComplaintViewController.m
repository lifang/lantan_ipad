//
//  ComplaintViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ComplaintViewController.h"
#import "PayViewController.h"

@interface ComplaintViewController ()

@end

@implementation ComplaintViewController

@synthesize lblCarNum,lblCode,lblName,lblProduct;
@synthesize reasonView,requestView;
@synthesize info,infoBgView;

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
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    if (info) {
        self.lblCarNum.text = [info objectForKey:@"carNum"];
        self.lblCode.text = [info objectForKey:@"code"];
        self.lblName.text = [info objectForKey:@"name"];
        self.lblProduct.text = [info objectForKey:@"prods"];
    }
    [self.reasonView becomeFirstResponder];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
     self.infoBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dot_1_bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//提交
-(void)submit {
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kComplaint]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.reasonView.text,@"reason",self.requestView.text,@"request",[DataService sharedService].store_id,@"store_id",[info objectForKey:@"order_id"],@"order_id", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] intValue] == 1) {
        if([[info objectForKey:@"from"] intValue]==1){
            [DataService sharedService].payNumber = 1;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [DataService sharedService].payNumber = 1;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (IBAction)clickSubmit:(id)sender{
    [reasonView resignFirstResponder];
    [requestView resignFirstResponder];
    if (self.reasonView.text.length==0 || self.requestView.text.length==0) {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请输入投诉理由和要求"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
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
            [hud showWhileExecuting:@selector(submit) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

-(IBAction)clickCancle:(id)sender {
    [reasonView resignFirstResponder];
    [requestView resignFirstResponder];
    [DataService sharedService].payNumber = 0;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
