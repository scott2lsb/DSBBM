//
//  ZhuCeYZMViewController.m
//  DSBBM
//
//  Created by bisheng on 14-8-19.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "CodeViewController.h"
#import "wishViewController.h"
#import "TransitViewController.h"



@interface CodeViewController ()

@end

@implementation CodeViewController
{
    CLLocationManager *locManager;
    BOOL isBool;
    int count;
    MBProgressHUD * HUD;
}
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
    self.view.backgroundColor = [UIColor blackColor];
    isBool = YES;
    count = 60;
    [self createNaBar];
    
    
    
    UIView * codeView = [[UIView alloc] init];
    codeView.backgroundColor = [UIColor whiteColor];
    codeView.userInteractionEnabled = YES;
    codeView.frame = CGRectMake(0, 89, 320,48);
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, 320, 0.5)];
    line.backgroundColor = [UIcol hexStringToColor:@"#bebebe"];
    [codeView addSubview:line];
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 18, 18)];
    icon.image = [UIImage imageNamed:@"xiaoxi"];
    [codeView addSubview:icon];
    
    [self.view addSubview:codeView];
    UITextField     *ncTextField = [[UITextField alloc] init];
    ncTextField.frame            = CGRectMake(50, 0, 240, 48);
    ncTextField.backgroundColor  = [UIColor clearColor];
    ncTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    ncTextField.placeholder      = @"验证码";
    ncTextField.tag = 101;
    ncTextField.font = [UIFont systemFontOfSize:14];
    ncTextField.returnKeyType    = UIReturnKeyNext;
    //    ncTextField.keyboardType     = UIKeyboardTypeNumberPad;
    ncTextField.delegate         = self;
    [codeView addSubview:ncTextField];
    
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(25,152, 270, 30)];
    sendBtn.tag = 5000;
    sendBtn.userInteractionEnabled = NO;
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setImage:[UIImage imageNamed:@"chongxinfasong"] forState:UIControlStateNormal];
    [sendBtn setImage:[UIImage imageNamed:@"chongxinfasonganniuselect"] forState:UIControlStateHighlighted];
    sendBtn.layer.cornerRadius = 6;
    sendBtn.layer.masksToBounds = YES;
    
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    number.tag = 5001;
    number.font = [UIFont systemFontOfSize:14];
    number.textColor = [UIcol hexStringToColor:@"#787878"];
    number.text = [NSString stringWithFormat:@"重新发送(%d)",count];
    number.textAlignment = NSTextAlignmentCenter;
    [sendBtn addSubview:number];
    
    NSTimer * countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
    [self.view addSubview:sendBtn];
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
            [sendBtn setImage:[UIImage imageNamed:@"chongxinfasonganniu"] forState:UIControlStateNormal];
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

-(void)Next{
    
    UITextField * tf = (id)[self.view viewWithTag:101];
    HUD = [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"注册中";
    [self.view addSubview:HUD];
    [HUD show:YES];
    [SMS_SDK commitVerifyCode:tf. text result:^(enum SMS_ResponseState state) {
        if(state == 1){
            BmobUser * bUser = [[BmobUser alloc] init];
            BmobQuery * query = [BmobQuery queryForUser];
            BmobFile * file = [[BmobFile alloc] initWithClassName:nil withFileName:@"ren.png" withFileData:UIImageJPEGRepresentation(self.t, 0.8f)];
            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful){
                    [bUser setUserName:self.tele];
                    [bUser setPassword:self.pass];
                    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if(!error){
                            [query getObjectInBackgroundWithId:bUser.objectId block:^(BmobObject *object, NSError *error){
                                if(!error){
                                    BmobObject * obj = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                                    [obj setObject:self.name forKey:@"nick"];
                                    [obj setObject:file.url forKey:@"avatar"];
                                    [obj setObject:self.sr forKey:@"birthday"];
                                    [obj setObject:[NSNumber numberWithBool:self.xb] forKey:@"sex"];
                                    [obj setObject:self.number forKey:@"bbID"];
                                    [obj setObject:@"ios" forKey:@"deviceType"];
                                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"]) {
                                        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"];
                                        NSString *strUrl = [[NSString stringWithFormat:@"%@",data] stringByReplacingOccurrencesOfString:@" " withString:@""];
                                        [[strUrl substringToIndex:(strUrl.length-1)] substringFromIndex:0];
                                        [obj setObject:[[strUrl substringToIndex:(strUrl.length-1)] substringFromIndex:1] forKey:@"installId"];
                                    }
                                    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
                                    BmobGeoPoint *location = [[BmobGeoPoint alloc] initWithLongitude:[array[0] floatValue] WithLatitude:[(id)array[1] floatValue]];
                                    
                                    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                                    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                                    NSString * qwe =[formatter stringFromDate:[NSDate date]];
                                    [obj setObject:qwe forKey:@"localtime"];
                                    [obj setObject:location forKey:@"location"];
                                    [obj setObject:[NSNumber numberWithInt:6] forKey:@"stars"];
                                    [obj setObject:@"保密" forKey:@"available"];
                                    [obj setObject:[NSNumber numberWithInt:1] forKey:@"online"];
                                    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                        if(!error){
                                            [BmobUser logInWithUsernameInBackground:self.tele password:self.pass block:^(BmobUser *user, NSError *error) {
                                                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"]) {
                                                    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"];
                                                    [[BmobUserManager currentUserManager] checkAndBindDeviceToken:data];
                                                }
                                                [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:@"nick"];
                                                [[NSUserDefaults standardUserDefaults] setObject:file.url forKey:@"avatar"];
                                                [[NSUserDefaults standardUserDefaults] setObject:self.tele forKey:@"username"];
                                                [[NSUserDefaults standardUserDefaults] setObject:self.pass forKey:@"pass"];
                                                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
                                                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.xb] forKey:@"sex"];
                                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sound"];
                                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vibrate"];
                                                TransitViewController * tvc = [[TransitViewController alloc] init];
                                                [self.navigationController pushViewController:tvc animated:YES];
                                            }];
                                        }else{
                                            HUD.labelText = @"注册失败";
                                            HUD.mode = MBProgressHUDModeCustomView;
                                            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                                            [HUD showAnimated:YES whileExecutingBlock:^{
                                                sleep(2);
                                            } completionBlock:^{
                                                [HUD removeFromSuperview];
                                                HUD = nil;
                                            }];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }else{
            HUD.labelText = @"验证码不正确";
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
                HUD = nil;
            }];
        }
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITextField * tf = (id)[self.view viewWithTag:101];
    [tf resignFirstResponder];
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
    [iv addSubview:nextBut];    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"个人资料（4/4）";
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
