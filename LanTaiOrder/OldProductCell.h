//
//  OldProductCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-4.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OldProductCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblCode,*lblDate,*lblTotal,*lblPay;
@property (nonatomic,strong) UIButton *btnComplaint;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier items:(NSMutableArray *)items;
@end
