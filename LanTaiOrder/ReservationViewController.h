//
//  ReservationViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *reservTable;
@property (nonatomic,strong) NSMutableArray *reservList;

@end
