//
//  DataService.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "DataService.h"

@implementation DataService

@synthesize user_id,reserve_count,car_num,reserve_list;
@synthesize number;


- (id)init{
    if (self == [super init]) {
        self.reserve_count = [NSString string];
        self.user_id = [NSString string];
        self.store_id = [NSString string];
        self.workingOrders = [NSMutableArray array];
        self.car_num = [NSString string];
        self.reserve_list = [NSMutableArray array];
    }
    return self;
}


+ (DataService *)sharedService {
    static dispatch_once_t once;
    static DataService *dataService = nil;
    
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}

@end
