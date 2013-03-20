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
#import "CollectionCell.h"
#import "CollectionHeader.h"
#import "CollectionViewLayout.h"
#import "ConfirmViewController.h"

@interface AddViewController : BaseViewController<GetPictureFromDeviceDelegate,PictureCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    PictureCell *picView_0,*picView_1,*picView_2,*picView_3;
    GetPictureFromDevice *getPic;
}

@property (nonatomic,strong) IBOutlet UIView *stepView_0,*stepView_1,*stepView_2,*stepView_3,*stepView_4;
@property (nonatomic,strong) IBOutlet UIButton *btnNext,*btnDone,*btnPre;
@property (nonatomic,strong) PictureCell *picView_0,*picView_1,*picView_2,*picView_3;
@property (nonatomic,strong) IBOutlet UIPickerView *brandView,*modelView;
@property (nonatomic,strong) IBOutlet UICollectionView *productsView;
@property (nonatomic,strong) IBOutlet UITextField *txtCarNum,*txtCarYear,*txtName,*txtPhone,*txtBirth,*txtEmail;
@property (nonatomic,strong) IBOutlet UIImageView *stepImg;
@property (nonatomic,strong) NSString *step;
@property (nonatomic,strong) GetPictureFromDevice *getPic;
@property (nonatomic,strong) NSMutableDictionary *brandResult,*customer;
@property (nonatomic,strong) NSMutableArray *brandList,*productList,*selectedIndexs;

- (IBAction)clickNext:(id)sender;
- (IBAction)clickFinished:(id)sender;

@end
