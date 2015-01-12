//
//  HelpViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-10-7.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "HelpViewController.h"
#import "LoginViewController.h"
#import "sqlStatusTool.h"
#import "ResetViewController.h"
#import "TransitViewController.h"
#import "HtmlViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self createUI];
}

-(void)createUI{
    
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
    back.backgroundColor = [UIColor whiteColor];
    NSArray * array;
    if(self.i == 0){
        array = @[@"黑名单",@"修改密码",@"消息提醒"];
        UIView * quit = [[UIView alloc] initWithFrame:CGRectMake(0, 225, self.view.bounds.size.width, 50)];
        quit.backgroundColor = [UIColor whiteColor];
        
        UILabel * quitLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        quitLab.text = @"退出登录";
        quitLab.textColor = [UIcol hexStringToColor:@"787878"];
        quitLab.font = [UIFont systemFontOfSize:15];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.view.bounds.size.width, 0.5)];
        line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        
        UIButton * quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        [quitBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] size:CGSizeMake(self.view.bounds.size.width, 50)] forState:UIControlStateHighlighted];
        quitBtn.tag = 100 + 3;
        [quitBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [quit addSubview:quitBtn];
        
        [quit addSubview:line];
        [quit addSubview:quitLab];
        [self.view addSubview:quit];
    }else if(self.i == 2){
        array = @[@"用户协议",@"用户帮助",@"版本特性"];
    }
    
    
    for (int j = 0; j < 3; j++) {
        UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(15, j * 50, 100, 50)];
        text.text = array[j];
        text.font = [UIFont systemFontOfSize:15];
        text.textColor = [UIcol hexStringToColor:@"#787878"];
        
        UIView * line;
        if(j == 2){
            line = [[UIView alloc] initWithFrame:CGRectMake(0 , 49.5 + j * 50, self.view.bounds.size.width, 0.5)];
        }else{
            line = [[UIView alloc] initWithFrame:CGRectMake(15 , 49.5 + j * 50, self.view.bounds.size.width, 0.5)];
        }
        line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0,j * 50, self.view.bounds.size.width, 50)];
        [btn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] size:CGSizeMake(self.view.bounds.size.width, 50)] forState:UIControlStateHighlighted];
        btn.tag = 100 + j;
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [back addSubview:btn];
        [back addSubview:text];
        [back addSubview:line];
    }
        
        
    [self.view addSubview:back];
}

-(void)onClick:(UIButton *)btn{
    if(self.i == 0){
        switch (btn.tag - 100) {
            case 0:{
                BlackListViewController * blvc = [[BlackListViewController alloc] init];
                [self.navigationController pushViewController:blvc animated:YES];
            }
                break;
            case 1:{
                ResetViewController * rvc = [[ResetViewController alloc] init];
                [self.navigationController pushViewController:rvc animated:YES];
            }
                break;
            case 2:{
                MessageRemindViewController * mrvc = [[MessageRemindViewController alloc] init];
                [self.navigationController pushViewController:mrvc animated:YES];
            }
                break;
                
            case 3:{
                UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"点击确认退出登录" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 10;
                [alert show];
            }
                break;
            case 4:{
                
                
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (btn.tag - 100) {
            case 0:
            case 1:{
                HtmlViewController * hvc = [[HtmlViewController alloc] init];
                hvc.i = btn.tag - 100;
                [self.navigationController pushViewController:hvc animated:YES];
            }
                break;
            case 2:{
                TransitViewController * tvc = [[TransitViewController alloc] init];
                [self.navigationController pushViewController:tvc animated:YES];
            }
                break;
 
            default:
                break;
        }

    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        [BmobUser logout];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
        [[BmobDB currentDatabase] clearAllDBCache];
        [sqlStatusTool deleteSql];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"nick"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"avatar"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pass"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vibrate"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"grabStar"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"grabStarTime"];
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];

    }
    
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
    if(self.i == 0){
        titleBar.text = @"设置";
    }else if(self.i == 1){
        titleBar.text = @"用户反馈";
    }else{
        titleBar.text = @"用户帮助";
    }
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
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
