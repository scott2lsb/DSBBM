//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "WishViewController.h"
#import "NewsViewController.h"
#import "LampViewController.h"
#import "RecentlyViewController.h"
#import "PersonalSetViewController.h"
#import "FriendsViewController.h"
#import "LoginViewController.h"

@implementation DEMOMenuViewController
{
    int row;
    UIView * back;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    row = 1;
    [self createTable];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailsNews) name:@"news" object:nil];
}

-(void)detailsNews{
    UIView * dotBack = (id)[self.view viewWithTag:666];
     if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
    if(dotBack == nil){
           UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            if( [[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
                UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(180,12.5, 20,20)];
                dotBack.tag = 666;
                dotBack.backgroundColor = [UIColor clearColor];
                dotBack.layer.cornerRadius = 10;
                dotBack.layer.masksToBounds = YES;
                [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
                [cell addSubview:dotBack];
                UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
                dot.backgroundColor = [UIcol hexStringToColor:@"#f58223"];
                dot.layer.cornerRadius = 20;
                dot.layer.masksToBounds = YES;
                [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
                [dotBack addSubview:dot];
            }
        }
    }else{
        [dotBack removeFromSuperview];
    }
    
    UIView * dotView = (id)[self.view viewWithTag:667];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    int m = 0;
    for (int j = 0 ; j < array.count ; j++) {
        BmobRecent * news = array[j];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    m = m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue];
    if(m != 0){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        UILabel * number = (id)[self.view viewWithTag:668];
        if(dotView == nil){
            UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(180,12.5, 20,20)];
            dotBack.tag = 667;
            dotBack.backgroundColor = [UIColor clearColor];
            dotBack.layer.cornerRadius = 10;
            dotBack.layer.masksToBounds = YES;
            [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
            [cell addSubview:dotBack];
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14,14)];
            dot.backgroundColor = [UIcol hexStringToColor:@"#f58223"];
            dot.layer.cornerRadius = 20;
            dot.layer.masksToBounds = YES;
            [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
            [dotBack addSubview:dot];
            UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
            number.tag = 668;
            number.font = [UIFont systemFontOfSize:11];
            number.textColor = [UIColor whiteColor];
            number.textAlignment = NSTextAlignmentCenter;
            if(m >= 99){
                number.text = @"99";
            }else{
                number.text = [NSString stringWithFormat:@"%d",m];
            }
            [dot addSubview:number];
        }else{
            number.tag = 668;
            if(m >= 99){
                number.text = @"99";
            }else{
                number.text = [NSString stringWithFormat:@"%d",m];
            }
        }
    }else{
        [dotView removeFromSuperview];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    UIImageView * avatar = (id)[self.view viewWithTag:88];
    NSURL * imu = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]];
    [avatar sd_setImageWithURL:imu];
    
    UILabel * nick = (id)[self.view viewWithTag:89];
    nick.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nick"];
    
}

-(void)createTable{
   
    self.tableView.separatorColor = [UIcol hexStringToColor:@"#f2f2f2"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.scrollEnabled = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    
   

}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];;
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
    if(indexPath.row == 0 && indexPath.section != 0){
        cell.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    for (int i = 0; i < 6 ; i ++) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(i == 1){
            cell.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        }
        if(i == indexPath.row){
            cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
            row = i;
        }else{
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
    }
    int k = 0;
    int j = 0;
    NSArray * array = navigationController.viewControllers;
    NSArray * nameArray = @[@"PersonalSetViewController",@"WishViewController",@"LampViewController",@"NewsViewController",@"RecentlyViewController",@"FriendsViewController"];
    
        for (int i = 0 ; i < array.count ; i++) {
            if([[NSString stringWithFormat:@"%@",[array[i] class]] isEqualToString:nameArray[indexPath.row]]){
                k++;
                j = i;
            }
        }
    if(k == 1){
            if([[NSString stringWithFormat:@"%@",[array[j] class]] isEqualToString:@"PersonalSetViewController"]){
                PersonalSetViewController * vc = array[j];
                [navigationController popToViewController:vc animated:NO];
                k++;
            }else if([[NSString stringWithFormat:@"%@",[array[j] class]] isEqualToString:@"WishViewController"]){
                WishViewController * vc = array[j];
                [navigationController popToViewController:vc animated:NO];
                k++;
            }else if([[NSString stringWithFormat:@"%@",[array[j] class]] isEqualToString:@"LampViewController"]){
                LampViewController * vc = array[j];
                [navigationController popToViewController:vc animated:NO];
                k++;
            }else if([[NSString stringWithFormat:@"%@",[array[j] class]] isEqualToString:@"NewsViewController"]){
                NewsViewController * vc = array[j];
                [navigationController popToViewController:vc animated:NO];
                k++;
            }else if([[NSString stringWithFormat:@"%@",[array[j] class]] isEqualToString:@"RecentlyViewController"]){
                RecentlyViewController * vc = array[j];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"visit"];
                NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:center];
                [navigationController popToViewController:vc animated:NO];
                k++;
            }else if([[NSString stringWithFormat:@"%@",[array[j] class]] isEqualToString:@"FriendsViewController"]){
                FriendsViewController * vc = array[j];
                [navigationController popToViewController:vc animated:NO];
                k++;
            }
    }
    if(k == 0){
        if(indexPath.row == 0){
            PersonalSetViewController * vc = [[PersonalSetViewController alloc] init];
            [navigationController pushViewController:vc animated:NO];
        }else if (indexPath.row == 1){
            WishViewController * vc = [[WishViewController alloc] init];
            [navigationController pushViewController:vc animated:NO];
        }else if (indexPath.row == 2){
            LampViewController * vc = [[LampViewController alloc] init];
            [navigationController pushViewController:vc animated:NO];
        }else if (indexPath.row == 3){
            NewsViewController * vc = [[NewsViewController alloc] init];
            [navigationController pushViewController:vc animated:NO];
        }else if (indexPath.row == 4){
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"visit"];
            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:center];
            RecentlyViewController * vc = [[RecentlyViewController alloc] init];
            [navigationController pushViewController:vc animated:NO];
        }else if (indexPath.row == 5){
            FriendsViewController * vc = [[FriendsViewController alloc] init];
            [navigationController pushViewController:vc animated:NO];
        }
    }
       NSLog(@"%@",navigationController.viewControllers);
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 90;
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.imageView.frame = CGRectMake(10, 12.5, 25, 25);
    cell.textLabel.textColor = [UIcol hexStringToColor:@"#787878"];
    if (indexPath.row == 0) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,89.5, 320, 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
        [cell addSubview:line];
        BmobUser * bUser = [BmobUser getCurrentUser];
        UIImageView * avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,10, 70, 70)];
        avatarImage.layer.cornerRadius = 10;
        avatarImage.layer.masksToBounds = YES;
        avatarImage.tag = 88;
        NSURL * imu = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]];
        [avatarImage sd_setImageWithURL:imu];
        [cell addSubview:avatarImage];
        
        UIImageView * set = [[UIImageView alloc] initWithFrame:CGRectMake(199, 10, 16, 16)];
        set.image = [UIImage imageNamed:@""];
        [cell addSubview:set];
        
        UILabel * nick = [[UILabel alloc] initWithFrame:CGRectMake(95,18.5, 150, 20)];
        nick.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nick"];
        nick.font = [UIFont systemFontOfSize:18];
        nick.tag = 89;
        nick.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        [cell addSubview:nick];
        
        UILabel * helpNum = [[UILabel alloc] initWithFrame:CGRectMake(95, 52.5, 150, 12)];
        helpNum.text = [NSString stringWithFormat:@"帮帮号:%@",[bUser objectForKey:@"bbID"]];
        helpNum.font = [UIFont systemFontOfSize:13];
        helpNum.textColor = [UIcol hexStringToColor:@"#787878"];
        [cell addSubview:helpNum];
    } else {
        NSArray *titles = @[@"愿望首页", @"阿拉丁神灯", @"信息", @"最近来访",@"朋友"];
        NSArray *image = @[@"yuanwangshouye",@"alading",@"xinxi",@"zuijinlaifang",@"pengyou"];
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(50, 13.5, 150, 20)];
        title.text = titles[indexPath.row - 1];
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = [UIcol hexStringToColor:@"#787878"];
        [cell addSubview:title];
        
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
        icon.image = [UIImage imageNamed:image[indexPath.row - 1]];
        [cell addSubview:icon];
       
       if(indexPath.row == 3){
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,44.5, 320, 0.5)];
            line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
            [cell addSubview:line];
        }
        if(indexPath.row == 4){
            if( [[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
                UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(180,12.5, 20,20)];
                dotBack.tag = 666;
                dotBack.backgroundColor = [UIColor clearColor];
                dotBack.layer.cornerRadius = 10;
                dotBack.layer.masksToBounds = YES;
                [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
                [cell addSubview:dotBack];
                UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
                dot.backgroundColor = [UIcol hexStringToColor:@"#f58223"];
                dot.layer.cornerRadius = 20;
                dot.layer.masksToBounds = YES;
                [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
                [dotBack addSubview:dot];
            }
        }
        if(indexPath.row == 3){
            NSArray * array = [[BmobDB currentDatabase] queryRecent];
            int m = 0;
            for (int j = 0 ; j < array.count ; j++) {
                BmobRecent * news = array[j];
                m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
                
            }
            m = m + [[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue];
            if(m != 0){
                UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(180,12.5, 20,20)];
                dotBack.tag = 667;
                dotBack.backgroundColor = [UIColor clearColor];
                dotBack.layer.cornerRadius = 10;
                dotBack.layer.masksToBounds = YES;
                [dotBack.layer setCornerRadius:CGRectGetHeight([dotBack bounds]) / 2];
                [cell addSubview:dotBack];
                UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14,14)];
                dot.backgroundColor = [UIcol hexStringToColor:@"#f58223"];
                dot.layer.cornerRadius = 20;
                dot.layer.masksToBounds = YES;
                [dot.layer setCornerRadius:CGRectGetHeight([dot bounds]) / 2];
                [dotBack addSubview:dot];
                UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
                number.tag = 668;
                number.font = [UIFont systemFontOfSize:11];
                number.textColor = [UIColor whiteColor];
                number.textAlignment = NSTextAlignmentCenter;
                if(m >= 99){
                    number.text = @"99";
                }else{
                    number.text = [NSString stringWithFormat:@"%d",m];
                }
                [dot addSubview:number];
            }
        }
    }
    if(indexPath.row == row){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }
    if(indexPath.row == 5 ){
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,44.5, 320, 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
        [cell addSubview:line];
    }
    return cell;
}



@end
