//
//  ZhuCeViewController.m
//  DSBBM
//
//  Created by bisheng on 14-8-19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "UserViewController.h"

#import "CodeViewController.h"

#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>


@interface UserViewController ()

@end

@implementation UserViewController
{
       CLLocationManager *locManager;
    UIView * iv;
    MBProgressHUD * HUD;
    BOOL isNext;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isNext = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    
  
   
    [self createNaBar];
  
    UIView * teleImage = [[UIView alloc] initWithFrame:CGRectMake(0, 89, self.view.bounds.size.width, 144)];
    teleImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:teleImage];
    
    UIImageView * photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 18, 18)];
    photoImage.image = [UIImage imageNamed:@"shouji"];
    [teleImage addSubview:photoImage];
    
    UIImageView * passImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,48 + 15, 18, 18)];
    passImage.image = [UIImage imageNamed:@"mima"];
    [teleImage addSubview:passImage];

    UIImageView * passImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(25,96 + 15, 18, 18)];
    passImage2.image = [UIImage imageNamed:@"mima"];
    [teleImage addSubview:passImage2];

    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(25, 47.5, 295, 0.5)];
    line1.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [teleImage addSubview:line1];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(25,48 + 47.5, 295, 0.5)];
    line2.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [teleImage addSubview:line2];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0,96 + 47.5,320, 0.5)];
    line3.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [teleImage addSubview:line3];
    
    UITextField     *ncTextField = [[UITextField alloc] init];
    ncTextField.frame            = CGRectMake(50, 0, 240,48);
    ncTextField.backgroundColor  = [UIColor clearColor];
    ncTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    ncTextField.placeholder      = @"请输入手机号";
    ncTextField.tag = 101;
    ncTextField.font = [UIFont systemFontOfSize:13];
    ncTextField.returnKeyType    = UIReturnKeyNext;
    ncTextField.delegate         = self;
    [teleImage addSubview:ncTextField];
    
    UITextField     *pwsTextField = [[UITextField alloc] init];
    pwsTextField.frame            = CGRectMake(50,48, 240,48);
    pwsTextField.backgroundColor  = [UIColor clearColor];
    pwsTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    pwsTextField.placeholder      = @"请输入密码";
    pwsTextField.tag = 102;
    pwsTextField.font = [UIFont systemFontOfSize:13];
    pwsTextField.returnKeyType    = UIReturnKeyDone;
    pwsTextField.secureTextEntry  = YES;
    pwsTextField.delegate         = self;
    [teleImage addSubview:pwsTextField];
    
    
    UITextField     *pwsTextField2 = [[UITextField alloc] init];
    pwsTextField2.frame            = CGRectMake(50,96, 240,48);
    pwsTextField2.backgroundColor  = [UIColor clearColor];
    pwsTextField2.clearButtonMode  = UITextFieldViewModeWhileEditing;
    pwsTextField2.placeholder      = @"请再次输入密码";
    pwsTextField2.tag = 103;
    pwsTextField2.font = [UIFont systemFontOfSize:13];
    pwsTextField2.returnKeyType    = UIReturnKeyDone;
    pwsTextField2.secureTextEntry  = YES;
    pwsTextField2.delegate         = self;
    [teleImage addSubview:pwsTextField2];
  
   
  
    
}

#pragma mark nabar
-(void)createNaBar{
    self.view.backgroundColor = [UIColor blackColor];
    iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor =  [UIcol hexStringToColor:@"#f2f2f2"];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
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
    tit.text = @"个人资料（3/4）";
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.font = [UIFont systemFontOfSize:18];
    tit.textAlignment = YES;
    tit.textColor = [UIColor whiteColor];
    [iv addSubview:tit];
}


-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)Next{
    if(isNext != YES){
        return;
    }
    isNext = NO;
    UITextField * nameTF = (id)[self.view viewWithTag:101];
    UITextField * passTF = (id)[self.view viewWithTag:102];
    UITextField * passTF2 = (id)[self.view viewWithTag:103];
    if([self isMobileNumber:nameTF.text]){
        BmobQuery * query = [BmobQuery queryForUser];
        [query whereKey:@"username" equalTo:nameTF.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            isNext = YES;
            if(!error){
            }else{
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"当前网络不稳定请重试";
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                    HUD = nil;
                }];
            }
            if(array.count == 0){
                if(passTF.text.length >= 6){
                    
                }else{
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = @"密码不得少于6位";
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        HUD = nil;
                    }];
                    return;
                }
                
                if([passTF.text isEqual:passTF2.text]){
                    
                    [SMS_SDK getVerifyCodeByPhoneNumber:nameTF.text AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
                        if (1==state) {
                            NSLog(@"block 获取验证码成功");
                            
                        }
                        else if(0==state)
                        {
                            NSLog(@"block 获取验证码失败");
                        }
                        
                    }];
                    
                    CodeViewController * yzmvc = [[CodeViewController alloc] init];
                    yzmvc.pass = passTF.text;
                    yzmvc.tele = nameTF.text;
                    yzmvc.name = self.name;
                    yzmvc.xb = self.xb;
                    yzmvc.sr = self.sr;
                    yzmvc.t = self.t;
                    yzmvc.number = self.number;
                    [self.navigationController pushViewController:yzmvc  animated:YES];
                }else{
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = @"两次密码不一致";
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        HUD = nil;
                    }];
                    
                }
            }else{
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"此号码已被注册";
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                    HUD = nil;
                }];
            }
        }];

    }else{
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"手机号输入不正确";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUD removeFromSuperview];
            HUD = nil;
        }];
        return;
    }
   
}


-(BOOL)isMobileNumber:(NSString *)mobileNum{
/**
 * 手机号码
 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
 * 联通：130,131,132,152,155,156,185,186,1709
 * 电信：133,1349,153,180,189,1700
 */
        NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况

/**
 10         * 中国移动：China Mobile
 11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
 12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
/**
 15         * 中国联通：China Unicom
 16         * 130,131,132,152,155,156,185,186,1709
 17         */
        NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
/**
 20         * 中国电信：China Telecom
 21         * 133,1349,153,180,189,1700
 22         */
        NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
        
        
/**
 25         * 大陆地区固话及小灵通
 26         * 区号：010,020,021,022,023,024,025,027,028,029
 27         * 号码：七位或八位
 28         */
        NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";


        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
        
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        ||  ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
            return YES;
        }
        else
        {
            return NO;
        }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(int j = 1 ; j<4 ; j++){
    UITextField * tf = (id)[self.view viewWithTag:j+100];
    [tf resignFirstResponder];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
            
        case 101:
        {
            
            UITextField * textField2 = (id)[self.view viewWithTag:102];
            [textField2 becomeFirstResponder];
        }
            break;
        case 102:
        {
            
            UITextField * textField2 = (id)[self.view viewWithTag:103];
            [textField2 becomeFirstResponder];
        }
            break;
        case 103:
            [textField resignFirstResponder];
            break;
            
        default:
            break;
    }
    
    return YES;

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * str = [[NSMutableString alloc] initWithString:textField.text];
    
    [str insertString:string atIndex:range.location];
    
    if(textField.tag == 101){
        if([self validateNumber:string] == YES){
            return str.length <= 11;
        }else{
            return [self validateNumber:string];
        }
    }
    return str.length <= 11;
}

- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
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
