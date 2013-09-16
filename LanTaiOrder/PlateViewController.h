//
//  PlateViewController.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-8-1.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TesseractWrapper.h"

@protocol PlateViewDelegate;

@interface PlateViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate> {
     TesseractWrapper *tesseract;
}
@property (nonatomic, assign) id<PlateViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) UIImage *imagee;
@property (nonatomic, strong) NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *plateArray;
@property (nonatomic, strong) NSMutableArray *plateNumberArray;
@property (nonatomic, strong) NSMutableString *plateString;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *strAlert;
@property (nonatomic, assign) BOOL save;
@end

@protocol PlateViewDelegate <NSObject>
@optional
- (void)closePlateView:(PlateViewController *)plateViewController;
@end
