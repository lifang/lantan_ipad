//
//  PicViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-20.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PicViewController.h"

@interface PicViewController ()

@end

@implementation PicViewController

@synthesize parentController;

@synthesize picView_0,picView_1,picView_2,picView_3;
@synthesize getPic,delegate;

- (void)initPicView{
    picView_0 = [[PictureCell alloc] initWithFrame:CGRectMake(50, 70, 172, 192) title:@"车前" delegate:self img:@"front"];
    picView_1 = [[PictureCell alloc] initWithFrame:CGRectMake(320, 70, 172, 192) title:@"车后" delegate:self img:@"behind"];
    picView_2 = [[PictureCell alloc] initWithFrame:CGRectMake(50, 280, 172, 192) title:@"车左" delegate:self img:@"left"];
    picView_3 = [[PictureCell alloc] initWithFrame:CGRectMake(320, 280, 172, 192) title:@"车右" delegate:self img:@"right"];
    [self.view addSubview:picView_0];
    [self.view addSubview:picView_1];
    [self.view addSubview:picView_2];
    [self.view addSubview:picView_3];
}

- (void)getCarPicture:(PictureCell *)cell{
    GetPictureFromDevice *pic = [[GetPictureFromDevice alloc] initWithParentViewController:self.parentController];
    self.getPic = pic;
    self.getPic.delegate = self;
    self.getPic.fileType = kPhotoType;
    self.getPic.picCell = cell;
    [self.getPic takePhotoWithCamera];
}

- (void)didGetFileWithFile:(GetPictureFromDevice *)getFile{
    PictureCell *cell = (PictureCell *)self.getPic.picCell;
    cell.carImageView.image = [UIImage imageWithData:[getFile fileData]];
}

- (IBAction)closePopup:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePopView:)]) {
        [self.delegate closePopView:self];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self initPicView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
