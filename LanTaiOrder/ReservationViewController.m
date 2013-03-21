//
//  ReservationViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ReservationViewController.h"
#import "ReservationCell.h"

@interface ReservationViewController ()

@end

@implementation ReservationViewController

@synthesize reservList,reservTable;

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
//    self.navigationController.navigationBar.hidden = NO;
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [self addRightnaviItemWithImage:@"back"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"updateReservation" object:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reservList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *dic = [reservList objectAtIndex:indexPath.row];
    ReservationCell *cell = (ReservationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =  [[ReservationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.viewController = self.navigationController;
    }
    cell.lblCreatedAt.text = [Utils formateDate:[dic objectForKey:@"created_at"]];
    cell.lblCarNum.text = [dic objectForKey:@"num"];
    cell.lblUsername.text = [dic objectForKey:@"name"];
    cell.lblPhone.text = [dic objectForKey:@"phone"];
    cell.lblEmail.text = [dic objectForKey:@"email"];
    cell.txtReservAt.text = [Utils formateDate:[dic objectForKey:@"reserv_at"]];
    cell.reserv_id = [dic objectForKey:@"id"];
    if ([[dic objectForKey:@"status"] intValue]==0) {
        cell.lblStatus.text = @"未确认";
        cell.btnConfirm.enabled = YES;
        cell.btnCancel.enabled = YES;
        cell.txtReservAt.enabled = YES;
    }else{
        cell.lblStatus.text = @"已确认";
        cell.btnConfirm.enabled = NO;
        cell.btnCancel.enabled = NO;
        cell.txtReservAt.enabled = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshData:(NSNotification *)notification{
    self.reservList = [DataService sharedService].reserve_list;
    [reservTable reloadData];
}
@end
