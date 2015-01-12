//
//  wishViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "WishViewController.h"
#import "WishModel.h"
#import "WishTableViewCell.h"
#import "AddWishViewController.h"
#import "DetailWishViewController.h"
#import "NewsViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface WishViewController ()

@end

@implementation WishViewController
{
    
    UITableView * recommendTable;
    NSMutableArray * recommendArray;
    UITableView * nearWishTable;
    NSMutableArray * nearWishArray;
    UITableView * nearHelpTable;
    NSMutableArray * nearHelpArray;
    BmobObject * postObj;
    BmobUser * user;
    BOOL isShow;
    UIButton * sideBtn;
    
    NSIndexPath * indexPathWish;
    int indexPathNumber;
    
    MJRefreshHeaderView *_header1;
    MJRefreshFooterView *_footer1;
    int _skip1;
    MBProgressHUD * HUD1;
    
    MJRefreshHeaderView *_header2;
    MJRefreshFooterView *_footer2;
    int _skip2;
    MBProgressHUD * HUD2;
    
    MJRefreshHeaderView *_header3;
    MJRefreshFooterView *_footer3;
    int _skip3;
    MBProgressHUD * HUD3;
   
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        recommendArray  = [[NSMutableArray alloc] init];
        nearWishArray = [[NSMutableArray alloc] init];
        nearHelpArray = [[NSMutableArray alloc] init];
        user = [BmobUser getCurrentObject];
        _skip1 = 1;
        _skip2 = 1;
        _skip3 = 1;
        isShow = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    UIView * back = [[UIView alloc] initWithFrame:self.view.bounds];
    back.tag = 2000;
    [self.view addSubview:back];
    [self createWish];
    [self createNarBar];
    [self createTabBar];
    [self getRecommendSkip:_skip1];
    [self getNearHelpSkip:_skip2];
    [self getNearWishSkip:_skip3];
    UIScrollView * sv = (id)[self.view viewWithTag:3000];
    BmobUser * bUser = [BmobUser getCurrentObject];
    UILabel * timeLabel = (id)[self.view viewWithTag:2101];
    UILabel * distanceLabel = (id)[self.view viewWithTag:2102];
    UILabel * recommendLabel = (id)[self.view viewWithTag:2103];
    UIView * x = (id)[self.view viewWithTag:2200];
    self.change = ^(){
        [sv setContentOffset:CGPointMake(640, 0) animated:YES];
        timeLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        distanceLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        recommendLabel.textColor = [UIcol hexStringToColor:@"#f85223"];
         x.center = CGPointMake(320/6*5+1, x.center.y);
        if([[bUser objectForKey:@"sex"] integerValue] == 0){
            _skip2 = 1;
            [self getNearWishSkip:_skip2];
        }else{
            _skip3 = 1;
            [self getNearHelpSkip:_skip3];
        }
    };
   
    self.commentChange = ^(int i , int j){
        UITableView * tableView = (id)[self.view viewWithTag:indexPathNumber];
        WishTableViewCell * cell = (id)[tableView cellForRowAtIndexPath:indexPathWish];
        cell.like.text = [NSString stringWithFormat:@"%d",i];
        cell.comment.text = [NSString stringWithFormat:@"%d",j];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNot) name:@"news" object:nil];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:(DEMONavigationController *)self.navigationController  action:@selector(panGestureRecognized:)]];
}

-(void)recieveNot{
    
    [self changeNaBar];
}

- (void)dealloc
{
    [_header1 removeFromSuperview];
    [_footer1 removeFromSuperview];
    [_header2 removeFromSuperview];
    [_footer2 removeFromSuperview];
    [_header3 removeFromSuperview];
    [_footer3 removeFromSuperview];
}




-(void)createTabBar{

    UIButton * tabBar = [[UIButton alloc] initWithFrame:CGRectMake(236.5,self.view.bounds.size.height - 88, 77,77)];
    [tabBar addTarget:self action:@selector(tabBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar setImage:[UIImage imageNamed:@"wishButton"] forState:UIControlStateNormal];
    [tabBar setImage:[UIImage imageNamed:@"chuji"] forState:UIControlStateHighlighted];
    
    UIView * back = (id)[self.view viewWithTag:2000];
    [back addSubview:tabBar];
}

-(void)tabBarBtn:(UIButton *)btn{
    
    AddWishViewController * bj = [[AddWishViewController alloc] init];
    [self.navigationController pushViewController:bj animated:YES];

}

-(void)createWish{
    
    UIView * v = [[UIView alloc] initWithFrame:self.view.bounds];
    v.tag = 101;
//    v.backgroundColor = [UIColor blackColor];
//    v.userInteractionEnabled = NO;
    
    UIView * back = (id)[self.view viewWithTag:2000];
    [back addSubview:v];
    
    //时间 距离 推荐
    UIView * shi = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 32)];
    shi.backgroundColor = [UIcol hexStringToColor:@"#f8f5fb"];
    [v addSubview:shi];
    
    UILabel * timetext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320/3,30)];
    timetext.text = @"推荐";
    timetext.font = [UIFont systemFontOfSize:13];
    timetext.textAlignment = NSTextAlignmentCenter;
    timetext.textColor = [UIcol hexStringToColor:@"#f58223"];
    timetext.tag = 2101;
    [shi addSubview:timetext];
   
    UIButton * timebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320/3, 32)];
    timebtn.tag = 2121;
    [timebtn addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    [shi addSubview:timebtn];
    
    
    UILabel * distancetext = [[UILabel alloc] initWithFrame:CGRectMake(320/3,0 , 320/3,30)];
    distancetext.text = @"愿望";
    distancetext.textAlignment = NSTextAlignmentCenter;
    distancetext.font = [UIFont systemFontOfSize:13];
    distancetext.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    distancetext.tag = 2102;
    [shi addSubview:distancetext];
   
    UIButton * distancebtn = [[UIButton alloc] initWithFrame:CGRectMake( 320/3, 0, 320/3, 32)];
    distancebtn.tag = 2122;
    [distancebtn addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    [shi addSubview:distancebtn];
   
    
    UILabel * recommendtext = [[UILabel alloc] initWithFrame:CGRectMake(320/3 * 2, 0, 320/3, 30)];
    recommendtext.text = @"大叔";
    recommendtext.textAlignment = NSTextAlignmentCenter;
    recommendtext.font = [UIFont systemFontOfSize:13];
    recommendtext.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    recommendtext.tag = 2103;
    [shi addSubview:recommendtext];
    if([[user objectForKey:@"sex"] integerValue] == 0){
          distancetext.text = @"大叔";
        recommendtext.text = @"愿望";
      
    }
   
    UIButton * recommendbtn = [[UIButton alloc] initWithFrame:CGRectMake( 320/3 * 2, 0, 320/3, 32)];
    recommendbtn.tag = 2123;
    [recommendbtn addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    [shi addSubview:recommendbtn];
 
    
    // line
    
    UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huadingxian"]];
    line.frame = CGRectMake(0, 25, 107, 2);
    line.tag = 2200;
    [shi addSubview:line];
    
    //  ScrollView
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 91, 320, self.view.bounds.size.height - 91 -32 + 44)];
    sv.tag = 3000;
    sv.backgroundColor = [UIColor whiteColor];
    sv.contentSize = CGSizeMake(320 * 3, self.view.bounds.size.height - 91);
    sv.pagingEnabled = YES;
    sv.delegate =self;
    [v addSubview:sv];
    
    
    
    //   时间Table
    recommendTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 91)];
    recommendTable.delegate = self;
    recommendTable.dataSource = self;
    recommendTable.tag = 300;
    recommendTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [sv addSubview:recommendTable];
   
    // 刷新功能
    _header1 = [[MJRefreshHeaderView alloc] init];
    _header1.delegate = self;
    _header1.scrollView = recommendTable;
    //添加上拉加载更多
    _footer1 = [[MJRefreshFooterView alloc] init];
    _footer1.delegate = self;
    _footer1.scrollView = recommendTable;
    //
    nearWishTable = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.bounds.size.height - 91)];
    nearWishTable.delegate = self;
    nearWishTable.dataSource = self;
    nearWishTable.tag = 301;
    nearWishTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [sv addSubview:nearWishTable];
//    // 刷新功能
    _header2 = [[MJRefreshHeaderView alloc] init];
    _header2.delegate = self;
    _header2.scrollView = nearWishTable;
    //添加上拉加载更多
    _footer2 = [[MJRefreshFooterView alloc] init];
    _footer2.delegate = self;
    _footer2.scrollView = nearWishTable;

    //
    nearHelpTable = [[UITableView alloc] initWithFrame:CGRectMake(640, 0, 320, self.view.bounds.size.height - 91)];
    nearHelpTable.delegate = self;
    nearHelpTable.dataSource = self;
    nearHelpTable.tag = 302;
    nearHelpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [sv addSubview:nearHelpTable];
//    // 刷新功能
    _header3 = [[MJRefreshHeaderView alloc] init];
    _header3.delegate = self;
    _header3.scrollView = nearHelpTable;
    //添加上拉加载更多
    _footer3 = [[MJRefreshFooterView alloc] init];
    _footer3.delegate = self;
    _footer3.scrollView = nearHelpTable;
    
    if([[user objectForKey:@"sex"] integerValue] == 0){
        nearWishTable.frame = CGRectMake(640, 0, 320,  self.view.bounds.size.height - 91);
        nearHelpTable.frame = CGRectMake(320, 0, 320,  self.view.bounds.size.height - 91);
    }
    
    HUD1= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD1.labelText = @"加载中";
    [self.view addSubview:HUD1];
    [HUD1 show:YES];
    HUD2= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD2.labelText = @"加载中";
    [self.view addSubview:HUD2];
    [HUD2 show:YES];
    HUD3= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD3.labelText = @"加载中";
    [self.view addSubview:HUD3];
    [HUD3 show:YES];

    
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header1 == refreshView)
    {
 
        [self performSelector:@selector(refreshDate1) withObject:nil afterDelay:2];
        
    } else if(_footer1 == refreshView){

        [self performSelector:@selector(reloadDeals1) withObject:nil afterDelay:2];
    }else if (_header2 == refreshView)
    {

        [self performSelector:@selector(refreshDate2) withObject:nil afterDelay:2];
        
    } else if(_footer2 == refreshView){

        [self performSelector:@selector(reloadDeals2) withObject:nil afterDelay:2];
    }else if (_header3 == refreshView)
    {
        
        [self performSelector:@selector(refreshDate3) withObject:nil afterDelay:2];
        
    } else if(_footer3 == refreshView){
        
        [self performSelector:@selector(reloadDeals3) withObject:nil afterDelay:2];
    }
    
}

-(void)refreshDate1{
    _skip1 = 1;
    
    [self getRecommendSkip:_skip1];
}

- (void)reloadDeals1{
    _skip1 = _skip1 + 1;
    [self getRecommendSkip:_skip1];
}

-(void)refreshDate2{
    _skip2 = 1;
   
    [self getNearWishSkip:_skip2];
}

- (void)reloadDeals2{
    _skip2 = _skip2 + 1;
    [self getNearWishSkip:_skip2];
}

-(void)refreshDate3{
    _skip3 = 1;
  
    [self getNearHelpSkip:_skip3];
}

- (void)reloadDeals3{
    _skip3 = _skip3 + 1;
    [self getNearHelpSkip:_skip3];
}


-(void)animation:(UIButton *)but{
    UIView * x = (id)[self.view viewWithTag:2200];
    UIScrollView * sv = (id)[self.view viewWithTag:3000];
    if(but.tag == 2121){
        
        UILabel * l1 = (id)[self.view viewWithTag:2101];
        l1.textColor = [UIcol hexStringToColor:@"#f58223"];
        
        UILabel * l2 = (id)[self.view viewWithTag:2102];
        l2.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        
        UILabel * l3 = (id)[self.view viewWithTag:2103];
        l3.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        
        [UIView animateWithDuration:0.5 animations:^{
            x.center = CGPointMake(320/6, x.center.y);
        }];
        
        [sv setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
    }else if(but.tag == 2122){
        
        UILabel * l1 = (id)[self.view viewWithTag:2101];
        l1.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        
        UILabel * l2 = (id)[self.view viewWithTag:2102];
        l2.textColor = [UIcol hexStringToColor:@"#f58223"];
               UILabel * l3 = (id)[self.view viewWithTag:2103];
        l3.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
  
        [UIView animateWithDuration:0.5 animations:^{
            x.center = CGPointMake(160, x.center.y);
        }];
        [sv setContentOffset:CGPointMake(320, 0) animated:YES];
    }else {
        UILabel * l1 = (id)[self.view viewWithTag:2101];
        l1.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
               UILabel * l2 = (id)[self.view viewWithTag:2102];
        l2.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
       
        UILabel * l3 = (id)[self.view viewWithTag:2103];
        l3.textColor = [UIcol hexStringToColor:@"#f58223"];
       
        [UIView animateWithDuration:0.5 animations:^{
            x.center = CGPointMake(320/6 * 5, x.center.y);
        }];
        [sv setContentOffset:CGPointMake(320*2, 0) animated:YES];
    }
    
}

-(void)getRecommendSkip:(int)skip{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%d",skip] forKey:@"page"];
    [BmobCloud callFunctionInBackground:@"queryWishTimeline" withParameters:dict block:^(id object, NSError * error) {
        NSArray * array = [object objectForKey:@"results"];
        if(!error){
            if(skip == 1){
                [recommendArray removeAllObjects];
            }
            for(int i= 0 ; i <  array.count;i++){
                BmobObject *obj = array[i];
                WishModel * wish = [[WishModel alloc] init];
                postObj = [obj objectForKey:@"user"];
                wish.objDict = array[i];
                wish.name = [postObj objectForKey:@"nick"];
                wish.charid = (id)postObj;
                wish.avatar = [postObj objectForKey:@"avatar"];
                wish.image = [obj objectForKey:@"url"];
                wish.age = [postObj objectForKey:@"birthday"];
                wish.context = [obj objectForKey:@"text"];
                wish.comment = [obj objectForKey:@"comment"];
                wish.like = [obj objectForKey:@"like"];
                if([obj objectForKey:@"localtime"] == nil){
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                    NSString * date = [postObj objectForKey:@"updatedAt"];
                    wish.attime = date;
                }else{
                    wish.attime = [postObj objectForKey:@"localtime"];
                }
                wish.type = [NSString stringWithFormat:@"%@",[postObj objectForKey:@"sex"]];
                wish.deviceType = [postObj objectForKey:@"deviceType"];
                wish.installId = [postObj objectForKey:@"installId"];
                if([[obj objectForKey:@"recommend"] integerValue] == 1){
                    if([[obj objectForKey:@"fromSystem"] integerValue] == 1){
                        wish.recommend = @"2";
                    }else{
                        wish.recommend = @"1";
                    }
                }
//                BmobGeoPoint * point = [postObj objectForKey:@"location"];
//                CLLocationManager * locManager = [[CLLocationManager alloc] init];
//                locManager.desiredAccuracy = kCLLocationAccuracyBest;
//                [locManager startUpdatingLocation];
//                locManager.distanceFilter = 1000.0f;
//                //第一个坐标
//                CLLocation *current=[[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
//                //第二个坐标
//                CLLocation *before=[[CLLocation alloc] initWithLatitude:locManager.location.coordinate.latitude longitude:locManager.location.coordinate.longitude];
//                // 计算距离
//                CLLocationDistance meters=[current distanceFromLocation:before];
//                wish.distance = [NSString stringWithFormat:@"%.2fkm",meters/1000];
                
                [recommendArray addObject:wish];
                
            }
            [recommendTable reloadData];
            [_header1 endRefreshing];
            [_footer1 endRefreshing];
            [HUD1 removeFromSuperview];
            HUD1 = nil;
            
        }else{
            HUD1.labelText = @"载入失败";
            HUD1.mode = MBProgressHUDModeCustomView;
            HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] ;
            [HUD1 showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD1 removeFromSuperview];
                HUD1 = nil;
            }];
            
        }
        
    }];
    
}

-(void)getNearWishSkip:(int)skip{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    if([[user objectForKey:@"sex"] integerValue] == 0){
        [dict setObject:[NSString stringWithFormat:@"\"%@\"",user.objectId] forKey:@"objectId"];
    }else{
        [dict setObject:@"" forKey:@"objectId"];
    }
    [dict setObject:[NSNumber numberWithBool:NO] forKey:@"sex"];
    [dict setObject:[NSString stringWithFormat:@"%d",skip] forKey:@"page"];
    [BmobCloud callFunctionInBackground:@"queryUserTimelineByTime" withParameters:dict block:^(id object, NSError *error) {
        if(!error){
            if(_skip2 == 1){
                [nearWishArray removeAllObjects];;
            }
           NSArray * array = [object objectForKey:@"results"];
            for(int i= 0 ; i <  array.count;i++){
                BmobObject *obj = array[i];
                WishModel * wish = [[WishModel alloc] init];
                postObj = [obj objectForKey:@"lastWish"];
                wish.objDict = (id)postObj;
                wish.name = [obj objectForKey:@"nick"];
                wish.charid = (id)obj;
                wish.avatar = [obj objectForKey:@"avatar"];
                wish.image = [postObj objectForKey:@"url"];
                wish.age = [obj objectForKey:@"birthday"];
                wish.context = [postObj objectForKey:@"text"];
                wish.comment = [postObj objectForKey:@"comment"];
                wish.like = [postObj objectForKey:@"like"];
                if([obj objectForKey:@"localtime"] == nil){
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                    NSString * date = [postObj objectForKey:@"updatedAt"];
                    wish.attime = date;
                }else{
                    wish.attime = [obj objectForKey:@"localtime"];
                }
                
                wish.type = [NSString stringWithFormat:@"%@",[obj objectForKey:@"sex"]];
                wish.deviceType = [obj objectForKey:@"deviceType"];
                wish.installId = [obj objectForKey:@"installId"];
//                BmobGeoPoint * point = [obj objectForKey:@"location"];
//                CLLocationManager * locManager = [[CLLocationManager alloc] init];
//                locManager.desiredAccuracy = kCLLocationAccuracyBest;
//                [locManager startUpdatingLocation];
//                locManager.distanceFilter = 1000.0f;
//                //第一个坐标
//                CLLocation *current=[[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
//                //第二个坐标
//                CLLocation *before=[[CLLocation alloc] initWithLatitude:locManager.location.coordinate.latitude longitude:locManager.location.coordinate.longitude];
//                // 计算距离
//                CLLocationDistance meters=[current distanceFromLocation:before];
//                wish.distance = [NSString stringWithFormat:@"%.2fkm",meters/1000];
                
                if([[obj objectForKey:@"objectId"] isEqualToString:user.objectId]){
                    if(nearWishArray.count == 0){
                        [nearWishArray addObject:wish];
                    }else{
                        [nearWishArray insertObject:wish atIndex:0];
                    }
                }else{
                    [nearWishArray addObject:wish];
                }
            }
            [nearWishTable reloadData];
            [_header2 endRefreshing];
            [_footer2 endRefreshing];
            [HUD2 removeFromSuperview];
            HUD2 = nil;
            
        }else{
            HUD2.labelText = @"载入失败";
            HUD2.mode = MBProgressHUDModeCustomView;
            HUD2.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] ;
            [HUD2 showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD2 removeFromSuperview];
                HUD2 = nil;
            }];
            
        }

    }];
}

-(void)getNearHelpSkip:(int)skip{

    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    if([[user objectForKey:@"sex"] integerValue] == 1){
        [dict setObject:[NSString stringWithFormat:@"\"%@\"",user.objectId] forKey:@"objectId"];
    }else{
        [dict setObject:@"" forKey:@"objectId"];
    }
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"sex"];
    [dict setObject:[NSString stringWithFormat:@"%d",skip] forKey:@"page"];
    [BmobCloud callFunctionInBackground:@"queryUserTimelineByTime" withParameters:dict block:^(id object, NSError *error) {
        if(!error){
            if(_skip3 == 1){
                [nearHelpArray removeAllObjects];;
            }
             NSArray * array = [object objectForKey:@"results"];
            for(int i= 0 ; i <  array.count;i++){
                BmobObject *obj = array[i];
                WishModel * wish = [[WishModel alloc] init];
                postObj = [obj objectForKey:@"lastWish"];
                wish.objDict = (id)postObj;
                wish.name = [obj objectForKey:@"nick"];
                wish.charid = (id)obj;
                wish.avatar = [obj objectForKey:@"avatar"];
                wish.image = [postObj objectForKey:@"url"];
                wish.age = [obj objectForKey:@"birthday"];
                wish.context = [postObj objectForKey:@"text"];
                wish.comment = [postObj objectForKey:@"comment"];
                wish.like = [postObj objectForKey:@"like"];
                if([obj objectForKey:@"localtime"] == nil){
                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                    NSString * date = [obj objectForKey:@"updatedAt"];
                    wish.attime = date;
                }else{
                    wish.attime = [obj objectForKey:@"localtime"];
                }
                
                wish.type = [NSString stringWithFormat:@"%@",[obj objectForKey:@"sex"]];
                wish.deviceType = [obj objectForKey:@"deviceType"];
                wish.installId = [obj objectForKey:@"installId"];
//                BmobGeoPoint * point = [obj objectForKey:@"location"];
//                CLLocationManager * locManager = [[CLLocationManager alloc] init];
//                locManager.desiredAccuracy = kCLLocationAccuracyBest;
//                [locManager startUpdatingLocation];
//                locManager.distanceFilter = 1000.0f;
//                //第一个坐标
//                CLLocation *current=[[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
//                //第二个坐标
//                CLLocation *before=[[CLLocation alloc] initWithLatitude:locManager.location.coordinate.latitude longitude:locManager.location.coordinate.longitude];
//                // 计算距离
//                CLLocationDistance meters=[current distanceFromLocation:before];
//                wish.distance = [NSString stringWithFormat:@"%.2fkm",meters/1000];
                
                if([[obj objectForKey:@"objectId"]isEqualToString:user.objectId]){
                    if(nearHelpArray.count == 0){
                        [nearHelpArray addObject:wish];
                    }else{
                        [nearHelpArray insertObject:wish atIndex:0];
                    }
                }else{
                    [nearHelpArray addObject:wish];
                }
            }
            [nearHelpTable reloadData];
            [_header3 endRefreshing];
            [_footer3 endRefreshing];
            [HUD3 removeFromSuperview];
            HUD3 = nil;
            
        }else{
            HUD3.labelText = @"载入失败";
            HUD3.mode = MBProgressHUDModeCustomView;
            HUD3.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] ;
            [HUD3 showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD3 removeFromSuperview];
                HUD3 = nil;
            }];
            
        }
    }];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WishTableViewCell * wishcell = [[WishTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"yw"];
    if(!wishcell){
        wishcell = [[[NSBundle mainBundle] loadNibNamed:@"yw" owner:self options:nil] lastObject];
        
    }
    WishModel * wish;
    if(tableView.tag == 300){
        wish = recommendArray[indexPath.row];
    }else if (tableView.tag == 301){
        wish = nearWishArray[indexPath.row];
    }else{
        wish = nearHelpArray[indexPath.row];
    }
    
    NSURL * avatarimu = [NSURL URLWithString:wish.avatar];
    [wishcell.avatar sd_setImageWithURL:avatarimu];
//    NSLog(@"%f,%f,%f",wishcell.avatar.image.size.width,wishcell.avatar.image.size.height,wishcell.avatar.image.scale);
    NSURL * imageimu = [NSURL URLWithString:wish.image];
    [wishcell.image sd_setImageWithURL:imageimu];
    
    wishcell.name.text = wish.name;
    CGRect nameRect = [wish.name boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
  
    if ([[NSString stringWithFormat:@"%@",wish.type] isEqualToString:@"1"]) {
        wishcell.agev.image = [UIImage imageNamed:@"nanshengnianling"];
    }else{
        wishcell.agev.image = [UIImage imageNamed:@"niushengnianling"];
    }
    wishcell.agev.center = CGPointMake(nameRect.size.width + 110, wishcell.agev.center.y);
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:wish.age];
    
    NSTimeInterval dateDiff = [d timeIntervalSinceNow];
    int age=trunc(dateDiff/(60*60*24))/365;
    wishcell.age.text = [NSString stringWithFormat:@"%d",-age];
    wishcell.context.text = wish.context;
    wishcell.like.text = [NSString stringWithFormat:@"%d",[wish.like intValue]];
    wishcell.comment.text = [NSString stringWithFormat:@"%d",[wish.comment intValue]];
    NSString * s = [NSString stringWithFormat:@"%@",[mistiming returnUploadTime:[NSString stringWithFormat:@"%@ +0800",wish.attime]]];
    if([[s substringFromIndex:s.length - 3]isEqualToString:@"分钟前"]){
        if([[s substringToIndex:s.length - 3] integerValue] <= 30){
            wishcell.distance.text = @"刚刚";
        }else{
            wishcell.distance.text = [NSString stringWithFormat:@"%@",s];
        }
    }else{
//    CGRect rect = [s boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    wishcell.distance.text = [NSString stringWithFormat:@"%@",s];
//    wishcell.xian.center = CGPointMake(305-rect.size.width ,wishcell.xian.center.y );
    }
    UIImageView * recommend;
    if([wish.recommend integerValue] == 1){
        recommend = [[UIImageView alloc] initWithFrame:CGRectMake(0,3, 45, 45)];
        [recommend setImage:[UIImage imageNamed:@"tuijian"]];
    }else if([wish.recommend integerValue] == 2){
        recommend = [[UIImageView alloc] initWithFrame:CGRectMake(0,3, 45,45)];
        [recommend setImage:[UIImage imageNamed:@"guanfang"]];
    }
    [wishcell addSubview:recommend];
    return wishcell;
}

- (void)richTextView:(TQRichTextView *)view touchEndRun:(TQRichTextBaseRun *)run
{
    if (run.type == richTextURLRunType)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:run.originalText]];
    }
    //    NSLog(@"%@",run.originalText);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 300){
        return recommendArray.count;
    }else if(tableView.tag == 301){
            return nearWishArray.count;
    }else{
        return nearHelpArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < 0 && isShow == YES){
        isShow = NO;
        [(DEMONavigationController *)self.navigationController showMenu];
    }
    if(scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > 640)
        return;
    isShow = YES;
    if (scrollView.isDragging == YES) {
        UIView * x = (id)[self.view viewWithTag:2200];
        if(scrollView.contentOffset.x > 0)
        x.center = CGPointMake(scrollView.contentOffset.x/3+53 , x.center.y);

        if(scrollView.contentOffset.x < 1 && scrollView.contentOffset.x != 0){
            
            UILabel * timeLabel = (id)[self.view viewWithTag:2101];
            timeLabel.textColor = [UIcol hexStringToColor:@"#f58223"];
      
            UILabel * distanceLabel = (id)[self.view viewWithTag:2102];
            distanceLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
            
            UILabel * recommendLabel = (id)[self.view viewWithTag:2103];
            recommendLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
            [UIView animateWithDuration:0.5 animations:^{
                x.center = CGPointMake(320/6, x.center.y);
            }];
         }else if(scrollView.contentOffset.x == 320){
            
            UILabel * timeLabel = (id)[self.view viewWithTag:2101];
            timeLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
          
            UILabel * distanceLabel = (id)[self.view viewWithTag:2102];
            distanceLabel.textColor = [UIcol hexStringToColor:@"#f58223"];
    
            UILabel * recommendLabel = (id)[self.view viewWithTag:2103];
            recommendLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
      
            [UIView animateWithDuration:0.5 animations:^{
                x.center = CGPointMake(160, x.center.y);
            }];
            
        }else if(scrollView.contentOffset.x == 640){
            UILabel * timeLabel = (id)[self.view viewWithTag:2101];
            timeLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
         
            UILabel * distanceLabel = (id)[self.view viewWithTag:2102];
            distanceLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
         
            UILabel * recommendLabel = (id)[self.view viewWithTag:2103];
            recommendLabel.textColor = [UIcol hexStringToColor:@"#f85223"];
        
            [UIView animateWithDuration:0.5 animations:^{
                x.center = CGPointMake(320/6*5+1, x.center.y);
            }];
        }
   }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailWishViewController * detailwish = [[DetailWishViewController alloc] init];
    WishModel * wish;
    if(tableView.tag == 300){
        wish = recommendArray[indexPath.row];
    }else if (tableView.tag == 301){
        wish = nearWishArray[indexPath.row];
    }else if (tableView.tag == 302){
        wish = nearHelpArray[indexPath.row];
    }
    NSLog(@"%@",wish.objDict);
    detailwish.objectId = wish.objDict[@"objectId"];
    indexPathWish = indexPath;
    indexPathNumber = tableView.tag;
    [self.navigationController pushViewController:detailwish animated:YES];
    
    
}

#pragma mark nabar
-(void)createNarBar{
    UIView * back = (id)[self.view viewWithTag:101];
    UIView * instrument = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    instrument.backgroundColor = [UIColor blackColor];
    [back addSubview:instrument];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, 44)];
    iv.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.95 alpha:1];
    [back addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
    
    UIImageView * sidebar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sidebar.image = [UIImage imageNamed:@"caidan"];
    sidebar.tag = 554;
    sidebar.userInteractionEnabled = YES;
    [iv addSubview:sidebar];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    int m = 0;
    for (int i = 0 ; i < array.count ; i++) {
        BmobRecent * news = array[i];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
        UIImageView * sidebar = (id)[self.view viewWithTag:554];
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 20,20)];
        dotBack.tag = 555;
        dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
        dotBack.layer.cornerRadius = 10;
        dotBack.layer.masksToBounds = YES;
        [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
        [sidebar addSubview:dotBack];
        UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
        dot.backgroundColor = [UIColor redColor];
        dot.layer.cornerRadius = 20;
        dot.tag = 557;
        dot.layer.masksToBounds = YES;
        [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
        [dotBack addSubview:dot];
        UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
        number.tag = 668;
        number.font = [UIFont systemFontOfSize:11];
        number.textColor = [UIColor whiteColor];
        number.textAlignment = NSTextAlignmentCenter;
        number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
        [dot addSubview:number];
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3,20,20)];
        dotBack.tag = 555;
        dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
        dotBack.layer.cornerRadius = 10;
        dotBack.layer.masksToBounds = YES;
        [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
        [sidebar addSubview:dotBack];
        UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
        dot.backgroundColor = [UIColor redColor];
        dot.layer.cornerRadius = 20;
        dot.tag = 557;
        dot.layer.masksToBounds = YES;
        [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
        [dotBack addSubview:dot];
    }
    
    sideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sideBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] size:CGSizeMake(44, 44)] forState:UIControlStateHighlighted];
    [sideBtn addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sidebar addSubview:sideBtn];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"愿望首页";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
    
}

-(void)changeNaBar{
    UIView * dotBack = (id)[self.view viewWithTag:555];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    UIImageView * sidebar = (id)[self.view viewWithTag:554];
    int m = 0;
    for (int i = 0 ; i < array.count ; i++) {
        BmobRecent * news = array[i];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
        if(dotBack == nil){
            
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 20,20)];
            dotBack.tag = 555;
            dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [sidebar addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
            dot.backgroundColor = [UIColor redColor];
            dot.layer.cornerRadius = 20;
            dot.tag = 557;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
            UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
            number.tag = 668;
            number.font = [UIFont systemFontOfSize:11];
            number.textColor = [UIColor whiteColor];
            number.textAlignment = NSTextAlignmentCenter;
            number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            [dot addSubview:number];
        }else{
            UILabel * number = (id)[self.view viewWithTag:668];
            if(number == nil){
                if(number == nil){
                    UIView * dot = (id)[self.view viewWithTag:557];
                    number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
                    number.tag = 668;
                    number.font = [UIFont systemFontOfSize:11];
                    number.textColor = [UIColor whiteColor];
                    number.textAlignment = NSTextAlignmentCenter;
                    [dot addSubview:number];
                }            }
            number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
        }
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
        if(dotBack == nil){
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 18,18)];
            dotBack.tag = 555;
            dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [sidebar addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
            dot.backgroundColor = [UIColor redColor];
            dot.layer.cornerRadius = 20;
            dot.tag = 557;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
        }else{
            UILabel * number = (id)[self.view viewWithTag:668];
            [number removeFromSuperview];
        }
    }else{
        [dotBack removeFromSuperview];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self changeNaBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
