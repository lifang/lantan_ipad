//
//  BaseViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>

- (void)addLeftnaviItemWithImage:(NSString *)imageName;
- (void)addRightnaviItemWithImage:(NSString *)imageName;

@end
