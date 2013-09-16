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
#import "RJLabel.h"
#import "UIImageView+WebCache.h"

@implementation DetailViewController
@synthesize delegate;
@synthesize classLab,detailLabb;
//@synthesize imageView;
@synthesize nameLab,priceLab,detailLab;
@synthesize productDic;
@synthesize number;
@synthesize scrollView;
@synthesize titleArray;
@synthesize kucunLab,countLab;
@synthesize point,pointLab;

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
    self.classLab.text = [self.titleArray objectAtIndex:self.number];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 63, 240, 209)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDomain,[self.productDic objectForKey:@"img"]]];
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defualt.jpg"]];
    
    [[imageView layer] setShadowOffset:CGSizeMake(5, 5)];
    [[imageView layer] setShadowRadius:6];
    [[imageView layer] setShadowOpacity:1];
    [[imageView layer] setShadowColor:[UIColor grayColor].CGColor];
    [self.view addSubview:imageView];

    self.nameLab.text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"name"]];
    self.priceLab.text = [NSString stringWithFormat:@"%.2f元",[[self.productDic objectForKey:@"price"]floatValue]];
    
    if (![[self.productDic objectForKey:@"mat_num"]isKindOfClass:[NSNull class]] && [self.productDic objectForKey:@"mat_num"]!= nil) {
        self.kucunLab.hidden = NO;
        self.countLab.hidden = NO;
        self.countLab.text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"mat_num"]];
        
        self.detailLabb.frame = CGRectMake(268, 135, 39, 21);
        self.scrollView.frame = CGRectMake(318, 135, 214, 195);
        
        if (![[self.productDic objectForKey:@"point"]isKindOfClass:[NSNull class]] && [self.productDic objectForKey:@"point"]!= nil) {
            self.pointLab.frame = CGRectMake(425, 100, 42, 21);
            self.point.frame = CGRectMake(475, 100, 55, 21);
            
            self.pointLab.hidden = NO;
            self.point.hidden = NO;
            self.point.text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"point"]];
        }else {
            self.pointLab.hidden = YES;
            self.point.hidden = YES;
        }
    }else {
        self.kucunLab.hidden = YES;
        self.countLab.hidden = YES;
        
        if (![[self.productDic objectForKey:@"point"]isKindOfClass:[NSNull class]] && [self.productDic objectForKey:@"point"]!= nil) {
            self.pointLab.frame = CGRectMake(268, 100, 42, 21);
            self.point.frame = CGRectMake(318, 100, 87, 21);
            
            self.pointLab.hidden = NO;
            self.point.hidden = NO;
            self.point.text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"point"]];

            self.detailLabb.frame = CGRectMake(268, 135, 39, 21);
            self.scrollView.frame = CGRectMake(318, 135, 214, 195);
            
        }else {
            self.pointLab.hidden = YES;
            self.point.hidden = YES;
            
            self.detailLabb.frame = CGRectMake(268, 100, 39, 21);
            self.scrollView.frame = CGRectMake(318, 100, 214, 230);
        }
    }
    
    NSString *text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"description"]];
    if (text.length == 0) {
        text = [NSString stringWithFormat:@"%@",[self.productDic objectForKey:@"name"]];
    }
    self.detailLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.detailLab setNumberOfLines:0];
    [self.detailLab setBackgroundColor:[UIColor clearColor]];
    self.detailLab.tag = 10000;
    UIFont *font = [UIFont fontWithName:@"Trebuchet MS" size:15];
    [self.detailLab setFont:font];
    
    CGSize size = [UILabel fitSize:214.0f
                              text:text
                              font:font
                     numberOfLines:0
                     lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.detailLab setFrame:CGRectMake(0, 0, 214, size.height)];
    self.detailLab.text = text;
    
    [self.scrollView addSubview:self.detailLab];
    self.scrollView.contentSize = CGSizeMake(214,self.detailLab.frame.size.height+5);
    [self.scrollView setScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}
@end
