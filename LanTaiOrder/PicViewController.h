//
//  PicViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-20.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "BaseViewController.h"
#import "PictureCell.h"
#import "GetPictureFromDevice.h"

@protocol PicViewDelegate;

@interface PicViewController : UIViewController<PictureCellDelegate,GetPictureFromDeviceDelegate>

@property (nonatomic,strong) PictureCell *picView_0,*picView_1,*picView_2,*picView_3;
@property (nonatomic,strong) GetPictureFromDevice *getPic;
@property (nonatomic, strong) id parentController;
@property (nonatomic,assign) id<PicViewDelegate> delegate;

- (IBAction)closePopup:(UIButton *)sender;

@end

@protocol PicViewDelegate <NSObject>

@optional
- (void)closePopView:(PicViewController *)picViewController;

@end
