//
//  ReservationCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ReservationCell.h"

@implementation ReservationCell

@synthesize lblCarNum,lblCreatedAt,lblEmail,lblPhone,lblReservAt,lblStatus,lblUsername;
@synthesize reserv_id;

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

- (IBAction)clickCancel:(id)sender{
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kConfirmReserv]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id",self.reserv_id,@"r_id",@"1",@"status", nil];
    [r setPOSTDictionary:dic];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    //    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] intValue]==1) {
        [DataService sharedService].reserve_list = [result objectForKey:@"reservation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReservation" object:nil];
    }
}

- (IBAction)clickConfirm:(id)sender{
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kConfirmReserv]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id",self.reserv_id,@"r_id",@"0",@"status", nil];
    [r setPOSTDictionary:dic];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
//    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] intValue]==1) {
        [DataService sharedService].reserve_list = [result objectForKey:@"reservation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateReservation" object:nil];
    }
}

@end
