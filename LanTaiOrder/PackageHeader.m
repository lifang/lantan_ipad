//
//  PackageHeader.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-7-9.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PackageHeader.h"

@implementation PackageHeader
@synthesize lbl_1,lbl_2,lbl_3,lbl_4;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(1, 1, 120, 42);
        lbl_1 = [[UILabel alloc] initWithFrame:frame];
        lbl_1.textAlignment = NSTextAlignmentCenter;
        lbl_1.text = @"名称";
        lbl_1.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_1];
        frame.origin.x += 121;
        frame.size.width = 300;
        lbl_2 = [[UILabel alloc] initWithFrame:frame];
        lbl_2.textAlignment = NSTextAlignmentCenter;
        lbl_2.text = @"已使用项目";
        lbl_2.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_2];
        frame.origin.x += 301;
        frame.size.width = 300;
        lbl_3 = [[UILabel alloc] initWithFrame:frame];
        lbl_3.textAlignment = NSTextAlignmentCenter;
        lbl_3.text = @"剩余项目";
        lbl_3.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_3];
        frame.origin.x += 301;
        frame.size.width = 119;
        lbl_4 = [[UILabel alloc] initWithFrame:frame];
        lbl_4.textAlignment = NSTextAlignmentCenter;
        lbl_4.text = @"使用期限";
        lbl_4.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];//颜色
        [self addSubview:lbl_4];
        
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
