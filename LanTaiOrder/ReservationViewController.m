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
@property (nonatomic, strong) ReservationCell *cellReser;
@end

@implementation ReservationViewController

@synthesize reservList,reservTable;
@synthesize cellReser;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loading) name:@"loading" object:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
    
    //更改frame
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"update" object:nil];
}

//更改frame
- (void)update:(NSNotification *)notification {
    NSDictionary *dic = [notification object];
    self.cellReser = [dic objectForKey:@"cell"];
    int value = [[dic objectForKey:@"frame"]intValue];
    if (value == 0) {
        self.reservTable.frame = CGRectMake(62, 134, 900, 200);
        [self.reservTable setContentOffset:CGPointMake(0, self.cellReser.frame.origin.y)];
    }else if(value == 1){
        self.reservTable.frame = CGRectMake(62, 134, 900, 526);
    }
}
-(void)loading {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.dimBackground = NO;
    hud.labelText = @"正在努力加载...";
    [self.view addSubview:hud];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.cellReser.txtReservAt resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reservList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    NSDictionary *dic = [reservList objectAtIndex:indexPath.row];
    ReservationCell *cell = (ReservationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =  [[ReservationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.viewController = self.navigationController;
    }
    cell.lblCreatedAt.text = [Utils formateDate:[dic objectForKey:@"created_at"]];
    cell.lblCarNum.text = [dic objectForKey:@"num"];
    if (![[dic objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
        cell.lblUsername.text = [dic objectForKey:@"name"];
    }
    if (![[dic objectForKey:@"phone"] isKindOfClass:[NSNull class]]) {
        cell.lblPhone.text = [dic objectForKey:@"phone"];
    }
    
    if (![[dic objectForKey:@"email"] isKindOfClass:[NSNull class]]) {
        cell.lblEmail.text = [dic objectForKey:@"email"];
    }
    cell.btnConfirm.tag = indexPath.row;
    cell.btnCancel.tag = indexPath.row;
    
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
    [self.reservTable reloadData];
}
@end
