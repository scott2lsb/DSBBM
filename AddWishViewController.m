//
//  BJYWViewController.m
//  chouti
//
//  Created by bisheng on 14-8-22.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "AddWishViewController.h"
#import "UIImageView+WebCache.h"
#import "TxetViewChar.h"
#import "WishViewController.h"
#import "NSString+Emote.h"
#import "LampViewController.h"

@interface AddWishViewController ()


@end

@implementation AddWishViewController
{
    BmobUser * bUser;
    UIImageView * backView;
    UIView * faceBack;
    BOOL microblogbool;
    BOOL facebool;
    CABasicAnimation* rotationAnimation;
    TQRichTextView * recommendtv;
    MBProgressHUD * HUD;
    NSDictionary * _SmileDict;
    BmobFile * file;
    UIImage * photoImage;
    BOOL isNumber;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        addWishText = [[NSMutableString alloc] init];
        isNumber = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bUser = [BmobUser getCurrentUser];

    microblogbool = NO;
    facebool = NO;
    [self createNaBar];
    [self createUI];
    [self getRecommend];
    [self createNotificationCenter];
    // Do any additional setup after loading the view.
}

- (void)createNotificationCenter
{
    //nc是个单例对象
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    
    //在通知中心中注册需要监听的通知
    [nc addObserver:self selector:@selector(recievedShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}

//收到对应通知，调用这个方法
- (void)recievedShowNotification:(NSNotification *)notifi{
    UIButton * btn  = (id)[self.view viewWithTag:304];
        facebool = NO;
        [btn setImage:[UIImage imageNamed:@"bjbiaoqing"] forState:UIControlStateNormal];
        [self removeFace];
}


-(void)share:(UIButton *)btn{
    switch (btn.tag) {
               case 302:
            if(microblogbool == NO){
                microblogbool = YES;
                [btn setImage:[UIImage imageNamed:@"tongbudaoweixinselect"] forState:UIControlStateNormal];
            }else{
                microblogbool = NO;
                [btn setImage:[UIImage imageNamed:@"tongbudaoweixin"] forState:UIControlStateNormal];
            }
            break;
        case 303:
        {
            
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            rotationAnimation.duration = 0.5;
            rotationAnimation.RepeatCount = 1000;//你可以设置到最大的整数值
            rotationAnimation.cumulative = NO;
            rotationAnimation.removedOnCompletion = NO;
            rotationAnimation.fillMode = kCAFillModeForwards;
            [btn.layer addAnimation:rotationAnimation forKey:@"Rotation"];
            [self getRecommend];
        }
            break;
        case 304:
            if(facebool == NO){
                facebool = YES;
                [btn setImage:[UIImage imageNamed:@"bjbiaoqingselect"] forState:UIControlStateNormal];
                [self createFace];
            }else{
                facebool = NO;
                [btn setImage:[UIImage imageNamed:@"bjbiaoqing"] forState:UIControlStateNormal];
                [self removeFace];
            }
            break;
        default:
            break;
    }
    
}

-(void)createFace{
     UITextView * textView = (id)[self.view viewWithTag:102];
    [textView resignFirstResponder];
   
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        faceBack = [[UIView alloc] initWithFrame:CGRectMake(0,178,320,backView.frame.size.height-178)];
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
       faceBack = [[UIView alloc] initWithFrame:CGRectMake(0,168,320,backView.frame.size.height-168)];
    }
    faceBack.tag = 800;
    NSArray * faceArray = [NSArray arrayWithObjects:
                           @"[ue056]",@"[ue057]",@"[ue058]",@"[ue059]",@"[ue105]",
                           @"[ue106]",@"[ue107]",@"[ue108]",@"[ue401]",@"[ue402]",
                           @"[ue404]",@"[ue410]",@"[ue403]",@"[ue405]",@"[ue406]",
                           @"[ue409]",@"[ue408]",@"[ue407]",@"[ue40d]",@"[ue411]",
                           @"[ue40e]",@"[ue40a]",@"[ue40f]",@"[ue412]",@"[ue413]",
                           @"[ue40b]",@"[ue414]",@"[ue415]",nil];
    int k = 0;
    for(int i = 0 ; i < 5 ; i++){
        for (int j = 0 ;  j < 6; j++) {
            if(k < faceArray.count){
                UIButton * faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(13 + j *53 ,11 +i * 50,27, 27)];
                [faceBtn setImage:[UIImage imageNamed:faceArray[k]] forState:UIControlStateNormal];
                [faceBack addSubview:faceBtn];
                faceBtn.tag = 900 + k;
                [faceBtn addTarget:self action:@selector(faceBtn:) forControlEvents:UIControlEventTouchUpInside];
                k++;
            }
        }
    }
    faceBack.backgroundColor = [UIcol hexStringToColor:@"f2f2f2"];
     [[backView superview] addSubview:faceBack];
}

-(void)faceBtn:(UIButton *)btn{
 
    UITextView * textView = (id)[self.view viewWithTag:102];
 
    NSArray * array1 = [NSArray arrayWithObjects:
                               @"[微笑]",@"[哈哈]",@"[害羞]",@"[嘻嘻]",@"[吐舌头]",
                               @"[飞吻]",@"[流鼻血]",@"[花心]",@"[发呆]",@"[惊讶]",
                               @"[汗]",@"[灵感]",@"[尴尬]",@"[可怜]",@"[大哭]",
                               @"[生气]",@"[咆哮]",@"[愤怒]",@"[卖萌]",@"[疑问]",
                               @"[呕吐]",@"[斜眼]",@"[酷]",@"[瞌睡]",@"[受伤]",
                               @"[娇媚]",@"[闭嘴]",@"[晕]", nil];
    textView.text = [NSString stringWithFormat:@"%@%@",textView.text,array1[btn.tag - 900]];
    [self textViewDidChange:textView];
    UILabel * l =(id)[self.view viewWithTag:600];
    if (textView.text.length == 0) {
        l.text = @"想让大家帮你实现的愿望";
    }else{
        l.text = @"";
    }
}

-(void)removeFace{
    [faceBack removeFromSuperview];
}

-(void)getRecommend{
    
    BmobQuery * query = [BmobQuery queryWithClassName:@"SuggestedWish"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        query.skip = random()%number;
        query.limit = 1;
        [query includeKey:@"user"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if(array.count == 0){
                return ;
            }
            recommendtv.text = [array[0] objectForKey:@"content"];
           [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.5f];
            
        }];
    }];

}

-(void)stopAnimation{
    rotationAnimation.speed = 0;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    UIButton * btn = (id)[self.view viewWithTag:303];
    [btn.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
}

-(void)createUI{
    self.view.backgroundColor = [UIColor blackColor];
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 64,320, self.view.bounds.size.height-20)];
    back.backgroundColor = [UIcol hexStringToColor:@"f0ecf3"];
    [self.view addSubview:back];
    backView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, self.view.bounds.size.height-64)];
    backView.userInteractionEnabled = YES;
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        NSLog(@"%@",[bUser objectForKey:@"sex"]);
        if([[NSString stringWithFormat:@"%@",[bUser objectForKey:@"sex"]] isEqualToString:@"0"]){
            backView.image = [UIImage imageNamed:@"nvshengbianjiyuanwang长"];
        }else{
            backView.image = [UIImage imageNamed:@"nanshengbianjiyuanwang长"];
        }
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
        if([[NSString stringWithFormat:@"%@",[bUser objectForKey:@"sex"]] isEqualToString:@"0"]){
            backView.image = [UIImage imageNamed:@"nvshengbianjiyuanwang"];
        }else{
            backView.image = [UIImage imageNamed:@"nanshengbianjiyuanwang"];
        }
    }
    
    [back addSubview:backView];
    back.userInteractionEnabled = YES;
    
    UITextView     *ncTextField1 = [[UITextView alloc] init];
    ncTextField1.frame            = CGRectMake(10,0, 200,120);

    ncTextField1.backgroundColor  = [UIColor clearColor];
    ncTextField1.font = [UIFont systemFontOfSize:14];
    ncTextField1.tag = 102;
    ncTextField1.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    ncTextField1.returnKeyType    = UIReturnKeyNext;
    ncTextField1.delegate         = self;
    UILabel * l4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    if([[bUser objectForKey:@"sex"]integerValue] == 1){
    l4.text = @"展示自己的大叔气质和生活";
    }else{
    l4.text = @"最新的愿望会被其他人看到";
    }
    l4.textColor = [UIcol hexStringToColor:@"#bebebe"];
   
    l4.font = [UIFont systemFontOfSize:14];
    l4.tag = 600;
    [ncTextField1 addSubview:l4];
    [backView addSubview:ncTextField1];

    
    UILabel * zs = [[UILabel alloc] initWithFrame:CGRectMake(155, 100, 150,20)];
    zs.text = @"还可以输入    字";
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(123, 0, 20, 20)];
    number.textColor = [UIColor redColor];
    number.text = @"60";
    number.textAlignment = NSTextAlignmentCenter;
    number.font = [UIFont systemFontOfSize:11];
    number.tag = 333;
    [zs addSubview:number];
    zs.textAlignment = NSTextAlignmentRight;
    zs.textColor = [UIcol hexStringToColor:@"#787878"];
    zs.font = [UIFont systemFontOfSize:11];
    [back addSubview:zs];
    
    UIImageView * zp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80,80)];
    zp.layer.cornerRadius = 5;
    zp.layer.masksToBounds = YES;
    zp.tag = 1000;

    zp.backgroundColor = [UIColor clearColor];
    
    
    UIButton * xc = [[UIButton alloc] initWithFrame:CGRectMake(225,10,80,80)];
    [xc addTarget:self action:@selector(asd) forControlEvents:UIControlEventTouchUpInside];
    [xc setImage:[UIImage imageNamed:@"tupiantianjia"] forState:UIControlStateNormal];
    [xc setImage:[UIImage imageNamed:@"tupiantianjiaselect"] forState:UIControlStateHighlighted];
    [xc addSubview:zp];
    
    [backView addSubview:xc];
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        recommendtv = [[TQRichTextView alloc] initWithFrame:CGRectMake(110,230,165,45)];
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
        recommendtv = [[TQRichTextView alloc] initWithFrame:CGRectMake(110,200,165,45)];
    }


    recommendtv.backgroundColor = [UIColor clearColor];
    recommendtv.userInteractionEnabled = NO;
    recommendtv.font = [UIFont systemFontOfSize:14];
    recommendtv.textColor = [UIcol hexStringToColor:@"787878"];
    [backView addSubview:recommendtv];
    UIButton * faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,125, 30, 30)];
    faceBtn.tag = 304;
    [faceBtn setImage:[UIImage imageNamed:@"bjbiaoqing"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:faceBtn];
    
    
    UIButton * microblogBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 125, 30,30)];
    microblogBtn.tag = 302;
    [microblogBtn setImage:[UIImage imageNamed:@"tongbudaoweixin"] forState:UIControlStateNormal];
    
    [microblogBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:microblogBtn];
    UIButton * refresh;
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        refresh = [[UIButton alloc] initWithFrame:CGRectMake(272, 250, 36, 36)];
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
        microblogBtn.frame = CGRectMake(280, 125, 30, 30);
        faceBtn.frame = CGRectMake(15, 125, 30, 30);
        refresh = [[UIButton alloc] initWithFrame:CGRectMake(272, 225, 36, 36)];
    }
    refresh.tag = 303;
    [refresh setImage:[UIImage imageNamed:@"huanyige"] forState:UIControlStateNormal];
    [refresh setImage:[UIImage imageNamed:@"huanyigeselect"] forState:UIControlStateHighlighted];
    [refresh addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:refresh];
}



-(void)createNaBar{
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
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
    
    UIButton * publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(266, 0, 54, 44)];
    [publishBtn setImage:[UIcol imageWithColor:[UIColor clearColor] size:CGSizeMake(70, 44)] forState:UIControlStateNormal];
    [publishBtn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0.9 green:0.74 blue:0 alpha:1] size:CGSizeMake(70, 44)] forState:UIControlStateHighlighted];
    [publishBtn addTarget:self action:@selector(addWish) forControlEvents:UIControlEventTouchUpInside];
    UILabel * publishLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    publishLab.text = @"发布";
    publishLab.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    publishLab.shadowOffset = CGSizeMake(1, 0.5);
    publishLab.textColor = [UIColor whiteColor];
    [publishBtn addSubview:publishLab];
    [iv addSubview:publishBtn];

   
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"编辑愿望";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
    
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UILabel * l =(id)[self.view viewWithTag:600];
    if (textView.text.length == 0) {
        if([[bUser objectForKey:@"sex"]integerValue] == 1){
            l.text = @"展示自己的大叔气质和生活";
        }else{
            l.text = @"最新的愿望会被其他人看到";
        }
    }else{
        l.text = @"";
    }
 
//    //该判断用于联想输入
    UILabel * number = (id)[self.view viewWithTag:333];
    int k = [TxetViewChar textViewCharWish:textView.text];
//   int k =textView.text.length;
    if((60 - k) > 0){
        number.text = [NSString stringWithFormat:@"%d",60-k];
    }else{
        number.text = @"0";
    }
    if (k > 60 && isNumber == YES)
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"字数不能超过60字" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 112;
        [alert show];
        isNumber = NO;
    }
}

- (NSString *)backFaceString:(NSString *)str{
    NSString *string = nil;
    if (str.length ) {
        
        NSInteger stringLength = str.length;
        if ( stringLength >= 6) {
            
            string = [str substringFromIndex:stringLength - 6];
            NSRange range = [string rangeOfString:@"\\ue"];
            if ( range.location == 0 ) {
                
                string = [str substringToIndex:
                          [str rangeOfString:@"\\ue"
                                             options:NSBackwardsSearch].location];
            }else{
                string = [str substringToIndex:stringLength - 1];
            }
        }else{
        string = [str substringToIndex:stringLength - 1];
        }
    
    }
    
    
    return string;
}



-(void)quxiao{
    UIView * zxv = (id)[self.view viewWithTag:500];
    zxv.frame = CGRectMake(320, 0, 0, 0);
    
}

-(void)addWish{
    
    UITextView * tv = (id)[self.view viewWithTag:102];
    NSString *str = [tv.text emoteStringWithDict:self.SmileDict];
    NSLog(@"%@",str);
    NSString *temp = [tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    int k = [TxetViewChar textViewCharWish:tv.text];
    if(temp.length == 0){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"内容不能为空";
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
    if(k <= 60 && k > 0){
        BmobObject  *wish = [BmobObject objectWithClassName:@"Wish"];
        
        [wish setObject:[NSNumber numberWithInt:0] forKey:@"like"];
        
        [wish setObject:str forKey:@"text"];
        
        [wish setObject:[NSNumber numberWithInt:0] forKey:@"comment"];
        UIImageView  *avatarView = (UIImageView *)[self.view viewWithTag:1000];
        
        file = [[BmobFile alloc] initWithClassName:nil withFileName:@"wish.png" withFileData:UIImageJPEGRepresentation(avatarView.image, 0.8)];
        HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
        HUD.labelText = @"发送中";
        [self.view addSubview:HUD];
        [HUD show:YES];
        [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
            
            [wish setObject:[NSNumber numberWithInteger:[[bUser objectForKey:@"sex"] integerValue]] forKey:@"type"];
            if(![[NSString stringWithFormat:@"%@",file.url]isEqualToString:@"(null)"]){
                [wish setObject:[NSString stringWithFormat:@"%@",file.url] forKey:@"url"];
            }
            [wish updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [wish setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:bUser.objectId] forKey:@"user"];
                
                [wish saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if(isSuccessful){
                        [bUser setObject:[BmobObject objectWithoutDatatWithClassName:@"Wish" objectId:wish.objectId] forKey:@"lastWish"];
                        if(self.k == 1){
                            
                            [bUser setObject:[BmobObject objectWithoutDatatWithClassName:@"Wish" objectId:wish.objectId] forKey:@"showWish"];
                        }
                    
                        [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if(self.k == 1){
                                NSArray * array = self.navigationController.viewControllers;
                                LampViewController * lvc;
                                for (int i = 0 ; i < array.count ; i++) {
                                    if([[NSString stringWithFormat:@"%@",[array[i] class]]isEqualToString:@"LampViewController"]){
                                        lvc = array[i];
                                    }
                                }
                                if(self.frist == 1){
                                    lvc.frist = 1;
                                    [self.navigationController popToViewController:lvc animated:YES];
                                }else{
                                    [self.navigationController popToViewController:lvc animated:YES];
                                }
                            }else{
                                if(microblogbool == YES){
                                    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享到朋友圈" message:@"确定分享到朋友圈" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                        alert.tag = 11;
                                        [alert show];

                                    }else{
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您没有微信客户端" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                        alert.tag = 11;
                                        [alert show];
                                    }
                                }
                                if(self.k == 2){
                                    [self.navigationController popViewControllerAnimated:YES];
                                }else{
                                    NSArray * array = self.navigationController.viewControllers;
                                    WishViewController * wvc;
                                    for (int i = 0 ; i < array.count ; i++) {
                                        if([[NSString stringWithFormat:@"%@",[array[i] class]]isEqualToString:@"WishViewController"]){
                                            wvc = array[i];
                                        }
                                    }
                                    wvc.change();
                                    [self.navigationController popToViewController:wvc animated:YES];
                                }
                            }
                        }];
                    }else{
                        
                    }
                }];

                 [HUD removeFromSuperview];
               
            }];
            
        }];
    }else{
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"字数不能超过60字" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}



#pragma mark 文字分享
- (void)sharedByWeChatWithText:(NSString *)WeChatMessage sceneType:(int)sceneType
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text  = WeChatMessage;
    req.bText = YES;
    req.scene = sceneType;
    [WXApi sendReq:req];
   
}

-(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark 图片分享
- (void)sharedByWeChatWithImage:(NSString *)imageName sceneType:(int)sceneType
{
    photoImage = [self scale:photoImage toSize:CGSizeMake(100, 100)];
   
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:photoImage];
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData  = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.url]];
    UIImage *image = [UIImage imageWithData:ext.imageData];
    ext.imageData  = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = sceneType;
    
    [WXApi sendReq:req];
}

//相册
-(void)photoLib{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing            = YES;
    
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}
//拍照
-(void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing            = YES;
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}

-(void)presentImagePickerController:(UIImagePickerController *)picker{
    [self.navigationController presentViewController:picker animated:YES completion:^{
//                [self hideBottomView];
    }];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *editImage          = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%f,%f",editImage.size.width,editImage.size.height);
    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(640,640)];
    UIImageView  *imageView = (UIImageView *)[self.view viewWithTag:1000];
    imageView.image = cutImage;
    photoImage = cutImage;

}

-(UIImage *)cutImage:(UIImage *)originImage size:(CGSize)size{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [originImage drawInRect:CGRectMake(0, 0, size.height, size.width)]; //newImageRect指定了图片绘制区域
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)asd{
    [self updateAvatar];
}

-(void)updateAvatar{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"相册",@"照相", nil];
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    switch (buttonIndex) {
        case 0:{
            [self photoLib];
        }
            break;
        case 1:{
           [self takePhoto];
        }
            break;
        default:
            break;
    }
    
}

-(UIImage*)captureView:(UIView *)theView andrect:(CGRect)rect

{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return img;
    
}

- (NSDictionary *)SmileDict
{
    if (_SmileDict == nil) {
        //1.获得plist的全路径
        NSString *path = [[NSBundle mainBundle]pathForResource:@"smile.plist" ofType:nil];
        //2.加载数据
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        _SmileDict = dict;
    }
    return _SmileDict;
}


-(void)goBack{
    UITextView * tv = (id)[self.view viewWithTag:102];
    NSString *temp = [tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(temp.length == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"放弃编辑愿望" message:@"确定放弃编辑愿望吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 112){
        isNumber = YES;
        
    }
    if(alertView.tag == 10){
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    }else{
        
        if (buttonIndex == 0) {
           
        }else if (buttonIndex == 1){
//            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
//            {
                if(![[NSString stringWithFormat:@"%@",file.url]isEqualToString:@"(null)"]){
                    [self sharedByWeChatWithImage:file.url sceneType:1];
                }else{
                    UITextView * tf = (id)[self.view viewWithTag:102];
                    [self sharedByWeChatWithText:tf.text sceneType:1];
                }
//            }
        }

    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITextView * tf = (id)[self.view viewWithTag:102];
    [tf resignFirstResponder];
    
    
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
