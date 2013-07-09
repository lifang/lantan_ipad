 //
//  AddViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "AddViewController.h"
#import "Customer.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kPickerAnimationDuration 0.40
#define TagOff 100
#define TagOn 1000

@interface AddViewController ()<DetailViewDelegate>{
    DetailViewController *detailView;
}

@end

@implementation AddViewController
@synthesize stepView_0,stepView_1,stepView_2,stepView_3,stepView_4,step,btnDone,btnNext,btnPre;
@synthesize picView_0,picView_1,picView_2,picView_3,stepImg;
@synthesize brandView;
@synthesize txtBirth,txtCarNum,txtCarYear,txtEmail,txtName,txtPhone;
@synthesize getPic,brandList,productList,customer;
@synthesize car_num;
@synthesize pickerView,pickView,dateFormatter,selectedIndexs;
@synthesize pickerBtn,refreshBtn;
@synthesize product_ids;
@synthesize manBtn,womanBtn;
@synthesize dataArray;
@synthesize button_tag;

@synthesize myPageControl,myScrollView,myTable;
@synthesize firstArray,secondArray,thirdArray;

static bool refresh = NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initView{
    self.btnNext.hidden = NO;
    self.btnDone.hidden = YES;
    self.btnPre.hidden = NO;
    self.refreshBtn.hidden = YES;
    if ([step intValue]==0) {
        self.refreshBtn.hidden = NO;
        self.btnPre.hidden = YES;
        stepView_0.hidden = NO;
        stepView_1.hidden = YES;
        stepView_2.hidden = YES;
        stepView_3.hidden = YES;
        stepView_4.hidden = YES;
    }else if ([step intValue]==1) {
        stepView_0.hidden = YES;
        stepView_1.hidden = NO;
        stepView_2.hidden = YES;
        stepView_3.hidden = YES;
        stepView_4.hidden = YES;
    }else if ([step intValue]==2) {
        stepView_0.hidden = YES;
        stepView_1.hidden = YES;
        stepView_2.hidden = NO;
        stepView_3.hidden = YES;
        stepView_4.hidden = YES;
    }else if ([step intValue]==3) {
        stepView_0.hidden = YES;
        stepView_1.hidden = YES;
        stepView_2.hidden = YES;
        stepView_3.hidden = NO;
        stepView_4.hidden = YES;
    }else if ([step intValue]==4) {
        self.btnNext.hidden = YES;
        self.btnDone.hidden = NO;
        stepView_0.hidden = YES;
        stepView_1.hidden = YES;
        stepView_2.hidden = YES;
        stepView_3.hidden = YES;
        stepView_4.hidden = NO;
    }
}

- (void)initPicView{
    picView_0 = [[PictureCell alloc] initWithFrame:CGRectMake(250, 50, 172, 192) title:@"车前" delegate:self img:@"front"];
    picView_1 = [[PictureCell alloc] initWithFrame:CGRectMake(520, 50, 172, 192) title:@"车后" delegate:self img:@"behind"];
    picView_2 = [[PictureCell alloc] initWithFrame:CGRectMake(250, 260, 172, 192) title:@"车左" delegate:self img:@"left"];
    picView_3 = [[PictureCell alloc] initWithFrame:CGRectMake(520, 260, 172, 192) title:@"车右" delegate:self img:@"right"];
    [stepView_4 addSubview:picView_0];
    [stepView_4 addSubview:picView_1];
    [stepView_4 addSubview:picView_2];
    [stepView_4 addSubview:picView_3];
}

- (void)initBrandView{
    if ((brandList.count>0) && (![[customer objectForKey:@"brand_name"] isKindOfClass:[NSNull class]]) && customer) {
        for (int i = 0; i<brandList.count; i++) {
            NSDictionary *brand_dic = [brandList objectAtIndex:i];
            NSArray *array = [brand_dic objectForKey:@"brands"];
            BOOL out = NO;
            if (array.count >0) {
                for (int j=0; j<array.count; j++) {
                    NSDictionary *dic = [array objectAtIndex:j];
                    NSString *name_brand = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                    NSString *nameBrand = [NSString stringWithFormat:@"%@",[customer objectForKey:@"brand_name"]];
                    if ([name_brand isEqualToString:nameBrand]) {
                        self.firstArray = [NSMutableArray arrayWithArray:self.brandList];
                        self.secondArray = [NSMutableArray arrayWithArray:[[self.firstArray objectAtIndex:i] objectForKey:@"brands"]];
                        self.thirdArray = [NSMutableArray arrayWithArray:[[self.secondArray objectAtIndex:j] objectForKey:@"models"]];
                        [self.brandView selectRow:i inComponent:0 animated:YES];
                        [self.brandView selectRow:j inComponent:1 animated:YES];
                        
                        NSArray *models_array = [dic objectForKey:@"models"];
                        if ((models_array.count >0)&& (![[customer objectForKey:@"model_name"] isKindOfClass:[NSNull class]])) {
                            for (int k=0; k<models_array.count; k++) {
                                NSDictionary *model_dic = [models_array objectAtIndex:k];
                                NSString *name_model = [NSString stringWithFormat:@"%@",[model_dic objectForKey:@"name"]];
                                NSString *modelName = [NSString stringWithFormat:@"%@",[customer objectForKey:@"model_name"]];
                                if ([name_model isEqualToString:modelName]) {
                                    out = YES;
                                    [self.brandView selectRow:k inComponent:2 animated:YES];
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            if (out) {
                break;
            }
        }
    }else {
        if (self.brandList.count > 0) {
            self.firstArray = [NSMutableArray arrayWithArray:self.brandList];
            self.secondArray = [NSMutableArray arrayWithArray:[[self.firstArray objectAtIndex:0] objectForKey:@"brands"]];
            self.thirdArray = [NSMutableArray arrayWithArray:[[self.secondArray objectAtIndex:0] objectForKey:@"models"]];
        }
    }
}
-(void)getData {
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kBrandProduct]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSString *str = [r startSynchronousWithError:&error];
    NSDictionary *result = [str objectFromJSONString];
    if ([[result objectForKey:@"status"] intValue]==1) {
        self.brandList = [NSMutableArray arrayWithArray:[result objectForKey:@"brands"]];
        self.productList = [NSMutableArray arrayWithArray:[result objectForKey:@"products"]];
        
        if (refresh == YES) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.dataArray = [self.productList objectAtIndex:self.button_tag];
            [self displayNewView];
            refresh = NO;
        }
    }
    
}
//刷新
-(IBAction)refreshBtnPressed:(id)sender {
    refresh = YES;
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    [self.selectedIndexs removeAllObjects];

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.dimBackground = NO;
    [hud showWhileExecuting:@selector(getData) onTarget:self withObject:nil animated:YES];
    hud.labelText = @"正在努力加载...";
    [self.view addSubview:hud];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DataService sharedService].ReservationFirst = NO;
    self.product_ids = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //日期得pickerView
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.selectedIndexs = [NSMutableArray array];
    
    [self initView];
    [self initPicView];
    [self initBrandView];

    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemsWithImage:@"back" andImage:nil andImage:nil];
    }
    //登记车牌号
    if (self.car_num) {
        self.txtCarNum.text = self.car_num;
    }
    if (self.customer) {
        self.txtCarNum.text = [customer objectForKey:@"carNum"];
        self.txtName.text = [customer objectForKey:@"name"];
        self.txtPhone.text = [customer objectForKey:@"phone"];
        if (![[customer objectForKey:@"email"] isKindOfClass:[NSNull class]]) {
            self.txtEmail.text = [customer objectForKey:@"email"];
        }
        if (![[customer objectForKey:@"birth"] isKindOfClass:[NSNull class]]) {
            self.txtBirth.text = [customer objectForKey:@"birth"];
        }
        if(![[customer objectForKey:@"year"]isKindOfClass:[NSNull class]]){
            self.txtCarYear.text = [NSString stringWithFormat:@"%@",[customer objectForKey:@"year"]];
        }
        
        if(![[customer objectForKey:@"sex"]isKindOfClass:[NSNull class]]) {
            int sexNumber = [[customer objectForKey:@"sex"]intValue];
            if (sexNumber == 0) {
                self.manBtn.tag = TagOn;
                [self.manBtn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                
                self.womanBtn.tag = TagOff;
                [self.womanBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
            }else if (sexNumber == 1) {
                self.womanBtn.tag = TagOn;
                [self.womanBtn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                
                self.manBtn.tag = TagOff;
                [self.manBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
            }
        }else {
            self.manBtn.tag = TagOff;
            [self.manBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
            
            self.womanBtn.tag = TagOff;
            [self.womanBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];

        }
    }else {
        self.manBtn.tag = TagOff;
        [self.manBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        
        self.womanBtn.tag = TagOff;
        [self.womanBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
    }
    
    if (self.step) {
        [self.stepImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"step_%@",step]]];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];

    self.dataArray = [NSMutableArray array];
    self.button_tag = 0;
    self.dataArray = [self.productList objectAtIndex:self.button_tag];
    [self displayNewView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowing:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHideing:) name: UIKeyboardWillHideNotification object:nil];
}
//根据分页控制跳转页面
-(void)changePage:(UIPageControl *)aPageControl{
    int whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.myScrollView setContentOffset:CGPointMake(804.0f * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
	
}
//控制滑动的时候分页按钮对应去显示
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
	if (sender == self.myScrollView) {
		CGFloat pageWidth = sender.frame.size.width;
		int page = floor((sender.contentOffset.x - pageWidth/2)/pageWidth)+1;
		self.myPageControl.currentPage = page;
	}
}

-(void)displayNewView {
    //清空
    [self.myScrollView removeFromSuperview];
    [self.myPageControl removeFromSuperview];
    NSInteger count = ([self.dataArray count]-1)/8+1;
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 74, 804, 400)];
    self.myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 464, 804, 12)];
    self.myPageControl.center = CGPointMake(402, 464);
    
    self.myScrollView.delegate = self;
    self.myScrollView.contentSize = CGSizeMake(804*count, self.myScrollView.frame.size.height);
    self.myScrollView.pagingEnabled = YES;
	self.myScrollView.showsVerticalScrollIndicator = NO;
	self.myScrollView.showsHorizontalScrollIndicator = NO;
    [self.stepView_0 addSubview:self.myScrollView];
    
    for (int i=0; i<count; i++) {
        self.myTable = [[UITableView alloc] initWithFrame:CGRectMake(0+804*i, 0, 804, self.myScrollView.frame.size.height)];
        self.myTable.tag = i;
        self.myTable.delegate = self;
        self.myTable.dataSource = self;
        self.myTable.scrollEnabled = NO;
        self.myTable.backgroundColor = [UIColor clearColor];
        [self.myScrollView addSubview:self.myTable];
    }
    self.myPageControl.backgroundColor = [UIColor colorWithRed:0.5765 green:0.0078 blue:0.0196 alpha:1.0];
	self.myPageControl.numberOfPages = count;
	[self.myPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	[self.stepView_0 addSubview:self.myPageControl];
    
    CGRect frame = [self.stepView_0 bounds];
    frame.origin.y = 0;
    frame.origin.x = 0;
    [self.myScrollView setContentOffset:CGPointMake(frame.origin.x, frame.origin.y)];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = ([self.dataArray count]-1)/8+1;
    
    static NSString *CellIdentifier = @"Cell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (int i = 0; i<count; i++) {
            if (tableView.tag==i) {
                [self drawTableViewCell:cell index:[indexPath row] category:i];
            }
        }
	}
    
    return cell;
}

//绘制tableview的cell
-(void)drawTableViewCell:(UITableViewCell *)cell index:(int)row category:(int)category{
    int maxIndex = (row*4+3);
    int number = [self.dataArray count]-8*category;
	if(maxIndex < number) {
		for (int i=0; i<4; i++) {
			[self displayPhotoes:cell row:row col:i category:category];
		}
		return;
	}
	else if(maxIndex-1 < number) {
		for (int i=0; i<3; i++) {
			[self displayPhotoes:cell row:row col:i category:category];
		}
		return;
	}
	else if(maxIndex-2 < number) {
		for (int i=0; i<2; i++) {
			[self displayPhotoes:cell row:row col:i category:category];
		}
		return;
	}
	else if(maxIndex-3 < number) {
		[self displayPhotoes:cell row:row col:0 category:category];
		return;
	}
}
-(void)displayPhotoes:(UITableViewCell *)cell row:(int)row col:(int)col category:(int)category
{
    NSInteger currentTag = 4*row+col+category*8;
    
    NSDictionary *prod = [self.dataArray objectAtIndex:currentTag];
    
    //自定义view
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0+col*201, 0, 201, 200)];
    //图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 150, 150)];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kDomain,[prod objectForKey:@"img"]]] placeholderImage:[UIImage imageNamed:@"defualt.jpg"]];
    imageView.tag = currentTag;
    UIButton  *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(0, 0, 160, 200);
    imageBtn.tag = imageView.tag;
    [imageBtn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:imageBtn];
    
    //名称
    UIFont *font = [UIFont systemFontOfSize:14];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 160, 40)];
    lab.text = [NSString stringWithFormat:@"%@:%.2f",[prod objectForKey:@"name"],[[prod objectForKey:@"price"]floatValue]];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.backgroundColor = [UIColor clearColor];
    lab.font = font;

    //checkBox
    UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(160, 55, 40, 40);
    button.tag = currentTag;
    NSString *str_index = [NSString stringWithFormat:@"%d_%d",self.button_tag,button.tag];
    if ([self isSelected:str_index]) {
        [button setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];//选择
    }else {
        [button setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];//不选择
    }
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [myView addSubview:imageView];
    [myView addSubview:lab];
    [myView addSubview:button];
    
    [cell.contentView addSubview:myView];
}

- (BOOL)isSelected:(NSString *)str_indexPath{
    //*****************判断是否选中行已添加进数组
    if ([self.selectedIndexs containsObject:str_indexPath]) {
        return YES;
    }
    return NO;
}

- (void)buttonClick:(id)sender{
    UIButton *button = sender;
    
    NSString *str_index = [NSString stringWithFormat:@"%d_%d",self.button_tag,button.tag];
    if ([self isSelected:str_index]) {
        [selectedIndexs removeObject:str_index];
        [button setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];//不选择
    }else {
        [selectedIndexs addObject:str_index];
        [button setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];//选择
    }

}

-(void)imageButtonClick:(id)sender {
    UIButton *button = sender;

    detailView = nil;
    detailView = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    detailView.delegate = self;
    detailView.number = self.button_tag;
    detailView.productDic = [NSDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:button.tag]];
    [self presentPopupViewController:detailView animationType:MJPopupViewAnimationSlideBottomBottom];
}



-(IBAction)btnPressed:(id)sender {
    [self.txtName resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtCarYear resignFirstResponder];
    [self.txtCarNum resignFirstResponder];
    [self.txtBirth resignFirstResponder];
    
    CGRect pickerFrame = self.pickView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickView.frame = pickerFrame;
    [UIView commitAnimations];
    [DataService sharedService].tagOfBtn = 0;
}

-(IBAction)pickerViewDown:(id)sender {
    CGRect pickerFrame = self.pickView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickView.frame = pickerFrame;
    [UIView commitAnimations];
    [DataService sharedService].tagOfBtn = 0;
}
-(IBAction)showPicker:(id)sender {
    [self.txtName resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtCarYear resignFirstResponder];
    [self.txtCarNum resignFirstResponder];
    [self.txtBirth resignFirstResponder];
    
    //初识状态
    if(![[customer objectForKey:@"birth"]isKindOfClass:[NSNull class]] && [customer objectForKey:@"birth"] != nil) {
        self.pickerView.date = [self.dateFormatter dateFromString:self.txtBirth.text];
    }else {
        self.pickerView.date = [NSDate date];
    }
    if ([DataService sharedService].tagOfBtn == 0)
    {
        CGRect startFrame = self.pickView.frame;
        CGRect endFrame = self.pickView.frame;
        startFrame.origin.y = self.view.frame.size.height;
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        self.pickView.frame = startFrame;
        [self.view addSubview:self.pickView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kPickerAnimationDuration];
        self.pickView.frame = endFrame;
        [UIView commitAnimations];
        
        [DataService sharedService].tagOfBtn = 1;
    }
}
#pragma mark - keyBoard

- (void)keyBoardWillShowing:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.stepView_3.frame;
    if (frame.origin.y==104) {
        frame.origin.y = 44;
    }
    self.stepView_3.frame = frame;
    [UIView commitAnimations];
    
    CGRect pickerFrame = self.pickView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickView.frame = pickerFrame;
    [UIView commitAnimations];
    
    [DataService sharedService].tagOfBtn = 0;
}

- (void)keyBoardWillHideing:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.stepView_3.frame;
    if (frame.origin.y==44) {
        frame.origin.y = 104;
    }
    self.stepView_3.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)dateAction:(id)sender
{
	self.txtBirth.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}
- (void)slideDownDidStop
{
	[self.pickView removeFromSuperview];
}
#pragma mark - 完成登记
-(void)finishInfo {
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kcheckIn]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:txtCarNum.text forKey:@"carNum"];
    [dic setObject:txtName.text forKey:@"userName"];
    [dic setObject:txtPhone.text forKey:@"phone"];
    [dic setObject:txtCarYear.text forKey:@"year"];
    if (![self.txtBirth.text isEqualToString:@""]) {
        [dic setObject:txtBirth.text forKey:@"birth"];
    }
    if (![self.txtEmail.text isEqualToString:@""])  {
        [dic setObject:txtEmail.text forKey:@"email"];
    }
    if ((self.manBtn.tag == TagOn) && (self.womanBtn.tag == TagOff)) {
        [dic setObject:@"0" forKey:@"sex"];
    }else if ((self.womanBtn.tag == TagOn) && (self.manBtn.tag == TagOff)) {
        [dic setObject:@"1" forKey:@"sex"];
    }
    [dic setObject:[DataService sharedService].store_id forKey:@"store_id"];
    
    NSDictionary *brand  = [self.secondArray objectAtIndex:[brandView selectedRowInComponent:1]];
    NSString *brandStr = [brand objectForKey:@"id"];
    NSString *modelStr = @"";
    if ([[brand objectForKey:@"models"] count]>0) {
        modelStr = [[[brand objectForKey:@"models"] objectAtIndex:[brandView selectedRowInComponent:2]] objectForKey:@"id"];
    }
    [dic setObject:[NSString stringWithFormat:@"%@_%@",brandStr,modelStr] forKey:@"brand"];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    [r setPOSTDictionary:dic];
    
    NSError *error = nil;
    NSString *str = [r startSynchronousWithError:&error];
    NSDictionary *result = [str objectFromJSONString];
    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] intValue]==1) {
        [AHAlertView applyCustomAlertAppearance];
        AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"登记信息成功"];
        __block AHAlertView *alert = alertt;
        [alertt setCancelButtonTitle:@"确定" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
            alert = nil;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertt show];
        
    }else {
        [self errorAlert:[result objectForKey:@"content"]];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
#pragma mark - 完成下单
-(void)finishOrder {
    if (self.selectedIndexs && self.selectedIndexs.count > 0) {
        STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kFinish]];
        
        NSDictionary *brand  = [self.secondArray objectAtIndex:[brandView selectedRowInComponent:1]];
        NSString *brandStr = [brand objectForKey:@"id"];
        NSString *modelStr = @"";
        if ([[brand objectForKey:@"models"] count]>0) {
            modelStr = [[[brand objectForKey:@"models"] objectAtIndex:[brandView selectedRowInComponent:2]] objectForKey:@"id"];
        }
        
        NSMutableString *prod_ids = [NSMutableString string];
        for (NSString *str_idx in self.selectedIndexs) {
            NSArray *array = [str_idx componentsSeparatedByString:@"_"];
            int num = [[array objectAtIndex:0]intValue];
            int idx = [[array objectAtIndex:1]intValue];
            
            NSDictionary *prod = [[self.productList objectAtIndex:num] objectAtIndex:idx];
            if (num  == 3) {
                [prod_ids appendFormat:@"%@_%d_%d,",[prod objectForKey:@"id"],num,[[prod objectForKey:@"type"]intValue]];
            }else {
                [prod_ids appendFormat:@"%@_%d,",[prod objectForKey:@"id"],num];
            }
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:txtCarNum.text forKey:@"carNum"];
        [dic setObject:txtName.text forKey:@"userName"];
        [dic setObject:txtPhone.text forKey:@"phone"];
        [dic setObject:txtCarYear.text forKey:@"year"];
        if (![self.txtBirth.text isEqualToString:@""] && (![self.txtBirth.text isKindOfClass:[NSNull class]])) {
            [dic setObject:txtBirth.text forKey:@"birth"];
        }
        if (![self.txtEmail.text isEqualToString:@""] && (![self.txtEmail.text isKindOfClass:[NSNull class]]))  {
            [dic setObject:txtEmail.text forKey:@"email"];
        }
        if ((self.manBtn.tag == TagOn) && (self.womanBtn.tag == TagOff)) {
            [dic setObject:@"0" forKey:@"sex"];
        }else if ((self.womanBtn.tag == TagOn) && (self.manBtn.tag == TagOff)) {
            [dic setObject:@"1" forKey:@"sex"];
        }
        
        if ([modelStr intValue] == 0) {
            [dic setObject:[NSString stringWithFormat:@"%@",brandStr] forKey:@"brand"];
        }else {
           [dic setObject:[NSString stringWithFormat:@"%@_%@",brandStr,modelStr] forKey:@"brand"]; 
        }
        
        [dic setObject:prod_ids forKey:@"prod_ids"];
        [dic setObject:[DataService sharedService].store_id forKey:@"store_id"];
        if ([customer objectForKey:@"reserv_at"]) {
            [dic setObject:[customer objectForKey:@"reserv_at"] forKey:@"res_time"];
        }
        
        [r setPostDataEncoding:NSUTF8StringEncoding];
        [r setPOSTDictionary:dic];
        NSError *error = nil;
        
        NSString *dicc = [r startSynchronousWithError:&error];
        NSDictionary *result = [dicc objectFromJSONString]; 

        if ([[result objectForKey:@"status"] intValue]==1) {
            ConfirmViewController *confirmView = [[ConfirmViewController alloc] initWithNibName:@"ConfirmViewController" bundle:nil];
            confirmView.productList = [NSMutableArray array];
            if ([result objectForKey:@"info"]) {
                confirmView.orderInfo = [result objectForKey:@"info"];
            }
            if ([result objectForKey:@"products"]) {
                [confirmView.productList addObjectsFromArray:[result objectForKey:@"products"]];
            }
            if ([result objectForKey:@"sales"]) {
                [confirmView.productList addObjectsFromArray:[result objectForKey:@"sales"]];
            }
            if ([result objectForKey:@"svcards"]) {
                [confirmView.productList addObjectsFromArray:[result objectForKey:@"svcards"]];
            }
            if ([result objectForKey:@"pcards"]) {
                [confirmView.productList addObjectsFromArray:[result objectForKey:@"pcards"]];
            }
            if ([[result objectForKey:@"total"] floatValue] <0) {
                confirmView.total_count = 0.0;
                confirmView.total_count_temp = [[result objectForKey:@"total"] floatValue];
            }else {
                confirmView.total_count = [[result objectForKey:@"total"] floatValue];
            }
            [DataService sharedService].total_count = confirmView.total_count;//总价放到单例去
            [self.navigationController pushViewController:confirmView animated:YES];
        }else{
            [self errorAlert:[result objectForKey:@"content"]];
        }
        
    }else{
        [self errorAlert:@"请选择所需的产品、服务"];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - 保存客户信息到数据库

static bool success = NO;//登记成功？
-(void)addCustomerData {
    success = NO;
    //brand
    NSDictionary *brand  = [self.secondArray objectAtIndex:[brandView selectedRowInComponent:1]];
    NSString *brandStr = [brand objectForKey:@"id"];
    NSString *name_brand = [brand objectForKey:@"name"];
    NSString *modelStr = @"";
    NSString *name_model = @"";
    if ([[brand objectForKey:@"models"] count]>0) {
        modelStr = [[[brand objectForKey:@"models"] objectAtIndex:[brandView selectedRowInComponent:2]] objectForKey:@"id"];
        name_model = [[[brand objectForKey:@"models"] objectAtIndex:[brandView selectedRowInComponent:2]] objectForKey:@"name"];
    }
    //sex
    NSString *sex = @"";
    if ((self.manBtn.tag == TagOn) && (self.womanBtn.tag == TagOff)) {
        sex = @"0";
    }else if ((self.womanBtn.tag == TagOn) && (self.manBtn.tag == TagOff)) {
        sex = @"1";
    }
    NSArray *array = [[LanTaiOrderManager sharedInstance] loadDataFromTableName:@"customer" WithName:nil andPassWord:nil andCarNum:self.txtCarNum.text andBrand_id:nil andCar_brand_id:nil andProduct_id:nil andClassify_id:nil andCar_capital_id:nil];
    if (array.count == 0) {
        NSArray *paramarray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",self.txtCarNum.text],[NSString stringWithFormat:@"%@",self.txtName.text],[NSString stringWithFormat:@"%@",self.txtPhone.text],[NSString stringWithFormat:@"%@_%@",brandStr,modelStr],[NSString stringWithFormat:@"%@",self.txtEmail.text],[NSString stringWithFormat:@"%@",self.txtBirth.text],[NSString stringWithFormat:@"%@",self.txtCarYear.text],[NSString stringWithFormat:@"%@",name_brand],[NSString stringWithFormat:@"%@",name_model],[NSString stringWithFormat:@"%@",sex],nil];
        success = [[LanTaiOrderManager sharedInstance]addDataToTable:@"customer" WithArray:paramarray];
        
        //判断同步按钮，避免访问数据库
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"sync"];
        [defaults synchronize];
    }else {//数据改动
        for (Customer *ctomer in array) {
            if (![ctomer.name isEqualToString:self.txtName.text] || ![ctomer.phone isEqualToString:self.txtPhone.text] ||  ![ctomer.brand isEqualToString:[NSString stringWithFormat:@"%@_%@",brandStr,modelStr]] || ![ctomer.email isEqualToString:self.txtEmail.text] || ![ctomer.birth isEqualToString:self.txtBirth.text] || ![ctomer.year isEqualToString:self.txtCarYear.text] || ![ctomer.brand_name isEqualToString:name_brand] || ![ctomer.model_name isEqualToString:name_model] || ![ctomer.sex isEqualToString:sex]) {
                [[LanTaiOrderManager sharedInstance]deleteTable:@"customer" WithName:nil andPassWord:nil andCarNum:self.txtCarNum.text andProduct_id:nil andCodeID:nil];
                
                NSArray *paramarray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",self.txtCarNum.text],[NSString stringWithFormat:@"%@",self.txtName.text],[NSString stringWithFormat:@"%@",self.txtPhone.text],[NSString stringWithFormat:@"%@_%@",brandStr,modelStr],[NSString stringWithFormat:@"%@",self.txtEmail.text],[NSString stringWithFormat:@"%@",self.txtBirth.text],[NSString stringWithFormat:@"%@",self.txtCarYear.text],[NSString stringWithFormat:@"%@",name_brand],[NSString stringWithFormat:@"%@",name_model],[NSString stringWithFormat:@"%@",sex],nil];
                success = [[LanTaiOrderManager sharedInstance]addDataToTable:@"customer" WithArray:paramarray];
                
                //判断同步按钮，避免访问数据库
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"1" forKey:@"sync"];
                [defaults synchronize];
            }
            success = YES;
        }
    }
}
#pragma mark -  点击完成

- (IBAction)clickFinished:(id)sender{
    if ([DataService sharedService].number == 1) {
            NSString *str = @"";
            if(txtName.text.length==0){
                str = @"请输入您的名称";
            }else {
                //判断联系电话
                if(txtPhone.text.length == 0){
                    str = @"请输入联系电话";
                }else {
                    NSString *regexCall = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))|(((\\+86)|(86))?+\\d{11})$)";
                    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
                    if ([predicateCall evaluateWithObject:txtPhone.text]) {
                        
                    }else {
                        str = @"请输入准确的联系电话";
                    }
                }
                //判断生日
                if (txtBirth.text.length == 0) {
                }else {
                    
                    NSString *regexCall =@"((19[0-9]{2})|(2[0-9]{3})）-((1[0-2])|(0[1-9]))-((0[1-9])|([1-2][0-9])|3[0-1])";
                    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
                    if ([predicateCall evaluateWithObject:txtBirth.text]) {
                        //获取年份
                        NSDate *now = [NSDate date];
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSUInteger unitFlags = NSYearCalendarUnit  | NSMonthCalendarUnit | NSDayCalendarUnit;
                        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                        int year = [dateComponent year];
                        int month = [dateComponent month];
                        int day = [dateComponent day];
                        
                        NSArray *arr = [txtBirth.text componentsSeparatedByString:@"-"];
                        int brith_year = [[arr objectAtIndex:0] intValue];
                        int birth_month = [[arr objectAtIndex:1]intValue];
                        int birth_day = [[arr objectAtIndex:2]intValue];
                        
                        if (brith_year > year) {
                            str = @"请输入准确的出生年份";
                        }else if ((brith_year==year) && (birth_month > month)) {
                            str = @"请输入准确的出生月份";
                        }else if ((brith_year==year) && (birth_month == month) && (birth_day >= day)) {
                            str = @"请输入准确的出生日子";
                        }
                    }
                }
                //判断邮箱
                if (self.txtEmail.text.length == 0) {
                }
            }
            if (self.txtName.text.length==0 || self.txtPhone.text.length==0 || ![str isEqualToString:@""]) {
                [self errorAlert:str];
            }else if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
                //保存客户信息到数据库
                [self addCustomerData];
                if (success == YES) {
                    [AHAlertView applyCustomAlertAppearance];
                    AHAlertView *alertt = [[AHAlertView alloc] initWithTitle:kTip message:@"登记信息成功"];
                    __block AHAlertView *alert = alertt;
                    [alertt setCancelButtonTitle:@"确定" block:^{
                        alert.dismissalStyle = AHAlertViewDismissalStyleTumble;
                        alert = nil;
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [alertt show];
                }else {
                    [self errorAlert:@"登记失败"];
                }
                
            }else {
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                hud.dimBackground = NO;
                [hud showWhileExecuting:@selector(finishInfo) onTarget:self withObject:nil animated:YES];
                hud.labelText = @"正在努力加载...";
                [self.view addSubview:hud];
            }
    }else {
        if ([[Utils connectToInternet] isEqualToString:@"locahost"]) {
            if (self.selectedIndexs && self.selectedIndexs.count > 0) {
                //保存员工信息到数据库
                [DataService sharedService].netWorking = NO;
                [self addCustomerData];
                ConfirmViewController *confirmView = [[ConfirmViewController alloc] initWithNibName:@"ConfirmViewController" bundle:nil];
                confirmView.productList = [NSMutableArray array];
                
                NSMutableArray *array_idx = [NSMutableArray array];
                NSMutableArray *array_idxx = [NSMutableArray array];
                ///排序
                for (NSString *str_idx in self.selectedIndexs) {
                    NSArray *array = [str_idx componentsSeparatedByString:@"_"];
                    int num = [[array objectAtIndex:0]intValue];
                    if (num <3) {
                        [array_idx addObject:str_idx];
                    }else {
                        [array_idxx addObject:str_idx];
                    }
                }
                if (array_idxx.count >0) {
                    [array_idx addObjectsFromArray:array_idxx];
                }
                for (NSString *str_idx in array_idx) {
                    NSArray *array = [str_idx componentsSeparatedByString:@"_"];
                    int num = [[array objectAtIndex:0]intValue];
                    int section = [[array objectAtIndex:1]intValue];
                    
                    NSDictionary *prod = [[self.productList objectAtIndex:num] objectAtIndex:section];
                    DLog(@"%@",prod);
                    if (num < 3) {//产品，服务
                        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                        if (![[prod objectForKey:@"type"] isKindOfClass:[NSNull class]] && [prod objectForKey:@"type"] != nil) {
                            [tempDic setObject:[prod objectForKey:@"type"] forKey:@"type"];
                        }else {
                            [tempDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"type"];
                        }
                        [tempDic setObject:@"1" forKey:@"count"];
                        [tempDic setObject:[prod objectForKey:@"id"] forKey:@"id"];
                        [tempDic setObject:[prod objectForKey:@"name"] forKey:@"name"];
                        [tempDic setObject:[prod objectForKey:@"price"] forKey:@"price"];
                        if ([prod objectForKey:@"classify_id"]!= nil && ![[prod objectForKey:@"classify_id"] isKindOfClass:[NSNull class]]) {
                            [tempDic setObject:[prod objectForKey:@"classify_id"] forKey:@"classify_id"];
                        }else {
                            [tempDic setObject:[NSString stringWithFormat:@"%d",num] forKey:@"classify_id"];
                        }
                        
                        [confirmView.productList addObject:tempDic];
                        
                        confirmView.total_count = confirmView.total_count + [[prod objectForKey:@"price"]floatValue];
                    }else if(num == 3 && [[prod objectForKey:@"type"]intValue] == 0){//套餐卡
                        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
                        if (![[prod objectForKey:@"type"] isKindOfClass:[NSNull class]] && [prod objectForKey:@"type"] != nil) {
                            [tempDic setObject:[prod objectForKey:@"type"] forKey:@"type"];
                        }else {
                            [tempDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"type"];
                        }
                        [tempDic setObject:@"0 " forKey:@"has_p_card"];
                        [tempDic setObject:[prod objectForKey:@"id"] forKey:@"id"];
                        [tempDic setObject:[prod objectForKey:@"name"] forKey:@"name"];
                        [tempDic setObject:[prod objectForKey:@"price"] forKey:@"price"];
                        [tempDic setObject:[prod objectForKey:@"price"] forKey:@"show_price"];
                        if ([prod objectForKey:@"classify_id"]!= nil && ![[prod objectForKey:@"classify_id"] isKindOfClass:[NSNull class]]) {
                            [tempDic setObject:[prod objectForKey:@"classify_id"] forKey:@"classify_id"];
                        }else {
                            [tempDic setObject:[NSString stringWithFormat:@"%d",num] forKey:@"classify_id"];
                        }
                        [tempDic setObject:arr forKey:@"products"];
                        [confirmView.productList addObject:tempDic];
                        
                        confirmView.total_count = confirmView.total_count + [[prod objectForKey:@"price"]floatValue];
                    }else if(num == 3 && [[prod objectForKey:@"type"]intValue] == 1) {//打折卡,储值卡
                        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                        if (![[prod objectForKey:@"type"] isKindOfClass:[NSNull class]] && [prod objectForKey:@"type"] != nil) {
                            [tempDic setObject:[prod objectForKey:@"type"] forKey:@"type"];
                        }else {
                            [tempDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"type"];
                        }
                        [tempDic setObject:@"0 " forKey:@"has_p_card"];
                        [tempDic setObject:@"1 " forKey:@"is_new"];
                        [tempDic setObject:@"1 " forKey:@"card_type"];
                        [tempDic setObject:[prod objectForKey:@"id"] forKey:@"scard_id"];
                        [tempDic setObject:[prod objectForKey:@"name"] forKey:@"scard_name"];
                        [tempDic setObject:[prod objectForKey:@"price"] forKey:@"price"];
                        [tempDic setObject:[prod objectForKey:@"price"] forKey:@"show_price"];
                        if ([prod objectForKey:@"classify_id"]!= nil && ![[prod objectForKey:@"classify_id"] isKindOfClass:[NSNull class]]) {
                            [tempDic setObject:[prod objectForKey:@"classify_id"] forKey:@"classify_id"];
                        }else {
                            [tempDic setObject:[NSString stringWithFormat:@"%d",num] forKey:@"classify_id"];
                        }
                        [confirmView.productList addObject:tempDic];
                        
                        confirmView.total_count = confirmView.total_count + [[prod objectForKey:@"price"]floatValue];
                    }
                }
                
                //brand
                NSDictionary *brand  = [self.secondArray objectAtIndex:[brandView selectedRowInComponent:1]];
                NSString *name_brand = [brand objectForKey:@"name"];
                NSString *name_model = @"";
                if ([[brand objectForKey:@"models"] count]>0) {
                    name_model = [[[brand objectForKey:@"models"] objectAtIndex:[brandView selectedRowInComponent:2]] objectForKey:@"name"];
                }
                NSMutableDictionary *order_dic = [NSMutableDictionary dictionary];
                [order_dic setObject:[NSString stringWithFormat:@"%@-%@",name_brand,name_model] forKey:@"car_brand"];
                [order_dic setObject:self.txtCarNum.text forKey:@"car_num"];
                [order_dic setObject:self.txtPhone.text forKey:@"phone"];
                [order_dic setObject:self.txtName.text forKey:@"c_name"];
                [order_dic setObject:@"" forKey:@"start"];
                [order_dic setObject:@"" forKey:@"end"];
                confirmView.orderInfo = [NSMutableDictionary dictionaryWithDictionary:order_dic];
                
                [DataService sharedService].total_count = confirmView.total_count;//总价放到单例去
                [self.navigationController pushViewController:confirmView animated:YES];
            }else {
                [self errorAlert:@"请选择所需的产品、服务"];
            }
            
        }else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.dimBackground = NO;
            [hud showWhileExecuting:@selector(finishOrder) onTarget:self withObject:nil animated:YES];
            hud.labelText = @"正在努力加载...";
            [self.view addSubview:hud];
        }
    }
}

//上一步，下一步
- (IBAction)clickNext:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int x = [step intValue];
    
    if (btn.tag == 102) {
        x -= 1;
    }else{
        NSString *str = @"";
        if (x==0 ) {//第一步  选择产品
            if (self.selectedIndexs && self.selectedIndexs.count > 0) {
                //已选择产品
            }else {
                str = @"请选择所需的产品、服务";
            }
        }
        
        if (x==1) {//第二步  车牌号
            if (txtCarNum.text.length==0) {
                str = @"请输入你的车牌号";
            }
            if (self.secondArray.count == 0) {
                str = @"请选择汽车品牌";
            }
            
        }
        
        if(x==2){//第三步 购车时间
            //获取年份
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            int year = [dateComponent year];
            
            if (txtCarYear.text.length == 0) {
                str = @"请输入购车时间";
            }else {
                //判断年份
                NSString *regexCall = @"(19[0-9]{2})|(2[0-9]{3})";
                NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
                if ([predicateCall evaluateWithObject:txtCarYear.text]) {
                    int car_year = [txtCarYear.text intValue];
                    if (car_year > year) {
                        str = @"请输入准确的购车时间";
                    }
                }else {
                    str = @"请输入准确的购车时间";
                }
            }
        }
         if(x==3){//第四步 用户信息
            if(txtName.text.length==0){
                str = @"请输入您的名称";
            }else {
                //判断联系电话
                if(txtPhone.text.length == 0){
                    str = @"请输入联系电话";
                }else {
                    NSString *regexCall = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))|(((\\+86)|(86))?+\\d{11})$)";
                    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
                    if ([predicateCall evaluateWithObject:txtPhone.text]) {
                        
                    }else {
                        str = @"请输入准确的联系电话";
                    }
                }
                //判断生日
                if (txtBirth.text.length == 0) {
                }else {
                    NSString *regexCall =@"((19[0-9]{2})|(2[0-9]{3})）-((1[0-2])|(0[1-9]))-((0[1-9])|([1-2][0-9])|3[0-1])";
                    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
                    if ([predicateCall evaluateWithObject:txtBirth.text]) {
                        //获取年份
                        NSDate *now = [NSDate date];
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
                        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                        int year = [dateComponent year];
                        int month = [dateComponent month];
                        int day = [dateComponent day];
                        
                        NSArray *arr = [txtBirth.text componentsSeparatedByString:@"-"];
                        int brith_year = [[arr objectAtIndex:0] intValue];
                        int birth_month = [[arr objectAtIndex:1]intValue];
                        int birth_day = [[arr objectAtIndex:2]intValue];
                        
                        if (brith_year > year) {
                            str = @"请输入准确的出生年份";
                        }else if ((brith_year==year) && (birth_month > month)) {
                            str = @"请输入准确的出生月份";
                        }else if ((brith_year==year) && (birth_month == month) && (birth_day >= day)) {
                            str = @"请输入准确的出生日子";
                        }
                    }
                }
                //判断邮箱
                if (self.txtEmail.text.length == 0) {
                }
            }
        }
        if (str.length==0) {
           x += 1; 
        }else{
            [self errorAlert:str];
        }
        
    }
    [self.stepImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"step_%d",x]]];
    step = [NSString stringWithFormat:@"%d",x];
    [self initView];
}

//拍照
- (void)getCarPicture:(PictureCell *)cell{
    GetPictureFromDevice *pic = [[GetPictureFromDevice alloc] initWithParentViewController:self];
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
#pragma mark - picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 40;
            break;
            
        case 1:
            return 150;
            break;
            
        case 2:
            return 150;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerVieww numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if (self.firstArray.count == 0) {
                return 1;
            }
            return self.firstArray.count;
            break;
            
        case 1:
            if (self.secondArray.count == 0) {
                return 1;
            }
            return self.secondArray.count;
            break;
            
        case 2:
            if (self.thirdArray.count == 0) {
                return 1;
            }
            return self.thirdArray.count;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerVieww titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if (self.firstArray.count>0) {
                return [[self.firstArray objectAtIndex:row]objectForKey:@"name"];
            }
            return @"";
            break;
            
        case 1:
            if (self.secondArray.count>0) {
                return [[self.secondArray objectAtIndex:row]objectForKey:@"name"];
            }
            return @"";
            break;
            
        case 2:
            if (self.thirdArray.count>0) {
                return [[self.thirdArray objectAtIndex:row]objectForKey:@"name"];
            }
            return @"";
            break;
            
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerVieww didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            self.secondArray = [NSMutableArray arrayWithArray:[[self.firstArray objectAtIndex:row]objectForKey:@"brands"]];
            [self.brandView reloadComponent:1];
            [self.brandView selectRow:0 inComponent:1 animated:YES];
            if (self.secondArray.count > 0) {
                self.thirdArray = [NSMutableArray arrayWithArray:[[self.secondArray objectAtIndex:0] objectForKey:@"models"]];
            }else {
                self.thirdArray = nil;
            }
            [self.brandView reloadComponent:2];
            [self.brandView selectRow:0 inComponent:2 animated:YES];
            break;
            
        case 1:
            if (self.secondArray.count>0) {
                self.thirdArray = [NSMutableArray arrayWithArray:[[self.secondArray objectAtIndex:row] objectForKey:@"models"]];
                [self.brandView reloadComponent:2];
                [self.brandView selectRow:0 inComponent:2 animated:YES];
            }
            break;
            
        case 2:
            break;
        
        default:
            break;
        
    }
}
#pragma mark - collectionview
-(IBAction)buttonPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.button_tag = btn.tag;
    self.dataArray = [NSMutableArray array];
    self.dataArray = [self.productList objectAtIndex:self.button_tag];
    if (self.dataArray.count != 0) {
        NSArray *subViews = [self.stepView_0 subviews];
        for (UIView *v in subViews) {
            if ([v isKindOfClass:[UIButton class]]) {
                UIButton *v_button = (UIButton *)v;
                if (v_button.tag != btn.tag) {
                    [v_button setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
                }
                
            }
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
        [self displayNewView];
    }
}

-(IBAction)manBtnPressed:(id)sender {
    if (self.manBtn.tag == TagOn) {
        self.manBtn.tag = TagOff;
        [self.manBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
    }else if (self.manBtn.tag == TagOff) {
        self.manBtn.tag = TagOn;
        [self.manBtn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
        if (self.womanBtn.tag == TagOn) {
            self.womanBtn.tag = TagOff;
            [self.womanBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        }
    }
}
-(IBAction)womanBtnPressed:(id)sender {
    if (self.womanBtn.tag == TagOn) {
        self.womanBtn.tag = TagOff;
        [self.womanBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
    }else if (self.womanBtn.tag == TagOff) {
        self.womanBtn.tag = TagOn;
        [self.womanBtn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
        if (self.manBtn.tag == TagOn) {
            self.manBtn.tag = TagOff;
            [self.manBtn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        }
    }
}

//关闭弹出框
- (void)closePopView:(DetailViewController *)detailViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    detailView = nil;
}


@end
