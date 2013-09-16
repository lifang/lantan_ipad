//
//  OrderViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-1.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductHeader.h"

@class AddViewController;
@interface OrderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *car_num;
}

@property (nonatomic,strong) IBOutlet UIView *carInfoView,*orderView,*carInfoBgView,*noInfoView,*workingView,*noWorkingView;
@property (nonatomic,strong) IBOutlet UIButton *btnDone,*btnCheckIn,*btnOrderRecord,*btnOldRecord,*btnPay,*btnCancel,*btnPackageRecord;
@property (nonatomic,strong) IBOutlet UITableView *orderTable,*workingTable,*packageTable;
@property (nonatomic,strong) IBOutlet UILabel *lblCarNum,*lblBrand,*lblUserName,*lblPhone,*lblProduct,*lblTime;
@property (nonatomic,strong) IBOutlet UILabel *lblReceiver,*lblOrderNum,*lblWorkingCar,*lblStatus,*lblWorkingName,*lblTotal;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *productLabel;

@property (nonatomic,strong) NSMutableArray *orderList,*orderItems,*packageList;
@property (nonatomic,strong) NSString *car_num;//车牌号
@property (nonatomic,strong) NSString *car_id;//车辆id
@property (nonatomic,strong) NSMutableDictionary *customer,*workingOrder;

@property (nonatomic,strong)AddViewController *addOrderView;


- (IBAction)clickDone:(id)sender;
- (IBAction)clickReg:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickPic:(id)sender;
- (IBAction)clickPay:(id)sender;
- (IBAction)clickWorking:(id)sender;
- (IBAction)clickOld:(id)sender;
@end
