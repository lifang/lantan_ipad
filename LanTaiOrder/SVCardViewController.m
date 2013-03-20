//
//  SVCardViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-18.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "SVCardViewController.h"

@interface SVCardViewController ()

@end

@implementation SVCardViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
