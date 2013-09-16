//
//  PackageCell.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-7-9.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PackageCell.h"
#import "TabHeaderSpace.h"

#define OPEN 100
#define CLOSE 1000

@implementation PackageCell
@synthesize nameLab,dateLab,products,index,packageDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier item:(NSMutableDictionary *)item indexPath:(NSIndexPath *)idx{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 844, 20);
        TabHeaderSpace *tabHeader = [[TabHeaderSpace alloc] initWithFrame:frame];
        frame = tabHeader.lbl_1.frame;
        frame.size.width = 120;
        self.products = [NSMutableArray arrayWithArray:[item objectForKey:@"products"]];
        if (self.products.count == 0) {
            frame.size.height = 44;
        }else {
            frame.size.height = self.products.count * 44;
        }
        self.packageDic = [item mutableCopy];
        self.index = idx;
        //名称
        nameLab = [[UILabel alloc]initWithFrame:frame];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:nameLab];
        //已使用项目
        frame.origin.x += 121;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        frame.size.height = 43;
        frame.size.width = 300;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                if (self.products.count == 1) {
                    frame.size.height = 44;
                }else {
                    if(i>0 ){
                        frame.origin.y += 44;
                        if (i == self.products.count-1) {
                            frame.size.height = 44;
                        }else {
                            frame.size.height = 43;
                        }
                    }
                }
                
                UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                lblName.text = [NSString stringWithFormat:@"%@:%@次",[[self.products objectAtIndex:i] objectForKey:@"name"],[[self.products objectAtIndex:i]objectForKey:@"useNum"]];
                [self addSubview:lblName];
            }
        }
        //剩余项目
        frame.origin.x += 301;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        frame.size.height = 43;
        frame.size.width = 300;
        if (self.products.count == 0) {
            frame.size.height = 44;
            UILabel *lblName = [[UILabel alloc] initWithFrame:frame];
            lblName.font = [UIFont boldSystemFontOfSize:15];
            lblName.textAlignment = NSTextAlignmentCenter;
            lblName.text = @"";
            [self addSubview:lblName];
        }else {
            for (int i=0; i<self.products.count; i++) {
                int leftNum = [[[self.products objectAtIndex:i]objectForKey:@"leftNum"]intValue];
                if (self.products.count == 1) {
                    frame.size.height = 44;
                }else {
                    if(i>0 ){
                        frame.origin.y += 44;
                        if (i == self.products.count-1) {
                            frame.size.height = 44;
                        }else {
                            frame.size.height = 43;
                        }
                    }
                }
                UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width-40, frame.size.height)];
                lblName.textAlignment = NSTextAlignmentCenter;
                lblName.font = [UIFont boldSystemFontOfSize:15];
                lblName.text = [NSString stringWithFormat:@"%@:%@次",[[self.products objectAtIndex:i] objectForKey:@"name"],[[self.products objectAtIndex:i]objectForKey:@"leftNum"]];
                [self addSubview:lblName];
                
                int is_expired = [[self.packageDic objectForKey:@"is_expired"]intValue];
                if (is_expired == 1) {//套餐卡过期
                    UILabel *whiteLab =[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x+260, frame.origin.y, 40, frame.size.height)];
                    [self addSubview:whiteLab];
                }else {//套餐卡没有过期
                    if (leftNum == 0) {
                        UILabel *whiteLab =[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x+260, frame.origin.y, 40, frame.size.height)];
                        [self addSubview:whiteLab];
                    }else {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(frame.origin.x+260, frame.origin.y, 40, frame.size.height);
                        btn.backgroundColor = [UIColor whiteColor];
                        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = CLOSE +i;
                        [self addSubview:btn];
                    }
                }
            }
        }
        //使用期限
        frame.origin.x += 301;
        frame.size.width = 119;
        frame.origin.y = tabHeader.lbl_1.frame.origin.y;
        if (self.products.count == 0) {
            frame.size.height = 44;
        }else {
            frame.size.height = self.products.count * 44;
        }
        dateLab = [[UILabel alloc] initWithFrame:frame];
        dateLab.font = [UIFont boldSystemFontOfSize:15];
        dateLab.numberOfLines = 0;
        dateLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLab];
        
        //空白条
        frame = CGRectMake(0, frame.size.height+2, 844, 18);
        tabHeader.frame = frame;
        [self addSubview:tabHeader];
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//[DataService sharedService].package_product
- (NSString *)checkFormWithId:(int)package_id andId:(int)product_id {
    NSMutableString *prod_string = [NSMutableString string];
    [prod_string appendFormat:@"%d_%d,",package_id,product_id];
    return prod_string;
}

- (void)clickSwitch:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
    NSMutableDictionary *dic = nil;
    int package_id = [[self.packageDic objectForKey:@"cpard_relation_id"]intValue];
    
    if (tagStr.length == 3) {
        dic = [[self.products objectAtIndex:sender.tag-OPEN]mutableCopy];
        [dic setValue:@"1" forKey:@"selected"];
        [self.products replaceObjectAtIndex:sender.tag - OPEN withObject:dic];
        
        int product_id = [[dic objectForKey:@"id"]intValue];
        int i = 0;
        while (i<[DataService sharedService].package_product.count) {
            NSString *str = [[DataService sharedService].package_product objectAtIndex:i];
            NSArray *arr = [str componentsSeparatedByString:@"_"];
            
            int pack_id = [[arr objectAtIndex:0]intValue];
            if (pack_id == package_id) {//package_id相同
                int pro_id = [[arr objectAtIndex:1]intValue];
                if (pro_id == product_id) {//product_id相同
                    [[DataService sharedService].package_product removeObjectAtIndex:i];
                    break;
                }
            }
            i++;
        }
        
        int tag = btn.tag;
        btn.tag = tag - OPEN + CLOSE;
        [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
    }else {
        dic = [[self.products objectAtIndex:sender.tag-CLOSE]mutableCopy];
        int product_id = [[dic objectForKey:@"id"]intValue];
        
        if (![[dic objectForKey:@"mat_num"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"mat_num"]!= nil) {
            int kucun = [[dic objectForKey:@"mat_num"]intValue];
            BOOL warning = NO;
            if (kucun < 1) {//库存不足
                warning = YES;
                NSString * message = [NSString stringWithFormat:@"%@ 库存不足",[dic objectForKey:@"name"]];
                [AHAlertView applyCustomAlertAppearance];
                AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:message];
                __block AHAlertView *alert = alertt;
                [alertt setCancelButtonTitle:@"确定" block:^{
                    alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                    alert = nil;
                }];
                [alertt show];
                
            }else if ([DataService sharedService].package_product.count >0 ) {//判断库存
                int selecteedCount = 0;
                for (int i=0; i<[DataService sharedService].package_product.count; i++) {
                    NSString *str = [[DataService sharedService].package_product objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    int pro_id = [[arr objectAtIndex:1]intValue];//产品id
                    if (pro_id == product_id) {//id
                        selecteedCount = selecteedCount + 1;
                    }
                }
                selecteedCount = selecteedCount +1;
                if (kucun < selecteedCount) {
                    warning = YES;
                    NSString * message = [NSString stringWithFormat:@"%@ 库存不足",[dic objectForKey:@"name"]];
                    [AHAlertView applyCustomAlertAppearance];
                    AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:message];
                    __block AHAlertView *alert = alertt;
                    [alertt setCancelButtonTitle:@"确定" block:^{
                        alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                        alert = nil;
                    }];
                    [alertt show];
                }
            }
            
            if (warning == NO) {//没有库存警告
                [dic setValue:@"0" forKey:@"selected"];
                
                [self.products replaceObjectAtIndex:sender.tag - CLOSE withObject:dic];
                
                NSString *string = [self checkFormWithId:package_id andId:product_id];
                [[DataService sharedService].package_product addObject:string];
                
                int tag = btn.tag;
                btn.tag = tag - CLOSE + OPEN;
                [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
            }
        }else {
            [dic setValue:@"0" forKey:@"selected"];
            
            [self.products replaceObjectAtIndex:sender.tag - CLOSE withObject:dic];
            
            NSString *string = [self checkFormWithId:package_id andId:product_id];
            [[DataService sharedService].package_product addObject:string];
            
            int tag = btn.tag;
            btn.tag = tag - CLOSE + OPEN;
            [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
        }
    }
}
@end
