//
//  PictureCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-5.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell

@synthesize addBtn,carImageView,delegate,titleLab;

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
        
        f.origin.y += 152;
        f.size.height = 25;
        self.titleLab = [[UILabel alloc]initWithFrame:f];
        self.titleLab.text = title;
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        
        f.origin.y -= 152;
        f.size.height = 172;
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = f;
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
