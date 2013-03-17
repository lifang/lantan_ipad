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
@synthesize segBtn,pleaseView;


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
    if (orderInfo) {
        DLog(@"%@",orderInfo);
        lblCarNum.text = [orderInfo objectForKey:@"car_num"];
        lblUsername.text = [orderInfo objectForKey:@"username"];
        lblStart.text = [orderInfo objectForKey:@"start"];
        lblEnd.text = [orderInfo objectForKey:@"end"];
        lblTotal.text = [NSString stringWithFormat:@"总计：%.2f(元)",[[orderInfo objectForKey:@"price"] floatValue]];
        
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
            [productList addObject:[orderInfo objectForKey:@"c_pcard_relation"]];
        }
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = tableView.bounds;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = 500;
    frame.size.height = 44;
    return [[ProductHeader alloc] initWithFrame:frame];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *product = [productList objectAtIndex:indexPath.row];
    int count = [[product objectForKey:@"products"] count];
    count = count == 0 ? 1 : count;
    return count * 44;
}

- (IBAction)clickSegBtn:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        ComplaintViewController *complaint = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
        [self.navigationController pushViewController:complaint animated:YES];
    }else{
        payStyleView = nil;
        payStyleView = [[PayStyleViewController alloc] initWithNibName:@"PayStyleViewController" bundle:nil];
        payStyleView.delegate = self;
        [self presentPopupViewController:payStyleView animationType:MJPopupViewAnimationSlideBottomBottom];
    }
}

- (void)closePopView:(PayStyleViewController *)payStyleViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    payStyleView = nil;
}

@end
