//
//  loadingView.m
//  PDTaobao1
//
//  Created by  on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "loadingView.h"
#import <QuartzCore/QuartzCore.h>
@implementation loadingView
@synthesize activityView;
@synthesize sv;
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.sv.layer.masksToBounds = YES;
        self.sv.layer.cornerRadius = 10;
    }
    return self;
}

- (void)dealloc {
    [activityView release];
    [super dealloc];
}
@end
