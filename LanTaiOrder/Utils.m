//
//  Utils.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "Utils.h"

@implementation Utils{
    
}

//判断网络类型
+ (NSString *)isExistenceNetwork {
    NSString *str = [NSString string];
	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			str = @"NotReachable";
            break;
        case ReachableViaWWAN:
			str = @"ReachableViaWWAN";
            break;
        case ReachableViaWiFi:
			str = @"ReachableViaWiFi";
            break;
    }
    return str;
}

+ (NSMutableArray *)fetchWorkingList{
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kIndex]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *result = [r startSynchronousWithError:&error];
    NSDictionary *jsonData = [result objectFromJSONString];
    DLog(@"%@",jsonData);
    if ([[jsonData objectForKey:@"status"] intValue] == 1) {
        if ([jsonData objectForKey:@"reservations"]!=nil) {
            NSArray *arr = [NSArray arrayWithArray:[jsonData objectForKey:@"reservations"]];
            [DataService sharedService].reserve_count = [NSString stringWithFormat:@"%d",[arr count]];
        }
        if ([jsonData objectForKey:@"orders"]!=nil) {
            [DataService sharedService].workingOrders = [NSMutableArray arrayWithArray:[jsonData objectForKey:@"orders"]];
        }
    }
    return nil;
}

+ (NSString *)orderStatus:(int)status{
    if (status==0) {
        return @"未施工";
    }else if(status==1){
        return @"施工中";
    }else if(status==2){
        return @"等待付款";
    }else if(status==3){
        return @"已付款";
    }else if(status==4){
        return @"已结束";
    }
    return @"";
}

@end
