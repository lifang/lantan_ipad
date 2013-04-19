//
//  SVCardCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-12.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "SVCardCell.h"

#define OPEN 100
#define CLOSE 1000

@implementation SVCardCell

@synthesize lblCount,lblName,lblPrice,switchBtn,prod,index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)product indexPath:(NSIndexPath *)idx
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SVCardCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[SVCardCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.prod = [product mutableCopy];
        self.index = idx;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
//选择开关
- (IBAction)clickSwitch:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
    [DataService sharedService].first = NO;
    CGFloat x = 0;
    
    if (tagStr.length == 3) {
        self.lblPrice.text = [NSString stringWithFormat:@"%.2f",x];
        x = [[prod objectForKey:@"price"] floatValue];
        [self.prod setValue:@"1" forKey:@"selected"];
        
        int tag = btn.tag;
        btn.tag = tag - OPEN + CLOSE;
        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
    }else {
        x = 0 - [[prod objectForKey:@"price"] floatValue];
        self.lblPrice.text = [NSString stringWithFormat:@"%.2f",x];
        [self.prod setValue:@"0" forKey:@"selected"];
        
        int tag = btn.tag;
        btn.tag = tag - CLOSE + OPEN;
        [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
    }

    [self.prod setObject:self.lblPrice.text forKey:@"show_price"];
    NSString *price = [NSString stringWithFormat:@"%.2f",x];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.prod,@"prod",self.index,@"idx",@"1",@"type", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic];
}

@end
