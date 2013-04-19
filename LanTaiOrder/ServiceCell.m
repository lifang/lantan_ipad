//
//  ServiceCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-12.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell

@synthesize lblPrice,lblName,lblCount,stepBtn,product;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)prod indexPath:(NSIndexPath *)idx
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ServiceCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ServiceCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.product = [prod mutableCopy];
        self.index = idx;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//增减数量
- (IBAction)stepCount:(UIStepper *)sender{
    [DataService sharedService].first = NO;
    DLog(@"temp = %@",[DataService sharedService].temp_dictionary);
    BOOL exit = NO;
    NSString * product_id = [self.product objectForKey:@"id"];
    int product_count = [[[DataService sharedService].temp_dictionary objectForKey:product_id]intValue];//所选产品 “被” 服务剩余次数

    double val = [sender value];
    double old = [self.lblCount.text doubleValue];
    int old_count = [self.lblCount.text intValue];//用户选择的次数
    if (old_count != product_count) {
        exit = YES;
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"请先取消套餐卡对该产品的使用"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
        }];
        [alertt show];
    }else {
        exit = NO;
    }
    if (exit == NO) {
        self.lblCount.text = [NSString stringWithFormat:@"%d",(int)val];
        NSString *price = [NSString stringWithFormat:@"%.2f",(val - old) * [self.lblPrice.text floatValue]];
        [self.product setValue:[NSNumber numberWithDouble:val] forKey:@"count"];
        
        int num = (val - old);
        //重置temp—dic数据
        [[DataService sharedService].temp_dictionary removeObjectForKey:product_id];
        [[DataService sharedService].temp_dictionary setObject:[NSString stringWithFormat:@"%d",num+product_count ] forKey:product_id];
        DLog(@"dicccc = %@",[DataService sharedService].temp_dictionary);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.product,@"prod",self.index,@"idx",@"0",@"type", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic];
    }
}

@end
