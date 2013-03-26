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
//    DLog(@"%@",jsonData);
    if ([[jsonData objectForKey:@"status"] intValue] == 1) {
        if ([jsonData objectForKey:@"reservations"]!=nil) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[jsonData objectForKey:@"reservations"]];
            [DataService sharedService].reserve_count = [NSString stringWithFormat:@"%d",[arr count]];
            [DataService sharedService].reserve_list = arr;
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

+ (NSString *)formateDate:(NSString *)date{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] init]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    NSDate* startDate = [inputFormatter dateFromString:date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *str = [outputFormatter stringFromDate:startDate];
    return str;
}

+ (NSString *)MD5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end
