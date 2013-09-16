//
//  RJLabel.m
//  
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RJLabel.h"

@implementation UILabel (RJCategory)
+ (CGSize)fitSize:(CGFloat)aWidth text:(NSString*)aText font:(UIFont*)aFont numberOfLines:(NSInteger)aNumberOfLines lineBreakMode:(UILineBreakMode)aLineBreakMode
{
    CGFloat maxHeight = (0 == aNumberOfLines) ? CGFLOAT_MAX : aFont.lineHeight * aNumberOfLines;
    CGSize size = [aText sizeWithFont:aFont constrainedToSize:CGSizeMake(aWidth, maxHeight) lineBreakMode:aLineBreakMode];
    return size;
}

- (CGSize)fitSize:(CGFloat)aWidth
{
    CGFloat maxHeight = (0 == self.numberOfLines) ? CGFLOAT_MAX : self.font.lineHeight * self.numberOfLines;
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(aWidth, maxHeight) lineBreakMode:self.lineBreakMode];
    return size;
}
@end
