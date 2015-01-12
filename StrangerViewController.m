//
//  StrangerViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "StrangerViewController.h"
#import "ChatViewController.h"
#import "NewsTableViewCell.h"

@interface StrangerViewController ()

@end

@implementation StrangerViewController
{
    UITableView         *_strangerTableView;
    NSMutableArray      *_strangerArray;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _strangerArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self createTableView];
}

#pragma mark data

-(void)viewWillAppear:(BOOL)animated{
    [_strangerArray removeAllObjects];
    [self search];
    [_strangerTableView reloadData];
}

-(void)search{
    //    NSArray *array = [[BmobDB currentDatabase] contaclList];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    for (int i = 0 ; i < array.count ; i++) {
        BmobRecent * news = array[i];
        int k = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@frist",news.targetId]] integerValue];
        if(k == 2){
        }else{
            [_strangerArray addObject:news];
        }
    }
        [_strangerTableView reloadData];
}

#pragma mark tableView

-(void)createTableView{
    _strangerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64)];
    _strangerTableView.delegate = self;
    _strangerTableView.dataSource = self;
    _strangerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_strangerTableView];
    
}

#pragma mark table方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_strangerArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    BmobRecent * news = (BmobRecent *)[_strangerArray objectAtIndex:(_strangerArray.count - indexPath.row - 1)];
    
    cell.nickLable.text = news.nick;
    cell.chatLable.text = news.message;
    cell.timeLable.text = [mistiming returnUploadTime:[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:news.time]]];
    NSURL * avatarimu = [NSURL URLWithString:news.avatar];
    [cell.avatar sd_setImageWithURL:avatarimu];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue] == 0){
    }else{
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(45,5, 20,20)];
        dotBack.tag = 666;
        dotBack.backgroundColor = [UIColor whiteColor];
        dotBack.layer.cornerRadius = 10;
        dotBack.layer.masksToBounds = YES;
        [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
        [cell addSubview:dotBack];
        UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
        dot.backgroundColor = [UIColor redColor];
        dot.layer.cornerRadius = 20;
        dot.layer.masksToBounds = YES;
        [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
        [dotBack addSubview:dot];
        UILabel * dotLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
        if([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId]] integerValue] >= 99){
            dotLab.text = @"99";
        }else{
        dotLab.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId]];
        }
        dotLab.font = [UIFont systemFontOfSize:11];
        dotLab.textColor = [UIColor whiteColor];
        dotLab.textAlignment = NSTextAlignmentCenter;
        [dot addSubview:dotLab];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteContact:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%d",indexPath.row);
    [self chatWithSB:indexPath];
}

#pragma mark some action about chatuser
-(void)chatWithSB:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    BmobRecent * user = (BmobRecent *)[_strangerArray objectAtIndex:(_strangerArray.count - indexPath.row - 1)];
    [infoDic setObject:user.targetId forKey:@"uid"];
    [infoDic setObject:user.nick forKey:@"name"];
    if (user.avatar) {
        [infoDic setObject:user.avatar forKey:@"avatar"];
    }
    if (user.nick) {
        [infoDic setObject:user.nick forKey:@"nick"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:user.targetId];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:2] forKey:[NSString stringWithFormat:@"%@frist",user.targetId]];
    NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:center];
    ChatViewController * cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
    
    cvc.where = 1;
    [self.navigationController pushViewController:cvc animated:YES];}

-(void)deleteContact:(NSIndexPath *)indexPath{
    BmobChatUser *user = (BmobChatUser *)[_strangerArray objectAtIndex:indexPath.row];
    [[BmobDB currentDatabase] deleteContactWithUid:user.objectId];
    [[BmobDB currentDatabase] deleteMessagesWithUid:user.objectId];
    [[BmobDB currentDatabase] deleteRecentWithUid:user.objectId];
    [[BmobUserManager currentUserManager] deleteContactWithUid:user.objectId block:^(BOOL isSuccessful, NSError *error) {
        
    }];
    
    [_strangerArray removeObject:user];
    [_strangerTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    titleBar.text = @"陌生人";
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
