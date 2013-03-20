//
//  ReservationCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *lblCreatedAt,*lblCarNum,*lblUsername,*lblPhone,*lblEmail,*lblReservAt,*lblStatus;

@property (nonatomic,strong) NSString *reserv_id;

- (IBAction)clickConfirm:(id)sender;
- (IBAction)clickCancel:(id)sender;

@end
