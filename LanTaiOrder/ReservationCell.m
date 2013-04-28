//
//  ReservationCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ReservationCell.h"
#import "AddViewController.h"
#import "AppDelegate.h"

@implementation ReservationCell

@synthesize lblCarNum,lblCreatedAt,lblEmail,lblPhone,lblStatus,lblUsername;
@synthesize reserv_id;
@synthesize txtReservAt,btnCancel,btnConfirm;
@synthesize viewController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ReservationCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ReservationCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cancle {
    AppDelegate *delegate = [AppDelegate shareInstance];
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kConfirmReserv]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id",self.reserv_id,@"r_id",@"1",@"status", nil];
    [r setPOSTDictionary:dic];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *str = [r startSynchronousWithError:&error];
    NSDictionary *result = [str objectFromJSONString];
    DLog(@"%@",result);
    
    if ([[result objectForKey:@"status"] intValue]==1) {
        [DataService sharedService].reserve_list = [result objectForKey:@"reservation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReservation" object:nil];
    }
    [MBProgressHUD hideAllHUDsForView:delegate.window animated:YES];
}
//作废预约
- (IBAction)clickCancel:(id)sender{
    AppDelegate *delegate = [AppDelegate shareInstance];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:delegate.window];
    [hud showWhileExecuting:@selector(cancle) onTarget:self withObject:nil animated:YES];
    hud.labelText = @"正在努力加载...";
    [delegate.window addSubview:hud];
}

-(void)confirm {
    AppDelegate *delegate = [AppDelegate shareInstance];
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kConfirmReserv]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id",self.reserv_id,@"r_id",@"0",@"status",self.txtReservAt.text,@"reserv_at", nil];
    [r setPOSTDictionary:dic];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *str = [r startSynchronousWithError:&error];
    NSDictionary *result = [str objectFromJSONString];
    DLog(@"%@",result);
    
    if ([[result objectForKey:@"status"] intValue]==1) {
        [DataService sharedService].reserve_list = [result objectForKey:@"reservation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReservation" object:nil];
        AddViewController *addOrder = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
        addOrder.brandResult = [NSMutableDictionary dictionaryWithDictionary:result];
        addOrder.customer = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"customer"]];
        addOrder.brandList = [NSMutableArray arrayWithArray:[result objectForKey:@"brands"]];
        addOrder.productList = [NSMutableArray arrayWithArray:[result objectForKey:@"products"]];
        addOrder.product_ids = [NSMutableArray arrayWithArray:[result objectForKey:@"product_ids"]];
        [DataService sharedService].number = 0;
        addOrder.step = @"1";
        [viewController pushViewController:addOrder animated:YES];
    }

    [MBProgressHUD hideAllHUDsForView:delegate.window animated:YES];
}
//确认预约
- (IBAction)clickConfirm:(id)sender{
    AppDelegate *delegate = [AppDelegate shareInstance];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:delegate.window];
    [hud showWhileExecuting:@selector(confirm) onTarget:self withObject:nil animated:YES];
    hud.labelText = @"正在努力加载...";
    [delegate.window addSubview:hud];
}

@end
