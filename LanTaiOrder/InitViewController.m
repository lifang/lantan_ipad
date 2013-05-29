//
//  InitViewController.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-3-29.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "InitViewController.h"
#import "AppDelegate.h"

@interface InitViewController ()

@end

@implementation InitViewController
@synthesize activityView,view2;
@synthesize txt,view1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userInfo = [defaults objectForKey:@"IP"];
    if (userInfo != nil) {
        self.view1.hidden = YES;
        self.view2.hidden = NO;
        [self.activityView startAnimating];
        
        [DataService sharedService].kHost = [NSString stringWithFormat:@"http://%@:3001/api",userInfo];
        [DataService sharedService].kDomain = [NSString stringWithFormat:@"http://%@:3001",userInfo];
        [DataService sharedService].str_ip = [NSString stringWithFormat:@"%@",userInfo];
        [self performSelector:@selector(showMainView) withObject:nil afterDelay:1];
    }else {
        self.view1.hidden = NO;
        self.view2.hidden = YES;
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.activityView stopAnimating];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShoww:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidee:) name: UIKeyboardWillHideNotification object:nil];
}

-(IBAction)btnPressed:(id)sender {
    [self.txt resignFirstResponder];
    NSString *str = @"";
    if (self.txt.text.length == 0) {
        str = @"请输入ip地址";
    }else {
        NSString *regexCall = @"(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\.(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\b";
        NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
        if ([predicateCall evaluateWithObject:self.txt.text]) {
            [DataService sharedService].kHost = [NSString stringWithFormat:@"http://%@:3001/api",self.txt.text];
            [DataService sharedService].kDomain = [NSString stringWithFormat:@"http://%@:3001",self.txt.text];
            [DataService sharedService].str_ip = [NSString stringWithFormat:@"%@",self.txt.text];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.txt.text forKey:@"IP"];
            [defaults synchronize];
            
            DLog(@"%@",[DataService sharedService].kHost);
        }else {
            str = @"请输入正确的ip地址";
        }
    }
    if (str.length==0) {
        self.view1.hidden = YES;
        self.view2.hidden = NO;
        [self.activityView startAnimating];
        
        [self performSelector:@selector(showMainView) withObject:nil afterDelay:1];
    }else {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:str];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showMainView {
    [[AppDelegate shareInstance] showRootView];
}

- (void)keyBoardWillShoww:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.view1.frame;
    if (frame.origin.y==618) {
        frame.origin.y = 218;
    }
    self.view1.frame = frame;
    [UIView commitAnimations];
}

- (void)keyBoardWillHidee:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.view1.frame;
    if (frame.origin.y==218) {
        frame.origin.y = 618;
    }
    self.view1.frame = frame;
    [UIView commitAnimations];
}
@end
