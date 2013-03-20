//
//  ComplaintViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplaintViewController : BaseViewController

@property (nonatomic,strong) IBOutlet UILabel *lblName,*lblCarNum,*lblCode,*lblProduct;
@property (nonatomic,strong) IBOutlet UITextView *reasonView,*requestView;
@property (nonatomic,strong) IBOutlet UIView *infoBgView;

@property (nonatomic,strong) NSMutableDictionary *info;

- (IBAction)clickSubmit:(id)sender;

@end
