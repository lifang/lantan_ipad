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
@synthesize btn_ip;

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

- (void)addRightnaviItemWithImage:(NSString *)imageName {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", imageName]] forState:UIControlStateHighlighted];
    btn.userInteractionEnabled = YES;
    [btn addTarget:self action:@selector(rightTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    btn = nil;
    item = nil;
    [self.navigationItem setHidesBackButton:YES animated:YES];
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
- (void)addRightnaviItemsWithImage:(NSString *)imageName andImage:(NSString *)image {
    NSMutableArray *mycustomButtons = [NSMutableArray array];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", imageName]] forState:UIControlStateHighlighted];
    btn.userInteractionEnabled = YES;
    [btn addTarget:self action:@selector(rightTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [mycustomButtons addObject: item];  
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn2 setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_active", image]] forState:UIControlStateHighlighted];
    btn2.userInteractionEnabled = YES;
    [btn2 addTarget:self action:@selector(setIp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    [mycustomButtons addObject: item2];
    
    self.navigationItem.rightBarButtonItems=mycustomButtons;
    btn = nil;
    item = nil;
    btn2 = nil;
    item2 = nil;
    [self.navigationItem setHidesBackButton:YES animated:YES];
}
@end
