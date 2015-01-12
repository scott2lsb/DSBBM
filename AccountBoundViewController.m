//
//  AccountBoundViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-10-6.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "AccountBoundViewController.h"
//#import "PhoneInViewController.h"

@interface AccountBoundViewController ()
{
    UIButton *threeBtn;
}
@end


@implementation AccountBoundViewController

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
    [self createNaBar];
    [self createUI];
   
}

-(void)createUI{
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 50)];
    back.backgroundColor = [UIColor whiteColor];
    
    UIImageView * teleImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25, 25)];
    UILabel * tele = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 100, 50)];
    tele.font = [UIFont systemFontOfSize:13];
    tele.textColor = [UIcol hexStringToColor:@"bebebe"];
//    if([self.tele integerValue] == 1){
        teleImage.image = [UIImage imageNamed:@"shoujibangding"];
        tele.text = @"已绑定";
//    }else{
//        teleImage.image = [UIImage imageNamed:@"shoujiweibangding"];
//        tele.text = @"未绑定";
//    }
    [back addSubview:tele];
    [back addSubview:teleImage];
    
    
    UILabel * teleLab = [[UILabel alloc] initWithFrame:CGRectMake(50,0, 100, 50)];
    teleLab.text = @"手机绑定";
    teleLab.font = [UIFont systemFontOfSize:15];
    teleLab.textColor = [UIcol hexStringToColor:@"787878"];
    [back addSubview:teleLab];
    
     UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, 305, 0.5)];
    line1.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [back addSubview:line1];
  
    
    UIButton * teleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [teleBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] size:CGSizeMake(320, 50)] forState:UIControlStateHighlighted];
    [teleBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    teleBtn.tag = 100;
    [back addSubview:teleBtn];
    
    
    [self.view addSubview:back];
}

-(void)onClick:(UIButton *)btn{
//    PhoneInViewController * pvc = [[PhoneInViewController alloc] init];
//    [self.navigationController pushViewController:pvc animated:YES];
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
    titleBar.text = @"账号绑定";
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
