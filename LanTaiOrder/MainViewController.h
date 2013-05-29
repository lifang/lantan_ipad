//
//  MainViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
// 首页面

#import <UIKit/UIKit.h>
#import "ShaixuanView.h"

@class OrderViewController;
@interface MainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *waitList;
@property (nonatomic,strong) ShaixuanView *sxView;
@property (nonatomic,strong) IBOutlet UITextField *txtCarNum;
@property (nonatomic,strong) IBOutlet UITableView *orderTable;
@property (nonatomic,strong) IBOutlet UILabel *lblCount;
@property (nonatomic,strong) IBOutlet UIButton *statusImg;
@property (nonatomic,strong) IBOutlet UIView *mainView;
@property (nonatomic,strong) IBOutlet UIView *hideView;

@property (nonatomic,strong) NSMutableArray *letterArray;

- (IBAction)clickSearchBtn:(id)sender;
- (IBAction)clickShowBtn:(id)sender;
- (IBAction)clickRefreshBtn:(id)sender;
- (IBAction)clickStatusImg:(UIButton *)sender;


@property (nonatomic, strong) OrderViewController *orderView2;
@end
