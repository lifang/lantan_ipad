//
//  ReservationCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UILabel *lblCreatedAt,*lblCarNum,*lblUsername,*lblPhone,*lblEmail,*lblStatus;
@property (nonatomic,strong) IBOutlet UITextField *txtReservAt;
@property (nonatomic,strong) IBOutlet UIButton *btnConfirm,*btnCancel;

@property (nonatomic,strong) NSString *reserv_id;
@property (nonatomic,assign) id viewController;

- (IBAction)clickConfirm:(id)sender;
- (IBAction)clickCancel:(id)sender;

@end
