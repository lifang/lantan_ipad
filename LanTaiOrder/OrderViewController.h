//
//  OrderViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-1.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductHeader.h"

@interface OrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString *car_num;
}

@property (nonatomic,strong) IBOutlet UIView *carInfoView,*orderView,*carInfoBgView,*noInfoView,*workingView,*noWorkingView;
@property (nonatomic,strong) IBOutlet UIButton *btnDone,*btnCheckIn,*btnOrderRecord,*btnOldRecord;
@property (nonatomic,strong) IBOutlet UITableView *orderTable,*workingTable;
@property (nonatomic,strong) IBOutlet UILabel *lblCarNum,*lblBrand,*lblUserName,*lblPhone,*lblProduct,*lblTime;
@property (nonatomic,strong) IBOutlet UILabel *lblReceiver,*lblOrderNum,*lblWorkingCar,*lblStatus,*lblWorkingName,*lblTotal;

@property (nonatomic,strong) NSMutableArray *orderList,*orderItems;
@property (nonatomic,strong) NSString *car_num;

- (IBAction)clickDone:(id)sender;
- (IBAction)clickReg:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickPic:(id)sender;
- (IBAction)clickPay:(id)sender;
- (IBAction)clickWorking:(id)sender;
- (IBAction)clickOld:(id)sender;
@end