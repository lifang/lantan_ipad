//
//  PayViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PayViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ComplaintViewController.h"
#import "PayStyleViewController.h"

@interface PayViewController ()<PayStyleViewDelegate>{
    PayStyleViewController *payStyleView;
}

@end

@implementation PayViewController

@synthesize lblBrand,lblCarNum,lblEnd,lblPhone,lblStart,lblTotal,lblUsername;
@synthesize productTable,productList,orderInfo,total_count;
@synthesize segBtn,pleaseView,orderBgView;

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
    self.segBtn.momentary = YES;
    if (orderInfo) {
        DLog(@"%@",orderInfo);
        lblBrand.text = [orderInfo objectForKey:@"code"];
        lblCarNum.text = [orderInfo objectForKey:@"car_num"];
        lblUsername.text = [orderInfo objectForKey:@"username"];
        lblStart.text = [orderInfo objectForKey:@"start"];
        if (lblStart.text.length <= 0) {
            self.start_lab.hidden = YES;
        }else {
            self.start_lab.hidden = NO;
        }
        lblEnd.text = [orderInfo objectForKey:@"end"];
        if (lblEnd.text.length <= 0) {
            self.end_lab.hidden = YES;
        }else {
            self.end_lab.hidden = NO;
        }
        lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",[[orderInfo objectForKey:@"total"] floatValue]];
        
        self.productList = [NSMutableArray array];
        if ([orderInfo objectForKey:@"products"]) {
            [productList addObjectsFromArray:[orderInfo objectForKey:@"products"]];
        }
        if ([orderInfo objectForKey:@"sale"]) {
            [productList addObject:[orderInfo objectForKey:@"sale"]];
        }
        if ([orderInfo objectForKey:@"c_svc_relation"]) {
            [productList addObject:[orderInfo objectForKey:@"c_svc_relation"]];
        }
        if ([orderInfo objectForKey:@"c_pcard_relation"]) {
            [productList addObjectsFromArray:[orderInfo objectForKey:@"c_pcard_relation"]];
        }
    }
    DLog(@"%@",productList);
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
    self.orderBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"confirm_bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *product = [productList objectAtIndex:indexPath.row];
    DLog(@"%@",product);
    if ([[product objectForKey:@"type"] intValue] == 0) {
        static NSString *CellIdentifier = @"ServiceCell";
        ServiceCell *cell = (ServiceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }
        cell.lblName.text = [product objectForKey:@"name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"price"]];
        cell.lblCount.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"num"]];
        cell.stepBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[product objectForKey:@"type"] intValue] == 1){
        static NSString *CellIdentifier = @"SVCardCell";
        SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }

        cell.lblName.text = [product objectForKey:@"name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"-%@",[product objectForKey:@"price"]];
        cell.switchBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[product objectForKey:@"type"] intValue] == 2){
        static NSString *CellIdentifier = @"SVCardCell";
        SVCardCell *cell = (SVCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SVCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath];
        }
        cell.lblName.text = [NSString stringWithFormat:@"%@(%@)折",[product objectForKey:@"name"],[product objectForKey:@"discount"]];
        cell.lblPrice.text = [NSString stringWithFormat:@"-%@",[product objectForKey:@"price"]];
        cell.switchBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[product objectForKey:@"type"] intValue] == 3){
        static NSString *CellIdentifier = @"PackageCardCell";
        PackageCardCell *cell = (PackageCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PackageCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier with:product indexPath:indexPath type:1];
        }
        cell.lblName.text = [NSString stringWithFormat:@"%@(成本价:%.2f)",[product objectForKey:@"name"],[[product objectForKey:@"price"] floatValue]];
            cell.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[product objectForKey:@"price"] floatValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *product = [productList objectAtIndex:indexPath.row];
    int count = [[product objectForKey:@"products"] count];
    count = count == 0 ? 1 : count;
    return count * 44;
}

- (IBAction)clickSegBtn:(UISegmentedControl *)sender{
    self.segBtn = (UISegmentedControl *)sender;
    //评价，不满意
    if (sender.selectedSegmentIndex == 0) {
        ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.lblUsername.text forKey:@"name"];
        [dic setObject:self.lblCarNum.text forKey:@"carNum"];
        [dic setObject:[orderInfo objectForKey:@"code"] forKey:@"code"];
        [dic setObject:[orderInfo objectForKey:@"id"] forKey:@"order_id"];
        [dic setObject:@"0" forKey:@"from"];
        NSMutableString *prods = [NSMutableString string];
        for (NSDictionary *prod in productList) {
            if ([[prod objectForKey:@"type"] intValue]==0) {
               [prods appendFormat:@"%@,",[prod objectForKey:@"name"]]; 
            }
        }
        DLog(@"%@",prods);
        if (prods.length>0) {
            [dic setObject:[prods substringToIndex:prods.length - 1] forKey:@"prods"];
        }
        
        complaint.info = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:complaint animated:YES];
    }else{
        //评价，弹出框
        payStyleView = nil;
        payStyleView = [[PayStyleViewController alloc] initWithNibName:@"PayStyleViewController" bundle:nil];
        payStyleView.delegate = self;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[orderInfo objectForKey:@"id"] forKey:@"order_id"];
        [dic setObject:[NSNumber numberWithInt:sender.selectedSegmentIndex] forKey:@"is_please"];
        [dic setObject:[orderInfo objectForKey:@"total"] forKey:@"price"];
        [dic setObject:[orderInfo objectForKey:@"content"] forKey:@"content"];
        payStyleView.order = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self presentPopupViewController:payStyleView animationType:MJPopupViewAnimationSlideBottomBottom];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DataService sharedService].payNumber == 1) {
        //评价，弹出框
        payStyleView = nil;
        payStyleView = [[PayStyleViewController alloc] initWithNibName:@"PayStyleViewController" bundle:nil];
        payStyleView.delegate = self;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[orderInfo objectForKey:@"id"] forKey:@"order_id"];
        [dic setObject:[NSNumber numberWithInt:0] forKey:@"is_please"];
        [dic setObject:[orderInfo objectForKey:@"total"] forKey:@"price"];
        [dic setObject:[orderInfo objectForKey:@"content"] forKey:@"content"];
        payStyleView.order = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self presentPopupViewController:payStyleView animationType:MJPopupViewAnimationSlideBottomBottom];
        
        [DataService sharedService].payNumber = 0;
    }
}

- (void)closePopView:(PayStyleViewController *)payStyleViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    if (payStyleViewController.isSuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    payStyleView = nil;
}

@end
