//
//  AppDelegate.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) InitViewController *lantan_initView;
//判断版本
@property(nonatomic, strong) NSString *versionUrlStr;
@property(nonatomic, strong) NSMutableData *definitionData;//请求到应用id的数据信息
- (void)showRootView;
+ (AppDelegate *)shareInstance;
@end
