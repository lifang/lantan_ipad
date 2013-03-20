//
//  OldProductCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-4.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "OldProductCell.h"
#import "TabHeader.h"

@implementation OldProductCell

@synthesize lblCode,lblDate,lblPay,lblTotal,btnComplaint;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  items:(NSMutableArray *)items
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 844, 44);
        TabHeader *tabHeader = [[TabHeader alloc] initWithFrame:frame];
        [self addSubview:tabHeader];
        frame = tabHeader.lbl_1.frame;
        frame.size.height = 43;
//        int frame_y = (items.count - 1) * 22;
        frame.origin.y += 44;
//        frame.origin.x += 10;
        frame.size.height = items.count * 44;
        lblCode = [[UILabel alloc] initWithFrame:frame];
        lblCode.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblCode];
        frame.origin.x += 181;
        frame.size.width = 100;
        lblDate = [[UILabel alloc] initWithFrame:frame];
        lblDate.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblDate];
        frame.origin.x += 101;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y + 44;
        frame.size.height = 43;
        frame.size.width = 160;
        for (int i=0; i<items.count; i++) {
            if(i>0){
                frame.origin.y += 44;
            }
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = [[items objectAtIndex:i] objectForKey:@"name"];
            [self addSubview:lblName];
        }
        frame.origin.x += 161;
        frame.size.width = 100;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y + 44;
        for (int i=0; i<items.count; i++) {
            if (i>0) {
                frame.origin.y += 44;
            }
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = [NSString stringWithFormat:@"%.2f",[[[items objectAtIndex:i] objectForKey:@"price"] floatValue]];
            [self addSubview:lblName];
        }
        frame.origin.x += 101;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y + 44;
        frame.size.height = items.count * 44;
        lblTotal = [[UILabel alloc] initWithFrame:frame];
        lblTotal.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblTotal];
        frame.origin.x += 101;
        lblPay = [[UILabel alloc] initWithFrame:frame];
        lblPay.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblPay];
        frame.origin.x += 120;
        frame.size.width = 60;
        btnComplaint = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComplaint.frame = frame;
        [btnComplaint setTitle:@"投诉" forState:UIControlStateNormal];
        [btnComplaint setTitle:@"投诉" forState:UIControlStateHighlighted];
        [self addSubview:btnComplaint];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
