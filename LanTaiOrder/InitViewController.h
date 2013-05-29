//
//  InitViewController.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-3-29.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UITextField *txt;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* activityView;
@end
