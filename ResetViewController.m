//
//  ResetViewController.m
//  DSBBM
//
//  Created by bisheng on 14-11-28.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "ResetViewController.h"


@interface ResetViewController ()

@end

@implementation ResetViewController
{
    MBProgressHUD * HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self createUI];
}

-(void)createUI{
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
    ncTextField.placeholder      = @"输入旧密码";
    ncTextField.tag = 101;
    ncTextField.font = [UIFont systemFontOfSize:13];
    ncTextField.returnKeyType    = UIReturnKeyNext;
    ncTextField.delegate         = self;
    [teleImage addSubview:ncTextField];
    
    UITextField     *pwsTextField = [[UITextField alloc] init];
    pwsTextField.frame            = CGRectMake(50,48, 240,48);
    pwsTextField.backgroundColor  = [UIColor clearColor];
    pwsTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    pwsTextField.placeholder      = @"输入新密码";
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
    pwsTextField2.placeholder      = @"再次输入新密码";
    pwsTextField2.tag = 103;
    pwsTextField2.font = [UIFont systemFontOfSize:13];
    pwsTextField2.returnKeyType    = UIReturnKeyDone;
    pwsTextField2.secureTextEntry  = YES;
    pwsTextField2.delegate         = self;
    [teleImage addSubview:pwsTextField2];
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
    

    return str.length <= 14;
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


#pragma mark nabar
-(void)createNaBar{
    self.view.backgroundColor = [UIColor blackColor];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
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
    nextLab.text = @"完成";
    nextLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    nextLab.shadowOffset = CGSizeMake(1, 0.5);
    nextLab.textAlignment = NSTextAlignmentCenter;
    nextLab.font = [UIFont systemFontOfSize:15];
    nextLab.textColor = [UIColor whiteColor];
    [nextBut addSubview:nextLab];
    [iv addSubview:nextBut];
    
    
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"修改密码";
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.font = [UIFont systemFontOfSize:18];
    tit.textAlignment = YES;
    tit.textColor = [UIColor whiteColor];
    [iv addSubview:tit];
}

-(void)Next{
    UITextField * tf1 = (id)[self.view viewWithTag:101];
    UITextField * tf2 = (id)[self.view viewWithTag:102];
    UITextField * tf3 = (id)[self.view viewWithTag:103];
    
    if([tf2.text isEqualToString:tf3.text]){
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pass"]);
        if([tf1.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"pass"]]){
        }else{
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"密码错误";
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
        if(tf2.text.length >= 6){
            
        }else{
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"密码少于6位";
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
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] forKey:@"phone"];
        [dict setObject:tf2.text forKey:@"password"];
        
        [BmobCloud callFunctionInBackground:@"resetPsw" withParameters:dict block:^(id object, NSError *error) {
            
            if([object isEqualToString:@"success"]){
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"修改密码成功";
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                    HUD = nil;
                    [[NSUserDefaults standardUserDefaults] setObject:tf2.text forKey:@"pass"];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            }else{
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"修改密码失败";
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
