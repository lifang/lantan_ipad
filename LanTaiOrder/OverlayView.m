//
//  OverlayView.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-8-2.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "OverlayView.h"
#define kSPUserResizableViewInteractiveBorderSize 0.0

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, CGRectInset(self.bounds, kSPUserResizableViewInteractiveBorderSize/2, kSPUserResizableViewInteractiveBorderSize/2));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}


@end
