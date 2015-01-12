//
//  MyWishViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "MyWishViewController.h"
#import "WishTableViewCell.h"
#import "WishModel.h"
#import "DetailWishViewController.h"
#import "AddWishViewController.h"

@interface MyWishViewController ()

@end

@implementation MyWishViewController
{
    UITableView * wishTableView;
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
        wishArray = [NSMutableArray array];
        _skip = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self createNaBar];
    [self createTableView];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getDataSikp:_skip];
}

- (void)dealloc
{
    [_header removeFromSuperview];
    [_footer removeFromSuperview];
}

-(void)getDataSikp:(int)skip{
//    BmobUser * user = [BmobUser getCurrentUser];
  
    BmobQuery *wishBquery = [BmobQuery queryWithClassName:@"Wish"];
    wishBquery.limit = 15;
    wishBquery.skip = skip;
    [wishBquery whereKey:@"user" equalTo:_userId];
    [wishBquery includeKey:@"user"];
    [wishBquery orderByDescending:@"createdAt"];
    [wishBquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [HUD removeFromSuperview];
        if(_skip == 0){
            [wishArray removeAllObjects];
        }
        for (BmobObject *obj in array) {
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
            [wishArray addObject:wish];
            
        }
        [wishTableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
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
    
    [self getDataSikp:_skip];
}

- (void)reloadDeals
{
      _skip = _skip + 15;
    [self getDataSikp:_skip];
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

    wishcell.distance.text = [NSString stringWithFormat:@"%@",[mistiming returnUploadTime:[NSString stringWithFormat:@"%@",wish.attime]]];
    
    
    
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
    detailwish.number = 1;
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
    
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
    
    BmobUser * user = [BmobUser getCurrentObject];
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    if([_userId isEqualToString:user.objectId]){
        titleBar.text = @"我的愿望";
    }else{
        titleBar.text = self.userName;
    }
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
    if([self.userName isEqualToString:@""]){
        UIButton * publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(266, 0, 54, 44)];
        [publishBtn setImage:[UIcol imageWithColor:[UIColor clearColor] size:CGSizeMake(70, 44)] forState:UIControlStateNormal];
        [publishBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0.9 green:0.74 blue:0 alpha:1] size:CGSizeMake(70, 44)] forState:UIControlStateHighlighted];
        [publishBtn addTarget:self action:@selector(addWish) forControlEvents:UIControlEventTouchUpInside];
        UILabel * publishLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
        publishLab.text = @"新增";
        publishLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
        publishLab.shadowOffset = CGSizeMake(1, 0.5);
        publishLab.textColor = [UIColor whiteColor];
        [publishBtn addSubview:publishLab];
        [iv addSubview:publishBtn];
    }
}

-(void)addWish{
    
    AddWishViewController * awvc = [[AddWishViewController alloc] init];
    awvc.k = 2;
    [self.navigationController pushViewController:awvc animated:YES];
    
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
