//
//  ConfirmViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-7.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *lblCarNum,*lblBrand,*lblUsername,*lblPhone,*lblStart,*lblEnd,*lblTotal;
@property (nonatomic,strong) IBOutlet UITableView *productTable;
@property (nonatomic,strong) NSMutableArray *productList;
@property (nonatomic,strong) NSMutableDictionary *orderInfo;
@property (nonatomic,assign) CGFloat total_count;
@property (nonatomic,strong) IBOutlet UIView *confirmView,*confirmBgView;


- (IBAction)clickConfirm:(id)sender;
- (IBAction)clickCancel:(id)sender;

@end
