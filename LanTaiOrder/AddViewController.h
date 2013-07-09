//
//  AddViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureCell.h"
#import "GetPictureFromDevice.h"
#import "ConfirmViewController.h"

@interface AddViewController : BaseViewController<GetPictureFromDeviceDelegate,PictureCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    PictureCell *picView_0,*picView_1,*picView_2,*picView_3;
    GetPictureFromDevice *getPic;
}

@property (nonatomic,strong) IBOutlet UIView *stepView_0,*stepView_1,*stepView_2,*stepView_3,*stepView_4;
@property (nonatomic,strong) IBOutlet UIButton *btnNext,*btnDone,*btnPre;
@property (nonatomic,strong) PictureCell *picView_0,*picView_1,*picView_2,*picView_3;
@property (nonatomic,strong) IBOutlet UIPickerView *brandView;
@property (nonatomic,strong) IBOutlet UITextField *txtCarNum,*txtCarYear,*txtName,*txtPhone,*txtBirth,*txtEmail;
@property (nonatomic,strong) IBOutlet UIImageView *stepImg;
@property (nonatomic,strong) NSString *step;
@property (nonatomic,strong) GetPictureFromDevice *getPic;
@property (nonatomic,strong) NSMutableDictionary *customer;
@property (nonatomic,strong) NSMutableArray *brandList,*productList,*selectedIndexs;

@property (nonatomic,strong) NSMutableArray *firstArray,*secondArray,*thirdArray;

@property (nonatomic,strong) NSString *car_num;
@property (nonatomic,strong) IBOutlet UIButton *refreshBtn;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) IBOutlet UIView *pickView;
@property (nonatomic, strong) IBOutlet UIButton *pickerBtn;

@property (nonatomic, strong) NSMutableArray *product_ids;
//性别
@property (nonatomic,strong) IBOutlet UIButton *manBtn,*womanBtn;


@property (nonatomic,strong) NSMutableArray *dataArray ;
@property (nonatomic,assign) int button_tag;

@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *myPageControl;
@property (nonatomic, retain) UITableView *myTable;

- (IBAction)clickNext:(id)sender;
- (IBAction)clickFinished:(id)sender;

@end
