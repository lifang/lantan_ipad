//
//  PayStyleViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-13.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayStyleViewDelegate;

@interface PayStyleViewController : UIViewController

@property (nonatomic,assign) id<PayStyleViewDelegate> delegate;

@end

@protocol PayStyleViewDelegate <NSObject>

@optional
- (void)closePopView:(PayStyleViewController *)payStyleViewController;

@end
