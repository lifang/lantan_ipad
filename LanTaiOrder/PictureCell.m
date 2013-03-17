//
//  PictureCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-5.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell

@synthesize addBtn,carImageView,delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title delegate:(id)deleg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = deleg;
        CGRect f = CGRectMake(2, 2, 150, 150);
        self.carImageView = [[UIImageView alloc] initWithFrame:f];
        carImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:carImageView];
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        f.origin.y += 150;
        f.size.height = 30;
        self.addBtn.frame = f;
        [self.addBtn setTitle:title forState:UIControlStateNormal];
        [self.addBtn setTitle:title forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)clickPhoto:(id)sender{
    if ([self.delegate respondsToSelector:@selector(getCarPicture:)]) {
        [self.delegate getCarPicture:self];
    }
}


@end
