//
//  OldProductCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-4.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "OldProductCell.h"
#import "TabHeaderSpace.h"

@implementation OldProductCell

@synthesize lblCode,lblDate,lblPay,lblTotal,btnComplaint;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  items:(NSMutableArray *)items
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 844, 20);
        TabHeaderSpace *tabHeader = [[TabHeaderSpace alloc] initWithFrame:frame];
        
        frame = tabHeader.lbl_1.frame;
        if (items.count == 0) {
            frame.size.height = 44;
        }else {
            frame.size.height = items.count * 44;
        }
        //订单号
        lblCode = [[UILabel alloc] initWithFrame:frame];
        lblCode.textAlignment = NSTextAlignmentCenter;
        lblCode.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:lblCode];
        
        //日期
        frame.origin.x += 181;
        frame.size.width = 100;
        lblDate = [[UILabel alloc] initWithFrame:frame];
        lblDate.textAlignment = NSTextAlignmentCenter;
        lblDate.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:lblDate];
        
        //消费项目
        frame.origin.x += 101;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        frame.size.height = 43;
        frame.size.width = 160;
        if (items.count == 0) {
            frame.size.height = 44;
            
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<items.count; i++) {
                if (items.count == 1) {
                    frame.size.height = 44;
                }else {
                    if(i>0 ){
                        frame.origin.y += 44;
                        if (i == items.count-1) {
                            frame.size.height = 44;
                        }else {
                            frame.size.height = 43;
                        }
                    }
                }
                
                UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                lblName.text = [[items objectAtIndex:i] objectForKey:@"name"];
                [self addSubview:lblName];
            }
        }
        
        //单价
        frame.origin.x += 161;
        frame.size.width = 100;
        frame.size.height = 43;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        
        if (items.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<items.count; i++) {
                if (items.count == 1) {
                    frame.size.height = 44;
                }else {
                    if(i>0 ){
                        frame.origin.y += 44;
                        if (i == items.count-1) {
                            frame.size.height = 44;
                        }else {
                            frame.size.height = 43;
                        }
                    }
                }
                UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                lblName.text = [NSString stringWithFormat:@"%.2f",[[[items objectAtIndex:i] objectForKey:@"price"] floatValue]];
                [self addSubview:lblName];
            }
        }
       
        //总价
        frame.origin.x += 101;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y ;
        if (items.count == 0) {
            frame.size.height = 44;
        }else {
            frame.size.height = items.count * 44;
        }
        lblTotal = [[UILabel alloc] initWithFrame:frame];
        lblTotal.font = [UIFont boldSystemFontOfSize:15];
        lblTotal.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblTotal];
        
        //付款方式
        frame.origin.x += 101;
        
        lblPay = [[UILabel alloc] initWithFrame:frame];
        lblPay.font = [UIFont boldSystemFontOfSize:15];
        lblPay.textAlignment = NSTextAlignmentCenter;
        [lblPay setNumberOfLines:0];
        [self addSubview:lblPay];
        
        //投诉下面得白色
        frame.origin.x += 101;
        frame.size.width = 96;
        UILabel *lab = [[UILabel alloc]initWithFrame:frame];
        [self addSubview:lab];
        
        //投诉
        frame.origin.x += 19;
        frame.size.width = 60;
        CGRect ff = CGRectMake(766, (frame.size.height-30)/2, 60, 30);
        btnComplaint = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComplaint.frame = ff;
        [btnComplaint setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        [btnComplaint setBackgroundImage:[UIImage imageNamed:@"btn_bg_active"] forState:UIControlStateHighlighted];
        [btnComplaint setTitle:@"投诉" forState:UIControlStateNormal];
        [btnComplaint setTitle:@"投诉" forState:UIControlStateHighlighted];
        [self addSubview:btnComplaint];
        
        //空白条
    
        frame = CGRectMake(0, frame.size.height+2, 844, 18);
        tabHeader.frame = frame;
        [self addSubview:tabHeader];
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
