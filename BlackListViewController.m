//
//  BlackListViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-10-7.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "BlackListViewController.h"
#import "sqlStatusTool.h"
#import "friendInfoViewController.h"
#import "isBlackTool.h"

@interface BlackListViewController ()
{
    BmobUser * user;
    NSArray * blackArray;
    UITableView * blackTableView;
}
@end

@implementation BlackListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         user = [BmobUser getCurrentObject];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNaBar];
    [self createTable];
    [self getData];
}

-(void)createTable{
    
    blackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    blackTableView.delegate = self;
    blackTableView.dataSource = self;
    blackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:blackTableView];
    
}


-(void)getData
{
    BmobQuery *bquery = [BmobQuery queryForUser];
   [bquery whereObjectKey:@"blacklist" relatedTo:user];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        blackArray = array;
        [blackTableView reloadData];
    }];
}

#pragma mark---tableView dataSource  delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return blackArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BlackListTableViewCell * cell = [[BlackListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"black"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"black" owner:self options:nil] lastObject];
        
    }
    NSURL * avatarimu = [NSURL URLWithString:[blackArray[indexPath.row] objectForKey:@"avatar"]];
    [cell.avatar sd_setImageWithURL:avatarimu];

    cell.nick.text = [blackArray[indexPath.row] objectForKey:@"nick"];
    cell.nick.frame = CGRectMake(80, 0, 100, 80);
    
//    UIButton * wipe = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 0, 80, 80)];
//    [wipe setImage:[UIImage imageNamed:@"jiechu"] forState:UIControlStateNormal];
//    [wipe setImage:[UIImage imageNamed:@"jiechuselect"] forState:UIControlStateHighlighted];
//    [wipe addTarget:self action:@selector(onWipe:) forControlEvents:UIControlEventTouchUpInside];
//    wipe.tag = 200 + indexPath.row;
//    [cell addSubview:wipe];
    
     return cell;
}

//-(void)onWipe:(UIButton *)btn{
//    
//    [isBlackTool cancelBlackListWithBlackId:[blackArray[btn.tag - 200] objectId]];
//    
//    [blackTableView reloadData];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    friendInfoViewController *userData = [[friendInfoViewController alloc] init];
    userData.userId = [blackArray[indexPath.row] objectId];
    userData.userName = [blackArray[indexPath.row] objectForKey:@"nick"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:userData animated:YES];
}

-(void)createNaBar{
    
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"f2f2f2"];
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
    titleBar.text = @"黑名单";
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
@end
