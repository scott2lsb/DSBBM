//
//  friendViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.

#import "FriendsViewController.h"
#import "WishModel.h"

#import "friendModel.h"
#import "WishTableViewCell.h"
#import "FriendTableViewCell.h"
#import "AddWishViewController.h"
#import "DetailWishViewController.h"
#import "NewsViewController.h"

#import "sqlStatusTool.h"
#import "friendDatumViewController.h"
#import "SearchViewController.h"
#import "friendInfoViewController.h"


//屏幕宽度
#define Main_Screen_Width   [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define Main_Screen_Height  [UIScreen mainScreen].bounds.size.height

@interface FriendsViewController ()<cancelFriendDelegate>

@end

@implementation FriendsViewController
{
    
    UITableView * recommendTable;
    NSMutableArray * recommendArray;
    UITableView * nearWishTable;
    NSMutableArray * nearWishArray;
    UITableView * nearHelpTable;
    NSMutableArray * nearHelpArray;
    BmobObject * postObj;
    
    MJRefreshHeaderView *_header1;
    MJRefreshFooterView *_footer1;
    int _skip1;
    
    MJRefreshHeaderView *_header2;
    MJRefreshFooterView *_footer2;
    int _skip2;
    
    MJRefreshHeaderView *_header3;
    MJRefreshFooterView *_footer3;
    int _skip3;
    
    NSArray *tempArray;
    //要传送的所有的关注+朋友
    NSMutableArray *allFollowArray;
    //黑名单
//    NSMutableArray *blackList;
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self) {
        
        
        recommendArray  = [[NSMutableArray alloc] init];
        nearWishArray = [[NSMutableArray alloc] init];
        nearHelpArray = [[NSMutableArray alloc] init];
        allFollowArray = [NSMutableArray array];
//        blackList = [NSMutableArray array];
        
        //
        _skip1 = 0;
        _skip2 = 0;
        _skip3 = 0;
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
    
   
    [self getRecommendSkip:_skip1];
    [self getNearHelpSkip:_skip2];
    [self getNearWishSkip:_skip3];
    
}

- (void)refreshTable
{
    [self performSelector:@selector(refreshDate1) withObject:nil afterDelay:0];
    [self performSelector:@selector(refreshDate2) withObject:nil afterDelay:0];
    [self performSelector:@selector(refreshDate3) withObject:nil afterDelay:0];

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

-(void)createNarBar{
    UIImageView * narBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tou"]];
    narBar.frame = CGRectMake(0, 20, Main_Screen_Width, 44);
    narBar.userInteractionEnabled = YES;
    [self.view addSubview:narBar];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    titleBar.text = @"朋友";
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [narBar addSubview:titleBar];
    
    //菜单
    UIButton * sidebar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sidebar setImage:[UIImage imageNamed:@"caidan"] forState:UIControlStateNormal];
    [sidebar setImage:[UIImage imageNamed:@"caidanselect"] forState:UIControlStateHighlighted];
    [sidebar addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [narBar addSubview:sidebar];
    
    //搜索
    //菜单页按钮的宽和高
#define menuBtnWidth 20.0f
#define menuBtnHeight 26.0f
#define barViewHeight 44.0f
    //搜索按钮
    UIButton *sousuo = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 29, barViewHeight/2-menuBtnHeight/2, menuBtnWidth, menuBtnHeight)];
    
    sousuo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sousuoBtn.png"]];
    [sousuo addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    sousuo.tag = 1000+10;
    [narBar addSubview:sousuo];
    
    
}

- (void)btnClick:(UIButton *)btn
{
    //点击进入搜索界面
    SearchViewController *searchControl = [[SearchViewController alloc] init];
    [self presentViewController:searchControl animated:YES completion:^{
        
    }];
    
}

-(void)createTabBar{

    UIButton * tabBar = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, Main_Screen_Width, 44)];
    [tabBar addTarget:self action:@selector(tabBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar setImage:[UIImage imageNamed:@"xuyuan"] forState:UIControlStateNormal];
    [tabBar setImage:[UIImage imageNamed:@"xuyuanchuji"] forState:UIControlStateHighlighted];

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
    v.backgroundColor = [UIColor blackColor];
    v.userInteractionEnabled = YES;
    
    UIView * back = (UIView *)[self.view viewWithTag:2000];
    [back addSubview:v];
    
    //时间 距离 推荐
    UIView * shi = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, 32)];
    shi.backgroundColor = [UIcol hexStringToColor:@"#f8f5fb"];
    [v addSubview:shi];
    
    UILabel * timetext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width/3,30)];
    timetext.text = @"好友";
    timetext.font = [UIFont systemFontOfSize:13];
    timetext.textAlignment = NSTextAlignmentCenter;
    timetext.textColor = [UIcol hexStringToColor:@"#f58223"];
    timetext.tag = 2101;
    [shi addSubview:timetext];
    
    UIButton * timebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width/3, 32)];
    timebtn.tag = 2121;
    [timebtn addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    [shi addSubview:timebtn];
    
    
    UILabel * distancetext = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/3,0 , Main_Screen_Width/3,30)];
    distancetext.text = @"关注";
    distancetext.textAlignment = NSTextAlignmentCenter;
    distancetext.font = [UIFont systemFontOfSize:13];
    distancetext.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    distancetext.tag = 2102;
    [shi addSubview:distancetext];
    
    UIButton * distancebtn = [[UIButton alloc] initWithFrame:CGRectMake( Main_Screen_Width/3, 0, Main_Screen_Width/3, 32)];
    distancebtn.tag = 2122;
    [distancebtn addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    [shi addSubview:distancebtn];
    
    
    UILabel * recommendtext = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/3 * 2, 0, Main_Screen_Width/3, 30)];
    recommendtext.text = @"粉丝";
    recommendtext.textAlignment = NSTextAlignmentCenter;
    recommendtext.font = [UIFont systemFontOfSize:13];
    recommendtext.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    recommendtext.tag = 2103;
    [shi addSubview:recommendtext];
    
    UIButton * recommendbtn = [[UIButton alloc] initWithFrame:CGRectMake( Main_Screen_Width/3 * 2, 0, Main_Screen_Width/3, 32)];
    recommendbtn.tag = 2123;
    [recommendbtn addTarget:self action:@selector(animation:) forControlEvents:UIControlEventTouchUpInside];
    [shi addSubview:recommendbtn];
    
    
    // line
    
    UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huadongxian"]];
    line.frame = CGRectMake(0, 30, 107, 2);
    line.tag = 2200;
    [shi addSubview:line];
    
    
    //  ScrollView
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 97, Main_Screen_Width, self.view.bounds.size.height )];
    sv.tag = 3000;
    sv.backgroundColor = [UIColor whiteColor];
    sv.contentSize = CGSizeMake(Main_Screen_Width * 3, self.view.bounds.size.height - 91 -44);
    sv.pagingEnabled = YES;
    sv.delegate =self;
    [v addSubview:sv];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 97, Main_Screen_Width ,32)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sousuo.png"]];
//    [v addSubview:view];
    
    
    
    
    //   时间Table
    recommendTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.view.bounds.size.height)];
    
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
    nearWishTable = [[UITableView alloc] initWithFrame:CGRectMake(Main_Screen_Width, 0, Main_Screen_Width, self.view.bounds.size.height)];
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
    nearHelpTable = [[UITableView alloc] initWithFrame:CGRectMake(640, 0, Main_Screen_Width, self.view.bounds.size.height)];
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
    
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    [sqlStatusTool deleteSql];
    [allFollowArray removeAllObjects];
    
    if (_header1 == refreshView)
    {
        
        [self performSelector:@selector(refreshDate1) withObject:nil afterDelay:2];
        
    } else if(_footer1 == refreshView){
        
        [self performSelector:@selector(reloadDeals1) withObject:nil afterDelay:2];
    }else if (_header2 == refreshView)
    {
//        [self refreshDate2];
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
    _skip1 = 0;
    [recommendArray removeAllObjects];
    NSLog(@"%d", recommendArray.count);
    [self getRecommendSkip:_skip1];
}

- (void)reloadDeals1{
    _skip1 = _skip1 + 15;
    [self getRecommendSkip:_skip1];
}

-(void)refreshDate2{
    _skip2 = 0;
    [nearWishArray removeAllObjects];
    NSLog(@"%d", nearWishArray.count);
    [self getNearWishSkip:_skip2];
}

- (void)reloadDeals2{
    _skip2 = _skip2 + 15;
    [self getNearWishSkip:_skip2];
}

-(void)refreshDate3{
    _skip3 = 0;
    [nearHelpArray removeAllObjects];
    [self getNearHelpSkip:_skip3];
}

- (void)reloadDeals3{
    _skip3 = _skip3 + 15;
    [self getNearHelpSkip:_skip3];
}


-(void)animation:(UIButton *)but{
    UIView * x = (id)[self.view viewWithTag:2200];
    UIScrollView * sv = (id)[self.view viewWithTag:3000];
    if(but.tag == 2121){
        
        UILabel * l1 = (id)[self.view viewWithTag:2101];
        l1.textColor = [UIcol hexStringToColor:@"#f58223"];
        UIImageView * iv1 = (id)[self.view viewWithTag:2111];
        iv1.image = [UIImage imageNamed:@"时间"];
        
        UILabel * l2 = (id)[self.view viewWithTag:2102];
        l2.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        UIImageView * iv2 = (id)[self.view viewWithTag:2112];
        iv2.image = [UIImage imageNamed:@"位置(未选）"];
        
        UILabel * l3 = (id)[self.view viewWithTag:2103];
        l3.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        UIImageView * iv3 = (id)[self.view viewWithTag:2113];
        iv3.image = [UIImage imageNamed:@"热门(未选）"];
        
        [UIView animateWithDuration:0.5 animations:^{
            x.center = CGPointMake(Main_Screen_Width/6, x.center.y);
        }];
        
        [sv setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
    }else if(but.tag == 2122){
        
        UILabel * l1 = (id)[self.view viewWithTag:2101];
        l1.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        UIImageView * iv1 = (id)[self.view viewWithTag:2111];
        iv1.image = [UIImage imageNamed:@"时间（未选）"];
        UILabel * l2 = (id)[self.view viewWithTag:2102];
        l2.textColor = [UIcol hexStringToColor:@"#f58223"];
        UIImageView * iv2 = (id)[self.view viewWithTag:2112];
        iv2.image = [UIImage imageNamed:@"位置"];
        UILabel * l3 = (id)[self.view viewWithTag:2103];
        l3.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        UIImageView * iv3 = (id)[self.view viewWithTag:2113];
        iv3.image = [UIImage imageNamed:@"热门(未选）"];
        [UIView animateWithDuration:0.5 animations:^{
            x.center = CGPointMake(160, x.center.y);
        }];
        [sv setContentOffset:CGPointMake(Main_Screen_Width, 0) animated:YES];
    }else {
        
        UILabel * l1 = (id)[self.view viewWithTag:2101];
        l1.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        UIImageView * iv1 = (id)[self.view viewWithTag:2111];
        iv1.image = [UIImage imageNamed:@"时间（未选）"];
        UILabel * l2 = (id)[self.view viewWithTag:2102];
        l2.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        UIImageView * iv2 = (id)[self.view viewWithTag:2112];
        iv2.image = [UIImage imageNamed:@"位置(未选）"];
        UILabel * l3 = (id)[self.view viewWithTag:2103];
        l3.textColor = [UIcol hexStringToColor:@"#f58223"];
        UIImageView * iv3 = (id)[self.view viewWithTag:2113];
        iv3.image = [UIImage imageNamed:@"热门"];
        [UIView animateWithDuration:0.5 animations:^{
            x.center = CGPointMake(Main_Screen_Width/6 * 5, x.center.y);
        }];
        [sv setContentOffset:CGPointMake(Main_Screen_Width*2, 0) animated:YES];
    }
    
}



//朋友
//syncFriends 云端代码
/*
 
 [BmobCloud callFunctionInBackground:@"sayhello" withParameters:nil block:^(id object, NSError *error) {
 if (error) {
 NSLog(@"error %@",[error description]);
 }
 NSLog(@"object      %@",object);
 }] ;
 
 */

-(void)getRecommendSkip:(int)skip{
    
    //时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//转为字符型
    NSLog(@"timeString:%@",timeString);
    
    //
    BmobUser *bUser = [BmobUser getCurrentObject];
    
    NSMutableArray *friendsArray = [[NSMutableArray alloc]init];
    
    friendsArray = [sqlStatusTool readFromSqlite:@"0"];
    NSLog(@"friendsArray = %d", friendsArray.count);
  
    recommendArray = friendsArray;
    
    //如果数据库中存在数据
    if (friendsArray.count) {
     
        //添加数据
        for (int i = 0; i < friendsArray.count; i ++) {
            friendModel *model = friendsArray[i];
            [allFollowArray addObject:model];
            
            if ([model.isBlack isEqualToString:@"1"]) {
                [recommendArray removeObject:model];
            }
        }

        NSLog(@"recommendArray.count = %d", recommendArray.count);
        
        [recommendTable reloadData];
        [_header1 endRefreshing];
        [_footer1 endRefreshing];
        
        
    }else{//若不存在数据，从网上加载数据
        //查询，等于ID的粉丝
//        BmobUser *bUser = [BmobUser getCurrentObject];
        //
        NSDictionary *parameters =  @{@"uid": bUser.objectId,@"timestamp": @"0"};
        
        [BmobCloud callFunctionInBackground:@"syncFriends2" withParameters:parameters block:^(id object, NSError *error) {
            if (error) {
                NSLog(@"error %@",[error description]);
            }
//            NSLog(@"%@",object);
            
            NSArray *friends = [[NSArray alloc]init];
            
            
            NSArray *blackList = [object objectForKey:@"blacklist"];
            friends = [object objectForKey:@"friends"];
            
            for(int i= 0 ; i <  friends.count;i++){
                
                NSMutableDictionary *dict = friends[i];
                
                for (BmobObject *bj in blackList) {
                     NSLog(@"就是你，%@",[bj objectForKey:@"nick"]);
                    if ([[bj objectForKey:@"nick"] isEqualToString:dict[@"nick"]]) {
                       
                        //包装
                        [dict setValue:@"1" forKey:@"isblack"];
//                        [recommendArray removeObject:friend];
                    }else [dict setValue:@"0" forKey:@"isblack"];
                    
                }
                friendModel *friend = [self friendDataToModel:dict type:@"0"];
                //如果黑名单中没有则显示
                if ([dict[@"isblack"] isEqualToString:@"1"]) {
                    
                }else
                {
                    [recommendArray addObject:friend];
                }
                [allFollowArray addObject:friend];
                
            }
            
            [recommendTable reloadData];
            [_header1 endRefreshing];
            [_footer1 endRefreshing];
            
        }] ;

    }
    
     NSLog(@"朋友");

}


- (friendModel *)friendDataToModel:(NSDictionary *)dict type:(NSString *)type
{
    friendModel * friend = [[friendModel alloc] init];
    
    friend.userlName = dict[@"username"];
    friend.userId = dict[@"objectId"];
    NSString *name = [dict[@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    friend.nickName = name;
    friend.userUrl = dict[@"avatar"];
    friend.personAge = dict[@"birthday"];
    friend.status = dict[@"status"];
    BOOL cheatMode = [dict[@"sex"] boolValue];
//    friend.userSex
    friend.userSex = [NSString stringWithFormat:@"%hhd", cheatMode ];
    friend.createdDateAt = dict[@"createdAt"];
    friend.UserupDateAt = dict[@"updatedAt"];
    
//    BOOL b = [dict[@"isblack"] boolValue];
    friend.isBlack = dict[@"isblack"];
    
    friend.type = type;
    
    [sqlStatusTool saveModelWithDict:friend];
    NSLog(@"这里是存醋数据的那个，到那时为什么啊%@", friend.userSex);
    
    return friend;
    
}


//关注
-(void)getNearWishSkip:(int)skip{
    
    BmobUser *bUser = [BmobUser getCurrentObject];
    
    NSMutableArray *friendsArray = [[NSMutableArray alloc]init];
    
    friendsArray = [sqlStatusTool readFromSqlite:@"1"];
    
    nearWishArray = friendsArray;
    
    //如果数据库中存在数据
    if (friendsArray.count) {
        
        //添加数据
        for (int i = 0; i < friendsArray.count; i ++) {
            friendModel *model = friendsArray[i];
            [allFollowArray addObject:model];
            
            if ([model.isBlack isEqualToString:@"1"]) {
                [nearWishArray removeObject:model];
            }
        }
        
        
        [nearWishTable reloadData];
        [_header2 endRefreshing];
        [_footer2 endRefreshing];
        
    }else{

    
    //查询，等于ID的关注
//    BmobUser *bUser = [BmobUser getCurrentObject];
    //
        NSDictionary *parameters =  @{@"uid": bUser.objectId,@"timestamp": @"0"};
        
        [BmobCloud callFunctionInBackground:@"syncFriends2" withParameters:parameters block:^(id object, NSError *error) {

        if (error) {
            NSLog(@"error %@",[error description]);
        }
        NSLog(@"ssss   %@\n11111111111111",object);
        NSArray *follows = [[NSArray alloc]init];
        NSArray *blackList = [object objectForKey:@"blacklist"];
        if ([object objectForKey:@"follows"]) {
            follows = [object objectForKey:@"follows"];
            
        }
//        NSArray *follows = [object objectForKey:@"follows"];
        
     
        for(int i= 0 ; i < follows.count;i++){
        //可合并
            NSDictionary *dict = follows[i];
            
            for (BmobObject *bj in blackList) {
                NSLog(@"就是你，%@",[bj objectForKey:@"nick"]);
                
                if ( [[bj objectForKey:@"nick"] isEqualToString:dict[@"nick"]]) {
                    
                    //包装
                    [dict setValue:@"1" forKey:@"isblack"];
                    //                        [recommendArray removeObject:friend];
                }else [dict setValue:@"0" forKey:@"isblack"];
                
            }
            
            friendModel *friend = [self friendDataToModel:dict type:@"1"];
            //如果黑名单中没有则显示
            if ([dict[@"isblack"] isEqualToString:@"1"]) {
                
            }else
            {
                [nearWishArray addObject:friend];
            }
            [allFollowArray addObject:friend];
            
        }

     
        [nearWishTable reloadData];
        [_header2 endRefreshing];
        [_footer2 endRefreshing];
    
    }] ;

    }
    
   
     NSLog(@"关注");
    
}

//粉丝
-(void)getNearHelpSkip:(int)skip{
    
    NSMutableArray *friendsArray = [[NSMutableArray alloc]init];
    
    friendsArray = [sqlStatusTool readFromSqlite:@"2"];
    
    
    //如果数据库中存在数据
    if (friendsArray.count) {
        
        nearHelpArray = friendsArray;
        
        [nearHelpTable reloadData];
        [_header3 endRefreshing];
        [_footer3 endRefreshing];
        
    }else{
        
    //查询，等于ID的粉丝
    BmobUser *bUser = [BmobUser getCurrentObject];
    //
        NSDictionary *parameters =  @{@"uid": bUser.objectId,@"timestamp": @"0"};
//        parameters objectForKeyedSubscript:<#(id)#>
        [BmobCloud callFunctionInBackground:@"syncFriends2" withParameters:parameters block:^(id object, NSError *error) {

        if (error) {
            NSLog(@"error %@",[error description]);
        }
        //fans
        
//        NSLog(@"%@",[object objectForKey:@"fans"]);
            NSArray *fans = [[NSArray alloc]init];
            if ([object objectForKey:@"fans"]) {
                fans = [object objectForKey:@"fans"];
            }
            
           
        
        for(int i= 0 ; i <  fans.count;i++){
            
            NSDictionary *dict = fans[i];
            
            friendModel *friend = [self friendDataToModel:dict type:@"2"];

            
            
            [nearHelpArray addObject:friend];
        }
        [nearHelpTable reloadData];
        [_header3 endRefreshing];
        [_footer3 endRefreshing];
        
    }] ;
         
    }
    NSLog(@"粉丝");
  }


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    FriendTableViewCell *friendcell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (friendcell == nil) {
        friendcell = [[FriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    
    //朋友模型
    friendModel * friend;
    
    //判断是哪一个tableview
    if(tableView.tag == 300){
        friend = recommendArray[indexPath.row];
        
    }else if (tableView.tag == 301){
        friend = nearWishArray[indexPath.row];
        
    }else{
        friend = nearHelpArray[indexPath.row];
    }
    
#warning 缺少大v的数据
    
    NSURL * iconUrl = [NSURL URLWithString:friend.userUrl];
    //圆形头像
    [friendcell.Headimg sd_setImageWithURL:iconUrl];
    
    friendcell.Age.image = nil;

    //判断型别
    if ([friend.userSex isEqualToString:@"1"]) {
        friendcell.Age.image = [UIImage imageNamed:@"nanshengnianling"];
    }else
    {
        friendcell.Age.image = [UIImage imageNamed:@"niushengnianling"];
    }
    
    
    //年龄
    if (friend.personAge) {
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd"];
        NSDate *d=[date dateFromString:friend.personAge];
        
        NSTimeInterval dateDiff = [d timeIntervalSinceNow];
        int age=trunc(dateDiff/(60*60*24))/365;
        friendcell.AgeLabe.text = [NSString stringWithFormat:@"%d",-age];
    }
    
    //姓名
    friendcell.Namelab.text = friend.nickName;
    NSLog(@"cell的");
    return friendcell;
    
    /*
   
     */
    
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
    NSLog(@"行数");
    if(tableView.tag == 300){
        return recommendArray.count;
    }else if(tableView.tag == 301){
        NSLog(@"umberOfRows = %d", nearWishArray.count);
        return nearWishArray.count;
        
    }else{
        return nearHelpArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > 640)
        return;
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
                x.center = CGPointMake(Main_Screen_Width/6, x.center.y);
            }];
            
            
            
        }else if(scrollView.contentOffset.x == Main_Screen_Width){
            
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
                x.center = CGPointMake(Main_Screen_Width/6*5+1, x.center.y);
            }];
            
            
        }
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    friendModel * friend;
    if(tableView.tag == 300){
        friend = recommendArray[indexPath.row];
    }else if (tableView.tag == 301){
        friend = nearWishArray[indexPath.row];
    }else if (tableView.tag == 302){
        friend = nearHelpArray[indexPath.row];
    }

    NSLog(@"allFollowArray = %d", allFollowArray.count);
    for (friendModel *model in allFollowArray) {
//        NSLog(@"nickName = %@", model.nickName);
    }
    friendInfoViewController *userData = [[friendInfoViewController alloc] init];
    userData.delegete  = self;
    userData.userId = friend.userId;
    userData.userName = friend.nickName;
    userData.furcation = 2;
    userData.allFollows = allFollowArray;
    [self.navigationController pushViewController:userData animated:YES]; 
  }






- (void)cancelFriend:(int)time
{
    NSLog(@"这就是我的取消");
    [self refreshTable];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

