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

- (id)initWithFrame:(CGRect)frame title:(NSString *)title delegate:(id)deleg img:(NSString *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = deleg;
        CGRect f = CGRectMake(10, 5, 150, 150);
        self.carImageView = [[UIImageView alloc] initWithFrame:f];
        carImageView.image = [UIImage imageNamed:image];
        carImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:carImageView];
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        f.origin.y += 152;
        f.size.height = 25;
        self.addBtn.frame = f;
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [self.addBtn setTitle:title forState:UIControlStateNormal];
        [self.addBtn setTitle:title forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"piccell_bg"]];
    }
    return self;
}

- (void)clickPhoto:(id)sender{
    if ([self.delegate respondsToSelector:@selector(getCarPicture:)]) {
        [self.delegate getCarPicture:self];
    }
}


@end
