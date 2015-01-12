 //
//  RecentlyViewController.m
//  DSBBM
//
//  Created by bisheng on 14-10-13.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "RecentlyViewController.h"
#import "RecentlyTableViewCell.h"
#import "HelpNewsModel.h"
#import "friendInfoViewController.h"

@interface RecentlyViewController ()

@end
 
@implementation RecentlyViewController
{
    UITableView * recentlyTable;
    NSMutableArray * recentlyArray;
    NSMutableArray * charidArray;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int _skip;
    MBProgressHUD * HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    recentlyArray = [[NSMutableArray alloc] init];
    charidArray = [[NSMutableArray alloc] init];
    _skip = 0;
    if(self.i == 1){
        [self createGoBack];
    }else{
        [self createNarBar];
         [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:(DEMONavigationController *)self.navigationController  action:@selector(panGestureRecognized:)]];
    }
    [self getDateSkip:0];
    [self createTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNot) name:@"news" object:nil];
   
}

-(void)recieveNot{
    
    [self changeNaBar];
}

- (void)dealloc
{
    [_header removeFromSuperview];
    [_footer removeFromSuperview];
}

-(void)createGoBack{
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * narBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tou"]];
    narBar.frame = CGRectMake(0, 20, 320, 44);
    narBar.userInteractionEnabled = YES;
    [self.view addSubview:narBar];
    
    UIButton * sidebar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
 
    [sidebar setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [sidebar setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [sidebar addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [narBar addSubview:sidebar];
    
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"点赞用户";
    tit.font = [UIFont systemFontOfSize:18];
    tit.textColor = [UIColor whiteColor];
    tit.textAlignment = YES;
    [narBar addSubview:tit];

}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTable{
    recentlyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64)];
    recentlyTable.delegate = self;
    recentlyTable.dataSource = self;
    recentlyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:recentlyTable];
    
    // 刷新功能
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = recentlyTable;
    //添加上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = recentlyTable;
    
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
    _skip = _skip + 15;
    [self getDateSkip:_skip];
}


#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecentlyTableViewCell * recentlycell = [[RecentlyTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recently"];
    if(!recentlycell){
        recentlycell = [[[NSBundle mainBundle] loadNibNamed:@"recently" owner:self options:nil] lastObject];
    }
    HelpNewsModel * recently = recentlyArray[indexPath.row];
    NSURL * avatarimu = [NSURL URLWithString:recently.avatar];
    [recentlycell.avatar sd_setImageWithURL:avatarimu];
    
    recentlycell.nick.text = recently.nick;
    if([[[mistiming returnUploadTime:recently.time] substringToIndex:1] integerValue] != 0){
    if(self.i == 1){
        recentlycell.text.text = [NSString stringWithFormat:@"%@点了赞",[mistiming returnUploadTime:recently.time]];
    }else{
        recentlycell.text.text = [NSString stringWithFormat:@"%@访问了你",[mistiming returnUploadTime:recently.time]];
    }
    }else{
        if(self.i == 1){
            recentlycell.text.text = [NSString stringWithFormat:@"1分钟前点了赞"];
        }else{
            recentlycell.text.text = [NSString stringWithFormat:@"1分钟前访问了你"];
        }
    }
    CGRect nameRect = [recently.nick boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    if([[NSString stringWithFormat:@"%@",recently.msgType] isEqualToString:@"1"]){
        recentlycell.agev.image = [UIImage imageNamed:@"nanshengnianling"];
    }else{
        recentlycell.agev.image = [UIImage imageNamed:@"niushengnianling"];
    }
    recentlycell.agev.center = CGPointMake(nameRect.size.width + 100, recentlycell.agev.center.y);
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:recently.text];
    
    NSTimeInterval dateDiff = [d timeIntervalSinceNow];
    int age=trunc(dateDiff/(60*60*24))/365;
    recentlycell.age.text = [NSString stringWithFormat:@"%d",-age];
    if(indexPath.row == recentlyArray.count - 1){
        recentlycell.line.frame = CGRectMake(0, 79.5, 320, 0.5);
    }
    
    return recentlycell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return recentlyArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    BmobChatUser *user = charidArray[indexPath.row];
    [infoDic setObject:user.objectId forKey:@"uid"];
    [infoDic setObject:[user objectForKey:@"username"]forKey:@"name"];
    if ([user objectForKey:@"avatar"]) {
        [infoDic setObject:[user objectForKey:@"avatar"] forKey:@"avatar"];
    }
    if ([user objectForKey:@"nick"]) {
        [infoDic setObject:[user objectForKey:@"nick"] forKey:@"nick"];
    }

    friendInfoViewController * fivc = [[friendInfoViewController alloc] init];
    fivc.userId = user.objectId;
    fivc.userName = [user objectForKey:@"nick"];
    [self.navigationController pushViewController:fivc animated:YES];

}

-(void)getDateSkip:(int)skip{
   
    BmobUser * user = [BmobUser getCurrentObject];
    BmobQuery *bquery;
    if(self.i == 1){
        bquery = [BmobQuery queryWithClassName:@"WishMsg"];
        [bquery orderByDescending:@"updatedAt"];
        bquery.limit = 15;
        bquery.skip = skip;
        [bquery includeKey:@"fromUser"];
        [bquery whereKey:@"msgType" equalTo:[NSNumber numberWithInt:1]];
        [bquery whereKey:@"wish" equalTo:self.userObject];
    }else{
        bquery = [BmobQuery queryWithClassName:@"RecentVisitor"];
        bquery.limit = 15;
        bquery.skip = skip;
        [bquery orderByDescending:@"updatedAt"];
        [bquery includeKey:@"visitor"];
        [bquery whereKey:@"respondents" equalTo:user];
    }
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
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
         [recentlyArray removeAllObjects];
        }
        for (BmobObject * object in array) {
            HelpNewsModel * recently = [[HelpNewsModel alloc] init];
            BmobUser * bUser;
            if (self.i == 1) {
                bUser = [object objectForKey:@"fromUser"];
            }else{
               bUser = [object objectForKey:@"visitor"];
            }
            recently.time = [NSString stringWithFormat:@"%@",[object updatedAt]];
            recently.avatar = [bUser objectForKey:@"avatar"];
            recently.nick = [bUser objectForKey:@"nick"];
            recently.text = [bUser objectForKey:@"birthday"];
            recently.msgType = [NSString stringWithFormat:@"%@",[bUser objectForKey:@"sex"]];
            [charidArray addObject:bUser];
            [recentlyArray addObject:recently];
        }
            [HUD removeFromSuperview];
        [recentlyTable reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
        }
    }];
}


-(void)createNarBar{
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * narBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tou"]];
    narBar.frame = CGRectMake(0, 20, 320, 44);
    narBar.userInteractionEnabled = YES;
    [self.view addSubview:narBar];
    
    UIImageView * sidebar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sidebar.tag = 554;
    sidebar.image = [UIImage imageNamed:@"caidan"];
    sidebar.userInteractionEnabled = YES;
    [narBar addSubview:sidebar];
    
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    int m = 0;
    for (int j = 0 ; j < array.count ; j++) {
        BmobRecent * news = array[j];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3,20,20)];
        dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
        dotBack.tag = 555;
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
        UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,14, 14)];
        number.tag = 668;
        number.font = [UIFont systemFontOfSize:11];
        number.textColor = [UIColor whiteColor];
        number.textAlignment = NSTextAlignmentCenter;
        if(m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] >= 99){
            number.text = @"99";
        }else{
            number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
        }
        [dot addSubview:number];

    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3,20,20)];
            dotBack.tag = 555;
            dotBack.backgroundColor = [UIcol hexStringToColor:@"#FFD200"];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [sidebar addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3,14, 14)];
            dot.backgroundColor = [UIColor redColor];
            dot.layer.cornerRadius = 20;
        dot.tag = 557;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
    }
    UIButton * sideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sideBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] size:CGSizeMake(44, 44)] forState:UIControlStateHighlighted];
    [sideBtn addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sidebar addSubview:sideBtn];
    
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"最近来访";
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.font = [UIFont systemFontOfSize:18];
    tit.textColor = [UIColor whiteColor];
    tit.textAlignment = YES;
    [narBar addSubview:tit];
    
}

-(void)changeNaBar{
    UIView * dotBack = (id)[self.view viewWithTag:555];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
     UIImageView * sidebar = (id)[self.view viewWithTag:554];
    int m = 0;
    for (int j = 0 ; j < array.count ; j++) {
        BmobRecent * news = array[j];
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
            UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
            number.tag = 668;
            number.font = [UIFont systemFontOfSize:11];
            number.textColor = [UIColor whiteColor];
            number.textAlignment = NSTextAlignmentCenter;
            if(m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] >= 99){
                number.text = @"99";
            }else{
                number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            }
            [dot addSubview:number];

        }else{
            UILabel * number = (id)[self.view viewWithTag:668];
            if(number == nil){
                UIView * dot = (id)[self.view viewWithTag:557];
                number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
                number.tag = 668;
                number.font = [UIFont systemFontOfSize:11];
                number.textColor = [UIColor whiteColor];
                number.textAlignment = NSTextAlignmentCenter;
                [dot addSubview:number];
            }
            if(m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] >= 99){
                number.text = @"99";
            }else{
                number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            }
        }
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
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
            }else{
                UILabel * number = (id)[self.view viewWithTag:668];
                [number removeFromSuperview];
            }
        }else{
        [dotBack removeFromSuperview];
    }
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
