//
//  TabHeaderSpace.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-3-26.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "TabHeaderSpace.h"

@implementation TabHeaderSpace

@synthesize lbl_1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(1, 1, 180, 43);
        lbl_1 = [[UILabel alloc] initWithFrame:frame];
        lbl_1.backgroundColor = [UIColor clearColor];
        [self addSubview:lbl_1];
        
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
