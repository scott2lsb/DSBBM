//
//  NewsViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-6.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "ChatViewController.h"
#import "StrangerViewController.h"
#import "FriendWishViewController.h"
#import "HelpNewsViewController.h"
#import "ShakeViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController
{
    UITableView         *_friendTableView;
    NSMutableArray      *_friendsArray;
    UIButton * sideBtn;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _friendsArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self createTableView];
    [self createHeaderView];
    [self search];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNot) name:@"news" object:nil];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:(DEMONavigationController *)self.navigationController  action:@selector(panGestureRecognized:)]];
}


-(void)recieveNot{
    
    [self changeNaBar];
  
    UIView * v = (id)[self.view viewWithTag:400];
    [v removeFromSuperview];
    [self createHeaderView];
    [_friendTableView reloadData];
}

-(void)createHeaderView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,308)];
    headerView.tag = 400;
    headerView.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    NSArray * imageArray = @[@"bangbangxiaoxi",@"moshenren",@"haoyoudongtai",@"aladingshendeng"];
    NSArray * nameArray = @[@"评论",@"陌生人消息",@"好友动态",@"阿拉丁神灯"];
    for (int i = 0 ; i < 4 ; i++) {
        UIView * headerCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + i * 77, 320, 76.5)];
        headerCell.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 16.5, 44, 44)];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        
        if(i == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0 ){
            [self dotImage:imageView Int:i];
        }
        NSArray * array = [[BmobDB currentDatabase] queryRecent];
        int m = 0;
        for (int i = 0 ; i < array.count ; i++) {
            BmobRecent * news = array[i];
            int k = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@frist",news.targetId]] integerValue];
            if(k == 2){
            }else{
                m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
            }
        }
        if(i == 1 && m != 0 ){
            [self dotImage:imageView Int:i];
        }
        if(i == 4 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 ){
            [self dotImage:imageView Int:i];
        }
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67,0, 100,77)];
        nameLabel.text = nameArray[i];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = [UIcol hexStringToColor:@"#343434"];
        
        UIButton * cellBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.5, 320,76)];
        [cellBtn addTarget:self action:@selector(cellBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cellBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] size:CGSizeMake(320, 76)] forState:UIControlStateHighlighted];
        cellBtn.tag = 100 + i;

        [headerCell addSubview:imageView];
        [headerCell addSubview:nameLabel];
        [headerCell addSubview:cellBtn];
        [headerView addSubview:headerCell];
    }
    _friendTableView.tableHeaderView = headerView;
}

-(void)dotImage:(UIImageView *)imageView Int:(int)k{
    
    UIImageView * sidebar = (id)[self.view viewWithTag:554];
    UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(30,-10,20,20)];
    dotBack.tag = 555;
    dotBack.backgroundColor = [UIColor whiteColor];
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
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
    number.tag = 668;
    number.font = [UIFont systemFontOfSize:11];
    number.textColor = [UIColor whiteColor];
    number.textAlignment = NSTextAlignmentCenter;
    if(k == 0){
    number.text = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue]];
    }else if(k == 4){
     number.text = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
    }else if(k == 1){
        NSArray * array = [[BmobDB currentDatabase] queryRecent];
        int m = 0;
        for (int i = 0 ; i < array.count ; i++) {
            BmobRecent * news = array[i];
            int k = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@frist",news.targetId]] integerValue];
            if(k == 2){
            }else{
                m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
            }
        }
         number.text = [NSString stringWithFormat:@"%d",m];
    }
    [dot addSubview:number];
    [imageView addSubview:dotBack];
}

#pragma mark data

-(void)viewDidAppear:(BOOL)animated{
    UIView * v = (id)[self.view viewWithTag:400];
    [v removeFromSuperview];
    [self createHeaderView];
    [super viewDidAppear:animated];
    [self search];
    [_friendTableView reloadData];
}

#pragma mark some action

-(void)search{
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    [_friendsArray removeAllObjects];
    for (int i = 0 ; i < array.count ; i++) {
        BmobRecent * news = array[i];
       int k = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@frist",news.targetId]] integerValue];
        
        if(k == 2){
            NSLog(@"%@",news.nick);
            [_friendsArray addObject:news];
        }else{
        }
    }
  
    [_friendTableView reloadData];
    
    
}


#pragma mark tableView

-(void)createTableView{
    _friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64)];
    _friendTableView.delegate = self;
    _friendTableView.dataSource = self;
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_friendTableView];
    [self createHeaderView];
}

-(void)cellBtn:(UIButton *)btn{
    switch (btn.tag - 100) {
        case 0:{
            HelpNewsViewController * hnvc = [[HelpNewsViewController alloc] init];
             [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"addLike"];
            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:center];
            [self.navigationController pushViewController:hnvc animated:YES];
        }
            break;
        case 1:{
            StrangerViewController * svc = [[StrangerViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
            
        case 2:{
            FriendWishViewController * fwvc = [[FriendWishViewController alloc] init];
            [self.navigationController pushViewController:fwvc animated:YES];
        }
            break;
        case 3:{
            ShakeViewController * svc = [[ShakeViewController alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"aladdinSnatch"];
            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:center];
            [self.navigationController pushViewController:svc animated:YES];
                }
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark table方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BmobRecent * news = (BmobRecent *)[_friendsArray objectAtIndex:(_friendsArray.count - indexPath.row - 1)];

    cell.nickLable.text = news.nick;
    cell.chatLable.text = news.message;
    NSString * s = [mistiming returnUploadTime:[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:news.time]]];
    if([[s substringToIndex:1] integerValue] == 0){
     cell.timeLable.text = @"1分钟前";
    }else{
    cell.timeLable.text = [mistiming returnUploadTime:[NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:news.time]]];
    }
    NSURL * avatarimu = [NSURL URLWithString:news.avatar];
    [cell.avatar sd_setImageWithURL:avatarimu];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue] == 0){
        UIView * dotBack = (id)[self.view viewWithTag:700 + indexPath.row];
        [dotBack removeFromSuperview];
    }else{
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(45,5, 20,20)];
        dotBack.tag = 700 + indexPath.row;
        dotBack.backgroundColor = [UIColor whiteColor];
        dotBack.layer.cornerRadius = 10;
        dotBack.layer.masksToBounds = YES;
        [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
        [cell addSubview:dotBack];
        UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
        dot.backgroundColor = [UIColor redColor];
        dot.layer.cornerRadius = 20;
        dot.tag = 557;
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
    return 77;
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
    [self chatWithSB:indexPath];
}

#pragma mark some action about chatuser
-(void)chatWithSB:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    BmobRecent * user = (BmobRecent *)[_friendsArray objectAtIndex:(_friendsArray.count - indexPath.row - 1)];
    [infoDic setObject:user.targetId forKey:@"uid"];
    [infoDic setObject:user.nick forKey:@"name"];
    if (user.avatar) {
        [infoDic setObject:user.avatar forKey:@"avatar"];
    }
    if (user.nick) {
        [infoDic setObject:user.nick forKey:@"nick"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:user.targetId];
    NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:2] forKey:[NSString stringWithFormat:@"%@frist",user.targetId]];
    [[NSNotificationCenter defaultCenter] postNotification:center];
    
    ChatViewController * cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
    cvc.where = 1;
    
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)deleteContact:(NSIndexPath *)indexPath{
    BmobChatUser *user = (BmobChatUser *)[_friendsArray objectAtIndex:indexPath.row];
    [[BmobDB currentDatabase] deleteContactWithUid:user.objectId];
    [[BmobDB currentDatabase] deleteMessagesWithUid:user.objectId];
    [[BmobDB currentDatabase] deleteRecentWithUid:user.objectId];
    [[BmobUserManager currentUserManager] deleteContactWithUid:user.objectId block:^(BOOL isSuccessful, NSError *error) {
        
    }];
    
    [_friendsArray removeObject:user];
    [_friendTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark nabar
-(void)createNaBar{
    
    UIView * instrument = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    instrument.backgroundColor = [UIColor blackColor];
    [self.view addSubview:instrument];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.95 alpha:1];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
   
    UIImageView * sidebar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sidebar.image = [UIImage imageNamed:@"caidan"];
    sidebar.tag = 554;
    sidebar.userInteractionEnabled = YES;
    [iv addSubview:sidebar];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    int m = 0;
    for (int i = 0 ; i < array.count ; i++) {
        BmobRecent * news = array[i];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
            UIImageView * sidebar = (id)[self.view viewWithTag:554];
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
            UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
            number.tag = 668;
        number.font = [UIFont systemFontOfSize:11];
        number.textColor = [UIColor whiteColor];
        number.textAlignment = NSTextAlignmentCenter;
            number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            [dot addSubview:number];
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3,20,20)];
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
    }
    
    sideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sideBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] size:CGSizeMake(44, 44)] forState:UIControlStateHighlighted];
    [sideBtn addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sidebar addSubview:sideBtn];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"消息";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
  
}

-(void)changeNaBar{
    UIView * dotBack = (id)[self.view viewWithTag:555];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    UIImageView * sidebar = (id)[self.view viewWithTag:554];
    int m = 0;
    for (int i = 0 ; i < array.count ; i++) {
        BmobRecent * news = array[i];
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
            UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
            number.tag = 668;
            number.font = [UIFont systemFontOfSize:11];
            number.textColor = [UIColor whiteColor];
            number.textAlignment = NSTextAlignmentCenter;
            number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
            [dot addSubview:number];
        }else{
            UILabel * number = (id)[self.view viewWithTag:668];
            if(number == nil){
                if(number == nil){
                    UIView * dot = (id)[self.view viewWithTag:557];
                    number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
                    number.tag = 668;
                    number.font = [UIFont systemFontOfSize:11];
                    number.textColor = [UIColor whiteColor];
                    number.textAlignment = NSTextAlignmentCenter;
                    [dot addSubview:number];
                }            }
            number.text =[NSString stringWithFormat:@"%d",m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue]];
        }
   }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
       if(dotBack == nil){
           UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 18,18)];
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
