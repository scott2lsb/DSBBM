//
//  ChooseWishViewController.m
//  DSBBM
//
//  Created by bisheng on 14-10-15.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "ChooseWishViewController.h"
#import "AddWishViewController.h"
#import "ChooseWishTableViewCell.h"
#import "LampViewController.h"

@interface ChooseWishViewController ()

@end

@implementation ChooseWishViewController
{
    UITableView * wishTableView;
    NSMutableArray * wishArray;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int _skip;
    int frist ;
    int k;
    MBProgressHUD * HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _skip = 0;
    [self createNaBar];
    [self createTable];
}

- (void)dealloc
{
    [_header removeFromSuperview];
    [_footer removeFromSuperview];
}

#pragma mark tableView
-(void)createTable{
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
    [self getDateSkip:_skip];
}

- (void)reloadDeals
{
    _skip = _skip + 15;
    [self getDateSkip:_skip];
}


#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseWishTableViewCell * wishcell = [[ChooseWishTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"choose"];
    if(!wishcell){
        wishcell = [[[NSBundle mainBundle] loadNibNamed:@"choose" owner:self options:nil] lastObject];
        
    }
    WishModel * wish = wishArray[indexPath.row];
    wishcell.content.text = wish.context;
    CGSize size = [wish.context boundingRectWithSize:CGSizeMake(250, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    wishcell.content.frame = CGRectMake(15, 15, 250, size.height + 5);
    wishcell.picture.frame = CGRectMake(15, 30 + size.height, 70, 70);
    NSURL * imageimu = [NSURL URLWithString:wish.image];
    [wishcell.picture sd_setImageWithURL:imageimu];
    int i = 0;
    if(![wish.image isEqualToString:@""] && wish.image != nil && ![wish.image isEqualToString:@"(null)"] ){
        i = 80;
    }
    wishcell.line.frame = CGRectMake(0, size.height + 45.5 + i, 320,0.5);
    wishcell.likeIcon.frame = CGRectMake(15, size.height + 24.5 + i, 12, 12);
    wishcell.commentIcon.frame = CGRectMake(77, size.height + 24.5 + i, 12, 12);
    
    wishcell.like.frame = CGRectMake(32, size.height + 24.5 + i,45, 14);
    wishcell.comment.frame = CGRectMake(94, size.height + 24.5 + i,45,14);
    wishcell.like.text = [NSString stringWithFormat:@"%d",[wish.like intValue]];
    wishcell.comment.text = [NSString stringWithFormat:@"%d",[wish.comment intValue]];
    if(indexPath.row == 0){
        if(self.wishObject.distance == nil){
            wishcell.choose.image = [UIImage imageNamed:@"weixuanze"];
        }else{
            wishcell.choose.image = [UIImage imageNamed:@"xuanze"];
            k = 3;
        }
    }else{
        wishcell.choose.image = [UIImage imageNamed:@"weixuanze"];
    }
    wishcell.choose.center = CGPointMake(self.view.bounds.size.width - 26.5,(size.height + 46 + i)/2);
    
    return wishcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishModel * wish = wishArray[indexPath.row];
    
    BmobQuery * query = [BmobUser query];
    BmobUser * user= [BmobUser getCurrentUser];
    [query getObjectInBackgroundWithId:user.objectId block:^(BmobObject *object, NSError *error) {
   if (!error) {
        if (object) {
            BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
         
            [obj setObject:[BmobObject objectWithoutDatatWithClassName:@"Wish" objectId:wish.distance] forKey:@"showWish"];
            //异步更新数据
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(!error){
                    if(k != 3){
                        frist = 1;
                    }
                     NSArray * array = self.navigationController.viewControllers;
                    LampViewController * lvc;
                    for (int i = 0 ; i < array.count ; i++) {
                        if([[NSString stringWithFormat:@"%@",[array[i] class]]isEqualToString:@"LampViewController"]){
                            lvc = array[i];
                        }
                    }

                    lvc.frist = frist;
                    [self.navigationController popToViewController:lvc animated:YES];
                }
            }];
        }
    }else{
        //进行错误处理
    }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return wishArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WishModel * wish = wishArray[indexPath.row];
    CGSize size = [wish.context boundingRectWithSize:CGSizeMake(250, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    
    if(![wish.image isEqualToString:@""] && wish.image != nil && ![wish.image isEqualToString:@"(null)"] ){
        return size.height + 126;
    }
    return size.height + 46;
}



-(void)getDateSkip:(int)skip{
    
    BmobUser * user = [BmobUser getCurrentUser];
    BmobQuery *wishBquery = [BmobQuery queryWithClassName:@"Wish"];
    wishBquery.limit = 15;
    wishBquery.skip = skip;
    [wishBquery whereKey:@"user" equalTo:user];
    [wishBquery includeKey:@"user"];
    [wishBquery whereKey:@"objectId" notEqualTo:self.wishObject.distance];
    [wishBquery  orderByAscending:@"updateAt"];
    [wishBquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
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
                if(self.wishObject.distance != nil){
                    WishModel * wish = [[WishModel alloc] init];
                    wish.image = self.wishObject.image;
                    wish.context = self.wishObject.context;
                    wish.comment = self.wishObject.comment;
                    wish.like = self.wishObject.like;
                    wish.distance = self.wishObject.distance;
                    [wishArray addObject:wish];
                }
            }
        for (BmobObject *obj in array) {
            WishModel * wish = [[WishModel alloc] init];
            wish.image = [obj objectForKey:@"url"];
            wish.context = [obj objectForKey:@"text"];
            wish.comment = [obj objectForKey:@"comment"];
            wish.like = [obj objectForKey:@"like"];
            wish.distance = [obj objectId];
           [wishArray addObject:wish];
        
        }
        [wishTableView reloadData];
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
    UIButton * publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(266, 0, 54, 44)];
    [publishBtn setImage:[UIcol imageWithColor:[UIColor clearColor] size:CGSizeMake(70, 44)] forState:UIControlStateNormal];
    [publishBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0.9 green:0.74 blue:0 alpha:1] size:CGSizeMake(70, 44)] forState:UIControlStateHighlighted];
    [publishBtn addTarget:self action:@selector(addWish) forControlEvents:UIControlEventTouchUpInside];
    UILabel * publishLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    publishLab.text = @"添加";
    publishLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    publishLab.shadowOffset = CGSizeMake(1, 0.5);
    publishLab.textColor = [UIColor whiteColor];
    [publishBtn addSubview:publishLab];
    [iv addSubview:publishBtn];

    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"选择愿望";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];

   
}

-(void)addWish{
    AddWishViewController * awvc = [[AddWishViewController alloc] init];
    awvc.k = 1;
    if(k != 3){
        awvc.frist = 1;
    }
    [self.navigationController pushViewController:awvc animated:YES];
}

-(void)goBack{
    NSArray * array = self.navigationController.viewControllers;
    LampViewController * lvc;
    for (int i = 0 ; i < array.count ; i++) {
        if([[NSString stringWithFormat:@"%@",[array[i] class]]isEqualToString:@"LampViewController"]){
            lvc = array[i];
        }
    }
    lvc.frist = frist;
    [self.navigationController popToViewController:lvc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    if(wishArray == nil){
        wishArray = [[NSMutableArray alloc] init];
    }else{
        [wishArray removeAllObjects];
    }
    WishModel * wish = [[WishModel alloc] init];
    wish.image = self.wishObject.image;
    wish.context = self.wishObject.context;
    wish.comment = self.wishObject.comment;
    wish.like = self.wishObject.like;
    wish.distance = self.wishObject.distance;
    if(wish.context == nil){
    }else{
    [wishArray addObject:wish];
    }
    [self getDateSkip:_skip];

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
