//
//  OrderViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-1.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "OrderViewController.h"
#import "AddViewController.h"
#import "ProductCell.h"
#import "OldProductCell.h"
#import "ComplaintViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

@synthesize lblBrand,lblCarNum,lblPhone,lblProduct,lblTime,lblUserName;
@synthesize btnCheckIn,btnDone,btnOldRecord,btnOrderRecord;
@synthesize orderView,carInfoBgView,noInfoView,carInfoView,orderTable,workingTable;
@synthesize orderList,orderItems;
@synthesize lblOrderNum,lblReceiver,lblStatus,lblWorkingCar,lblWorkingName,lblTotal;
@synthesize car_num;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchOrderByCarNum{
    if (car_num) {
        STHTTPRequest *r = [STHTTPRequest requestWithURLString:[NSString stringWithFormat:@"%@%@",kHost,kSearchCar]];
        [r setPOSTDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[DataService sharedService].store_id,@"store_id",car_num,@"car_num", nil]];
        [r setPostDataEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *result = [[r startSynchronousWithError:&error] objectFromJSONString];
        DLog(@"%@",result);
        if ([[result objectForKey:@"status"] intValue]==1) {
            if ([[result objectForKey:@"customer"] count]==0) {
                self.carInfoView.hidden = YES;
                self.noInfoView.hidden = NO;
            }else{
                self.carInfoView.hidden = NO;
                self.noInfoView.hidden = YES;
                self.lblCarNum.text = [[result objectForKey:@"customer"] objectForKey:@"num"];
                NSString *brand = [NSString stringWithFormat:@"%@-%@",[[result objectForKey:@"customer"] objectForKey:@"brand_name"],[[result objectForKey:@"customer"] objectForKey:@"model_name"]];
                self.lblBrand.text = brand;
                self.lblUserName.text = [[result objectForKey:@"customer"] objectForKey:@"name"];
                self.lblPhone.text = [[result objectForKey:@"customer"] objectForKey:@"mobilephone"];
                if ([[result objectForKey:@"working"] count]==0) {
                  self.lblProduct.text = @"";
                  self.lblTime.text = @"";
                    self.workingView.hidden = YES;
                    self.noWorkingView.hidden = NO;
                    self.orderTable.hidden = YES;
                }else{
                    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                    [inputFormatter setLocale:[[NSLocale alloc] init]];
                    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
                    NSDate* startDate = [inputFormatter dateFromString:[[result objectForKey:@"working"] objectForKey:@"started_at"]];
                    NSDate *endDate = [inputFormatter dateFromString:[[result objectForKey:@"working"] objectForKey:@"ended_at"]];
                    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                    [outputFormatter setLocale:[NSLocale currentLocale]];
                    [outputFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
                    NSString *str = [outputFormatter stringFromDate:startDate];
                    NSString *time = [NSString stringWithFormat:@"%@--%@",str,[outputFormatter stringFromDate:endDate]];
                    self.lblTime.text = time;
                    NSMutableString *prod = [NSMutableString string];
                    NSArray *products = [[result objectForKey:@"working"] objectForKey:@"products"];
                    for (int x=0; x<products.count; x++) {
                        if (x==products.count-1) {
                          [prod appendFormat:@"%@",[[products objectAtIndex:x] objectForKey:@"name"]];  
                        }else{
                        [prod appendFormat:@"%@,",[[products objectAtIndex:x] objectForKey:@"name"]];
                        }
                    }
                    self.lblProduct.text = prod;
                    self.workingView.hidden = NO;
                    self.noWorkingView.hidden = YES;
                    self.orderTable.hidden = YES;
                    self.lblReceiver.text = [[result objectForKey:@"working"] objectForKey:@"staff"];
                    self.lblOrderNum.text = [[result objectForKey:@"working"] objectForKey:@"code"];
                    self.lblStatus.text = [Utils orderStatus:[[[result objectForKey:@"working"] objectForKey:@"status"] intValue]];
                    self.lblWorkingName.text = [[result objectForKey:@"customer"] objectForKey:@"name"];
                    self.lblWorkingCar.text = [[result objectForKey:@"customer"] objectForKey:@"num"];
                    self.lblTotal.text = [NSString stringWithFormat:@"%@(元)",[[result objectForKey:@"working"] objectForKey:@"price"]];
                    self.orderItems = [[result objectForKey:@"working"] objectForKey:@"products"];
                }
                if ([[result objectForKey:@"old"] count]>0) {
                    self.orderList = [result objectForKey:@"old"];
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    self.orderList = [NSMutableArray array];
    self.orderItems = [NSMutableArray array];
    [self searchOrderByCarNum];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:orderTable]) {
        return orderList.count;
    }else if([tableView isEqual:workingTable]){
        return orderItems.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:workingTable]) {
        static NSString *CellIdentifier = @"ProductCell";
        NSDictionary *product = [orderItems objectAtIndex:indexPath.row];
        ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.lblName.text = [product objectForKey:@"name"];
        cell.lblPrice.text = [NSString stringWithFormat:@"%@",[product objectForKey:@"price"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *CellIdentifier = @"OldProductCell";
        OldProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSDictionary *order = [orderList objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[OldProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier items:[order objectForKey:@"products"]];
        }
        cell.lblCode.text = [order objectForKey:@"code"];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] init]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
        NSDate* createdDate = [inputFormatter dateFromString:[order objectForKey:@"created_at"]];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"yyyy.MM.dd"];
        NSString *str = [outputFormatter stringFromDate:createdDate];
        cell.lblDate.text = str;
        cell.lblTotal.text = [NSString stringWithFormat:@"%.2f",[[order objectForKey:@"price"] floatValue]];
        cell.lblPay.text = [order objectForKey:@"pay_type"];
        [cell.btnComplaint addTarget:self action:@selector(clickComplaint:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:workingTable]) {
        CGRect frame = tableView.bounds;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = 700;
        frame.size.height = 44;
        return [[ProductHeader alloc] initWithFrame:frame];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:workingTable]) {
    return 44;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:workingTable]) {
        return 44;
    }else{
        NSDictionary *order = [orderList objectAtIndex:indexPath.row];
        int count = [[order objectForKey:@"products"] count];
        return (count + 1) * 44;
    }
}

- (void)clickComplaint:(id)sender{
    ComplaintViewController *complaintView = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
    [self.navigationController pushViewController:complaintView animated:YES];
    
}

- (IBAction)clickCancel:(id)sender{
    
}

- (IBAction)clickDone:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    AddViewController *addOrder = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    if (btn.tag==101) {
        addOrder.step = @"0";
    }else if (btn.tag==100){
        [DataService sharedService].car_num = self.lblCarNum.text;
        addOrder.step = @"3";
    }
    [self.navigationController pushViewController:addOrder animated:YES];
    
}

- (IBAction)clickOld:(id)sender{
    self.orderTable.hidden = NO;
    self.workingView.hidden = YES;
}

- (IBAction)clickPay:(id)sender{
    
}

- (IBAction)clickPic:(id)sender{
    
}

- (IBAction)clickReg:(id)sender{
    AddViewController *addOrder = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    addOrder.step = @"0";
    [self.navigationController pushViewController:addOrder animated:YES];
}

- (IBAction)clickWorking:(id)sender{
    self.workingView.hidden = NO;
    self.orderTable.hidden = YES;
}

@end
