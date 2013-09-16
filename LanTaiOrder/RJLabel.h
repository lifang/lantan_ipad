//
//  RJLabel.h
//  
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RJCategory)
+ (CGSize)fitSize:(CGFloat)aWidth text:(NSString*)aText font:(UIFont*)aFont numberOfLines:(NSInteger)aNumberOfLines lineBreakMode:(UILineBreakMode)aLineBreakMode;
- (CGSize)fitSize:(CGFloat)aWidth;
@end
