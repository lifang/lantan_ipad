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
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rightTapped:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

@end
