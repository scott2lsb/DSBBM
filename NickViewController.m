//
//  ZhuCeNCViewController.m
//  DSBBM
//
//  Created by bisheng on 14-8-19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "NickViewController.h"
#import "BirthdayViewController.h"
@interface NickViewController ()

@end

@implementation NickViewController
{
    NSArray * pickerData;
    BOOL isSex;
    MBProgressHUD * HUD;
    UILabel * sexl;
    NSString * str;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        str = [NSString stringWithFormat:@"男"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isSex = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
    UIButton * goBackBut = [[UIButton alloc] initWithFrame:CGRectMake(0,0,44, 44)];
    [goBackBut setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [goBackBut setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [goBackBut addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:goBackBut];
    UIButton * nextBut = [[UIButton alloc] initWithFrame:CGRectMake(250,0,70,44)];
    [nextBut setImage:[UIcol imageWithColor:[UIColor clearColor] size:CGSizeMake(70, 44)] forState:UIControlStateNormal];
    [nextBut setImage:[UIcol imageWithColor:[UIColor colorWithRed:0.9 green:0.74 blue:0 alpha:1] size:CGSizeMake(70, 44)] forState:UIControlStateHighlighted];
    [nextBut addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    UILabel * nextLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    nextLab.text = @"下一步";
    nextLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    nextLab.shadowOffset = CGSizeMake(1, 0.5);
    nextLab.textAlignment = NSTextAlignmentCenter;
    nextLab.font = [UIFont systemFontOfSize:15];
    nextLab.textColor = [UIColor whiteColor];
    [nextBut addSubview:nextLab];
    [iv addSubview:nextBut];
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"输入性别（1/4）";
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.textAlignment = YES;
    tit.font = [UIFont systemFontOfSize:18];
    tit.textColor = [UIColor whiteColor];
    [iv addSubview:tit];
    
    
    UIView * nickView = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 320, 48)];
    nickView.userInteractionEnabled = YES;
    nickView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * sexView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 18, 18)];
    sexView.image = [UIImage imageNamed:@"xingbie"];
    [nickView addSubview:sexView];
    
    UILabel * warn = [[UILabel alloc] initWithFrame:CGRectMake(25, 152, 200, 20)];
    warn.text = @"性别选择后不允许修改，请谨慎操作";
    warn.font = [UIFont systemFontOfSize:11];
    warn.textColor = [UIcol hexStringToColor:@"bebebe"];
    [self.view addSubview:warn];
    
    UIButton     * sexBtn = [[UIButton alloc] init];
     sexBtn.frame            = CGRectMake(53, 0, 240, 48);
    sexl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 420, 48)];
    sexl.text = @"性别";
    sexl.tag = 102;
    sexl.textColor = [UIcol hexStringToColor:@"bebebe"];
    sexl.font = [UIFont systemFontOfSize:11];
    [sexBtn addSubview:sexl];
    [sexBtn addTarget:self action:@selector(sex) forControlEvents:UIControlEventTouchUpInside];
    [nickView addSubview:sexBtn];
    [self.view addSubview:nickView];
    
    UIView * pickerViewv = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 0, 0)];
    UIPickerView * pickerView = [[UIPickerView alloc] init];
    pickerView.center = CGPointMake(160, self.view.bounds.size.height * 2 / 3);
    //    指定Delegate
    pickerViewv.tag = 501;
    pickerView.delegate=self;
    //    显示选中框
    pickerView.showsSelectionIndicator=YES;
    NSArray *dataArray = [[NSArray alloc]initWithObjects:@"男",@"女", nil];
    
    pickerData=dataArray;
    [pickerViewv addSubview:pickerView];
    [self.view addSubview:pickerViewv];
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        UIView * v = (id)[self.view viewWithTag:501];
        v.frame = CGRectMake(320, 0, 0, 0);
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *seletedProvince = [pickerData objectAtIndex:row];
    UILabel * tf = (id)[self.view viewWithTag:102];
    tf.textColor = [UIcol hexStringToColor:@"787878"];
    tf.text = seletedProvince;
    str = seletedProvince;
    if([seletedProvince isEqualToString:@"男"]){
        self.xb = YES;
    }else{
        self.xb = NO;
    }
    isSex = YES;

}

-(void)sex{
    UILabel * tf = (id)[self.view viewWithTag:102];
    tf.textColor = [UIcol hexStringToColor:@"787878"];
    tf.text = str;
    if([tf.text isEqualToString:@"男"]){
        self.xb = YES;
    }else{
        self.xb = NO;
    }
    isSex = YES;
    UIView * pickerViewv = (id)[self.view viewWithTag:501];
    pickerViewv.frame = self.view.bounds;
}

-(void)Next{
    if(isSex == YES){
        BirthdayViewController * xxvc = [[BirthdayViewController alloc] init];
        xxvc.sex = self.xb;
        [self.navigationController pushViewController:xxvc animated:YES];
    }else{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"请输入性别";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUD removeFromSuperview];
            HUD = nil;
        }];
    }
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
