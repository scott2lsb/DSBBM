//
//  HelpNewsViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "HelpNewsViewController.h"
#import "HelpNewsModel.h"
#import "HelpNewsTableViewCell.h"
#import "DetailWishViewController.h"
#import "WishModel.h"

@interface HelpNewsViewController ()

@end

@implementation HelpNewsViewController
{
    UITableView * helpTableView;
    NSMutableArray * newsArray;
    NSMutableArray * wishArray;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    MBProgressHUD * HUD;
    int _skip;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        newsArray = [NSMutableArray array];
        wishArray = [NSMutableArray array];
        _skip = 0;
    }
    return self;
}

- (void)dealloc
{
    [_header removeFromSuperview];
    [_footer removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self createTableView];
    [self getData:_skip];
    NSNotification * center = [[NSNotification alloc] initWithName:@"detailsNews" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:center];
}

#pragma mark tableView
-(void)createTableView{
    
    helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64)];
    helpTableView.delegate = self;
    helpTableView.dataSource = self;
    helpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:helpTableView];
    
    // 刷新功能
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = helpTableView;
    //添加上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = helpTableView;
    
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
    [self getData:_skip];
}

- (void)reloadDeals
{
    _skip = _skip + 15;
    [self getData:_skip];
}


#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpNewsTableViewCell * newscell = [[HelpNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"news"];
    if(!newscell){
        newscell = [[[NSBundle mainBundle] loadNibNamed:@"news" owner:self options:nil] lastObject];
        
    }
    HelpNewsModel * news = newsArray[indexPath.row];
    CGSize size = [news.text boundingRectWithSize:CGSizeMake(180, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
    if(size.height < 20){
        size.height = 20;
    }
    
    newscell.nick.text = news.nick;
    
    if([news.msgType integerValue] == 1){
        [newscell addSubview:newscell.like];
    }else{
        newscell.text.frame = CGRectMake(75, 33,180, size.height);
        newscell.text.text = news.text;
    }
 
    if([[news.time substringToIndex:1] integerValue] == 0){
         newscell.time.text = @"1分钟前";
    }else{
         newscell.time.text = news.time;
    }

    newscell.time.frame = CGRectMake(75,size.height + 32, 100, 12);
   
    newscell.wish.frame = CGRectMake(260, 15,45, 45);
    newscell.wish.text = news.wish;
    
    NSURL * avatarimu = [NSURL URLWithString:news.avatar];
    [newscell.avatar sd_setImageWithURL:avatarimu];
    
    NSURL * wishimu = [NSURL URLWithString:news.wishImage];
    [newscell.wishImage sd_setImageWithURL:wishimu];
    
    if(size.height < 20){
        newscell.line.frame = CGRectMake(15, 79.5, 305, 0.5);
    }else{
        newscell.line.frame = CGRectMake(15, size.height + 59.5, 305, 0.5);
    }
    
    return newscell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return newsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpNewsModel * news = newsArray[indexPath.row];
    CGSize size = [news.text boundingRectWithSize:CGSizeMake(180, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
    if(size.height < 20)
        return 80;
    return size.height + 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailWishViewController * detailwish = [[DetailWishViewController alloc] init];
    WishModel * wish = wishArray[indexPath.row];
    
    detailwish.objectId = wish.obj.objectId;

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:detailwish animated:YES];
}

#pragma mark data
-(void)getData:(int)skip{
    
    BmobUser * bUser = [BmobUser getCurrentObject];
    BmobQuery *wishBquery = [BmobQuery queryWithClassName:@"WishMsg"];
    [wishBquery whereKey:@"toUser" equalTo:bUser];
    [wishBquery orderByDescending:@"createdAt"];
    wishBquery.limit = 15;
    wishBquery.skip = skip;
    [wishBquery includeKey:@"fromUser,toUser,wish"];
    [wishBquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
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
            [newsArray removeAllObjects];
        }
        for(BmobObject * obj in array){
            
            HelpNewsModel * news = [[HelpNewsModel alloc] init];
            news.nick = [[obj objectForKey:@"fromUser"] objectForKey:@"nick"];
            news.text = [obj objectForKey:@"content"];
            news.msgType = [obj objectForKey:@"msgType"];
            news.time = [mistiming returnUploadTime:[NSString stringWithFormat:@"%@",obj.createdAt]];
            news.avatar = [[obj objectForKey:@"fromUser"] objectForKey:@"avatar"];
            news.wish = [[obj objectForKey:@"wish"] objectForKey:@"text"];
            news.wishImage = [[obj objectForKey:@"wish"] objectForKey:@"url"];
            
            [newsArray addObject:news];
            
            WishModel * wish = [[WishModel alloc] init];
            wish.obj = [obj objectForKey:@"wish"];
            wish.name = [[obj objectForKey:@"toUser"] objectForKey:@"nick"];
            wish.charid = (id)[obj objectForKey:@"toUser"];
            wish.avatar = [[obj objectForKey:@"toUser"] objectForKey:@"avatar"];
            wish.image = [[obj objectForKey:@"wish"] objectForKey:@"url"];
            wish.age = [[obj objectForKey:@"toUser"] objectForKey:@"birthday"];
            wish.context = [[obj objectForKey:@"wish"] objectForKey:@"text"];
            wish.comment = [[obj objectForKey:@"wish"] objectForKey:@"comment"];
            wish.like = [[obj objectForKey:@"wish"] objectForKey:@"like"];
            BmobObject * timeobj = [obj objectForKey:@"wish"];
            wish.attime = timeobj.updatedAt;
            
            BmobGeoPoint * point = [[obj objectForKey:@"toUser"] objectForKey:@"location"];
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
        [helpTableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
        }
    }];
    
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
    
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"评论";
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
