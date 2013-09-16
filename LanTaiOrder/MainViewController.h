//
//  MainViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
// 首页面

#import <UIKit/UIKit.h>
#import "ShaixuanView.h"
#import "GetPictureFromDevice.h"
#import "PlateViewController.h"

@class OrderViewController;
@class AddViewController;

@interface MainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GetPictureFromDeviceDelegate,PlateViewDelegate>


@property (nonatomic,strong) PlateViewController *plateView;
@property (nonatomic,strong) GetPictureFromDevice *getPic;
@property (nonatomic,strong) NSMutableDictionary *waitList;
@property (nonatomic,strong) NSMutableArray *orderArray;
@property (nonatomic,strong) NSMutableArray *nameArray;//标题

@property (nonatomic,strong) ShaixuanView *sxView;
@property (nonatomic,strong) IBOutlet UITextField *txtCarNum;
@property (nonatomic,strong) IBOutlet UITableView *orderTable;
@property (nonatomic,strong) IBOutlet UILabel *lblCount;
@property (nonatomic,strong) IBOutlet UIButton *statusImg;
@property (nonatomic,strong) IBOutlet UIView *mainView;
@property (nonatomic,strong) IBOutlet UIView *hideView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray *letterArray;
@property (nonatomic,strong) NSString *postString;
@property (nonatomic,assign) int btnTag;
@property (nonatomic,strong) IBOutlet UIButton *addViewBtn;
@property (nonatomic,strong)AddViewController *addOrderView;

- (IBAction)clickSearchBtn:(id)sender;
- (IBAction)clickShowBtn:(id)sender;
- (IBAction)clickRefreshBtn:(id)sender;
- (IBAction)clickStatusImg:(UIButton *)sender;


@property (nonatomic, strong) OrderViewController *orderView2;
@end
