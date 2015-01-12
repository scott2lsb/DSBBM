//
//  changePassViewController.m
//  DSBBM
//
//  Created by bisheng on 14-11-26.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "changePassViewController.h"

@interface changePassViewController ()

@end

@implementation changePassViewController
{
    int count;
    BOOL isBool;
    MBProgressHUD * HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBool = YES;
    count = 60;
    [self createNaBar];
    [self createTF];
}

-(void)createTF{
    
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 89, self.view.bounds.size.width,144)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    
    UIImageView * codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 18, 18)];
    codeImage.image = [UIImage imageNamed:@"xiaoxi"];
    [back addSubview:codeImage];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(25, 47.5, 295, 0.5)];
    line1.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [back addSubview:line1];
    
    UITextField     *codeTextField = [[UITextField alloc] init];
    codeTextField.frame            = CGRectMake(50, 0, 240,48);
    codeTextField.backgroundColor  = [UIColor clearColor];
    codeTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    codeTextField.placeholder      = @"输入验证码";
    codeTextField.tag = 101;
    codeTextField.font = [UIFont systemFontOfSize:13];
    codeTextField.returnKeyType    = UIReturnKeyNext;
    codeTextField.delegate         = self;
    [back addSubview:codeTextField];
    
    UIImageView * passImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 48+ 15, 18, 18)];
    passImage.image = [UIImage imageNamed:@"mima"];
    [back addSubview:passImage];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(25,48 + 47.5,295, 0.5)];
    line2.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [back addSubview:line2];
    
    UITextField     *passTextField = [[UITextField alloc] init];
    passTextField.frame            = CGRectMake(50,48, 240,48);
    passTextField.backgroundColor  = [UIColor clearColor];
    passTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    passTextField.placeholder      = @"输入登陆密码";
    passTextField.tag = 102;
    passTextField.font = [UIFont systemFontOfSize:13];
    passTextField.returnKeyType    = UIReturnKeyNext;
    passTextField.delegate         = self;
    [back addSubview:passTextField];
    
    UIImageView * passImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 96+ 15, 18, 18)];
    passImage2.image = [UIImage imageNamed:@"mima"];
    [back addSubview:passImage2];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0,96 + 47.5,320, 0.5)];
    line3.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [back addSubview:line3];
    
    UITextField     *passTextField2 = [[UITextField alloc] init];
    passTextField2.frame            = CGRectMake(50,96, 240,48);
    passTextField2.backgroundColor  = [UIColor clearColor];
    passTextField2.clearButtonMode  = UITextFieldViewModeWhileEditing;
    passTextField2.placeholder      = @"再次输入登陆密码";
    passTextField2.tag = 103;
    passTextField2.font = [UIFont systemFontOfSize:13];
    passTextField2.returnKeyType    = UIReturnKeyNext;
    passTextField2.delegate         = self;
    [back addSubview:passTextField2];

    
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(25,254, 270, 30)];
    sendBtn.tag = 5000;
    sendBtn.userInteractionEnabled = NO;
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setImage:[UIImage imageNamed:@"chongxinfasong"] forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageNamed:@"chongxinselect"] forState:UIControlStateHighlighted];
    sendBtn.layer.cornerRadius = 6;
    sendBtn.layer.masksToBounds = YES;
    
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    number.tag = 5001;
    number.font = [UIFont systemFontOfSize:14];
    number.textColor = [UIcol hexStringToColor:@"#787878"];
    number.text = [NSString stringWithFormat:@"重新发送(%d)",count];
    number.textAlignment = NSTextAlignmentCenter;
    [sendBtn addSubview:number];
    [self.view addSubview:sendBtn];
    NSTimer * countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}

-(void)timeFireMethod{
    if(isBool == YES){
        UIButton * sendBtn = (id)[self.view viewWithTag:5000];
        UILabel * number = (id)[self.view viewWithTag:5001];
        count--;
        number.text = [NSString stringWithFormat:@"重新发送(%d)",count];
        if(count == 0){
            isBool = NO;
            number.text = @"重新发送";
            sendBtn.userInteractionEnabled = YES;
            number.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
            [sendBtn setImage:[UIImage imageNamed:@"chongxin"] forState:UIControlStateNormal];
        }
    }
}

-(void)send{
    UIButton * sendBtn = (id)[self.view viewWithTag:5000];
    UILabel * number = (id)[self.view viewWithTag:5001];
    if(isBool == YES){
        
    }else{
        count = 60;
        number.text = [NSString stringWithFormat:@"重新发送(%d)",count];
        isBool = YES;
        number.textColor = [UIcol hexStringToColor:@"#787878"];
        sendBtn.userInteractionEnabled = NO;
        [sendBtn setImage:[UIImage imageNamed:@"chongxinfasong"] forState:UIControlStateNormal];
        [SMS_SDK getVerifyCodeByPhoneNumber:self.tele AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSMutableString * str = [[NSMutableString alloc] initWithString:textField.text];
    
    [str insertString:string atIndex:range.location];
    
    if(textField.tag == 101){
        if([self validateNumber:string] == YES){
            return str.length <= 4;
        }else{
            return [self validateNumber:string];
        }
    }
    return str.length <= 4;
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
    nextLab.text = @"提交";
    nextLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    nextLab.shadowOffset = CGSizeMake(1, 0.5);
    nextLab.textAlignment = NSTextAlignmentCenter;
    nextLab.font = [UIFont systemFontOfSize:15];
    nextLab.textColor = [UIColor whiteColor];
    [nextBut addSubview:nextLab];
    [iv addSubview:nextBut];
    
    
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"重置密码（2/2）";
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
    if(tf2.text.length >= 6){
    if([tf2.text isEqualToString:tf3.text]){
        [SMS_SDK commitVerifyCode:tf1.text result:^(enum SMS_ResponseState state) {
            if(state == 1){
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:self.tele forKey:@"phone"];
            [dict setObject:tf2.text forKey:@"password"];
            [BmobCloud callFunctionInBackground:@"resetPsw" withParameters:dict block:^(id object, NSError *error) {
    
                   if([object isEqualToString:@"success"]){
                       NSArray * array = self.navigationController.viewControllers;
                    UIViewController * vc = array[1];
                    [self.navigationController popToViewController:vc animated:YES];
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
                HUD.labelText = @"验证码错误";
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
