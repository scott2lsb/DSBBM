//
//  LampViewController.m
//  DSBBM
//
//  Created by bisheng on 14-10-13.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "LampViewController.h"
#import "ChooseWishViewController.h"
#import "DetailWishViewController.h"
#import "WishModel.h"
#import "GrabStarViewController.h"
#import <AVFoundation/AVFoundation.h>


#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
@interface LampViewController ()

@end

@implementation LampViewController
{
    UIImageView * lamp;
    CABasicAnimation * shake;
    BOOL islamp;
    BOOL iswish;
    UIImageView * back;
    NSString * avatar;
    NSString * wishtf;
    BmobObject * wishObject;
    int i;
    int k;
    UIView * wishBack;
    UIView * wishV;
    WishModel * wishModel;
    UIView * star;
    NSString * userId;
    UIImageView * avatarv;
    TQRichTextView * wishtv;
    UIView * progressBar;
    NSDictionary * chatDict;
    MBProgressHUD * HUD;
    UIImageView * bling;
    UIButton * lead;
    UIImageView * rub;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    islamp = NO;
    [self createNarBar];
    [self createUI];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNot) name:@"news" object:nil];
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 50,300)];
    [self.view addSubview:v];
    [v addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:(DEMONavigationController *)self.navigationController  action:@selector(panGestureRecognized:)]];
}

-(void)recieveNot{
    
    [self changeNaBar];
}

-(void)viewWillAppear:(BOOL)animated{
    HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"加载中";
    [self.view addSubview:HUD];
    [HUD show:YES];
    [self getStar];
}

-(void)getStar{
    wishModel = [[WishModel alloc] init];
    BmobUser * user = [BmobUser getCurrentUser];
    BmobQuery * query = [BmobQuery queryForUser];
    [query getObjectInBackgroundWithId:user.objectId block:^(BmobObject *object, NSError *error) {
        i = [[object objectForKey:@"stars"] integerValue];
        [self getWish];
    }];
}

-(void)createUI{
    back = [[UIImageView alloc] initWithFrame:CGRectMake(0,64, 320,self.view.bounds.size.height - 114)];

    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        back.image = [UIImage  imageNamed:@"aladingshendengdichang"];
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
    
        back.image = [UIImage  imageNamed:@"aladingshendengdi"];
    }
    back.userInteractionEnabled = YES;
    [self.view addSubview:back];
    bling = [[UIImageView alloc] initWithFrame:CGRectMake(90, back.frame.size.height -120,0,0)];
    bling.image = [UIImage imageNamed:@"bling"];
    [back addSubview:bling];
    UIView * wishView = [[UIView alloc] initWithFrame:CGRectMake(5,5, 310, 65)];
    wishView.layer.cornerRadius = 8;
    wishView.layer.masksToBounds = YES;
    wishView.backgroundColor = [UIColor whiteColor];
    [back addSubview:wishView];
    
    avatarv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 45, 45)];
    avatarv.layer.cornerRadius = 8;
    avatarv.layer.masksToBounds = YES;
    [wishView addSubview:avatarv];
    
    wishtv = [[TQRichTextView alloc] initWithFrame:CGRectMake(60, 15, 170, 36)];
    wishtv.backgroundColor = [UIColor clearColor];
    wishtv.font = [UIFont systemFontOfSize:14];
    wishtv.textColor = [UIcol hexStringToColor:@"787878"];
    wishtv.userInteractionEnabled = NO;
    [wishView addSubview:wishtv];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(240,12.5, 1, 40)];
    line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [wishView addSubview:line];
    
    UIButton * alter = [[UIButton alloc] initWithFrame:CGRectMake(250, 22.5, 50,20)];
    [alter setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    [alter setImage:[UIImage imageNamed:@"xiugaiselect"] forState:UIControlStateHighlighted];
    [alter addTarget:self action:@selector(alterWish) forControlEvents:UIControlEventTouchUpInside];
    [wishView addSubview:alter];
    UIImageView * starNull = [[UIImageView alloc] init];
    starNull.frame = CGRectMake(0,self.view.bounds.size.height - 114, 320,50);
    starNull.image = [UIImage imageNamed:@"xingxingkong"];
    [back addSubview:starNull];
    
    star = [[UIView alloc] initWithFrame:CGRectMake(0,0,(42 * i) + 13.5,50)];
    star.clipsToBounds = YES;
    [starNull addSubview:star];
    
    UIImageView * starFull = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320,50)];
    starFull.image = [UIImage imageNamed:@"xingxingman"];
    [star addSubview:starFull];
    
    UIButton * grabBtn= [[UIButton alloc] initWithFrame:CGRectMake(272,self.view.bounds.size.height - 40,30,30)];
    [grabBtn setImage:[UIImage imageNamed:@"keqiang"] forState:UIControlStateNormal];
    [grabBtn setImage:[UIImage imageNamed:@"keqiangselect"] forState:UIControlStateHighlighted];
    [grabBtn addTarget:self action:@selector(grab) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grabBtn];
    
    progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0, 1)];
    progressBar.backgroundColor = [UIcol hexStringToColor:@"fad219"];
    [starNull addSubview:progressBar];
    
    wishBack = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 0, 0)];
    wishBack.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:wishBack];
    [self createWish];
    
    [self createLamp];
}

-(void)grab{
    GrabStarViewController * gsvc = [[GrabStarViewController alloc] init];
    gsvc.userId = userId;
    gsvc.i = i;
    [self.navigationController pushViewController:gsvc animated:YES];
}

-(void)alterWish{
    [lead removeFromSuperview];
    ChooseWishViewController * cwvc = [[ChooseWishViewController alloc] init];
    WishModel * wish = [[WishModel alloc] init];
    wish.image = [wishObject objectForKey:@"url"];
    wish.context = [wishObject objectForKey:@"text"];
    wish.comment = [wishObject objectForKey:@"comment"];
    wish.like = [wishObject objectForKey:@"like"];
    wish.distance = [wishObject objectId];
    cwvc.wishObject = wish;
    [self.navigationController pushViewController:cwvc animated:YES];
}


-(void)createLamp{
   
    lamp = [[UIImageView alloc] initWithFrame:CGRectMake(65,back.frame.size.height - 88, 163, 85)];
    
    lamp.image = [UIImage imageNamed:@"shendeng"];
   
    [back addSubview:lamp];
}

-(void)getWish{
    BmobUser * user = [BmobUser getCurrentUser];

    BmobQuery * query = [BmobQuery queryForUser];
    [query includeKey:@"showWish"];
    [query getObjectInBackgroundWithId:user.objectId block:^(BmobObject *object, NSError *error) {
        NSLog(@"%@",[[object objectForKey:@"showWish"] objectForKey:@"text"]);
        if([[NSString stringWithFormat:@"%@",[[object objectForKey:@"showWish"] objectForKey:@"text"]] isEqualToString:@"(null)"]){
            wishtf = @"不放弃对美好的期许";
            avatar = @"yuanwangjiazaitu";
            lead = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
            if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
                [lead setImage:[UIImage imageNamed:@"shendengyindaoyechang1"] forState:UIControlStateNormal];
                [lead setImage:[UIImage imageNamed:@"shendengyindaoyechang1"] forState:UIControlStateHighlighted];
            }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
                [lead setImage:[UIImage imageNamed:@"shendengyindaoye1"] forState:UIControlStateNormal];
                [lead setImage:[UIImage imageNamed:@"shendengyindaoye1"] forState:UIControlStateHighlighted];
            }
            UIButton * next = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 66, 66)];
            [next addTarget:self action:@selector(alterWish) forControlEvents:UIControlEventTouchUpInside];
            [lead addSubview:next];
            lead.userInteractionEnabled = YES;
            [self.view addSubview:lead];
        }else{
            wishtf = [[object objectForKey:@"showWish"] objectForKey:@"text"];
            avatar = [[object objectForKey:@"showWish"] objectForKey:@"url"];
            wishObject = [object objectForKey:@"showWish"];
        }
        if(self.frist == 1){
            rub = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
            if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
                rub.image = [UIImage imageNamed:@"shendengyindaoyechang2"];
            }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
               rub.image = [UIImage imageNamed:@"shendengyindaoye2"];
            }
            [self.view addSubview:rub];
        }
        
        [HUD removeFromSuperview];
        [self changeUI];
    }];

}
- (void)richTextView:(TQRichTextView *)view touchBeginRun:(TQRichTextBaseRun *)run
{
    
}

- (void)richTextView:(TQRichTextView *)view touchEndRun:(TQRichTextBaseRun *)run
{
    if (run.type == richTextURLRunType)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:run.originalText]];
    }
    
}


-(void)changeUI{
    NSLog(@"%d",i);
     star.frame = CGRectMake(0,0,(42 * i) + 13.5,50);
    wishtv.text = wishtf;
    if([avatar isEqualToString:@"yuanwangjiazaitu"]){
        avatarv.image = [UIImage imageNamed:@"yuanwangjiazaitu"];
    }else{
        NSURL * avatarimu = [NSURL URLWithString:avatar];
        [avatarv sd_setImageWithURL:avatarimu];
        NSLog(@"第一次");
    }
}

-(void)getDate{
    BmobUser * user = [BmobUser getCurrentUser];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:user.objectId forKey:@"objectId"];
    [dict setObject:[user objectForKey:@"sex"] forKey:@"sex"];
    [BmobCloud callFunctionInBackground:@"shake" withParameters:dict block:^(id object, NSError *error) {
         [HUD removeFromSuperview];
        if(!error){
            wishModel.name = [object objectForKey:@"nick"];
            wishModel.context = [[object objectForKey:@"showWish"] objectForKey:@"text"];
            wishModel.avatar = [object objectForKey:@"avatar"];
            wishModel.image = [[object objectForKey:@"showWish"] objectForKey:@"url"];
            chatDict = object;
            NSDateFormatter *date=[[NSDateFormatter alloc] init];
            [date setDateFormat:@"yyyy-MM-dd"];
            NSDate *d=[date dateFromString:[object objectForKey:@"birthday"]];
            NSTimeInterval dateDiff = [d timeIntervalSinceNow];
            int age=trunc(dateDiff/(60*60*24))/365;
            wishModel.age = [NSString stringWithFormat:@"%d",-age];
            wishModel.type = [object objectForKey:@"sex"];
            [self createRandomWish];
        }else{
            MBProgressHUD * HUD1 = [[MBProgressHUD alloc] init];
            HUD1.labelText = @"灯神没有听到你的声音";
            HUD1.mode = MBProgressHUDModeCustomView;
            [self.view addSubview:HUD1];
            HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] ;
            [HUD1 showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD1 removeFromSuperview];
                
            }];
        }
    }];
   
}

-(void)createRandomWish{
    if(i <= 0){
        return;
    }
    iswish = YES;
    wishBack.frame = self.view.bounds;
    [self changeWish];
    shake.speed = 0;
    shake.fromValue = [NSNumber numberWithFloat:0];
    [lamp.layer addAnimation:shake forKey:@"Rotation"];
}


-(void)createWish{
    
    UIButton * comBack = [[UIButton alloc] initWithFrame:CGRectMake(5, (self.view.bounds.size.height-120)/2, 310, 100)];;
    [comBack setImage:[UIcol imageWithColor:[UIColor whiteColor] size:CGSizeMake(310, 100)] forState:UIControlStateNormal];
    [comBack addTarget:self action:@selector(onChat) forControlEvents:UIControlEventTouchUpInside];
    comBack.layer.cornerRadius = 5;
    comBack.layer.masksToBounds = YES;
    comBack.tag = 199;
    [wishBack addSubview:comBack];
    
    UIImageView * avatar1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15,70,70)];
    avatar1.layer.cornerRadius = 5;
    avatar1.layer.masksToBounds = YES;
    avatar1.tag = 200;
    [comBack addSubview:avatar1];

    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(90,15, 100, 20)];
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = [UIcol hexStringToColor:@"2e2e2e"];
    name.tag = 201;
    [comBack addSubview:name];

    TQRichTextView * contextTV = [[TQRichTextView alloc] initWithFrame:CGRectMake(88,42,160,40)];
    contextTV.font = [UIFont systemFontOfSize:14];
    contextTV.textColor = [UIcol hexStringToColor:@"787878"];
    contextTV.userInteractionEnabled = NO;
    contextTV.tag = 202;
    [comBack addSubview:contextTV];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(255,42,45,45)];
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = YES;
    image.userInteractionEnabled = YES;
    image.tag = 203;
    UIButton * imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [imageBtn addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    [image addSubview:imageBtn];
    [comBack addSubview:image];

    
    UIImageView * agev = [[UIImageView alloc] initWithFrame:CGRectMake(70, 40, 15, 12)];
    agev.tag = 204;
    [comBack addSubview:agev];
    
    UILabel * age = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 12)];
    age.tag = 205;
    age.textColor = [UIColor whiteColor];
    age.font = [UIFont systemFontOfSize:11];
    age.textAlignment = YES;
    [agev addSubview:age];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(90, 37.5,235, 0.5)];
    line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
    [comBack addSubview:line];
}

-(void)onChat{
    
    DetailWishViewController * dwvc = [[DetailWishViewController alloc] init];
    dwvc.objectId = [[chatDict objectForKey:@"showWish"] objectForKey:@"objectId"];
    [self.navigationController pushViewController:dwvc animated:YES];
    
}

-(void)photo{
    NSLog(@"1");
}

-(void)changeWish{

    UIImageView * image = (id)[self.view viewWithTag:203];
    NSURL * avatarimu1 =
    [NSURL URLWithString:wishModel.image];
    [image sd_setImageWithURL:avatarimu1];
      //中心点
    UIImageView * avatar1 = (id)[self.view viewWithTag:200];
    NSURL * avatarimu = [NSURL URLWithString:wishModel.avatar];
    [avatar1 sd_setImageWithURL:avatarimu];
    
    UILabel * name = (id)[self.view viewWithTag:201];
    name.text = wishModel.name;
    
    TQRichTextView * contextTV = (id)[self.view viewWithTag:202];
    contextTV.backgroundColor = [UIColor clearColor];
    contextTV.text = wishModel.context;
    
    UIImageView * agev = (id)[self.view viewWithTag:204];
    CGRect nameRect = [wishModel.name boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    if ([[NSString stringWithFormat:@"%@",wishModel.type] isEqualToString:@"1"]) {
        agev.image = [UIImage imageNamed:@"nanshengnianling"];
    }else{
        agev.image = [UIImage imageNamed:@"niushengnianling"];
    }
    agev.center = CGPointMake(nameRect.size.width + 105, 25);
    
    star.frame = CGRectMake(0, 0, 13.5+ (42 * --i) , 50);
    [self changeStar];
    
    UILabel * age = (id)[self.view viewWithTag:205];
    age.text = wishModel.age;
    
    
}

-(void)changeStar{

     BmobQuery *bquery = [BmobQuery queryWithClassName:@"Star"];
     [bquery whereKey:@"user" equalTo:[BmobUser objectWithoutDatatWithClassName:nil objectId:@"fea970eb5f"]];
     [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
         for(BmobObject *obj in array){
             BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:obj.className objectId:obj.objectId];
             //设置cheatMode为YES
             [obj1 setObject:[NSNumber numberWithInt:i] forKey:@"stars"];
             //异步更新数据
             [obj1 updateInBackground];
         }
     }];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];

    if(currentPosition.y > self.view.bounds.size.height - 200 && currentPosition.y < self.view.bounds.size.height - 50 ){

    if(i <= 0){
        MBProgressHUD * HUD1 = [[MBProgressHUD alloc] init];
        HUD1.labelText = @"你的星星没有了，快去抢星星";
        HUD1.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:HUD1];
        HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] ;
        [HUD1 showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [HUD1 removeFromSuperview];
            
        }];
    }
    }
    wishBack.frame = CGRectMake(320, 0, 0, 0);
    bling.frame = CGRectMake(0, 0, 0, 0);
//     UIImageView * image = (id)[self.view viewWithTag:203];
//    image.frame = CGRectMake(0, 0, 0, 0);
    if(iswish == YES){
        k = 0;
        progressBar.frame = CGRectMake(0, 0, 0, 1);
        iswish = NO;
        islamp = NO;
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladingFrist"] integerValue] != 1) {
    //        return;
    //    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];
    
    if(i <= 0){
      
        return;
    }
    
    if(currentPosition.y > self.view.bounds.size.height - 200 && currentPosition.y < self.view.bounds.size.height - 50 ){
        if(k < 999){
            self.frist = 0;
            [rub removeFromSuperview];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            progressBar.frame = CGRectMake(0, 0, k *3, 1);
        }
        k++;
        
        if(k == 108){
            bling.frame = CGRectMake(90, back.frame.size.height -120,150,150);
            HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
            HUD.labelText = @"灯神灯神快出来";
            [self.view addSubview:HUD];
            [HUD show:YES];
             if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"] integerValue] == 1){
                 static SystemSoundID soundIDTest = 0;
                 NSString * path = [[NSBundle mainBundle] pathForResource:@"lamp" ofType:@"wav"];
                 if (path) {
                        AudioServicesCreateSystemSoundID( (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]), &soundIDTest );
                 }
                 AudioServicesPlaySystemSound( soundIDTest );
            }
            [self getDate];
            k = 999;
        }
        if(islamp == NO && iswish == NO){
            islamp = YES;
            shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            lamp.layer.anchorPoint = CGPointMake(0.6, 1);
            shake.toValue = [NSNumber numberWithFloat: M_PI/18];
            shake.fromValue = [NSNumber numberWithFloat:-M_PI/18];
            shake.duration = 0.1;
            shake.autoreverses = true;
            shake.repeatCount = MAXFLOAT;
            lamp.frame = CGRectMake(65,back.frame.size.height - 88, 163, 85);
            
            [lamp.layer addAnimation:shake forKey:@"Rotation"];
        }
    }else{
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    shake.speed = 0;
    islamp = NO;
    shake.fromValue = [NSNumber numberWithFloat:0];
    [lamp.layer addAnimation:shake forKey:@"Rotation"];
}

-(void)createNarBar{
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * narBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tou"]];
    narBar.frame = CGRectMake(0, 20, 320, 44);
    narBar.userInteractionEnabled = YES;
    [self.view addSubview:narBar];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"阿拉丁神灯";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [narBar addSubview:titleBar];
    
    UIImageView * sidebar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sidebar.image = [UIImage imageNamed:@"caidan"];
    sidebar.tag = 554;
    sidebar.userInteractionEnabled = YES;
    [narBar addSubview:sidebar];
    
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    int m = 0;
    for (int j = 0 ; j < array.count ; j++) {
        BmobRecent * news = array[j];
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
        UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14,14)];
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
        UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14,14)];
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
    
}

-(void)changeNaBar{
    UIView * dotBack = (id)[self.view viewWithTag:555];
    NSArray * array = [[BmobDB currentDatabase] queryRecent];
    UIImageView * sidebar = (id)[self.view viewWithTag:554];
    int m = 0;
    for (int j = 0 ; j < array.count ;j++) {
        BmobRecent * news = array[j];
        m += [[[NSUserDefaults standardUserDefaults] objectForKey:news.targetId] integerValue];
        
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"aladdinShake"] integerValue] != 0 || m != 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"addLike"] integerValue] != 0){
        if(dotBack == nil){
            UIImageView * sidebar = (id)[self.view viewWithTag:554];
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
                number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,14, 14)];
                number.tag = 668;
                number.font = [UIFont systemFontOfSize:11];
                number.textColor = [UIColor whiteColor];
                number.textAlignment = NSTextAlignmentCenter;
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
            UIView * dot = [[UIView alloc] initWithFrame:CGRectMake(3, 3, 14,14)];
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
