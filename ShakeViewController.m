//
//  ShakeViewController.m
//  DSBBM
//
//  Created by bisheng on 14-12-1.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "ShakeViewController.h"
#import "RecentlyTableViewCell.h"
#import "friendInfoViewController.h"

@interface ShakeViewController ()

@end

@implementation ShakeViewController
{
    NSArray * shakeArray;
    UITableView * shakeTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self getData];
    [self createTable];
}

-(void)getData{

    shakeArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"alading"];
  
    
}

-(void)createTable{
    
    shakeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
    shakeTable.delegate = self;
    shakeTable.dataSource = self;
    shakeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:shakeTable];

}

#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecentlyTableViewCell * recentlycell = [[RecentlyTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recently"];
    if(!recentlycell){
        recentlycell = [[[NSBundle mainBundle] loadNibNamed:@"recently" owner:self options:nil] lastObject];
    }
    
    recentlycell.nick.text = [shakeArray[indexPath.row] objectForKey:@"nick"];
    NSURL * imageimu = [NSURL URLWithString:[shakeArray[indexPath.row] objectForKey:@"avatar"]];
    [recentlycell.avatar sd_setImageWithURL:imageimu];
    recentlycell.text.text = [NSString stringWithFormat:@"%@摇到了你", [mistiming returnUploadTime:[NSString stringWithFormat:@"%@",[shakeArray[indexPath.row] objectForKey:@"atTime"] ] ]];
    
    return recentlycell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    friendInfoViewController * udvc = [[friendInfoViewController alloc] init];
    udvc.userId = [shakeArray[indexPath.row] objectForKey:@"objectId"];
    udvc.userName = [shakeArray[indexPath.row] objectForKey:@"nick"];
    udvc.furcation = 2;
    [self.navigationController pushViewController:udvc animated:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return shakeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
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
    titleBar.text = @"阿拉丁神灯";
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
