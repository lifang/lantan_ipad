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
@synthesize picView_0,picView_1,picView_2,picView_3;
@synthesize brandView,modelView,productsView;
@synthesize txtBirth,txtCarNum,txtCarYear,txtEmail,txtName,txtPhone;
@synthesize getPic,brandList,brandResult,productList,selectedIndexs;

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
    picView_0 = [[PictureCell alloc] initWithFrame:CGRectMake(300, 60, 152, 182) title:@"车前" delegate:self];
    picView_1 = [[PictureCell alloc] initWithFrame:CGRectMake(520, 60, 152, 182) title:@"车后" delegate:self];
    picView_2 = [[PictureCell alloc] initWithFrame:CGRectMake(300, 260, 152, 182) title:@"车左" delegate:self];
    picView_3 = [[PictureCell alloc] initWithFrame:CGRectMake(520, 260, 152, 182) title:@"车右" delegate:self];
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
    [self initData];
    [super viewDidLoad];
    [self initView];
    [self initPicView];
    [self initBrandView];
    [self initProdView];
    self.txtCarNum.text = [DataService sharedService].car_num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickFinished:(id)sender{
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
//        DLog(@"ssss:%@",prod_ids);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:txtCarNum.text forKey:@"carNum"];
        [dic setObject:txtName.text forKey:@"userName"];
        [dic setObject:txtPhone.text forKey:@"phone"];
        [dic setObject:txtEmail.text forKey:@"email"];
        [dic setObject:txtBirth.text forKey:@"birth"];
        [dic setObject:txtCarYear.text forKey:@"year"];
        [dic setObject:[NSString stringWithFormat:@"%@_%@",brandStr,modelStr] forKey:@"brand"];
        [dic setObject:prod_ids forKey:@"prod_ids"];
        [dic setObject:[DataService sharedService].store_id forKey:@"store_id"];
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
            
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"请选择所需的产品、服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (IBAction)clickNext:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int x = [step intValue];
    
    if (btn.tag == 102) {
        x -= 1;
    }else{
        NSString *str = @"";
        if (x==1 && txtCarNum.text.length==0) {
            str = @"请输入你的车牌号";
        }else if(x==2 && txtCarYear.text.length == 0){
            str = @"请输入购车时间";
        }else if(x==3){
            if(txtName.text.length==0){
                str = @"请输入您的名称";
            }else if(txtPhone.text.length == 0){
                str = @"请输入联系电话";
            }
        }
        if (str.length==0) {
           x += 1; 
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    step = [NSString stringWithFormat:@"%d",x];
    [self initView];
}

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CollectionCell";
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.prodName.hidden = YES;
    cell.prodImage.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    for (int x=0; x<4; x++) {
        if (indexPath.row == x) {
            int len = [[self.productList objectAtIndex:x] count];
            if (indexPath.section < len) {
                NSDictionary *prod = [[self.productList objectAtIndex:x] objectAtIndex:indexPath.section];
                cell.prodName.text = [prod objectForKey:@"name"];
                cell.prodName.hidden = NO;
                cell.prodImage.hidden = NO;
                if ([self isSelected:indexPath]) {
                    cell.backgroundColor = [UIColor redColor];
                }else{
                    cell.backgroundColor = [UIColor whiteColor];
                }
                if (![[prod objectForKey:@"img"] isEqual:[NSNull null]]) {
                    cell.prodImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[prod objectForKey:@"img"]]]];
                }
                
            }
        }
    }
    cell.prodImage.image = [UIImage imageNamed:@"status_img"];
    
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
    
}

- (BOOL)isSelected:(NSIndexPath *)indexPath{
    for (NSIndexPath *idx in selectedIndexs) {
        if ([idx isEqual:indexPath]) {
            return TRUE;
            break;
        }
    }
    return FALSE;
}

@end
