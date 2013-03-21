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
    double val = [sender value];
    double old = [self.lblCount.text doubleValue];
    
    self.lblCount.text = [NSString stringWithFormat:@"%d",(int)val];
    NSString *price = [NSString stringWithFormat:@"%.2f",(val - old) * [self.lblPrice.text floatValue]];
    [self.product setValue:[NSNumber numberWithDouble:val] forKey:@"count"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.product,@"prod",self.index,@"idx",@"0",@"type", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic];
}

@end
