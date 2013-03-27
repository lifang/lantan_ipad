//
//  AddViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize stepView_0,stepView_1,stepView_2,stepView_3,stepView_4,step,btnDone,btnNext,btnPre;
@synthesize picView_0,picView_1,picView_2,picView_3,stepImg;
@synthesize brandView,modelView,productsView;
@synthesize txtBirth,txtCarNum,txtCarYear,txtEmail,txtName,txtPhone;
@synthesize getPic,brandList,brandResult,productList,selectedIndexs,customer;

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
    if ([step intValue]==0) {
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
        if ([DataService sharedService].number == 1) {
            stepView_0.hidden = YES;
            stepView_1.hidden = YES;
            stepView_2.hidden = YES;
            stepView_3.hidden = NO;
            stepView_4.hidden = YES;
            self.btnNext.hidden = YES;
            self.btnDone.hidden = NO;
        }else {
            stepView_0.hidden = YES;
            stepView_1.hidden = YES;
            stepView_2.hidden = YES;
            stepView_3.hidden = NO;
            stepView_4.hidden = YES;
        }
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
    [stepView_0 addSubview:picView_0];
    [stepView_0 addSubview:picView_1];
    [stepView_0 addSubview:picView_2];
    [stepView_0 addSubview:picView_3];
}

- (void)initBrandView{
    CGRect frame = self.brandView.frame;
    frame.size.height = 162.0;
    self.brandView.frame = frame;
    frame = self.modelView.frame;
    frame.size.height = 162.0;
    self.modelView.frame = frame;
}

- (void)initData{
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kBrandProduct]];
    [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id", nil]];
    [r setPostDataEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
    self.brandResult = [NSMutableDictionary dictionaryWithDictionary:result];
    DLog(@"%@",result);
    if ([[result objectForKey:@"status"] intValue]==1) {
        self.brandList = [NSMutableArray arrayWithArray:[result objectForKey:@"brands"]];
        self.productList = [NSMutableArray arrayWithArray:[result objectForKey:@"products"]];
    }
}

- (void)initProdView{
   [self.productsView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [self.productsView registerClass:[CollectionHeader class] forSupplementaryViewOfKind:@"CollectionHeader" withReuseIdentifier:@"CollectionHeader"];
    CollectionViewLayout *layout = [[CollectionViewLayout alloc] init];
    [self.productsView setCollectionViewLayout:layout];
    self.selectedIndexs = [NSMutableArray array];
}

- (void)viewDidLoad
{
    DLog(@"number = %d",[DataService sharedService].number);
    [self initData];
    [super viewDidLoad];
    [self initView];
    [self initPicView];
    [self initBrandView];
    [self initProdView];

    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    if (self.customer) {
        self.txtCarNum.text = [customer objectForKey:@"carNum"];
        self.txtName.text = [customer objectForKey:@"name"];
        self.txtPhone.text = [customer objectForKey:@"phone"];
        self.txtEmail.text = [customer objectForKey:@"email"];
        self.txtBirth.text = [customer objectForKey:@"birth"];
        if([customer objectForKey:@"year"]!= NULL){
            self.txtCarYear.text = [NSString stringWithFormat:@"%@",[customer objectForKey:@"year"]];
        }
    }
    if (self.step) {
        [self.stepImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"step_%@",step]]];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickFinished:(id)sender{
    if ([DataService sharedService].number == 1) {
        STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kcheckIn]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:txtCarNum.text forKey:@"carNum"];
        [dic setObject:txtName.text forKey:@"userName"];
        [dic setObject:txtPhone.text forKey:@"phone"];
        if (txtEmail.text.length > 0) {
            [dic setObject:txtEmail.text forKey:@"email"];
        }
        if (txtBirth.text.length>0) {
            [dic setObject:txtBirth.text forKey:@"birth"];
        }
        
        [dic setObject:txtCarYear.text forKey:@"year"];
        [dic setObject:[DataService sharedService].store_id forKey:@"store_id"];
        NSDictionary *brand  = [brandList objectAtIndex:[brandView selectedRowInComponent:0]];
        NSString *brandStr = [brand objectForKey:@"id"];
        NSString *modelStr = @"";
        if ([[brand objectForKey:@"models"] count]>0) {
            modelStr = [[[brand objectForKey:@"models"] objectAtIndex:[modelView selectedRowInComponent:0]] objectForKey:@"id"];
        }
        [dic setObject:[NSString stringWithFormat:@"%@_%@",brandStr,modelStr] forKey:@"brand"];
        [r setPostDataEncoding:NSUTF8StringEncoding];
        [r setPOSTDictionary:dic];
        
        NSError *error = nil;
        NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
        DLog(@"re = %@",result);
        if ([[result objectForKey:@"status"] intValue]==1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:[result objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    }else {
        if (selectedIndexs && selectedIndexs.count > 0) {
            STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kFinish]];
            NSDictionary *brand  = [brandList objectAtIndex:[brandView selectedRowInComponent:0]];
            NSString *brandStr = [brand objectForKey:@"id"];
            NSString *modelStr = @"";
            if ([[brand objectForKey:@"models"] count]>0) {
                modelStr = [[[brand objectForKey:@"models"] objectAtIndex:[modelView selectedRowInComponent:0]] objectForKey:@"id"];
            }
            NSMutableString *prod_ids = [NSMutableString string];
            for (NSIndexPath *idx in selectedIndexs) {
                NSDictionary *prod = [[self.productList objectAtIndex:idx.row] objectAtIndex:idx.section];
                [prod_ids appendFormat:@"%@_%d,",[prod objectForKey:@"id"],idx.row];
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:txtCarNum.text forKey:@"carNum"];
            [dic setObject:txtName.text forKey:@"userName"];
            [dic setObject:txtPhone.text forKey:@"phone"];
            if (txtEmail.text.length > 0) {
                [dic setObject:txtEmail.text forKey:@"email"];
            }
            if (txtBirth.text.length>0) {
                [dic setObject:txtBirth.text forKey:@"birth"];
            }
            
            [dic setObject:txtCarYear.text forKey:@"year"];
            [dic setObject:[NSString stringWithFormat:@"%@_%@",brandStr,modelStr] forKey:@"brand"];
            [dic setObject:prod_ids forKey:@"prod_ids"];
            [dic setObject:[DataService sharedService].store_id forKey:@"store_id"];
            if ([customer objectForKey:@"reserv_at"]) {
                [dic setObject:[customer objectForKey:@"reserv_at"] forKey:@"res_time"];
            }
            
            [r setPostDataEncoding:NSUTF8StringEncoding];
            [r setPOSTDictionary:dic];
            //        DLog(@"%@",dic);
            NSError *error = nil;
            NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
            DLog(@"%@",result);
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
                confirmView.total_count = [[result objectForKey:@"total"] floatValue];
                [self.navigationController pushViewController:confirmView animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:[result objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"请选择所需的产品、服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
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
        if (x==1 && txtCarNum.text.length==0) {
            str = @"请输入你的车牌号";
        }
        //判断购车时间
        else if(x==2){
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
        else if(x==3){
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
                    str = @"请输入出生年月日";
                }else {

                    NSString *regexCall =@"((19[0-9]{2})|(2[0-9]{3})）-((1[0-2])|(0[1-9]))-((0[1-9])|([1-2][0-9])|3[0-1])";
                    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
                    if ([predicateCall evaluateWithObject:txtBirth.text]) {
                        //获取年份
                        NSDate *now = [NSDate date];
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSUInteger unitFlags = NSYearCalendarUnit;
                        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                        int year = [dateComponent year];
                        
                        NSString *yearStr = [txtBirth.text substringToIndex:4];
                        int brith_year = [yearStr intValue];
                        if (brith_year >= year) {
                            str = @"请输入准确的出生年月日";
                        }
                    }else {
                        str = @"请输入准确的出生年月日";
                    }
                }
                
            }
        }
        if (str.length==0) {
           x += 1; 
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if ([pickerView isEqual:modelView]) {
        NSDictionary *brand  = [brandList objectAtIndex:[brandView selectedRowInComponent:0]];
        return [[brand objectForKey:@"models"] count];
    }
    return self.brandList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if ([pickerView isEqual:modelView]) {
        NSDictionary *brand  = [brandList objectAtIndex:[brandView selectedRowInComponent:0]];
        if ([[brand objectForKey:@"models"] count]>0) {
            return [[[brand objectForKey:@"models"] objectAtIndex:row] objectForKey:@"name"];
        }else{
            return @"";
        }
        
    }else{
        NSDictionary *brand  = [brandList objectAtIndex:row];
        return [brand objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([pickerView isEqual:brandView]) {
        [modelView reloadAllComponents];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [[self.brandResult objectForKey:@"count"] integerValue];
}

//产品，服务的单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CollectionCell";
//    NSString *CellIdentifier = [NSString stringWithFormat:@"CollectionCell%d", [indexPath row]];
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.prodName.hidden = YES;
    cell.prodImage.hidden = YES;
    cell.contentView.backgroundColor = [UIColor clearColor];
    for (int x=0; x<4; x++) {
        if (indexPath.row == x) {
            int len = [[self.productList objectAtIndex:x] count];
            if (indexPath.section < len) {
                NSDictionary *prod = [[self.productList objectAtIndex:x] objectAtIndex:indexPath.section];
                cell.prodName.text = [prod objectForKey:@"name"];
                cell.prodName.hidden = NO;
                cell.prodImage.hidden = NO;
                if ([self isSelected:indexPath]) {
                    cell.contentView.backgroundColor = [UIColor redColor];
                }else{
                    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"collectioncell_bg"]];
                }
                if (![[prod objectForKey:@"img"] isEqual:[NSNull null]]) {
                    cell.prodImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDomain,[prod objectForKey:@"img"]]]]];
                }
                
            }else{
                cell.prodName.hidden = YES;
                cell.prodImage.hidden = YES;
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    //****************判断cell是否已被选中
    if ([self.selectedIndexs containsObject:indexPath]) {
        cell.backgroundColor = [UIColor redColor];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }

    
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeZero;
    }
    return CGSizeZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}

//设置选中效果
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    DLog(@"select:%d",indexPath.section);
    CollectionCell *cell = (CollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.prodName.hidden == NO) {
        if (cell.backgroundColor == [UIColor redColor]) {
            cell.backgroundColor = [UIColor whiteColor];
            if ([self isSelected:indexPath]) {
                [selectedIndexs removeObject:indexPath];
            }
        }else{
           cell.backgroundColor = [UIColor redColor];
            if (![self isSelected:indexPath]) {
                [selectedIndexs addObject:indexPath];
            }
        }
    }
    //***************刷新页面
    [self.productsView reloadData];
    
}

- (BOOL)isSelected:(NSIndexPath *)indexPath{
    //*****************判断是否选中行已添加进数组
    if ([self.selectedIndexs containsObject:indexPath]) {
        return YES;
    }
    return NO;
}

@end
