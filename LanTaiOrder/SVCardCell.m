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

@synthesize lblCount,lblName,lblPrice,switchBtn,prod,index,selectedArr;

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
        self.selectedArr = [NSMutableArray arrayWithArray:[prod objectForKey:@"sale_products"]];
        self.index = idx;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
- (NSString *)checkFormWithIndexRow:(int)row andId:(int)product_id andNumber:(int)num {
    NSMutableString *prod_count = [NSMutableString string];
    [prod_count appendFormat:@"%d_%d_%d,",row,product_id,num];
    return prod_count;
}
//选择开关
- (IBAction)clickSwitch:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
    [DataService sharedService].first = NO;
    CGFloat x = 0;
    DLog(@"%@",self.prod);
    NSArray *array = [[DataService sharedService].price_id allKeys];

    int disc_types = [[self.prod objectForKey:@"disc_types"]intValue];
    if (disc_types == 0){
        CGFloat discount_x = 0;
        CGFloat discount_y = 0;
        //折扣
        CGFloat sale_discount = 1 -[[self.prod objectForKey:@"discount"]floatValue]/10;
        if (tagStr.length == 3) {
            //活动对应的产品
            for (int j=0; j<self.selectedArr.count; j++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.selectedArr objectAtIndex:j]];
                NSString * product_id = [dic objectForKey:@"product_id"];
                //判断这个id在不在number_id里面
                if ([array containsObject:product_id]) {//活动包含此产品
                    //从row_id_numArray数组中找到此产品被消费次数
                    int row = self.index.row;
                    int num = [[dic objectForKey:@"prod_num"]intValue];//活动里面的数目
                    discount_x = [[[DataService sharedService].price_id objectForKey:product_id] floatValue];//产品价格
                    int num_count = 0;
                    if ([DataService sharedService].row_id_numArray.count >0) {
                        int i = 0;
                        while (i<[DataService sharedService].row_id_numArray.count) {
                            NSString *str = [[DataService sharedService].row_id_numArray objectAtIndex:i];
                            NSArray *arr = [str componentsSeparatedByString:@"_"];
                            int index_row = [[arr objectAtIndex:0]intValue];
                            if (row == index_row) {//index.row相同
                                int p_id = [[arr objectAtIndex:1]intValue];
                                if (p_id == [product_id intValue]){
                                    //id相同
                                    num_count = [[arr objectAtIndex:2]intValue];
                                    discount_y = discount_y +discount_x *num_count *sale_discount;
                                    //重置number_id数据
                                    int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                                    [[DataService sharedService].number_id removeObjectForKey:product_id];
                                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                                    
                                    //删除消费次数
                                    [[DataService sharedService].row_id_numArray removeObjectAtIndex:i];
                                    
                                    [dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                                    //修改活动
                                    [self.selectedArr replaceObjectAtIndex:j withObject:dic];
                                }
                                break;
                            }
                            i++;
                        }
                    }
                }
            }
            CGFloat lbl_price = [self.lblPrice.text floatValue];
            if ((lbl_price+discount_y) <0.0001f ) {
                self.lblPrice.text = @"0";
            }else {
                self.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
            }
            //////////////////////////////////////////////////
            x = discount_y;
            [self.prod setValue:@"0" forKey:@"selected"];
            [self.prod setObject:self.selectedArr forKey:@"sale_products"];
            
            int tag = btn.tag;
            btn.tag = tag - OPEN + CLOSE;
            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        }else {
            //活动对应的产品
            if (self.selectedArr.count>0) {
                
            }
            for (int i=0; i<self.selectedArr.count; i++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.selectedArr objectAtIndex:i]];
                NSString * product_id = [dic objectForKey:@"product_id"];
                //判断这个id在不在price_id里面
                if ([array containsObject:product_id]) {//活动包含此产品
                    int num = [[dic objectForKey:@"prod_num"]intValue];//活动里面的数目
                    int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//用户选择的数目
                    discount_x = 0-[[[DataService sharedService].price_id objectForKey:product_id]floatValue];//此产品的价格
                    if (count_num == 0) {
                        
                    }else {
                        if (num <= count_num) {//用户次数大于活动提供次数
                            //初始count  --num
                            NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:num];
                            if ([DataService sharedService].row_id_numArray.count == 0) {
                                [DataService sharedService].row_id_numArray = [NSMutableArray array];
                            }
                            
                            [[DataService sharedService].row_id_numArray addObject:str];
                            
                            discount_y = discount_y +discount_x * num*sale_discount;
                            //重置number_id数据
                            [[DataService sharedService].number_id removeObjectForKey:product_id];
                            [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d",count_num - num] forKey:product_id];
                            
                            [dic setObject:[NSString stringWithFormat:@"%d",num - num] forKey:@"prod_num"];
                            //修改活动
                            [self.selectedArr replaceObjectAtIndex:i withObject:dic];
                        }else {//用户次数小于活动提供次数
                            //初始count  --count_num
                            NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:count_num];
                            if ([DataService sharedService].row_id_numArray.count == 0) {
                                [DataService sharedService].row_id_numArray = [NSMutableArray array];
                            }
                            [[DataService sharedService].row_id_numArray addObject:str];
                            
                            discount_y = discount_y+ discount_x * count_num  *sale_discount;
                            //重置number_id数据
                            [[DataService sharedService].number_id removeObjectForKey:product_id];
                            [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", count_num- count_num] forKey:product_id];
                            
                            [dic setObject:[NSString stringWithFormat:@"%d",num - count_num] forKey:@"prod_num"];
                            //修改活动
                            [self.selectedArr replaceObjectAtIndex:i withObject:dic];
                        }
                    }
                    
                }
            }
            //////////////////////////////////////////////////
            x = discount_y;
            CGFloat lbl_price = [self.lblPrice.text floatValue];
            self.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
            [self.prod setValue:@"0" forKey:@"selected"];
            [self.prod setObject:self.selectedArr forKey:@"sale_products"];
            
            int tag = btn.tag;
            btn.tag = tag - CLOSE + OPEN;
            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
        }
        
        [self.prod setObject:self.lblPrice.text forKey:@"show_price"];
        //////////////////////////////////////////////////
        NSString *price = [NSString stringWithFormat:@"%.2f",x];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.prod,@"prod",self.index,@"idx",@"1",@"type", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic];
    } else {
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
}

@end
