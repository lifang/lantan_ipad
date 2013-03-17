//
//  PackageCardCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-12.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PackageCardCell.h"

@implementation PackageCardCell

@synthesize lblName,lblPrice,selectedArr,product,index,cellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  with:(NSMutableDictionary *)prod indexPath:(NSIndexPath *)idx type:(NSInteger)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.product = [prod mutableCopy];
        self.index = idx;
        self.cellType = type;
        self.selectedArr = [NSMutableArray arrayWithArray:[prod objectForKey:@"products"]];
        int len = selectedArr.count;
        CGRect frame = CGRectMake(350, 0, 100, 44);
        for (int i=0; i<len; i++) {
            frame.origin.y += 44 * i;
            UILabel *lblProd = [[UILabel alloc] initWithFrame:frame];
            lblProd.text = [NSString stringWithFormat:@"%@(%@)次",[[selectedArr objectAtIndex:i] objectForKey:@"name"],[[selectedArr objectAtIndex:i] objectForKey:@"num"]];
            lblProd.textAlignment = NSTextAlignmentRight;
            [self addSubview:lblProd];
            if(cellType == 0){
            frame.origin.x += 125;
            frame.size.width = 80;
            frame.origin.y += 10;
            UISwitch *btnSwitch = [[UISwitch alloc] initWithFrame:frame];
            btnSwitch.tag = 100 + i;
            [btnSwitch addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:btnSwitch];
            NSDictionary *dic = [selectedArr objectAtIndex:i];
            if ([[dic objectForKey:@"selected"] intValue] == 0) {
                [btnSwitch setOn:YES animated:NO];
            }else{
                [btnSwitch setOn:NO animated:NO];
            }
            }
            frame.origin.x = 350;
            frame.size.width = 100;
            frame.origin.y -= 10;
        }
        frame = CGRectMake(10, 10, 200, self.frame.size.height);
        lblName = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:lblName];
        frame.origin.x += 250;
        frame.size.width = 80;
        lblPrice = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:lblPrice];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickSwitch:(UISwitch *)sender{
    NSMutableDictionary *dic = [[selectedArr objectAtIndex:sender.tag - 100] mutableCopy];
    CGFloat x = [self.lblPrice.text floatValue];
    int num = [dic objectForKey:@"num"];
    if ([sender isOn]) {
        x -= [[dic objectForKey:@"product_price"] floatValue];
        [dic setValue:@"1" forKey:@"selected"];
        [dic setObject:[NSString stringWithFormat:@"%d",num - 1] forKey:@"num"];
    }else{
        x += [[dic objectForKey:@"product_price"] floatValue];
        [dic setValue:@"0" forKey:@"selected"];
        [dic setObject:[NSString stringWithFormat:@"%d",num + 1] forKey:@"num"];
    }
    NSString *price = [NSString stringWithFormat:@"%.2f",x];
    self.lblPrice.text = price;
    [selectedArr replaceObjectAtIndex:sender.tag - 100 withObject:dic];
    [self.product setObject:selectedArr forKey:@"products"];
    
    [self.product setObject:price forKey:@"show_price"];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.product,@"prod",self.index,@"idx",@"2",@"type", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic1];
}

@end
