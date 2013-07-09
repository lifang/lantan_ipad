//
//  DetailViewController.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-6-14.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetailViewDelegate;


@interface DetailViewController : UIViewController
@property (nonatomic,assign) id<DetailViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *classLab;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *detailLab;

@property (strong, nonatomic) NSDictionary *productDic;
@property (assign, nonatomic) int number;
@end


@protocol DetailViewDelegate <NSObject>
@optional
- (void)closePopView:(DetailViewController *)detailViewController;

@end