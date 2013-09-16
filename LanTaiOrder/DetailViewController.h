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
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) UILabel *detailLab;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *detailLabb;
@property (strong, nonatomic) NSDictionary *productDic;
@property (assign, nonatomic) int number;
@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) IBOutlet UILabel *kucunLab;
@property (strong, nonatomic) IBOutlet UILabel *countLab;
@property (strong, nonatomic) IBOutlet UILabel *pointLab;
@property (strong, nonatomic) IBOutlet UILabel *point;

@end


@protocol DetailViewDelegate <NSObject>
@optional
- (void)closePopView:(DetailViewController *)detailViewController;

@end