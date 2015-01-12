//
//  forgetPassViewController.m
//  DSBBM
//
//  Created by bisheng on 14-11-26.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "forgetPassViewController.h"
#import "changePassViewController.h"

@interface forgetPassViewController ()
{
    MBProgressHUD * HUD;
}
@end

@implementation forgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    [self createTF];
}

-(void)createTF{
    
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 89, self.view.bounds.size.width, 48)];
    back.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:back];
    
    UIImageView * photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 18, 18)];
    photoImage.image = [UIImage imageNamed:@"shouji"];
    [back addSubview:photoImage];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(25, 47.5, 295, 0.5)];
    line1.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [back addSubview:line1];
    
    UITextField     *ncTextField = [[UITextField alloc] init];
    ncTextField.frame            = CGRectMake(50, 0, 240,48);
    ncTextField.backgroundColor  = [UIColor clearColor];
    ncTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    ncTextField.placeholder      = @"请输入与帮帮号绑定的手机号";
    ncTextField.tag = 101;
    ncTextField.font = [UIFont systemFontOfSize:13];
    ncTextField.returnKeyType    = UIReturnKeyNext;
    ncTextField.delegate         = self;
    [back addSubview:ncTextField];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

        UITextField * tf = (id)[self.view viewWithTag:101];
        [tf resignFirstResponder];

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  
    UITextField * tf = (id)[self.view viewWithTag:101];
        
    [tf resignFirstResponder];
    return YES;
    
    
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
    nextLab.text = @"下一步";
    nextLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    nextLab.shadowOffset = CGSizeMake(1, 0.5);
    nextLab.textAlignment = NSTextAlignmentCenter;
    nextLab.font = [UIFont systemFontOfSize:15];
    nextLab.textColor = [UIColor whiteColor];
    [nextBut addSubview:nextLab];
    [iv addSubview:nextBut];
    
    
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"重置密码（1/2）";
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.font = [UIFont systemFontOfSize:18];
    tit.textAlignment = YES;
    tit.textColor = [UIColor whiteColor];
    [iv addSubview:tit];
}

-(void)Next{
    UITextField * tf = (id)[self.view viewWithTag:101];
    if([self isMobileNumber:tf.text]){
        changePassViewController * cpvc = [[changePassViewController alloc] init];
        cpvc.tele = tf.text;
        [self.navigationController pushViewController:cpvc animated:YES];
        [SMS_SDK getVerifyCodeByPhoneNumber:tf.text AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
            
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
