//
//  TransitViewController.m
//  DSBBM
//
//  Created by bisheng on 14-12-9.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "TransitViewController.h"
#import "WishViewController.h"
#import "TxetViewChar.h"
#import "NSString+Emote.h"

@interface TransitViewController ()

@end

@implementation TransitViewController
{
    UIButton * wishBack;
    UIView * addWish;
    UITextView * addText;
    int centerX;
     UIView * faceBack;
     MBProgressHUD * HUD;
     NSDictionary * _SmileDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBarHidden = YES;
    UIView * v= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];

    v.backgroundColor = [UIColor blackColor];
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        centerX = 175;
    }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
        centerX = 120;
    }
    [self.view addSubview:v];
    [self createScrollView];
    [self createPageControl];
    [self createNotificationCenter];
}

-(void)createWish{
    wishBack = [[UIButton alloc] initWithFrame:self.view.bounds];
    wishBack.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [wishBack addTarget:self action:@selector(wishRemove) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wishBack];
   
    addWish = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 285, 160)];
    addWish.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    addWish.backgroundColor = [UIColor whiteColor];
    addWish.layer.cornerRadius = 5;
    addWish.layer.masksToBounds = YES;
    [self.view addSubview:addWish];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 122, 285, 0.5)];
    line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [addWish addSubview:line];
    
    UIButton * addImage = [[UIButton alloc] initWithFrame:CGRectMake(198,19.5, 70, 70)];
    [addImage setImage:[UIImage imageNamed:@"tupiantianjia"] forState:UIControlStateNormal];
    [addImage setImage:[UIImage imageNamed:@"tupiantianjiaselect"] forState:UIControlStateHighlighted];
    [addImage addTarget:self action:@selector(updateAvatar) forControlEvents:UIControlEventTouchUpInside];
    [addWish addSubview:addImage];
    
    UIImageView * zp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,70,70)];
    zp.layer.cornerRadius = 5;
    zp.layer.masksToBounds = YES;
    zp.tag = 1000;
    zp.backgroundColor = [UIColor clearColor];
    [addImage addSubview:zp];
    
    addText = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 180, 108)];
    addText.font = [UIFont systemFontOfSize:14];
    addText.tag = 102;
    addText.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    addText.delegate         = self;
    [addWish addSubview:addText];
    UILabel * l4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue] == 1){
        l4.text = @"展示自己的大叔气质和生活";
    }else{
        l4.text = @"最新的愿望会被其他人看到";
    }
    l4.textColor = [UIcol hexStringToColor:@"#bebebe"];
    
    l4.font = [UIFont systemFontOfSize:14];
    l4.tag = 600;
    [addText addSubview:l4];

    
    UIButton * faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 131, 20, 20)];
    [faceBtn setImage:[UIImage imageNamed:@"bjbiaoqing"] forState:UIControlStateNormal];
    [faceBtn setImage:[UIImage imageNamed:@"bjbiaoqingselect"] forState:UIControlStateHighlighted];
    [faceBtn addTarget:self action:@selector(createFace) forControlEvents:UIControlEventTouchUpInside];
    [addWish addSubview:faceBtn];
    
    UIButton * addWishBtn = [[UIButton alloc] initWithFrame:CGRectMake(220,129.5, 50, 25)];
    [addWishBtn setImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [addWishBtn setImage:[UIImage imageNamed:@"fabuselect"] forState:UIControlStateHighlighted];
    [addWishBtn addTarget:self action:@selector(addWish) forControlEvents:UIControlEventTouchUpInside];
    [addWish addSubview:addWishBtn];
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

-(void)addWish{
    UIImageView  *avatarView = (UIImageView *)[self.view viewWithTag:1000];
    if(avatarView.image == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window addSubview:HUD];
        HUD.labelText = @"请添加图片";
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
    BmobUser * bUser = [BmobUser getCurrentObject];
        NSString *temp = [addText.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(temp.length == 0){
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
            [window addSubview:HUD];
            HUD.labelText = @"请输入文字";
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
        if(addText.text .length < 60 && addText.text .length > 0){
            BmobObject  *wish = [BmobObject objectWithClassName:@"Wish"];
            
            [wish setObject:[NSNumber numberWithInt:0] forKey:@"like"];
            
            NSString * str = [addText.text emoteStringWithDict:self.SmileDict];
            [wish setObject:str forKey:@"text"];
            
            [wish setObject:[NSNumber numberWithInt:0] forKey:@"comment"];
            
            BmobFile * file = [[BmobFile alloc] initWithClassName:nil withFileName:@"wish.png" withFileData:UIImageJPEGRepresentation(avatarView.image, 0.8)];
            HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
            UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
            [window addSubview:HUD];
            [self.view addSubview:HUD];
            [HUD show:YES];
            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                
                [wish setObject:[NSNumber numberWithInteger:[[bUser objectForKey:@"sex"] integerValue]] forKey:@"type"];
                [wish setObject:[NSString stringWithFormat:@"%@",file.url] forKey:@"url"];
                [wish updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    [wish setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:bUser.objectId] forKey:@"user"];
                    
                    [wish saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if(isSuccessful){
                            [bUser setObject:[BmobObject objectWithoutDatatWithClassName:@"Wish" objectId:wish.objectId] forKey:@"lastWish"];
                
                            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                WishViewController * wvc = [[WishViewController alloc] init];
                                [self.navigationController pushViewController:wvc animated:YES];
                            }];
                            }else{
                            
                        }
                    }];
                    
                    [HUD removeFromSuperview];
                    
                }];
                
            }];
        }
    }


-(void)createFace{
    [addText resignFirstResponder];
    NSLog(@"%f",addWish.frame.origin.y);
    NSLog(@"%f",addText.frame.origin.y);
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
        addWish.frame = CGRectMake(addWish.frame.origin.x,95, addWish.frame.size.width, 400);

          }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
              addWish.frame = CGRectMake(addWish.frame.origin.x,40, addWish.frame.size.width, 400);

      
    }        faceBack = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 285, 240)];
    faceBack.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [addWish addSubview:faceBack];
    
    NSMutableArray  *emojiArray = [NSMutableArray arrayWithObjects:
                                   @"[ue056]",@"[ue057]",@"[ue058]",@"[ue059]",@"[ue105]",
                                   @"[ue106]",@"[ue107]",@"[ue108]",@"[ue401]",@"[ue402]",
                                   @"[ue404]",@"[ue410]",@"[ue403]",@"[ue405]",@"[ue406]",
                                   @"[ue409]",@"[ue408]",@"[ue407]",@"[ue40d]",@"[ue411]",
                                   @"[ue40e]",@"[ue40a]",@"[ue40f]",@"[ue412]",@"[ue413]",
                                   @"[ue40b]",@"[ue414]",@"[ue415]",nil];
    int k = 0;
    for(int i = 0 ; i < 5 ; i++){
        for (int j = 0 ;  j < 6; j++) {
            if(k < emojiArray.count){
                UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(j *47 + 13 ,i * 47 + 13,27, 27)];
                [btn setImage: [UIImage imageNamed:emojiArray[k]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(addFace:) forControlEvents:UIControlEventTouchUpInside];
                [faceBack addSubview:btn];
                btn.tag = 900 + k;
                k++;
            }
        }
    }
    
}

-(void)addFace:(UIButton *)btn{
    
    NSMutableArray * array1 = [NSMutableArray arrayWithObjects:
                              @"[微笑]",@"[哈哈]",@"[害羞]",@"[嘻嘻]",@"[吐舌头]",
                              @"[飞吻]",@"[流鼻血]",@"[花心]",@"[发呆]",@"[惊讶]",
                              @"[汗]",@"[灵感]",@"[尴尬]",@"[可怜]",@"[大哭]",
                              @"[生气]",@"[咆哮]",@"[愤怒]",@"[卖萌]",@"[疑问]",
                              @"[呕吐]",@"[斜眼]",@"[酷]",@"[瞌睡]",@"[受伤]",
                              @"[娇媚]",@"[闭嘴]",@"[晕]", nil];
    addText.text = [NSString stringWithFormat:@"%@%@",addText.text,array1[btn.tag - 900]];
    [self textViewDidChange:addText];
}

- (void)createNotificationCenter
{
    //nc是个单例对象
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    
    //在通知中心中注册需要监听的通知
    [nc addObserver:self selector:@selector(recievedShowNotification:) name:UIKeyboardWillShowNotification object:nil];
 
}
- (void)recievedShowNotification:(NSNotification *)notifi{
    if(addWish.center.y != centerX){
        addWish.center = CGPointMake(addWish.center.x,centerX);
    }
    addWish.frame = CGRectMake(addWish.frame.origin.x,addWish.frame.origin.y, addWish.frame.size.width, 160);
    [UIView animateWithDuration:0.3 animations:^{
        addWish.center = CGPointMake(self.view.bounds.size.width/2,centerX);
    }];
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
       
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue] == 1){
            l.text = @"展示自己的大叔气质和生活";
        }else{
            l.text = @"最新的愿望会被其他人看到";
        }
    }else{
        l.text = @"";
    }

    UILabel * number = (id)[self.view viewWithTag:333];
    int k = [TxetViewChar textViewCharWish:textView.text];
    //   int k =textView.text.length;
    if((60 - k) > 0){
        number.text = [NSString stringWithFormat:@"%d",60-k];
    }else{
        number.text = @"0";
    }
    if (textView.text.length > 60)
    {
        textView.text = [textView.text substringToIndex:60];
    }
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
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *editImage          = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(640, 640)];
    UIImageView  *imageView = (UIImageView *)[self.view viewWithTag:1000];
    imageView.image = cutImage;
    
    
}

-(NSString *)filepath{
    NSArray  *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirecotry =[paths objectAtIndex:0];
    return documentDirecotry;
}

-(UIImage *)cutImage:(UIImage *)originImage size:(CGSize)size{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [originImage drawInRect:CGRectMake(0, 0, size.height, size.width)]; //newImageRect指定了图片绘制区域
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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


-(void)wishRemove{
  
    [wishBack removeFromSuperview];
    [addWish removeFromSuperview];
  
}

#pragma mark - UIScrollView

//创建scrollView
- (void) createScrollView
{
    UIScrollView * sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0,20, self.view.bounds.size.width, self.view.bounds.size.height-62.5-20)];
    
    sv.tag = 1;
    
    //    设置代理
    sv.delegate = self;
    
    [self.view addSubview:sv];
    
    //添加图片
    [self addImages];
}

//添加图片
- (void)addImages
{
    UIScrollView * sv = (id)[self.view viewWithTag:1];
    //设置包含内容的大小
    sv.contentSize = CGSizeMake(320 * 4, self.view.bounds.size.height- 62.5-40 );
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;

    //设置按页翻动
    sv.pagingEnabled = YES;
    
    //禁止出界
    sv.bounces = NO;
    
    for (int i = 0; i < 4; i++) {
        //每次循环创建一张图片
        NSArray * array1;
        NSArray * array2;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue] == 0){
            array1 = @[@"guochang1",@"guochang2",@"guochang3",@"ditunv"];
            array2 = @[@"guochang1chang",@"guochang2chang",@"guochang3chang",@"ditunvchang"];
        }else{
            array1 = @[@"guochang1",@"guochang2",@"guochang3",@"ditunan"];
            array2 = @[@"guochang1chang",@"guochang2chang",@"guochang3chang",@"ditunanchang"];
        }
        NSString * imageName ;
        if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
            imageName = array2[i];
        }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
           imageName = array1[i];
        }
        
        //每次循环创建一个图片视图
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, self.view.bounds.size.width, self.view.bounds.size.height - 62.5 - 40)];
        //设置图片进入图片视图
        iv.image = [UIImage imageNamed:imageName];
        
        [sv addSubview:iv];
        
    }
}

#pragma mark - UIPageControl
//创建pageControl
- (void)createPageControl
{
    UIPageControl * pc = [[UIPageControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 170 ) / 2, self.view.bounds.size.height - 75, 170, 50)];
  
    pc.currentPageIndicatorTintColor = [UIcol hexStringToColor:@"F58223"];
    pc.pageIndicatorTintColor = [UIcol hexStringToColor:@"#bebebe"];
    //设置页数
    pc.numberOfPages = 4;
    
    pc.tag = 2;
    
    //添加事件
    [pc addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,0,0)];
    btn.tag = 3;
    [btn setImage:[UIImage imageNamed:@"wishButton"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"chuji"] forState:UIControlStateHighlighted];
    btn.clipsToBounds = NO;
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pc];
    [self.view addSubview:btn];
    
}

- (void)valueChanged:(UIPageControl *)pc
{
    UIScrollView * sv = (id)[self.view viewWithTag:1];
    
    //属性，设置，返回pc当前页
    NSUInteger currentPage = pc.currentPage;
    
    [sv setContentOffset:CGPointMake(currentPage * 320, 0) animated:YES];
}


//协议方法，发生滚动时，不断调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPageControl * pc = (id)[self.view viewWithTag:2];
    
    if (scrollView.isDragging == YES) {
        pc.currentPage = (scrollView.contentOffset.x / 320 + 0.5);
        
        if( pc.currentPage == 3){
            UIButton * btn = (id)[self.view viewWithTag:3];
            if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) ){
                btn.frame = CGRectMake(121.5,334,77,77);
            }else if(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO) ){
                btn.frame = CGRectMake(121.5,277,77,77);
            }

       }else{
            UIButton * btn = (id)[self.view viewWithTag:3];
            btn.frame = CGRectMake(0, 0, 0, 0);
           
        }

    }
    
}

-(void)goBack{
    BmobUser * user = [BmobUser getCurrentUser];
    if([user objectForKey:@"lastWish"] == nil){
        [self createWish];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
