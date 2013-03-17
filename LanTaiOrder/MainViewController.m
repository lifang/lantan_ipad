//
//  MainViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "MainViewController.h"
#import "OrderViewController.h"
#import "ReservationViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize txtCarNum,lblCount,orderTable,statusImg,mainView;
@synthesize waitList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = YES;
    orderTable.delegate = self;
    waitList = [NSMutableArray array];
    [Utils fetchWorkingList];
    waitList = [DataService sharedService].workingOrders;
    if ([DataService sharedService].reserve_count && [[DataService sharedService].reserve_count intValue] > 0) {
        self.lblCount.text = [DataService sharedService].reserve_count;
    }else{
        self.lblCount.text = @"0";
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickRefreshBtn:(id)sender{
    
}

- (IBAction)clickSearchBtn:(id)sender{
    [txtCarNum resignFirstResponder];
    if(self.txtCarNum.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTip message:@"请输入车牌号" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        OrderViewController *orderView = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
        orderView.car_num = self.txtCarNum.text;
        [self.navigationController pushViewController:orderView animated:YES];
    }
}

- (IBAction)clickShowBtn:(id)sender{
    ReservationViewController *reservationView = [[ReservationViewController alloc] initWithNibName:@"ReservationViewController" bundle:nil];
    
    [self.navigationController pushViewController:reservationView animated:YES];
    
}

- (IBAction)clickStatusImg:(id)sender{
    CGRect frame = self.view.bounds;
    [UIView beginAnimations:nil context:nil];
    CGRect btnFrame = self.statusImg.frame;
    CGRect tFrame = self.orderTable.frame;
    if (btnFrame.origin.x + btnFrame.size.width == frame.size.width) {
        btnFrame.origin.x -= tFrame.size.width;
        tFrame.origin.x -= tFrame.size.width;
    }else{
        btnFrame.origin.x += tFrame.size.width;
        tFrame.origin.x += tFrame.size.width;
    }
    self.statusImg.frame = btnFrame;
    self.orderTable.frame = tFrame;
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return waitList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *order = [waitList objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 施工中",[order objectForKey:@"num"]];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
