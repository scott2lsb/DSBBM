//
//  PersonalSetViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-13.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "PersonalSetViewController.h"
#import "MyWishViewController.h"
#import "ChatViewController.h"

@interface PersonalSetViewController ()
{
    BmobUser * user;
    BmobObject * userObject;
    UITableView * setTableView;
    int k;
  
    BOOL isBool;
    MBProgressHUD * HUD;
}

@end

@implementation PersonalSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       user = [BmobUser getCurrentUser];
        k = 0;
        isBool = YES;
    }
    return self;
}


- (void)viewDidLoad
{

    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    [self createNarBar];
    [self createTable];
    HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"加载中";
    [self.view addSubview:HUD];
    [HUD show:YES];
    [self getDate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNot) name:@"news" object:nil];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:(DEMONavigationController *)self.navigationController  action:@selector(panGestureRecognized:)]];
}

-(void)recieveNot{
    
    [self changeNaBar];
}

-(void)viewWillAppear:(BOOL)animated{
    if(isBool == NO){
        [setTableView removeFromSuperview];
        [self createTable];
    }
}

-(void)createTable{
    
    setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width , self.view.bounds.size.height - 64)];
    setTableView.delegate = self;
    setTableView.dataSource = self;
    setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    setTableView.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [self.view addSubview:setTableView];
}

#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil] lastObject];
    }
    if([[userObject objectForKey:@"lastWish"] objectForKey:@"text"] != nil){
        if(indexPath.row == 3){
            UILabel * wishLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100,32)];
            wishLab.textColor = [UIcol hexStringToColor:@"2e2e2e"];
            wishLab.font = [UIFont systemFontOfSize:13];
            if([[user objectForKey:@"sex"] integerValue] == 1){
                wishLab.text = @"   我的动态";
            }else{
                wishLab.text = @"   我的愿望";
            }
            [cell addSubview:wishLab];
            [cell.contentView setBackgroundColor: [UIcol hexStringToColor:@"f2f2f2"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if(indexPath.row == 4){
            UIImageView * wishBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 82)];
            wishBack.image = [UIImage imageNamed:@"di"];
            [cell addSubview:wishBack];
            
            UIImageView * wishUrl = [[UIImageView alloc] initWithFrame:CGRectMake(25, 18.5, 45, 45)];
            wishUrl.layer.cornerRadius = 6;
            wishUrl.layer.masksToBounds = YES;
            [wishUrl sd_setImageWithURL:[[userObject objectForKey:@"lastWish"] objectForKey:@"url"]];
            [cell addSubview:wishUrl];
            
            TQRichTextView * wishText = [[TQRichTextView alloc] initWithFrame:CGRectMake(80,15, 200, 36)];
            wishText.backgroundColor = [UIColor clearColor];
            wishText.text = [[userObject objectForKey:@"lastWish"] objectForKey:@"text"];
            wishText.textColor = [UIcol hexStringToColor:@"787878"];
            wishText.font = [UIFont systemFontOfSize:14];
            wishText.userInteractionEnabled = NO;
            [cell addSubview:wishText];
            
            UILabel * like = [[UILabel alloc] initWithFrame:CGRectMake(100, 53, 50, 20)];
            like.text = [NSString stringWithFormat:@"%@",[[userObject objectForKey:@"lastWish"] objectForKey:@"like"]];
            like.textColor = [UIcol hexStringToColor:@"bebebe"];
            like.font = [UIFont systemFontOfSize:11];
            [cell addSubview:like];
            
            UILabel * comment = [[UILabel alloc] initWithFrame:CGRectMake(162, 53, 50, 20)];
            comment.text = [NSString stringWithFormat:@"%@",[[userObject objectForKey:@"lastWish"] objectForKey:@"comment"]];
            comment.textColor = [UIcol hexStringToColor:@"bebebe"];
            comment.font = [UIFont systemFontOfSize:11];
            [cell addSubview:comment];
            
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,81.5, cell.bounds.size.width , 0.5)];
            line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
            [cell addSubview:line];
        }
    }
     if(indexPath.row == 0){
        UIImageView * avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 70, 70)];
        [avatar sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]];
        avatar.layer.cornerRadius = 6;
        avatar.layer.masksToBounds = YES;
        [cell addSubview:avatar];
        UILabel * nick = [[UILabel alloc] initWithFrame:CGRectMake(95,13, 200, 20)];
         nick.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nick"];
        nick.font = [UIFont systemFontOfSize:18];
        nick.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        [cell addSubview:nick];
        UILabel * bbID = [[UILabel alloc] initWithFrame:CGRectMake(95, 53, 200, 20)];
        bbID.text = [NSString stringWithFormat:@"帮帮号：%@",[user objectForKey:@"bbID"]];
        bbID.textColor = [UIcol hexStringToColor:@"787878"];
        bbID.font = [UIFont systemFontOfSize:13];
        [cell addSubview:bbID];
        UIImageView * dataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 65, 35,50, 20)];
        dataView.image = [UIImage imageNamed:@"ziliao"];
        [cell addSubview:dataView];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 89.5, self.view.bounds.size.width, 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        [cell addSubview:line];
    }else if (indexPath.row == 1){
            [cell.contentView setBackgroundColor: [UIcol hexStringToColor:@"f2f2f2"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.row == 2){
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 25, 25)];
        icon.image = [UIImage imageNamed:@"zhanghaobangding"];
        [cell addSubview:icon];
        UILabel * bindingLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 200, 20)];
        bindingLab.text = @"账号绑定";
        bindingLab.font = [UIFont systemFontOfSize:15];
        bindingLab.textColor = [UIcol hexStringToColor:@"787878"];
        [cell addSubview:bindingLab];
      
        UIImageView * tele = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 40, 14, 25, 25)];
//        if([[[userObject objectForKey:@"setting"] objectForKey:@"contactBind"] integerValue] == 1){
        tele.image = [UIImage imageNamed:@"shoujibangding"];
//        }else{
//            tele.image = [UIImage imageNamed:@"shoujiweibangding"];
//        }
        [cell addSubview:tele];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,49.5, cell.bounds.size.width , 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        [cell addSubview:line];
    }else if (indexPath.row == 5){
        UILabel * privacyLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 100,32)];
        privacyLab.textColor = [UIcol hexStringToColor:@"2e2e2e"];
        privacyLab.font = [UIFont systemFontOfSize:13];
     
            privacyLab.text = @"   其他";
        [cell addSubview:privacyLab];
        [cell.contentView setBackgroundColor: [UIcol hexStringToColor:@"f2f2f2"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.row == 6 || indexPath.row == 7|| indexPath.row == 8){
        NSArray * arrayLab = @[@"设置",@"用户反馈",@"用户帮助"];
        UILabel * setLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200,50)];
        setLab.text = arrayLab[indexPath.row - 6];
        setLab.font = [UIFont systemFontOfSize:15];
        setLab.textColor = [UIcol hexStringToColor:@"787878"];
        [cell addSubview:setLab];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,49.5, cell.bounds.size.width , 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        [cell addSubview:line];
    }
    
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[userObject objectForKey:@"lastWish"] objectForKey:@"text"] != nil){
        if(indexPath.row == 3){
            return 32;
        }else if(indexPath.row == 4){
            return 82;
        }
    }else{
        if(indexPath.row == 3){
            return 0;
        }else if(indexPath.row == 4){
            return 0;
        }
    }
    if(indexPath.row == 0){
        return 90;
    }else if (indexPath.row == 1){
        return 10;
    }else if (indexPath.row == 2){
        return 50;
    }else if (indexPath.row == 5){
        return 32;
    }else{
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
      
        friendInfoViewController *userData = [[friendInfoViewController alloc] init];
        userData.userId = user.objectId;
        userData.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nick"];
        userData.furcation = 1;

        [self.navigationController pushViewController:userData animated:YES];

    }else if (indexPath.row == 2){
        AccountBoundViewController * abvc = [[AccountBoundViewController alloc] init];
        abvc.tele = [[userObject objectForKey:@"setting"] objectForKey:@"contactBind"];
        [self.navigationController pushViewController:abvc animated:YES];
        
    }else if (indexPath.row == 4){
        MyWishViewController * myWish = [[MyWishViewController alloc] init];
        myWish.userId = user.objectId;
        myWish.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nick"];
        [self.navigationController pushViewController:myWish animated:YES];
    }else if (indexPath.row == 6 || indexPath.row == 8){
        HelpViewController * hvc = [[HelpViewController alloc] init];
        hvc.i = indexPath.row - 6;
        [self.navigationController pushViewController:hvc animated:YES];
    }else if (indexPath.row == 7){
        BmobQuery * query = [BmobQuery queryWithClassName:@"Config"];
        [query whereKey:@"version" equalTo:@"feedback"];
        [query includeKey:@"user"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[[array[0] objectForKey:@"user"] objectForKey:@"ncik"] forKey:@"nick"];
            [dict setObject:[[array[0] objectForKey:@"user"] objectId] forKey:@"uid"];
            [dict setObject:[[array[0] objectForKey:@"user"] objectForKey:@"username"] forKey:@"name"];
            [dict setObject:[[array[0] objectForKey:@"user"] objectForKey:@"avatar"] forKey:@"avatar"];
            ChatViewController * cvc = [[ChatViewController alloc] initWithUserDictionary:dict];
            cvc.where = 3;
            [self.navigationController pushViewController:cvc animated:YES];
        }];
    
    }
}



-(void)perSet{
    friendInfoViewController * udvc = [[friendInfoViewController alloc] init];
    udvc.userId = user.objectId;
    udvc.userName = [user objectForKey:@"nick"];
    udvc.furcation = 1;
    [self.navigationController pushViewController:udvc animated:YES];
}

-(void)getDate{
   
    BmobQuery * userQuery = [BmobQuery queryForUser];
    [userQuery includeKey:@"lastWish,setting"];
    [userQuery getObjectInBackgroundWithId:user.objectId block:^(BmobObject *object, NSError *error) {
        userObject = object;
        [HUD removeFromSuperview];
        isBool = NO;
    
        [setTableView reloadData];
    }];
    
}

-(void)createNarBar{
    UIImageView * narBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tou"]];
    narBar.frame = CGRectMake(0, 20, 320, 44);
    narBar.userInteractionEnabled = YES;
    [self.view addSubview:narBar];
    
    UIImageView * sidebar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sidebar.image = [UIImage imageNamed:@"caidan"];
    sidebar.tag = 554;
    sidebar.userInteractionEnabled = YES;
    [narBar addSubview:sidebar];
    
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    int m = 0;
    for (int i = 0 ; i < array.count ; i++) {
        BmobRecent * news = array[i];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
        UIView * dotBack = [[UIView alloc] initWithFrame:CGRectMake(20,3, 20,20)];
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
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"visit"] integerValue] != 0){
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
    }
    UIButton * sideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sideBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] size:CGSizeMake(44, 44)] forState:UIControlStateHighlighted];
    [sideBtn addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sidebar addSubview:sideBtn];
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"个人设置";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [narBar addSubview:titleBar];
    
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
                number.font = [UIFont systemFontOfSize:11];
                number.textColor = [UIColor whiteColor];
                number.textAlignment = NSTextAlignmentCenter;
                number.tag = 668;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   }


@end
