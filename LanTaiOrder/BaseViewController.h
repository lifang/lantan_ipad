//
//  BaseViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-17.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)addLeftnaviItemWithImage:(NSString *)imageName;
- (void)addRightnaviItemsWithImage:(NSString *)imageName andImage:(NSString *)image2;
- (void)errorAlert:(NSString *)message;
- (void)errorAlertWithbtns:(NSString *)message;
@end
