//
//  MainViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
// 首页面

#import <UIKit/UIKit.h>

@interface MainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *waitList;

@property (nonatomic,strong) IBOutlet UITextField *txtCarNum;
@property (nonatomic,strong) IBOutlet UITableView *orderTable;
@property (nonatomic,strong) IBOutlet UILabel *lblCount;
@property (nonatomic,strong) IBOutlet UIButton *statusImg;
@property (nonatomic,strong) IBOutlet UIView *mainView;

- (IBAction)clickSearchBtn:(id)sender;
- (IBAction)clickShowBtn:(id)sender;
- (IBAction)clickRefreshBtn:(id)sender;
- (IBAction)clickStatusImg:(UIButton *)sender;

@end
