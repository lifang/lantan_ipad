//
//  ProductCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-4.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

@synthesize lblPrice,lblName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(10, 2, 300, 44);
        lblName = [[UILabel alloc] initWithFrame:frame];
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblName];
        frame.origin.x += 400;
        frame.size.width = 100;
        lblPrice = [[UILabel alloc] initWithFrame:frame];
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblPrice];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
