//
//  TabHeader.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-4.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "TabHeader.h"

@implementation TabHeader

@synthesize lbl_1,lbl_2,lbl_3,lbl_4,lbl_5,lbl_6,lbl_7;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(1, 1, 180, 42);
        lbl_1 = [[UILabel alloc] initWithFrame:frame];
        lbl_1.textAlignment = NSTextAlignmentCenter;
        lbl_1.text = @"订单号";
        lbl_1.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_1];
        frame.origin.x += 181;
        frame.size.width = 100;
        lbl_2 = [[UILabel alloc] initWithFrame:frame];
        lbl_2.textAlignment = NSTextAlignmentCenter;
        lbl_2.text = @"消费日期";
        lbl_2.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_2];
        frame.origin.x += 101;
        frame.size.width = 160;
        lbl_3 = [[UILabel alloc] initWithFrame:frame];
        lbl_3.textAlignment = NSTextAlignmentCenter;
        lbl_3.text = @"消费项目";
        lbl_3.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_3];
        frame.origin.x += 161;
        frame.size.width = 100;
        lbl_4 = [[UILabel alloc] initWithFrame:frame];
        lbl_4.textAlignment = NSTextAlignmentCenter;
        lbl_4.text = @"单价(元)";
        lbl_4.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_4];
        frame.origin.x += 101;
        lbl_5 = [[UILabel alloc] initWithFrame:frame];
        lbl_5.textAlignment = NSTextAlignmentCenter;
        lbl_5.text = @"总价(元)";
        lbl_5.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_5];
        frame.origin.x += 101;
        lbl_6 = [[UILabel alloc] initWithFrame:frame];
        lbl_6.textAlignment = NSTextAlignmentCenter;
        lbl_6.text = @"付款方式";
        lbl_6.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_6];
        frame.origin.x += 101;
        frame.size.width = 96;
        lbl_7 = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:lbl_7];
        self.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
