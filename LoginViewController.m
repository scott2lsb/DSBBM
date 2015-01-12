//
//  LoginViewController.m
//  DSBBM
//
//  Created by bisheng on 14-8-18.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "LoginViewController.h"
#import "wishViewController.h"
#import "forgetPassViewController.h"
#import "NickViewController.h"
#import "TransitViewController.h"
#import "chatData.h"
#import "synFriends.h"
#import "NSString+Emote.h"

@interface LoginViewController ()
@end

@implementation LoginViewController
{
    UIView * loginBack;
    UIImageView * logo;
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
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createUI];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        _locationManager = [[CLLocationManager alloc]init];
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }else{
        _locationManager = [[CLLocationManager alloc]init];
    }
    [_locationManager startUpdatingLocation];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1000.0f;
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude]];
    [array addObject:[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude]];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"location"];
    [self createNotificationCenter];
}


- (void)createNotificationCenter
{
    //nc是个单例对象
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    
    //在通知中心中注册需要监听的通知
    [nc addObserver:self selector:@selector(recievedShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(recievedHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

//收到对应通知，调用这个方法
- (void)recievedShowNotification:(NSNotification *)notifi
{[UIView animateWithDuration:0.3 animations:^{
      if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        loginBack.frame = CGRectMake(0, 55, self.view.bounds.size.width, 250);
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
        loginBack.frame = CGRectMake(0, 30, self.view.bounds.size.width, 250);
    }
}];
}


- (void)recievedHideNotification:(NSNotification *)notifi
{
 [UIView animateWithDuration:0.3 animations:^{
     if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
         loginBack.frame = CGRectMake(0, 175, self.view.bounds.size.width, 250);
     }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
         loginBack.frame = CGRectMake(0, 140, self.view.bounds.size.width, 250);
     }
 }];

    
    
}


-(void)createUI{
    
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    logo = [[UIImageView alloc]init];
    logo.image = [UIImage imageNamed:@"logo"];
    [iv addSubview:logo];
    
    loginBack = [[UIView alloc] init];
    [iv addSubview:loginBack];
    
    UIView * tfBack = [[UIView alloc] initWithFrame:CGRectMake(35, 10, 250, 101.5)];
    tfBack.backgroundColor = [UIColor whiteColor];
    [tfBack.layer setBorderWidth:0.5]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.9, 0.9, 0.9, 1 });
    [tfBack.layer setCornerRadius:5];
    [tfBack.layer setBorderColor:colorref];
    [loginBack addSubview:tfBack];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15,50.5, 220, 0.5)];
    line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [tfBack addSubview:line];
    
    UIImageView * sicon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 18, 18)];
    sicon.image = [UIImage imageNamed:@"yonghu"];
    [tfBack addSubview:sicon];
    UIImageView * xicon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16 + 51, 18, 18)];
    xicon.image = [UIImage imageNamed:@"mima"];
    [tfBack addSubview:xicon];
    
    UITextField     *ncTextField = [[UITextField alloc] init];
    ncTextField.frame            = CGRectMake(40, 0, 170,50.5);
    ncTextField.backgroundColor  = [UIColor clearColor];
    ncTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    ncTextField.placeholder      = @"手机号或帮帮账号";
    ncTextField.tag = 101;
    ncTextField.font = [UIFont systemFontOfSize:14];
    ncTextField.textColor = [UIcol hexStringToColor:@"bebebe"];
    ncTextField.returnKeyType    = UIReturnKeyNext;
    ncTextField.delegate         = self;
    [tfBack addSubview:ncTextField];
    
    
    UITextField     *pwsTextField = [[UITextField alloc] init];
    pwsTextField.frame            = CGRectMake(40,51, 170,50.5);
    pwsTextField.backgroundColor  = [UIColor clearColor];
    pwsTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    pwsTextField.placeholder      = @"登陆密码";
    pwsTextField.tag = 102;
    pwsTextField.font = [UIFont systemFontOfSize:14];
    pwsTextField.textColor = [UIcol hexStringToColor:@"bebebe"];
    pwsTextField.returnKeyType    = UIReturnKeyDone;
    pwsTextField.secureTextEntry  = YES;
    pwsTextField.delegate         = self;
    [tfBack addSubview:pwsTextField];

    UIButton * loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 127, 250, 40)];
    [loginBtn setImage:[UIImage imageNamed:@"denglu"] forState:UIControlStateNormal];
    [loginBtn setImage:[UIImage imageNamed:@"dengluchuji"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginBack addSubview:loginBtn];
    
    UILabel * loginLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    loginLab.text = @"登陆";
    loginLab.font = [UIFont systemFontOfSize:15];
    loginLab.textColor = [UIcol hexStringToColor:@"2e2e2e"];
    loginLab.textAlignment = NSTextAlignmentCenter;
    [loginBtn addSubview:loginLab];
    
    UIButton * signBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 182, 250, 40)];
    [signBtn setImage:[UIcol imageWithColor:[UIColor whiteColor] size:CGSizeMake(250, 40)] forState:UIControlStateNormal];
    [signBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] size:CGSizeMake(250, 40)] forState:UIControlStateHighlighted];
    signBtn.clipsToBounds = YES;
    [signBtn addTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
    [signBtn.layer setBorderWidth:0.5]; //边框宽度
    [signBtn.layer setCornerRadius:5];
    [signBtn.layer setBorderColor:colorref];
    [loginBack addSubview:signBtn];
    
    UILabel *signLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    signLab.text = @"注册";
    signLab.font = [UIFont systemFontOfSize:15];
    signLab.textColor = [UIcol hexStringToColor:@"2e2e2e"];
    signLab.textAlignment = NSTextAlignmentCenter;
    [signBtn addSubview:signLab];
    
    UIButton * forgetbtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 227, 100, 20)];
    [forgetbtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    [loginBack addSubview:forgetbtn];
    
    UILabel * forgetl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    forgetl.text = @"忘记密码?";
    forgetl.font = [UIFont systemFontOfSize:11];
    forgetl.textColor = [UIcol hexStringToColor:@"bebebe"];
    [forgetbtn addSubview:forgetl];
    
    UIView * forgetLine = [[UIView alloc] initWithFrame:CGRectMake(0,19.5, 50, 0.5)];
    forgetLine.backgroundColor = [UIcol hexStringToColor:@"bebebe"];
    [forgetl addSubview:forgetLine];
    
    UILabel * tit = [[UILabel alloc] init];
    tit.textAlignment = NSTextAlignmentCenter;
    tit.textColor = [UIcol hexStringToColor:@"787878"];
    tit.font = [UIFont systemFontOfSize:13];
    tit.text = @"内测版";
    [iv addSubview:tit];
    
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        logo.frame = CGRectMake(117, 70, 87, 80);
        loginBack.frame = CGRectMake(0, 175, self.view.bounds.size.width, 250);
        tit.frame = CGRectMake(0, 515, self.view.bounds.size.width, 12);
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
       logo.frame = CGRectMake(117, 45, 87, 80);
        loginBack.frame = CGRectMake(0, 140, self.view.bounds.size.width, 250);
        tit.frame = CGRectMake(0, 428, self.view.bounds.size.width, 12);
    }
    
}

-(void)forget{
    forgetPassViewController * fpvc = [[forgetPassViewController alloc] init];
    [self.navigationController pushViewController:fpvc animated:YES];
}


-(void)sign{
    NickViewController * nvc = [[NickViewController alloc] init];
    [self.navigationController pushViewController:nvc animated:YES];
}

-(void)login{
    UITextField * nameTF = (id)[self.view viewWithTag:101];
    UITextField * passTF = (id)[self.view viewWithTag:102];
    HUD = [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"登陆中";
    [self.view addSubview:HUD];
    [HUD show:YES];
    [BmobUser logInWithUsernameInBackground:nameTF.text password:passTF.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            if([[error.userInfo objectForKey:@"error"]isEqualToString:@"username or password incorrect."]){
                HUD.labelText = @"账号或密码错误";
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                    HUD = nil;
                }];
            }else{
                HUD.labelText = @"登陆失败";
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
           
            [HUD removeFromSuperview];
            HUD = nil;
            if([[user objectForKey:@"blockade"] integerValue] == 1){
                
                return ;
            }
            NSString * nick = [user objectForKey:@"nick"];
            NSString * avatar = [user objectForKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:nick forKey:@"nick"];
            [[NSUserDefaults standardUserDefaults] setObject:avatar forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:nameTF.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:passTF.text forKey:@"pass"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sound"];
            [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"sex"] forKey:@"sex"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vibrate"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
            NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
      
            BmobGeoPoint *location = [[BmobGeoPoint alloc] initWithLongitude:[array[0] floatValue] WithLatitude:[(id)array[1] floatValue]];
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            NSString * qwe =[formatter stringFromDate:[NSDate date]];
            [user setObject:qwe forKey:@"localtime"];
            [user setObject:[NSNumber numberWithInt:1] forKey:@"online"];
            [user setObject:location forKey:@"location"];
            //更新定位
            [user updateInBackground];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"]) {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfDeviceToken"];
                [[BmobUserManager currentUserManager] checkAndBindDeviceToken:data];
            }
            BmobUser * user = [BmobUser getCurrentUser];
            NSLog(@"%@",[user objectForKey:@"lastWish"]);
            
            if(![[NSString stringWithFormat:@"%@",[user objectForKey:@"lastWish"]]isEqualToString:@"(null)"]){
                [synFriends synchFriend];
                //每次进去后，将上一次从网上去下的数据中最后一条作为时间戳，若是，接受到新的信息，以新的信息为准
                NSString *lastTime = [chatData readChatMessageTimeAndSaveTime];
                if(![lastTime isBlankString]){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date = [dateFormatter dateFromString:[user objectForKey:@"exittime"]];
                    lastTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                    [chatData saveChatMessageTime:lastTime];
                }
               [chatData getMessageWhenReceivePush:lastTime successful:^(BOOL successful, NSDictionary *dict) {
               }];
                BmobQuery * query = [BmobQuery queryWithClassName:@"WishMsg"];
                [query whereKey:@"toUser" equalTo:user.objectId];
                [query whereKey:@"updatedAt" greaterThan:[user objectForKey:@"exittime"]];
                [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                    if(!error){
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] + number] forKey:@"addLike"];
                        NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:center];
                    }
                }];
                BmobQuery *  queryVisitor = [BmobQuery queryWithClassName:@"RecentVisitor"];
                [queryVisitor whereKey:@"respondents" equalTo:user.objectId];
                [queryVisitor whereKey:@"updatedAt" greaterThan:[user objectForKey:@"exittime"]];
                [queryVisitor countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                    if(!error){
                        if(number != 0){
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"visit"];
                            NSNotification * center = [[NSNotification alloc] initWithName:@"news" object:nil userInfo:nil];
                            [[NSNotificationCenter defaultCenter] postNotification:center];
                        }
                    }
                }];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"exittime"];


                WishViewController * jhy = [[WishViewController alloc] init];
                [self.navigationController pushViewController:jhy animated:YES];
            }else{
                TransitViewController * tvc = [[TransitViewController alloc] init];
                [self.navigationController pushViewController:tvc animated:YES];
        }
        }
       
    }];
    
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
    }else{
        return str.length <= 14;
    }
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(int i = 1 ; i<3 ; i++){
        UITextField * tf = (id)[self.view viewWithTag:i+100];
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
            [textField resignFirstResponder];
            break;
            
        default:
            break;
    }
    
    return YES;
    
    
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
