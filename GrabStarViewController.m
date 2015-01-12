//
//  GrabStarViewController.m
//  DSBBM
//
//  Created by bisheng on 14-10-16.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "GrabStarViewController.h"
#import "GrabTableViewCell.h"
#import "WishModel.h"
#import "friendInfoViewController.h"

@interface GrabStarViewController ()

@end

@implementation GrabStarViewController
{
    NSMutableArray * nearMan;
    UITableView * nearManTableView;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    MBProgressHUD * HUD;
    int _skip;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _skip = 0;
    [self createNaBar];
    nearMan = [[NSMutableArray alloc] init];
    [self getTableView];
    [self getDateSkip:_skip];
   
}

- (void)dealloc
{
    [_header removeFromSuperview];
    [_footer removeFromSuperview];
}

-(void)getDateSkip:(int)skip{
    BmobUser * user = [BmobUser getCurrentUser];
    BmobQuery * query = [BmobQuery queryForUser];
    query.limit = 25;
    query.skip = skip;
    CLLocationManager * locManager = [[CLLocationManager alloc] init];
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locManager startUpdatingLocation];
    locManager.distanceFilter = 1000.0f;
    CLLocationCoordinate2D cllocation = CLLocationCoordinate2DMake(locManager.location.coordinate.latitude,locManager.location.coordinate.longitude);
    BmobGeoPoint * point = [[BmobGeoPoint alloc] initWithLongitude:cllocation.longitude WithLatitude:cllocation.latitude];
    [query whereKey:@"objectId" notEqualTo:user.objectId];
    [query whereKey:@"location" nearGeoPoint:point];

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(error){
            HUD.labelText = @"载入失败";
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                HUD = nil;
            }];
        }else{
        if(_skip == 0){
            [nearMan removeAllObjects];
        }
        for (BmobObject * object in array) {
            WishModel * near = [[WishModel alloc] init];
            near.obj = object;
            near.deviceType = [object objectForKey:@"deviceType"];
            near.installId = [object objectForKey:@"installId"];
            near.name = [object objectForKey:@"nick"];
            near.type = [object objectForKey:@"stars"];
            near.avatar = [object objectForKey:@"avatar"];
            BmobGeoPoint * point = [object objectForKey:@"location"];
            CLLocationManager * locManager = [[CLLocationManager alloc] init];
            locManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locManager startUpdatingLocation];
            locManager.distanceFilter = 1000.0f;
            //第一个坐标
            CLLocation *current=[[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
            //第二个坐标
            CLLocation *before=[[CLLocation alloc] initWithLatitude:locManager.location.coordinate.latitude longitude:locManager.location.coordinate.longitude];
            // 计算距离
            CLLocationDistance meters=[current distanceFromLocation:before];
            near.distance = [NSString stringWithFormat:@"%.2fkm",meters/1000];
            
            [nearMan addObject:near];
        }
        [HUD removeFromSuperview];
        [nearManTableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
        }
    }];
    
    
    
}

-(void)createNaBar{
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
    
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"抢星星";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getTableView{
    nearManTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
    nearManTableView.delegate = self;
    nearManTableView.dataSource = self;
    nearManTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:nearManTableView];
    // 刷新功能
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = nearManTableView;
    //添加上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = nearManTableView;
    
    HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"加载中";
    [self.view addSubview:HUD];
    [HUD show:YES];
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (_header == refreshView)
    {
        //下拉刷新数据请求********************************
        // 2秒后刷新表格
        [self performSelector:@selector(refreshDate) withObject:nil afterDelay:2];
        
    } else {
        //上拉刷新数据请求**************************************
        // 2秒后刷新表格
        [self performSelector:@selector(reloadDeals) withObject:nil afterDelay:2];
    }
}

-(void)refreshDate{
    _skip = 0;
    
    [self getDateSkip:_skip];
}

- (void)reloadDeals
{
    _skip = _skip + 25;
    [self getDateSkip:_skip];
}


#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GrabTableViewCell * wishcell = [[GrabTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"grab"];
    if(!wishcell){
        wishcell = [[[NSBundle mainBundle] loadNibNamed:@"grab" owner:self options:nil] lastObject];
        
    }
    WishModel * wish = nearMan[indexPath.row];

    NSURL * imageimu = [NSURL URLWithString:wish.avatar];
    [wishcell.avatar sd_setImageWithURL:imageimu];
    
    wishcell.nick.text = wish.name;
    if([wish.type integerValue] <= 0){
        wishcell.star.frame = CGRectMake(0, 0, 0, 17);
    }else{
        wishcell.star.frame = CGRectMake(0, 0, 24 * [wish.type integerValue], 17);
    }
    wishcell.distance.text = wish.distance;
    UIButton * choose = [[UIButton alloc] initWithFrame:CGRectMake(240,0,80,80)];
    choose.tag = 400 + indexPath.row;
    wishcell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"grabStar"];
    if([[NSString stringWithFormat:@"%@",wish.type] isEqualToString:@"0"]){
        [choose setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
        [choose addTarget:self action:@selector(grabStarFail) forControlEvents:UIControlEventTouchUpInside];
//        choose.userInteractionEnabled = NO;
    }else{
        [choose setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
        [choose addTarget:self action:@selector(grabStar:) forControlEvents:UIControlEventTouchUpInside];
        [choose setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateHighlighted];
    }
    for(int i = 0 ; i < array.count ;i++){
        if([wish.obj.objectId isEqualToString: array[i]]){
            [choose setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
            choose.userInteractionEnabled = NO;

        }
    }
   
    [wishcell addSubview:choose];
    return wishcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     WishModel * near = nearMan[indexPath.row];
    friendInfoViewController * fivc = [[friendInfoViewController alloc] init];
    fivc.userId = [[near obj] objectForKey:@"objectId"];
    fivc.userName = [near.obj objectForKey:@"nick"];
    [self.navigationController pushViewController:fivc animated:YES];
}

-(void)grabStarFail{
    MBProgressHUD * HUD1 = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:HUD1];
    HUD1.labelText = @"每天能抢对方一次";
    HUD1.mode = MBProgressHUDModeCustomView;
    HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD1 showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD1 removeFromSuperview];
    }];


}

-(void)grabStar:(UIButton *)btn{
    if(self.i < 6){
    WishModel * wish = nearMan[btn.tag - 400];
   
    BmobUser * user= [BmobUser getCurrentUser];
    
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"grabStarTime"];
    if([NSNumber numberWithInt:[wish.type integerValue] - 1] > 0){
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:wish.deviceType forKey:@"deviceToken"];
        [dict setObject:wish.installId forKey:@"installationId"];
        [dict setObject:wish.obj.objectId forKey:@"fromUser"];
        [dict setObject:user.objectId forKey:@"toUser"];
        HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
        HUD.labelText = @"正在为你努力的抢星星中";
        [self.view addSubview:HUD];
        [HUD show:YES];

        [BmobCloud callFunctionInBackground:@"stealStar" withParameters:dict block:^(id object, NSError *error) {
            if(!error){
                self.i = self.i + 1;
                [HUD removeFromSuperview];
                MBProgressHUD * HUD1 = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
                [self.view addSubview:HUD1];
                HUD1.labelText = @"抢了一颗星星";
                HUD1.mode = MBProgressHUDModeCustomView;
                HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                [HUD1 showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [HUD1 removeFromSuperview];
                }];
                NSArray * oldArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"grabStar"];
                NSMutableArray * array = [[NSMutableArray alloc] initWithArray:oldArray];
                
                [array addObject:wish.obj.objectId];
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"grabStar"];
                [self getDateSkip:_skip];
            }else{
                [HUD removeFromSuperview];
                MBProgressHUD * HUD1 = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
                [self.view addSubview:HUD1];
                HUD1.labelText = @"抢星星失败";
                HUD1.mode = MBProgressHUDModeCustomView;
                HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                [HUD1 showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [HUD1 removeFromSuperview];
                }];

            }
        }];
    }
    }else{
        MBProgressHUD * HUD1 = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self.view addSubview:HUD1];
        HUD1.labelText = @"你的星星已经满了";
        HUD1.mode = MBProgressHUDModeCustomView;
        HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [HUD1 showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUD1 removeFromSuperview];
        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return nearMan.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
