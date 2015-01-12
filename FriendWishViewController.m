//
//  FriendWishViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-17.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "FriendWishViewController.h"
#import "WishTableViewCell.h"
#import "WishModel.h"
#import "DetailWishViewController.h"
#import "sqlStatusTool.h"
#import "friendModel.h"

@interface FriendWishViewController ()

@end

@implementation FriendWishViewController
{
    UITableView * wishTableView;
    NSMutableArray * wishArray;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int _skip;
    MBProgressHUD * HUD;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        wishArray = [NSMutableArray array];
        _skip = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self getDataSkip:_skip];
    [self createTableView];
}

- (void)dealloc
{
    [_header removeFromSuperview];
    [_footer removeFromSuperview];
}

#pragma mark data
-(void)getDataSkip:(int)skip{
    
    NSArray * array = [sqlStatusTool readFromSqliteWithType:@"0"];
    NSMutableArray * arrayId = [NSMutableArray array];
    for(int i = 0 ; i < array.count ; i++){
        friendModel * fm = array[i];
        [arrayId addObject:fm.userId];
    }
     NSLog(@"%@",arrayId);
    BmobQuery *wishBquery = [BmobQuery queryWithClassName:@"Wish"];
   
    [wishBquery whereKey:@"user" containedIn:arrayId];
    [wishBquery includeKey:@"user"];
    [wishBquery  orderByAscending:@"updateAt"];
    [wishBquery findObjectsInBackgroundWithBlock:^(NSArray *warray, NSError *error) {
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
            [HUD removeFromSuperview];
        if(_skip == 0){
        [wishArray removeAllObjects];
        }
        for (BmobObject *obj in warray) {
            BmobUser * postObj =   [obj objectForKey:@"user"];
            
            WishModel * wish = [[WishModel alloc] init];
            wish.obj = obj;
            wish.name = [postObj objectForKey:@"nick"];
            wish.charid = (id)postObj;
            wish.avatar = [postObj objectForKey:@"avatar"];
            wish.image = [obj objectForKey:@"url"];
            wish.age = [postObj objectForKey:@"birthday"];
            wish.context = [obj objectForKey:@"text"];
            wish.comment = [obj objectForKey:@"comment"];
            wish.like = [obj objectForKey:@"like"];
            wish.attime = obj.updatedAt;
            
            BmobGeoPoint * point = [postObj objectForKey:@"location"];
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
            wish.distance = [NSString stringWithFormat:@"%.2fkm",meters/1000];
            [wishArray addObject:wish];
            
        }
        [wishTableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
        }
    }];
}

#pragma mark tableView
-(void)createTableView{
    
    wishTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64)];
    wishTableView.delegate  = self;
    wishTableView.dataSource = self;
    wishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:wishTableView];
    
    // 刷新功能
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = wishTableView;
    //添加上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = wishTableView;
    
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
 
    [self getDataSkip:_skip];
}

- (void)reloadDeals
{
    _skip = _skip + 15;
    [self getDataSkip:_skip];
}

#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WishTableViewCell * wishcell = [[WishTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"yw"];
    if(!wishcell){
        wishcell = [[[NSBundle mainBundle] loadNibNamed:@"yw" owner:self options:nil] lastObject];
    }
    WishModel * wish = wishArray[indexPath.row];
        
    NSURL * avatarimu = [NSURL URLWithString:wish.avatar];
    [wishcell.avatar sd_setImageWithURL:avatarimu];
    NSURL * imageimu = [NSURL URLWithString:wish.image];
    [wishcell.image sd_setImageWithURL:imageimu];
    wishcell.name.text = wish.name;

    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:wish.age];
    
    NSTimeInterval dateDiff = [d timeIntervalSinceNow];
    int age=trunc(dateDiff/(60*60*24))/365;
    wishcell.age.text = [NSString stringWithFormat:@"%d",-age];
    
       wishcell.context.text = wish.context;
    wishcell.like.text = [NSString stringWithFormat:@"%d",[wish.like intValue]];
    wishcell.comment.text = [NSString stringWithFormat:@"%d",[wish.comment intValue]];
    NSString * s = [NSString stringWithFormat:@"%@",[mistiming returnUploadTime:[NSString stringWithFormat:@"%@",wish.attime]]];
    CGRect rect = [s boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    wishcell.distance.text = [NSString stringWithFormat:@"%@   %@",wish.distance,s];
    
    wishcell.xian.center = CGPointMake(305-rect.size.width,wishcell.xian.center.y );
    
    return wishcell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return wishArray.count;}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailWishViewController * detailwish = [[DetailWishViewController alloc] init];
    WishModel * wish = wishArray[indexPath.row];
    
    detailwish.objectId = wish.obj.objectId;
    [self.navigationController pushViewController:detailwish animated:YES];
    
    
}


#pragma mark nabar
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
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"好友愿望";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];

    
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
