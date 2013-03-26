//
//  AppDelegate.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"

@implementation AppDelegate
@synthesize versionUrlStr,definitionData;


- (void)showRootView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userInfo = [defaults objectForKey:@"userId"];
//    DLog(@"%@--------%i",userInfo,[userInfo isEqualToString:@""]);
    if (userInfo != nil) {
        [DataService sharedService].store_id = [defaults objectForKey:@"storeId"];
        MainViewController *messageView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        UINavigationController *navigationView = [[UINavigationController alloc] initWithRootViewController:messageView];
        //设置导航条背景
        if ([navigationView.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navigationView.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
        }
        self.window.rootViewController = navigationView;
    }else{
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navigationView = [[UINavigationController alloc] initWithRootViewController:loginView];
        self.window.rootViewController = navigationView;
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self showRootView];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    //新版本链接
//    //获取appstore中的应用版本信息
//    //异步请求信息
//    self.definitionData = [NSMutableData data];//数据缓存对象
//    //实际上架后需要更改应用id 
//    NSURL *url=[NSURL URLWithString:@"http://itunes.apple.com/lookup?id=584371753"];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//	[NSURLConnection connectionWithRequest:req delegate:self];
    
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.definitionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error=nil;
    NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:self.definitionData options:NSJSONReadingMutableLeaves error:&error];
    NSArray *infoArray = [jsonData objectForKey:@"results"];
    if ([infoArray count]>0) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *latestVersion = [releaseInfo objectForKey:@"version"];
        NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
        self.versionUrlStr=trackViewUrl;
        
        NSString* appver=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        double clientVer = [appver doubleValue];
        double serverVer = [latestVersion doubleValue];
        if (clientVer>=serverVer) {
            
        }else {
            NSString *message = [NSString stringWithFormat:@"软件有最新版本%@，您是否升级？",latestVersion];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionUrlStr]];
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)decode:(NSString *)urlStr{
    NSArray *params = [urlStr componentsSeparatedByString:@"//"];
    NSArray *dic = [[params objectAtIndex:1] componentsSeparatedByString:@"&"];
    int x = 0;
    for (NSString *item in dic) {
        if([item isEqualToString:[NSString stringWithFormat:@"appid=%@",kPosAppId]]){
            x++;
        }
        if ([item isEqualToString:[NSString stringWithFormat:@"resultmsg=success"]]) {
            x++;
        }
        if (x==2) {
            break;
        }
    }
    if (x==2) {
        return YES;
    }
    return NO;
}
//回调钱方的反馈信息
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString *urlString = [url absoluteString];
    if ([self decode:urlString]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payQFPOS" object:@"success"];
    }else{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"payQFPOS" object:@"fail"];  
    }
    return YES;
}
@end
