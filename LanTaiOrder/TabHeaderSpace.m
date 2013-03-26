//
//  TabHeaderSpace.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-3-26.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "TabHeaderSpace.h"

@implementation TabHeaderSpace

@synthesize lbl_1,lbl_2,lbl_3,lbl_4,lbl_5,lbl_6,lbl_7;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(0, 1, 180, 43);
        lbl_1 = [[UILabel alloc] initWithFrame:frame];
        lbl_1.backgroundColor = [UIColor clearColor];
        [self addSubview:lbl_1];
//
//        frame.origin.x += 181;
//        frame.size.width = 100;
//        lbl_2 = [[UILabel alloc] initWithFrame:frame];
//        [self addSubview:lbl_2];
//        
//        frame.origin.x += 101;
//        frame.size.width = 160;
//        lbl_3 = [[UILabel alloc] initWithFrame:frame];
//        [self addSubview:lbl_3];
//        
//        frame.origin.x += 161;
//        frame.size.width = 100;
//        lbl_4 = [[UILabel alloc] initWithFrame:frame];
//        [self addSubview:lbl_4];
//        
//        frame.origin.x += 101;
//        lbl_5 = [[UILabel alloc] initWithFrame:frame];
//        [self addSubview:lbl_5];
//        
//        frame.origin.x += 101;
//        lbl_6 = [[UILabel alloc] initWithFrame:frame];
//        [self addSubview:lbl_6];
//        
//        frame.origin.x += 101;
//        lbl_7 = [[UILabel alloc] initWithFrame:frame];
//        [self addSubview:lbl_7];
        self.backgroundColor = [UIColor whiteColor];
        
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
