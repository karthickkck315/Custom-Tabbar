//
//  AdminDashboardPage.m
//  JLL Car Booking
//
//  Created by karthick on 10/27/17.
//  Copyright © 2017 Technoduce. All rights reserved.
//
#define SCROLLHEIGHT 58

#define VIEWHEIGHT 50

#define VIEWWIDTH 60

#define IMAGEHEIGHT 350

#define UNDERLINELABELHEIGHT 2.0

#define TEXTLABELHEIGHT 20

#define BUTTONCLICKHEIGHT 75

#define CELLHEIGTH 115

#define XPOSTION 5

#define LISTIMAGEHEIGHT 30

#define LABLEHEIGHT 25

#import "AdminDashboardPage.h"
#import <RESideMenu.h>
#import "UIColor+custom.h"
#import "UIFont+CustomFont.h"
#import "GlobalClass.h"
#import "Constant.h"
#import "APICall.h"
#import "DashBoardModel.h"
#import "UserResults.h"
#import "DashBoardResult.h"
#import "LoginModel.h"
#import "DetailPageVC.h"

@interface AdminDashboardPage ()<UITableViewDelegate,UITableViewDataSource>
{
    int screensize;
    int selectedBtn;
    UIScrollView *scroll;
    UITableView *menuTableView;
    
    LoginModel *loginModel;
    UserResults *result;
    DashBoardModel *dashBoardModel;
    NSDictionary *dataDict;
    
    NSArray *dataArray;
    
    NSMutableDictionary *dict;
    
    NSMutableArray *menuListArray;
    NSMutableArray *menuImageArray;
    NSMutableArray *countArray;
    NSMutableArray *filterArray;
    UILabel *noData;
}

@end

@implementation AdminDashboardPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedBtn = 0;
    self.navigationController.navigationBarHidden = NO;
    
    dashBoardModel =  [DashBoardModel sharedInstance];
    
    countArray = [[NSMutableArray alloc]init];

     filterArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"4",@"3",@"6",@"9",@"8", nil];
    
//    filterArray = [[NSMutableArray alloc]initWithObjects:@"Requested",@"Approved",@"Rejected",@"Canceled",@"Completed",@"Car Allotted",@"By Pass Car Allotted", nil];
    
   // menuImageArray = [[NSMutableArray alloc]initWithObjects:@"icon_status_total",@"icon_status_pending",@"icon_status_approved",@"icon_status_rejected",@"icon_status_canceled",@"icon_status_completed",@"icon_status_alloted",@"icon_status_bypass", nil];
    
    menuListArray = [[NSMutableArray alloc]initWithObjects:@"Total",@"Pending",@"Approved",@"Rejected",@"Canceled",@"Completed",@"Allotted",@"By Pass", nil];
    
    loginModel = [LoginModel sharedInstance];
    result = loginModel.OutResult;
    
    screensize = self.view.frame.size.width;
    scroll = [[UIScrollView alloc]init];
    scroll.frame = CGRectMake(0, 64, screensize, SCROLLHEIGHT);
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:scroll];
    NSLog(@"result.EmployeeID = %@",loginModel.OutResult);
    
    [self getHistoryList];
    
}
-(void)adminRole{
    
}
-(void)approverRole{
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObject:@"List" forKey:@"Page"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTitle" object:nil userInfo:dict1];
}
-(void)setUpView{
    
    self.view.backgroundColor = [UIColor customGrayColor2];
    
    int x = 5;
    
    for (int i=0; i< menuListArray.count; i++) {
        
        UIView *bgview = [[UIView alloc]init];
        bgview.frame = CGRectMake(x, 5, VIEWWIDTH, VIEWHEIGHT);
        bgview.backgroundColor = [UIColor blackColor];
        
        UILabel *textlbl = [[UILabel alloc]init];
        textlbl.frame = CGRectMake(0,VIEWHEIGHT/2-TEXTLABELHEIGHT/2-5, VIEWWIDTH, TEXTLABELHEIGHT);
        textlbl.font = [UIFont regularFont10];
        textlbl.text = [menuListArray objectAtIndex:i];
        textlbl.textColor = [UIColor whiteColor];
        textlbl.textAlignment = NSTextAlignmentCenter;
        
        UILabel *numberlbl = [[UILabel alloc]init];
        numberlbl.frame = CGRectMake(0,textlbl.frame.origin.y+textlbl.frame.size.height ,VIEWWIDTH , TEXTLABELHEIGHT);
        numberlbl.text = countArray.count ? [NSString stringWithFormat:@"%@",[countArray objectAtIndex:i]] : @"0";
        numberlbl.font = [UIFont regularFont10];
        numberlbl.textColor = [UIColor whiteColor];
        numberlbl.textAlignment = NSTextAlignmentCenter;
        
        UIButton *carname = [[UIButton alloc]init];
        carname.frame = CGRectMake(bgview.frame.origin.x, bgview.frame.origin.y, VIEWWIDTH, VIEWHEIGHT);
        carname.tag = i+1;
        [carname addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [carname setBackgroundColor:[UIColor clearColor]];
        
        UILabel *underlinelbl = [[UILabel alloc]init];
        underlinelbl.frame = CGRectMake(0, VIEWHEIGHT, VIEWWIDTH, UNDERLINELABELHEIGHT);
        
        if (i == 0) {
            underlinelbl.backgroundColor = [UIColor whiteColor];
        }
        
        [scroll addSubview:bgview];
        [bgview addSubview:underlinelbl];
        [bgview addSubview:textlbl];
        [bgview addSubview:numberlbl];
        [scroll addSubview:carname];
        
        x += bgview.frame.size.width+5;
    }
    scroll.contentSize = CGSizeMake( x+20, scroll.frame.size.height);
    scroll.backgroundColor = [UIColor blackColor];
    
    menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, scroll.frame.origin.y+scroll.frame.size.height, self.view.frame.size.width-10, self.view.frame.size.height-(scroll.frame.origin.y+scroll.frame.size.height)) style:UITableViewStylePlain];
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    menuTableView.backgroundColor = [UIColor customLightGrayColor];
    [self.view addSubview:menuTableView];
    
    noData = [[UILabel alloc]initWithFrame:CGRectMake(0, menuTableView.frame.size.height/2-15, menuTableView.frame.size.width, 30)];
    noData.text = @"No data found";
    noData.font = [UIFont regularFont14];
    noData.textColor = [UIColor blackColor];
    noData.hidden = YES;
    noData.textAlignment = NSTextAlignmentCenter;
    [menuTableView addSubview:noData];
    
    
}
-(void)getHistoryList{
    
    if ([GlobalClass networkConnectAvailable]){
        
        [GlobalClass showGlobalProgressHUDWithTitle:@"" controller:self.view];
        
        NSLog(@"result.EmployeeID = %@",loginModel.OutResult);
        NSLog(@"result.EmployeeID = %@",result.OfficeID);
        
        [[APICall sharedInstance]url:[NSString stringWithFormat:@"%@?officeID=%@",GetAdminCarRequestDetails,result.OfficeID] user:@"" PostBody:nil method:@"GET" completion:^(NSDictionary *jsonDict){
            [GlobalClass dismissGlobalHUD:self.view];
            
            NSLog(@"Dict = %@",jsonDict);
            
            if ([[[jsonDict valueForKeyPath:@"GetAdminCarRequestDetailsResult.status"]description] isEqualToString:@"1"]){
                
                [DashBoardModel reinitSharedInstanceWithDictionary: [jsonDict objectForKey:@"GetAdminCarRequestDetailsResult"]];
                
                dataArray = [jsonDict valueForKeyPath:@"GetAdminCarRequestDetailsResult.OutResult"]; //dashBoardModel.OutResult;
                if (dataArray.count) {
                    dict = [[NSMutableDictionary alloc]init];
                    for (int count = 0; count < filterArray.count; count++) {
                        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"RequestStatusID = %@",[filterArray objectAtIndex:count]];
                        NSArray *array = [dataArray filteredArrayUsingPredicate:bPredicate];
                        [dict setObject:array forKey:[filterArray objectAtIndex:count]];
                        [countArray addObject:[NSString stringWithFormat:@"%ld",array.count]];
                    }
                    [countArray insertObject:[NSString stringWithFormat:@"%ld",dataArray.count] atIndex:0];
                }
                
                [self setUpView];
                [menuTableView reloadData];
                
            }else{
                
                [GlobalClass showAlertwithtitle:@"" message:@"No Response found" view:self];
            }
            
        } error:^(NSString *errorStr) {
            [GlobalClass dismissGlobalHUD:self.view];
            [GlobalClass showAlertwithtitle:@"" message:errorStr view:self];
        }];
        
    }else{
        
        [GlobalClass showAlertwithtitle:@"" message:@"Please check your internet connection" view:self];
    }
}

-(void)buttonclick:(id)sender{
    
    UIButton *selectedButton = (UIButton *)sender;
    selectedBtn = (int)selectedButton.tag-1;
    [menuTableView reloadData];
    
    for (UIView *subView in scroll.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)subView;
            
            UIView *lineView;
            UIView *lineView2;
            if (btn.tag == selectedButton.tag) {
                
                lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, UNDERLINELABELHEIGHT)];
                [btn addSubview:lineView];
                lineView.backgroundColor = [UIColor whiteColor];
                [lineView2 removeFromSuperview];
            }else{
                
                [lineView removeFromSuperview];
                lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, UNDERLINELABELHEIGHT)];
                [btn addSubview:lineView2];
                lineView2.backgroundColor = [UIColor blackColor];
            }
        }
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    
    if (selectedBtn == 0) {
        if (dataArray.count) {
            noData.hidden = YES;
            return [dataArray count];
        }else
            noData.hidden = NO;
        return 0;
    }else{
        if ([[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]]count]) {
            noData.hidden = YES;
            return [[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]]count];
            
        }else{
            noData.hidden = NO;
            return 0;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UIImageView *menuImage = [[UIImageView alloc]initWithFrame:CGRectMake(XPOSTION, CELLHEIGTH/2-LISTIMAGEHEIGHT/2, LISTIMAGEHEIGHT, LISTIMAGEHEIGHT)];
        menuImage.tag = 120;
        menuImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:menuImage];
        
        UILabel *bookingLbl = [[UILabel alloc]initWithFrame:CGRectMake(menuImage.frame.origin.x+menuImage.frame.size.width+8, 5, self.view.frame.size.width-(menuImage.frame.origin.x+menuImage.frame.size.width+15), LABLEHEIGHT)];
        bookingLbl.tag = 130;
        bookingLbl.font = [UIFont regularFont12];
        bookingLbl.textColor = [UIColor appRedColor];
        [cell addSubview:bookingLbl];
        
        UILabel *dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(menuImage.frame.origin.x+menuImage.frame.size.width+10, bookingLbl.frame.origin.y+bookingLbl.frame.size.height, self.view.frame.size.width-(menuImage.frame.origin.x+menuImage.frame.size.width+20), LABLEHEIGHT)];
        dateLbl.tag = 131;
        dateLbl.font = [UIFont regularFont12];
        dateLbl.textColor = [UIColor appGreenColor];
        [cell addSubview:dateLbl];
        
        int imageSize = 8;
        UIImageView *redImage = [[UIImageView alloc]initWithFrame:CGRectMake(menuImage.frame.origin.x+menuImage.frame.size.width+10, dateLbl.frame.origin.y+dateLbl.frame.size.height+9, imageSize, imageSize)];
        redImage.tag = 121;
        redImage.contentMode = UIViewContentModeScaleAspectFit;
        redImage.backgroundColor = [UIColor appRedColor];
        redImage.layer.cornerRadius = redImage.frame.size.width/2;
        redImage.clipsToBounds = YES;
        [cell addSubview:redImage];
        
        UILabel *addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(redImage.frame.origin.x+redImage.frame.size.width+10, dateLbl.frame.origin.y+dateLbl.frame.size.height, self.view.frame.size.width-(redImage.frame.origin.x+redImage.frame.size.width+20), LABLEHEIGHT)];
        addressLbl.tag = 132;
        addressLbl.font = [UIFont regularFont12];
        addressLbl.textColor = [UIColor darkGrayColor];
        [cell addSubview:addressLbl];
        
        UIImageView *greenImage = [[UIImageView alloc]initWithFrame:CGRectMake(menuImage.frame.origin.x+menuImage.frame.size.width+10, addressLbl.frame.origin.y+addressLbl.frame.size.height+9, imageSize, imageSize)];
        greenImage.tag = 122;
        greenImage.contentMode = UIViewContentModeScaleAspectFit;
        greenImage.backgroundColor = [UIColor appGreenColor];
        greenImage.layer.cornerRadius = greenImage.frame.size.width/2;
        greenImage.clipsToBounds = YES;
        [cell addSubview:greenImage];
        
        UILabel *addressLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(greenImage.frame.origin.x+greenImage.frame.size.width+10, addressLbl.frame.origin.y+addressLbl.frame.size.height, self.view.frame.size.width-(greenImage.frame.origin.x+greenImage.frame.size.width+20), LABLEHEIGHT)];
        addressLbl2.tag = 133;
        addressLbl2.font = [UIFont regularFont12];
        addressLbl2.textColor = [UIColor darkGrayColor];
        [cell addSubview:addressLbl2];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *menuImage = [(UIImageView *) cell viewWithTag:120];
    //    UIImageView *redImage = [(UIImageView *) cell viewWithTag:121];
    //    UIImageView *greenImage = [(UIImageView *) cell viewWithTag:122];
    
    UILabel *bookingLbl = [(UILabel *) cell viewWithTag:130];
    UILabel *dateLbl = [(UILabel *) cell viewWithTag:131];
    UILabel *addressLbl = [(UILabel *) cell viewWithTag:132];
    UILabel *addressLbl2 = [(UILabel *) cell viewWithTag:133];
    
    //    DashBoardResult *result = dashBoardModel.OutResult;
    
    if (selectedBtn == 0) {
        if ([[[[dataArray valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"1"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_pending"];
        }else if ([[[[dataArray valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"2"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_approved"];
        }else if ([[[[dataArray valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"4"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_rejected"];
        }else if ([[[[dataArray valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"3"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_canceled"];
        }else if ([[[[dataArray valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"9"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_alloted"];
        }else if ([[[[dataArray valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"8"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_bypass"];
        }else if ([[[[dataArray valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"6"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_completed"];
        }else{
            menuImage.image = [UIImage imageNamed:@"icon_status_total"];
        }
        
        bookingLbl.text = [NSString stringWithFormat:@"Booking ID : %@",[[[dataArray valueForKey:@"CarRequestID"]objectAtIndex:indexPath.row]description]];
        dateLbl.text = [self datefromatter:[[[dataArray valueForKey:@"PickupTime"]objectAtIndex:indexPath.row]description]];
        addressLbl.text = [[dataArray valueForKey:@"PickupLocation"]objectAtIndex:indexPath.row];
        addressLbl2.text = [[dataArray valueForKey:@"VisitingLocation"]objectAtIndex:indexPath.row];
        
    }else{
        if ([[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"1"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_pending"];
        }else if ([[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"2"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_approved"];
        }else if ([[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"4"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_rejected"];
        }else if ([[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"3"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_canceled"];
        }else if ([[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"9"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_alloted"];
        }else if ([[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"8"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_bypass"];
        }else if ([[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"RequestStatusID"]objectAtIndex:indexPath.row]description] isEqualToString:@"6"]) {
            menuImage.image = [UIImage imageNamed:@"icon_status_completed"];
        }else{
            menuImage.image = [UIImage imageNamed:@"icon_status_total"];
        }
        
        bookingLbl.text = [NSString stringWithFormat:@"Booking ID : %@",[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"CarRequestID"] objectAtIndex:indexPath.row]];
        dateLbl.text = [self datefromatter:[[[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"PickupTime"]objectAtIndex:indexPath.row]description]];
        addressLbl.text = [[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"PickupLocation"]objectAtIndex:indexPath.row];
        addressLbl2.text = [[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"VisitingLocation"]objectAtIndex:indexPath.row];
        
    }
    //    redImage.image = [UIImage imageNamed:@"User"];
    //    greenImage.image = [UIImage imageNamed:@"User"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
-(NSString *)datefromatter:(NSString *)dateStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"M/d/yyyy h:mm:ss a"];
    NSDate *tempDate = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"MMM dd yyyy, HH:mm a"];
    NSString *newFormatedDateStr = [dateFormatter stringFromDate:tempDate];
    return newFormatedDateStr;
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailPageVC *detailPage = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailPageVC"];
    detailPage.isFromMyTrips = NO;
    if (selectedBtn == 0) {
        detailPage.getDetails = [dataArray objectAtIndex:indexPath.row];
    }else{
        //        detailPage.carId = [[[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]] valueForKey:@"CarRequestID"]objectAtIndex:indexPath.row];
        detailPage.getDetails = [[dict objectForKey:[filterArray objectAtIndex:selectedBtn-1]]objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:detailPage animated:YES];
    
    NSLog(@"selected %ld row", (long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELLHEIGTH;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [menuTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [menuTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
