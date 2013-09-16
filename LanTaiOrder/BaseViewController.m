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
    UILabel *versionLab = [[UILabel alloc]initWithFrame:CGRectMake(170, 12, 60, 30)];
    versionLab.text = @"V2.1";
    versionLab.backgroundColor = [UIColor clearColor];
    versionLab.font = [UIFont boldSystemFontOfSize:18];
    versionLab.textColor = [UIColor colorWithRed:0.80784341 green:0.57647059 blue:0.58039216 alpha:1.0];
    
    [self.navigationController.navigationBar addSubview:versionLab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (void)syncData:(id)sender {
    
}
- (void)addRightnaviItemsWithImage:(NSString *)imageName andImage:(NSString *)image2 {
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
