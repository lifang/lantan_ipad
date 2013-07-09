//
//  BaseViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"


@interface BaseViewController ()

@end

@implementation BaseViewController


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightTapped:(id)sender{
    [DataService sharedService].refreshing = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)leftTapped:(id)sender{
    
}

- (void)addLeftnaviItemWithImage:(NSString *)imageName{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(leftTapped:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)setIp:(id)sender {
    [DataService sharedService].kDomain = nil;
    [DataService sharedService].kHost = nil;
    [DataService sharedService].str_ip = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"IP"];
    [defaults synchronize];
    
    [DataService sharedService].user_id = nil;
    [DataService sharedService].reserve_list = nil;
    [DataService sharedService].reserve_count = nil;
    [DataService sharedService].store_id = nil;
    [DataService sharedService].car_num = nil;
    NSUserDefaults *defaultss = [NSUserDefaults standardUserDefaults];
    [defaultss removeObjectForKey:@"userId"];
    [defaultss removeObjectForKey:@"storeId"];
    [defaultss synchronize];
    
    InitViewController *initView = [[InitViewController alloc]initWithNibName:@"InitViewController" bundle:nil];
    [self presentViewController:initView animated:YES completion:nil];
}
- (void)syncData:(id)sender {
    
}
- (void)addRightnaviItemsWithImage:(NSString *)imageName andImage:(NSString *)image1 andImage:(NSString *)image2 {
    NSMutableArray *mycustomButtons = [NSMutableArray array];
    
    if (imageName != nil && ![imageName isEqualToString:@""]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", imageName]] forState:UIControlStateHighlighted];
        btn.userInteractionEnabled = YES;
        [btn addTarget:self action:@selector(rightTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [mycustomButtons addObject: item];
        btn = nil;
        item = nil;
    }
    
    
    if (image1 != nil && ![image1 isEqualToString:@""]) {
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn2 setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", image1]] forState:UIControlStateHighlighted];
        btn2.userInteractionEnabled = YES;
        [btn2 addTarget:self action:@selector(setIp:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
        [mycustomButtons addObject: item2];
        btn2 = nil;
        item2 = nil;
    }
    
    
    if (image2 != nil && ![image2 isEqualToString:@""]) {
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btn3 setImage:[UIImage imageNamed:image2] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", image2]] forState:UIControlStateHighlighted];
        btn3.userInteractionEnabled = YES;
        [btn3 addTarget:self action:@selector(syncData:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:btn3];
        [mycustomButtons addObject: item3];
        btn3 = nil;
        item3 = nil;
    }
    
    self.navigationItem.rightBarButtonItems=mycustomButtons;
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)errorAlert:(NSString *)message
{
    [AHAlertView applyCustomAlertAppearance];
    AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:message];
    __block AHAlertView *alert = alertt;
    [alertt setCancelButtonTitle:@"确定" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
        alert = nil;
    }];
    [alertt show];
}
- (void)errorAlertWithbtns:(NSString *)message
{
    [AHAlertView applyCustomAlertAppearance];
    AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:message];
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

@end
