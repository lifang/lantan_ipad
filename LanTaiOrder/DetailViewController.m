//
//  DetailViewController.m
//  LanTaiOrder
//
//  Created by comdosoft on 13-6-14.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DetailViewController
@synthesize delegate;
@synthesize classLab;
@synthesize imageView;
@synthesize nameLab,priceLab,detailLab;
@synthesize productDic;
@synthesize number;

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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    self.classLab.textColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];
    if (self.number == 0 || self.number == 1) {
        self.classLab.text = @"服务";
    }else if (self.number == 2) {
        self.classLab.text = @"产品";
    }else {
        self.classLab.text = @"会员卡";
    }
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kDomain,[self.productDic objectForKey:@"img"]]] placeholderImage:[UIImage imageNamed:@"defualt.jpg"]];
    [[self.imageView layer] setShadowOffset:CGSizeMake(5, 5)];
    [[self.imageView layer] setShadowRadius:6];
    [[self.imageView layer] setShadowOpacity:1];
    [[self.imageView layer] setShadowColor:[UIColor grayColor].CGColor];

    self.nameLab.text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"name"]];
    self.priceLab.text = [NSString stringWithFormat:@"%.2f元",[[self.productDic objectForKey:@"price"]floatValue]];
    
    NSString *text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"description"]];
    self.detailLab.text = text;
    [self.detailLab setNumberOfLines:0];
    self.detailLab.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(214,210);
    UIFont *font = [UIFont systemFontOfSize:17];
    [self.detailLab setFont:font];
    self.detailLab.adjustsFontSizeToFitWidth = YES;
    CGSize labelsize = [text sizeWithFont:self.detailLab.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.detailLab.frame = CGRectMake(316, 135, 214, labelsize.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
