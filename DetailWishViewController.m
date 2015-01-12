//
//  YWXQViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-1.
//  Copyright (c) 2014年 qt. All rights reserved.
//
#define Main_screen_width [UIScreen mainScreen].bounds.size.width
#define Main_screen_height [UIScreen mainScreen].bounds.size.height
#import "DetailWishViewController.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "ChatViewController.h"
#import "WishViewController.h"
#import "friendDatumViewController.h"
#import "RecentlyViewController.h"
#import "friendInfoViewController.h"
#import "WishViewController.h"
#import "WXApi.h"
#import "photosView.h"
#import "NSString+Extension.h"
#import "NSString+Emote.h"
#import "TxetViewChar.h"

@interface DetailWishViewController ()

@end

@implementation DetailWishViewController
{
    UITableView * commentTableView;
    NSMutableArray * commentarray;
    NSMutableArray * likearray;
//    UIView * commentv;
    UITextView * commenttv;
    UIView * back;
    BOOL likeBool;
    int _type;
    NSString * _user;
    NSString * likeObject;
    MBProgressHUD * HUD;
    BOOL isBackBool;
    BOOL isComBool;
    int removeComment;
    NSString * chatInstallId;
    NSString * chatDeviceType;
    UIImage * photoImage;
    //输入框
    UIView * _textViewBack;
    UITextView *_textView;
    //表情按钮
    UIButton                * emojiButton;
    
    UILabel * _textLable;
    NSString * _textStr;
    
    //发送按钮
    UIButton                * sendBut;
    //输入框的线
    UIView                  * textViewXian;
    smileView               * _emojiView;
    
    CGFloat                 textY;
    CGFloat                 BJHeight;
    UIView                  * xBarV;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _textStr = [[NSString alloc] init];
     }
    return self;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIcol hexStringToColor:@"#f0ecf3"];
    [self createNaBar];
    isBackBool = YES;
    likeBool = YES;
    isComBool = YES;
    _type = 0;
    BJHeight = 49;
    commentTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-50)];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:commentTableView];
    [self getData];
    [self createTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
//     commentv.frame = CGRectMake(0, self.view.bounds.size.height, 320, 50);
//    [commenttv resignFirstResponder];
}

-(void)getData{
    HUD= [[MBProgressHUD alloc] initWithFrame: CGRectMake(0, 0, 320, 320)];
    HUD.labelText = @"加载中";
    [self.view addSubview:HUD];
    [HUD show:YES];
    BmobQuery * query = [BmobQuery queryWithClassName:@"Wish"];
    [query includeKey:@"user"];
    [query getObjectInBackgroundWithId:self.objectId block:^(BmobObject *object, NSError *error) {
        if(!error){
        self.context = [object objectForKey:@"text"];
        self.nickname = [[object objectForKey:@"user"] objectForKey:@"nick"];
        self.avatar =[[object objectForKey:@"user"] objectForKey:@"avatar"];
        self.image = [object objectForKey:@"url"];
        self.deviceType = [[object objectForKey:@"user"] objectForKey:@"deviceType"];
        self.installId = [[object objectForKey:@"user"] objectForKey:@"installId"];
        self.chatid = [object objectForKey:@"user"];
        self.chatId = self.chatid.objectId;
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd"];
        NSDate *d= [date dateFromString:[[object objectForKey:@"user"] objectForKey:@"birthday"]];
        self.timeDate = self.chatid.updatedAt;
        
        NSTimeInterval dateDiff = [d timeIntervalSinceNow];
        int age=trunc(dateDiff/(60*60*24))/365;
        self.age = [NSString stringWithFormat:@"%d",-age];
        self.like = [NSString stringWithFormat:@"%d",[[object objectForKey:@"like"] intValue]];
        self.comment= [NSString stringWithFormat:@"%d",[[object objectForKey:@"comment"] intValue]];
       
        NSString * s = [NSString stringWithFormat:@"%@",[mistiming returnUploadTime:[NSString stringWithFormat:@"%@",self.timeDate]]];
        self.distance = s;
        self.attime = [NSString stringWithFormat:@"%@",[mistiming returnUploadTime:[NSString stringWithFormat:@"%@",self.timeDate]]];
        self.sex = [self.chatid objectForKey:@"sex"];
         _user = [NSString stringWithString:self.chatId];
            [self getWishMsg];
        }else{
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
            lab.text = @"此愿望已经删除";
            lab.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:lab];
            [HUD removeFromSuperview];
        }
        
    }];


}

-(void)getWishMsg{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"WishMsg"];
    [bquery orderByDescending:@"updatedAt"];
    bquery.limit = 15;
    [bquery includeKey:@"wish,fromUser,toUser"];
    [bquery whereKey:@"msgType" containedIn:@[[NSNumber numberWithInt:2],[NSNumber numberWithInt:0]]];
    [bquery whereKey:@"wish" equalTo:self.objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        commentarray = [[NSMutableArray alloc] init];
        CommentModel * comment;
        for (BmobObject * obj in array) {
            comment = [[CommentModel alloc] init];
            BmobUser * bUser = [obj objectForKey:@"fromUser"];
            BmobUser * toUser = [obj objectForKey:@"toUser"];
            if([[obj objectForKey:@"msgType"] integerValue] == 0){
                comment.name = [bUser objectForKey:@"nick"];
            }else{
                comment.name = [NSString stringWithFormat:@"%@ 回复 %@",[bUser objectForKey:@"nick"],[toUser objectForKey:@"nick"]];
            }
            comment.installId = [bUser objectForKey:@"installId"];
            comment.deviceType = [bUser objectForKey:@"deviceType"];
            comment.userId = bUser.objectId;
            comment.commentId = obj.objectId;
            comment.url = [bUser objectForKey:@"avatar"];
            comment.context = [obj objectForKey:@"content"];
            comment.createTime = obj.createdAt;
            [commentarray addObject:comment];
            }
            [commentTableView reloadData];
            [HUD removeFromSuperview];
        if(isComBool == YES){
            isComBool = NO;
            [self createUI];
            [self createXBar];
            [self getLike];
        }
    }];
}

-(void)getLike{
    likearray = [[NSMutableArray alloc] init];
    BmobUser * user = [BmobUser getCurrentObject];
    BmobQuery *query = [BmobQuery queryWithClassName:@"WishMsg"];
    [query includeKey:@"fromUser"];
    [query whereKey:@"msgType" equalTo:[NSNumber numberWithInt:1]];
    [query whereKey:@"wish" equalTo:self.objectId];
    [query whereKey:@"fromUser" equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count != 0){
            likeObject = [array[0] objectId];
            UIButton * btn  = (id)[self.view viewWithTag:402];
           if([user.objectId isEqualToString:_chatId]){
            [btn setImage:[UIImage imageNamed:@"yikaopuchang"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"yikaopuchangselect"] forState:UIControlStateHighlighted];
            }else{
                [btn setImage:[UIImage imageNamed:@"yikaopu"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"yikaopuselect"] forState:UIControlStateHighlighted];
            }
            btn.tag = 403;
            

        }else{
            UIButton * btn  = (id)[self.view viewWithTag:403];
            if([user.objectId isEqualToString:_chatId]){
                [btn setImage:[UIImage imageNamed:@"kaopuchang"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"kaopuchangselect"] forState:UIControlStateHighlighted];
            }else{
                [btn setImage:[UIImage imageNamed:@"kaopu"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"kaopuselect"] forState:UIControlStateHighlighted];

            }
            btn.tag = 402;
        }
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"WishMsg"];
        [bquery orderByDescending:@"updatedAt"];
        bquery.limit = 7;
        [bquery includeKey:@"fromUser"];
        [bquery whereKey:@"msgType" equalTo:[NSNumber numberWithInt:1]];
        [bquery whereKey:@"wish" equalTo:self.objectId];
        
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            for (BmobObject * obj in array) {
                if([[obj objectForKey:@"fromUser"] objectForKey:@"avatar"] != nil)
                    [likearray addObject:[[obj objectForKey:@"fromUser"] objectForKey:@"avatar"]];
            }
            [HUD removeFromSuperview];
            [self createImage];
        }];
    }];
  
}

-(void)createNaBar{
    
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIColor whiteColor];
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
    
    UIButton * more = [[UIButton alloc] initWithFrame:CGRectMake(276,0, 44,44)];
    [more setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [more setImage:[UIImage imageNamed:@"gengduoselect"] forState:UIControlStateHighlighted];
    [more addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:more];
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = @"愿望详情";
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];

    
}

-(void)more{
    BmobUser * user = [BmobUser getCurrentUser];
    UIActionSheet *as;
    if([user.objectId isEqualToString:_chatId]){
        as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"分享",@"删除", nil];
        as.tag = 10000;
    }else{
        as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"分享",@"举报", nil];
        as.tag = 10001;
    }
    as.delegate = self;
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 10000){
        if(buttonIndex == 1){
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:self.objectId forKey:@"wishId"];
            [BmobCloud callFunctionInBackground:@"deleteWish" withParameters:dict block:^(id object, NSError *error) {
                if(error){
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = @"删除愿望失败";
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        HUD = nil;
                    }];
                }else{
                if([[NSString stringWithFormat:@"%@",object] isEqualToString:@"最后一条数据不能删除"]){
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = @"最后一条愿望不可被删除";
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        HUD = nil;
                    }];
                }else{
                    BmobUser * user=  [BmobUser getCurrentObject];
                    [user setObject:[BmobObject objectWithoutDatatWithClassName:@"Wish" objectId:[object objectForKey:@"objectId"]] forKey:@"lastWish"];
                
                    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if(self.number == 1){
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

                    }];
                }
                }
            }];
        }else{
            if(buttonIndex == 0){
              UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享到朋友圈" message:@"确定分享到朋友圈" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 11;
            [alert show];
            }
        }
        
    }else{
        if(buttonIndex == 1){
            BmobUser * user = [BmobUser getCurrentObject];
            BmobObject * object = [BmobObject objectWithClassName:@"ReportMsg"];
            [object setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:user.objectId] forKey:@"fId"];
            [object setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_chatId] forKey:@"tId"];
            [object setObject:[BmobUser objectWithoutDatatWithClassName:@"Wish" objectId:_objectId] forKey:@"wish"];
            [object saveInBackground];
            HUD.labelText = @"举报成功";
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
            [self.view addSubview:HUD];
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                HUD = nil;
            }];
        }else{
             if(buttonIndex == 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享到朋友圈" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 11;
            [alert show];
             }
        }
    
    }
             
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11){
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            if(self.image != nil){
                [self sharedByWeChatWithImage:self.image sceneType:1];
            }else{
                [self sharedByWeChatWithText:self.context sceneType:1];
            }
        }
    }else{
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            CommentModel * comment = commentarray[removeComment];
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"WishMsg"];
            [bquery getObjectInBackgroundWithId:comment.commentId block:^(BmobObject *object, NSError *error){
                if (error) {
                    HUD.labelText = @"删除评论失败";
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                    [self.view addSubview:HUD];
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        HUD = nil;
                    }];
                }else{
                    if (object) {
                        [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                            NSLog(@"%@",error);
                            [self getData];
                        }];
                    }
                }
            }];
        }

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
    
    ext.imageData  = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.image]];
    UIImage *image = [UIImage imageWithData:ext.imageData];
    ext.imageData  = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = sceneType;
    
    [WXApi sendReq:req];
}

-(void)goBack{
    NSArray * array = self.navigationController.viewControllers;
    int k = 0;
    for (int i = 0 ; i < array.count ; i++) {
        if([[NSString stringWithFormat:@"%@",[array[array.count -2] class]] isEqualToString:@"WishViewController"]){
            WishViewController * wvc = array[array.count - 2];
            UILabel * like = (id)[self.view viewWithTag:20];
            UILabel * comment = (id)[self.view viewWithTag:21];
            if([[NSString stringWithFormat:@"%@",[like class]] isEqualToString:@"UILabel"]){
                wvc.commentChange([like.text intValue],[comment.text intValue]);
            }
            [self.navigationController popToViewController:wvc animated:YES];
            k = 1;
        }
    }
    if(k == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)createXBar{
    BmobUser * user = [BmobUser getCurrentObject];
    xBarV.hidden = NO;
    xBarV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, 320, 49)];
    if([user.objectId isEqualToString:_chatId]){
        xBarV.backgroundColor = [UIcol hexStringToColor:@"#2e2e2e"];
        NSArray * imageArray = @[@"",@"pinglunchang",@"kaopuchang"];
        NSArray * seleArray = @[@"",@"pinglunchangselect",@"kaopuchangselect"];
        for(int i= 0 ; i < 3 ;i ++){
            UIButton * xBarBtn;
            if(i == 1){
                xBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
            }else if(i == 2){
                xBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 50)];
            }
            [xBarBtn addTarget:self action:@selector(addlike:) forControlEvents:UIControlEventTouchUpInside];
            [xBarBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [xBarBtn setImage:[UIImage imageNamed:seleArray[i]] forState:UIControlStateHighlighted];
            
            xBarBtn.tag = 400+i;
            [xBarV addSubview:xBarBtn];
        }
    }else{
        xBarV.backgroundColor = [UIcol hexStringToColor:@"#2e2e2e"];
        NSArray * imageArray = @[@"siliao",@"pinglun",@"kaopu"];
        NSArray * seleArray = @[@"siliaoselect",@"pinglunselect",@"kaopuselect"];
        for(int i= 0 ; i < 3 ;i ++){
            UIButton * xBarBtn;
            if(i == 0){
                xBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 106.5, 50)];
            }else if(i == 1){
                xBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(106.5, 0, 107, 50)];
            }else if(i == 2){
                xBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(107 + 106.5, 0, 106.5, 50)];
            }
            [xBarBtn addTarget:self action:@selector(addlike:) forControlEvents:UIControlEventTouchUpInside];
            [xBarBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [xBarBtn setImage:[UIImage imageNamed:seleArray[i]] forState:UIControlStateHighlighted];
            
            xBarBtn.tag = 400+i;
            [xBarV addSubview:xBarBtn];
        }
    }
    [self.view addSubview:xBarV];
}


-(void)addSeek{
    [self addSeekFromUser:_user Type:_type];
}

-(void)addSeekFromUser:(NSString *)user Type:(int)type{
    NSLog(@"%d",_type);
    
    if(![_textView.text isEqualToString:@""]){
            BmobUser * bUser = [BmobUser getCurrentObject];
            BmobObject  * wishMsg = [BmobObject objectWithClassName:@"WishMsg"];
            [wishMsg setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:bUser.objectId] forKey:@"fromUser"];
            [wishMsg setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:user] forKey:@"toUser"];
            [wishMsg setObject:[BmobUser objectWithoutDatatWithClassName:@"Wish" objectId:self.objectId] forKey:@"wish"];
            [wishMsg setObject:_textView.text forKey:@"content"];
            [wishMsg setObject:[NSNumber numberWithInt:type] forKey:@"msgType"];
            [wishMsg saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(!error){
                    _textView.text = @"";
                    UILabel * comment = (id)[self.view viewWithTag:21];
                    comment.text = [NSString stringWithFormat:@"%d",[comment.text intValue]+1];
                    BmobQuery* wishQuery = [BmobQuery queryWithClassName:@"Wish"];
                    [wishQuery getObjectInBackgroundWithId:self.objectId block:^(BmobObject *object,NSError *error){
                        [object setObject:[NSNumber numberWithInt:[comment.text integerValue]] forKey:@"comment"];
                        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            [self getData];
                            [self pushWishInstallId:self.installId DeviceType:self.deviceType];
                            if(type == 2){
                                [self pushWishInstallId:chatInstallId DeviceType:chatDeviceType];
                            }
                        }];
                    }];
                }
            }];
        _type = 0;
        _user = self.chatId;
        //        commentv.frame = CGRectMake(320, 0, 200, 30);
        _textView.text = @"";
        //        [commenttv resignFirstResponder]
    }

}

-(void)pushWishInstallId:(NSString *)installId DeviceType:(NSString *)deviceType{
    BmobUser * bUser = [BmobUser getCurrentObject];
    if([[bUser objectForKey:@"installId"] isEqualToString:installId])
        return ;
    if([deviceType isEqualToString:@"android"]){
        BmobPush *push = [BmobPush push];
        BmobQuery *query = [BmobInstallation query];
        [query whereKey:@"installationId" equalTo:installId];
        [push setQuery:query];
        NSMutableDictionary * set = [NSMutableDictionary dictionary];
        [set setObject:[NSString stringWithFormat:@"%@评论了你的愿望",[[NSUserDefaults standardUserDefaults] objectForKey:@"nick"]] forKey:@"alert"];
        [set setObject:@"0" forKey:@"badge"];
        [set setObject:[bUser objectId] forKey:@"tId"];
        [set setObject:@"" forKey:@"sound"];
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:set forKey:@"aps"];
        [dict setObject:@"addComment" forKey:@"tag"];
        [push setData:dict];
        
        [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"error %@",[error description]);
        }];
        
    }else{
        BmobPush *push = [BmobPush push];
        BmobQuery *query = [BmobInstallation query];
        [query whereKey:@"deviceToken" equalTo:installId];
        [push setQuery:query];
        NSMutableDictionary * set = [NSMutableDictionary dictionary];
        [set setObject:[NSString stringWithFormat:@"%@评论了你的愿望",[[NSUserDefaults standardUserDefaults] objectForKey:@"nick"]] forKey:@"alert"];
        [set setObject:@"0" forKey:@"badge"];
        [set setObject:@"" forKey:@"sound"];
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:set forKey:@"aps"];
        [dict setObject:@"addComment" forKey:@"tag"];
        [push setData:dict];
        [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"error %@",[error description]);
        }];
    }
}

-(void)addlike:(UIButton *)btn{
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    switch (btn.tag) {
        case 403:{
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"WishMsg"];
            [bquery orderByDescending:@"updatedAt"];
            [bquery includeKey:@"wish"];
            [bquery whereKey:@"msgType" equalTo:[NSNumber numberWithInt:1]];
            [bquery whereKey:@"fromUser" equalTo:bUser.objectId];
            [bquery whereKey:@"wish" equalTo:self.objectId];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                for (int i = 0; i < array.count; i++) {
                    BmobObject * object = array[i];
                    [bquery getObjectInBackgroundWithId:object.objectId block:^(BmobObject *object, NSError *error) {
                        [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                            UILabel * like = (id)[self.view viewWithTag:20];
                            like.text = [NSString stringWithFormat:@"%d",[like.text intValue]-1];
                            BmobQuery* wishQuery = [BmobQuery queryWithClassName:@"Wish"];
                            [wishQuery getObjectInBackgroundWithId:self.objectId block:^(BmobObject *object,NSError *error){
                                [object setObject:[NSNumber numberWithInt:[like.text integerValue]] forKey:@"like"];
                                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    [self getLike];
                                }];
                            }];
                        }];
                    }];
                }
            }];
            
        }
            break;
        case 402:{
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"WishMsg"];
            [bquery orderByDescending:@"updatedAt"];
            [bquery includeKey:@"wish"];
            [bquery whereKey:@"msgType" equalTo:[NSNumber numberWithInt:1]];
            [bquery whereKey:@"fromUser" equalTo:bUser.objectId];
            [bquery whereKey:@"wish" equalTo:self.objectId];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                NSLog(@"array%@",array);
                if(array.count == 0){
                    BmobObject  * wishMsg = [BmobObject objectWithClassName:@"WishMsg"];
                    [wishMsg setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:bUser.objectId] forKey:@"fromUser"];
                    [wishMsg setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_chatId] forKey:@"toUser"];
                    [wishMsg setObject:[BmobUser objectWithoutDatatWithClassName:@"Wish" objectId:self.objectId] forKey:@"wish"];
                    [wishMsg setObject:[NSNumber numberWithInt:1] forKey:@"msgType"];
                    [wishMsg saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if(!error){
                            UILabel * like = (id)[self.view viewWithTag:20];
                            like.text = [NSString stringWithFormat:@"%d",[like.text intValue]+1];
                            BmobQuery* wishQuery = [BmobQuery queryWithClassName:@"Wish"];
                            [wishQuery getObjectInBackgroundWithId:self.objectId block:^(BmobObject *object,NSError *error){
                                [object setObject:[NSNumber numberWithInt:[like.text integerValue]] forKey:@"like"];
                                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    [self getLike];
                                    if([[bUser objectForKey:@"installId"] isEqualToString:self.installId])
                                        return ;
                                    if([self.deviceType isEqualToString:@"android"]){
                                        BmobPush *push = [BmobPush push];
                                        BmobQuery *query = [BmobInstallation query];
                                        [query whereKey:@"installationId" equalTo:self.installId];
                                        [push setQuery:query];
                                        NSMutableDictionary * set = [NSMutableDictionary dictionary];
                                        [set setObject:[NSString stringWithFormat:@"%@对你点了赞",[[NSUserDefaults standardUserDefaults] objectForKey:@"nick"]] forKey:@"alert"];
                                        [set setObject:@"0" forKey:@"badge"];
                                        [set setObject:@"" forKey:@"sound"];
                                        
                                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                                        [dict setObject:set forKey:@"aps"];
                                        [dict setObject:[bUser objectId] forKey:@"tId"];
                                        [dict setObject:@"addLike" forKey:@"tag"];
                                        [push setData:dict];
                                        NSLog(@"%@",dict);
                                        [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                            NSLog(@"error %@",[error description]);
                                        }];
                                        
                                    }else{
                                        BmobPush *push = [BmobPush push];
                                        BmobQuery *query = [BmobInstallation query];
                                        [query whereKey:@"deviceToken" equalTo:self.installId];
                                        [push setQuery:query];
                                        NSMutableDictionary * set = [NSMutableDictionary dictionary];
                                        [set setObject:[NSString stringWithFormat:@"%@对你点了赞",[[NSUserDefaults standardUserDefaults] objectForKey:@"nick"]] forKey:@"alert"];
                                        [set setObject:@"0" forKey:@"badge"];
                                        [set setObject:@"" forKey:@"sound"];
                                        
                                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                                        [dict setObject:set forKey:@"aps"];
                                        [dict setObject:@"addLike" forKey:@"tag"];
                                        [push setData:dict];
                                        [push sendPushInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                            NSLog(@"error %@",[error description]);
                                        }];
                                    }
                                }];
                            }];
                        }
                    }];
                }
            }];
            
        }
            break;
        case 401:{
//            commentv.frame = CGRectMake(0, self.view.bounds.size.height-50, 320, 50);
            _textStr = @"";
            _textViewBack.hidden = NO;
            xBarV.hidden = YES;
            [_textView becomeFirstResponder];
        }
            break;
        case 400:{
            NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
            BmobChatUser *user = (id)self.chatid;
            
            
            [infoDic setObject:user.objectId forKey:@"uid"];
            [infoDic setObject:[user objectForKey:@"username"]forKey:@"name"];
            if ([user objectForKey:@"avatar"]) {
                [infoDic setObject:[user objectForKey:@"avatar"] forKey:@"avatar"];
            }
            if ([user objectForKey:@"nick"]) {
                [infoDic setObject:[user objectForKey:@"nick"] forKey:@"nick"];
            }
            /*
             
             
             */
            [infoDic setObject:_context forKey:@"context"];
            if (_image) {
                [infoDic setObject:_image forKey:@"image"];
            }
            
            [infoDic setObject:_like forKey:@"like"];
            [infoDic setObject:_comment forKey:@"comment"];
            [infoDic setObject:_timeDate forKey:@"createdAt"];
            NSString *str = self.objectId;
            [infoDic setObject:str forKey:@"objectId"];
            
            ChatViewController * cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
            cvc.where = 0;
            [self.navigationController pushViewController:cvc animated:YES];
            
        }
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _textLable.text = @"";
    _textStr = @"";
    _textViewBack.hidden = YES;
    xBarV.hidden = NO;
    _emojiView.frame = CGRectMake(0, self.view.bounds.size.height, 320, 174);
    [_textView endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _textLable.text = @"";
    _textStr = @"";
    [_textView endEditing:YES];
    _textViewBack.frame = CGRectMake(0,self.view.bounds.size.height-BJHeight, 320,BJHeight);
    _emojiView.frame = CGRectMake(0, self.view.bounds.size.height, 320, 174);
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
//    commentv.frame = CGRectMake(0, self.view.bounds.size.height-260, 320, 50);
}

-(void)createUI{
    int i;
    CGSize size = [self.context boundingRectWithSize:CGSizeMake(219, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
    i = size.height;
    if(![self.image isEqualToString:@""] && self.image != nil && ![self.image isEqualToString:@"(null)"] ){
        i += 80;
    }
    back = [[UIView alloc] initWithFrame:CGRectMake(320, 64, self.view.bounds.size.width, i + 80)];
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, i + 80)];
    [backBtn addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:backBtn];
    TQRichTextView * contextv = [[TQRichTextView alloc] initWithFrame:CGRectMake(75,42,219,size.height)];
    contextv.backgroundColor = [UIColor clearColor];
    contextv.text = self.context;
    contextv.userInteractionEnabled = NO;
    contextv.font = [UIFont systemFontOfSize:14];
    contextv.textColor = [UIcol hexStringToColor:@"787878"];
    
    UIButton * avatar = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    avatar.layer.cornerRadius = 8;
    avatar.layer.masksToBounds = YES;
    UIImageView * avatarImageView = [[UIImageView alloc] init];
    NSURL * avatarimu = [NSURL URLWithString:self.avatar];
    [avatarImageView sd_setImageWithURL:avatarimu completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [avatar setImage:avatarImageView.image forState:UIControlStateNormal];    
    }];
    [avatar addTarget:self action:@selector(onClickAvatar) forControlEvents:UIControlEventTouchUpInside];
    if(![self.image isEqualToString:@""] && self.image != nil && ![self.image isEqualToString:@"(null)"] ){
        UIView * drawingImageView = [[UIView alloc] initWithFrame:CGRectMake(65,i - 42, 70, 70)];
        photosView * photo = [[photosView alloc] init];
        NSMutableArray * array = [[NSMutableArray alloc] init];
        [array addObject:self.image];
        photo.picUrls = array;
        [drawingImageView addSubview:photo];
        
//        NSURL * imageimu = [NSURL URLWithString:self.image];
        photoImage = photo.customIV.image;
        [back addSubview:drawingImageView];
    }

    UIImageView * likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(75, i + 50, 12, 12)];
    likeIcon.image = [UIImage imageNamed:@"kaopuliebiao"];
    UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(137, i + 50, 12, 12)];
    commentIcon.image = [UIImage imageNamed:@"pinglunliebiao"];
    
    UILabel * likeText = [[UILabel alloc] initWithFrame:CGRectMake(92, i + 50, 80, 12)];
    likeText.tag = 20;
    likeText.font = [UIFont systemFontOfSize:11];
    likeText.text = self.like;
    likeText.textColor = [UIcol hexStringToColor:@"bebebe"];
    
    UILabel * commentText = [[UILabel alloc] initWithFrame:CGRectMake(154, i + 50, 80, 12)];
    commentText.font = [UIFont systemFontOfSize:11];
    commentText.text = self.comment;
    commentText.tag = 21;
    commentText.textColor = [UIcol hexStringToColor:@"bebebe"];

    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, i+79.5, 320, 0.5)];
    line.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 100, 20)];
    name.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    name.text = self.nickname;
    name.font = [UIFont systemFontOfSize:13];
    
    UIImageView * agev = [[UIImageView alloc] initWithFrame:CGRectMake(70, 40, 15, 12)];
    UILabel * age = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 12)];
    age.textColor = [UIColor whiteColor];
    age.text = self.age;
    age.font = [UIFont systemFontOfSize:10];
    age.textAlignment = YES;
    [agev addSubview:age];
    
    CGRect nameRect = [self.nickname boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    if ([[NSString stringWithFormat:@"%@",self.sex] isEqualToString:@"1"]) {
        agev.image = [UIImage imageNamed:@"nanshengnianling"];
    }else{
        agev.image = [UIImage imageNamed:@"niushengnianling"];
    }
    agev.center = CGPointMake(nameRect.size.width + 85, 25);
    
    
//    UILabel * distance = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 160, 15)];
//    distance.font = [UIFont systemFontOfSize:11];
//    distance.textAlignment = NSTextAlignmentRight;
//    distance.textColor = [UIcol hexStringToColor:@"bebebe"];
//  
////    CGRect rect = [[NSString stringWithFormat:@"%@",self.attime] boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
//    distance.text = [NSString stringWithFormat:@"%@",self.attime];
//    UIView * xian = [[UIView alloc] initWithFrame:CGRectMake(320, 17, 1, 10)];
//    xian.backgroundColor = [UIcol hexStringToColor:@"#bebebe"];
//    xian.center = CGPointMake(305-rect.size.width,xian.center.y );
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(75, 37.5, 320, 0.5)];
    line2.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    
    UILabel * createTime = [[UILabel alloc] initWithFrame:CGRectMake(160, i + 50, 150, 12)];
    createTime.textAlignment = NSTextAlignmentRight;
    createTime.font = [UIFont systemFontOfSize:11];
    createTime.textColor = [UIcol hexStringToColor:@"#bebebe"];
    if(self.timeDate != nil)
        createTime.text = [[NSString stringWithFormat:@"%@",self.timeDate] substringWithRange:NSMakeRange(5,5)];
    
    [back addSubview:createTime];
    [back addSubview:commentText];
    [back addSubview:likeText];
    [back addSubview:line2];
//    [back addSubview:distance];
    [back addSubview:agev];
    [back addSubview:name];
    [back addSubview:line];
    [back addSubview:commentIcon];
    [back addSubview:likeIcon];
    [back addSubview:avatar];
    [back addSubview:contextv];
    [self.view addSubview:back];
}

-(void)onClickAvatar{
    friendInfoViewController * fdvc = [[friendInfoViewController alloc] init];
    fdvc.userId = _chatId;
    fdvc.userName = [self.chatid objectForKey:@"nick"];
    [self.navigationController pushViewController:fdvc animated:YES];
}



-(void)wishBtn{
    friendDatumViewController * fdvc = [[friendDatumViewController alloc] init];
    fdvc.tempIdStr = self.chatId;
    [self presentViewController:fdvc animated:YES completion:^{
        
    }];
}

-(void)createImage{
    UIButton * btn = (id)[self.view viewWithTag:615] ;
    UIView * line = (id)[self.view viewWithTag:616] ;
    [btn removeFromSuperview];
    [line removeFromSuperview];
    if(likearray.count != 0){
        if(isBackBool == YES){
            back.frame = CGRectMake(0,64, 320,back.frame.size.height + 35);
            isBackBool = NO;
        }
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, back.frame.size.height - 35, 320, 35)];
        [btn addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] size:btn.bounds.size] forState:UIControlStateHighlighted];
        line = [[UIView alloc] initWithFrame:CGRectMake(0,back.frame.size.height-0.5, 320, 0.5)];
        btn.tag = 615;
        line.tag = 616;
        line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
            for(int i = 0  ; i < likearray.count ; i++){
                
                UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(10,11.5 , 12, 12)];
                icon.image = [UIImage imageNamed:@"kaopuliebiao"];
                [btn addSubview:icon];

                UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(34 + i * 35,5, 25, 25)];
                iv.layer.cornerRadius = 7;
                iv.layer.masksToBounds = YES;
                NSURL * imu = [NSURL URLWithString:likearray[i]];
                [iv sd_setImageWithURL:imu];
                [btn addSubview:iv];
                if(i == 6){
                    UIImageView * boult = [[UIImageView alloc] initWithFrame:CGRectMake(69 + i * 35,9, 11, 17)];
                    boult.image = [UIImage imageNamed:@"jiantou"];
                    [btn addSubview:boult];
                }
        }
        [back addSubview:btn];
        [back addSubview:line];
    }else{
        if(isBackBool == NO){
            back.frame = CGRectMake(0, 64, back.frame.size.width, back.frame.size.height - 35);
            isBackBool = YES;
        }else{
            
        }
    }
    
    commentTableView.tableHeaderView = back;
}

-(void)likeBtn{
    RecentlyViewController * rvc = [[RecentlyViewController alloc] init];
    rvc.i = 1;
    rvc.userObject = self.objectId;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell * commentcell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (!commentcell) {
        commentcell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"] ;
    }
    
    CommentModel * comment =commentarray[indexPath.row];
    commentcell.context.text = comment.context;
    commentcell.name.text = comment.name;
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",comment.createTime];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    timeString = [NSString stringWithFormat:@"%f", cha/60];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@", timeString];

    if([timeString integerValue] <= 30){
        commentcell.createTime.text =@"刚刚";
    }else{
        commentcell.createTime.text = [[NSString stringWithFormat:@"%@",comment.createTime] substringWithRange:NSMakeRange(5,11)];
    }
    NSURL * imu = [NSURL URLWithString:comment.url];
    [commentcell.image sd_setImageWithURL:imu];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(32, 15, 50, 50)];
    btn.tag  = 10000 + indexPath.row;
    [btn addTarget:self action:@selector(onPer:) forControlEvents:UIControlEventTouchUpInside];
    [commentcell addSubview:btn];
    
    CGSize size = [comment.context boundingRectWithSize:CGSizeMake(200, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    commentcell.context.frame = CGRectMake(92,38, 200,size.height + 20);
        commentcell.line.frame = CGRectMake(0, size.height + 49.5, 320, 0.5);
    if(size.height < 17){
        commentcell.context.frame = CGRectMake(92,38, 200,size.height + 20);
       commentcell.line.frame = CGRectMake(0, 79.5, 320, 0.5);
    }
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1;
    [commentcell addGestureRecognizer:longPressGr];
    return commentcell;
}

-(void)onPer:(UIButton *)btn{
   CommentModel * comment = commentarray[btn.tag - 10000];
    friendInfoViewController * fdvc = [[friendInfoViewController alloc] init];
    fdvc.userId = comment.userId;
    NSString *string1 = comment.name;
    NSString *string2 = @"回复:";
    NSRange range = [string1 rangeOfString:string2];
    NSString *astring;
    if(range.length != 0){
        astring = [comment.name substringToIndex:range.location];
    }else{
        astring = comment.name;
    }
    fdvc.userName = astring;
    [self.navigationController pushViewController:fdvc animated:YES];
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"%d",removeComment);
        NSIndexPath *indexPath = [commentTableView indexPathForCell:((UITableViewCell *)gesture.view)];
        removeComment = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除评论" message:@"确定删除评论吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textView.text = @"";
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIButton * btn = [[UIButton alloc] init];
    btn.tag = 401;
    CommentModel * comment =commentarray[indexPath.row];
    _user = comment.userId;
    
    NSString *string1 = comment.name;
    NSString *string2 = @"回复:";
    NSRange range = [string1 rangeOfString:string2];
    NSString *astring;
    if(range.length != 0){
       astring = [comment.name substringToIndex:range.location];
    }else{
        astring = comment.name;
    }
    _textLable.text = [NSString stringWithFormat:@"回复 %@:",astring];
    _textStr = [NSString stringWithFormat:@"回复 %@:",astring];
    chatInstallId = comment.installId;
    chatDeviceType = comment.deviceType;
    _type = 2;
    [_textView becomeFirstResponder];
    [self addlike:btn];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel * comment =commentarray[indexPath.row];

    CGSize size = [comment.context boundingRectWithSize:CGSizeMake(200, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;

    if(size.height < 17)
        return 80;
    return size.height + 50;

}

//****************************************************************************************************
-(void)keyboardFrameChange:(NSNotification *)note{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.view.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    //    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    textY = keyboardFrame.origin.y;
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        //        _textViewBack.transform = CGAffineTransformMakeTranslation(0, transformY);
        CGFloat keyboardY = [self.view convertRect:keyboardFrame fromView:nil].origin.y;
        CGRect inputViewFrame = _textViewBack.frame;
        //        CGRect tableviewFrame = _chatTableView.frame;
        CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
        //        keyboardHeight = tableviewFrameY;
        CGFloat messageViewFrameBottom = self.view.frame.size.height - 49;
        if(inputViewFrameY > messageViewFrameBottom)
            inputViewFrameY = messageViewFrameBottom;
        
        _textViewBack.frame = CGRectMake(inputViewFrame.origin.x,
                                         inputViewFrameY,
                                         inputViewFrame.size.width,
                                         inputViewFrame.size.height);
    }];
    
}



-(void)createTextView{
    
    _textViewBack = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-49, 320, 49)];
    _textViewBack.userInteractionEnabled = YES;
    _textViewBack.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    _textViewBack.hidden = YES;
    
    _textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 397 * 0.5, 30)];
    _textLable.textColor = [UIcol hexStringToColor:@"#bebebe"];
    _textLable.font = [UIFont systemFontOfSize:15];
    //设置
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake( 47, 9.5, 397 * 0.5, 30);
    //    _textView.returnKeyType    = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.contentInset = UIEdgeInsetsMake(0, 2, 0, 0);
    _textView.showsVerticalScrollIndicator = NO;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    [_textView addSubview:_textLable];
    //获得焦点
    _textView.delegate = self;
    _textView.bounces = NO;
    [_textViewBack addSubview:_textView];
    [self.view addSubview:_textViewBack];
    
    //发送
    sendBut = [[UIButton alloc] initWithFrame:CGRectMake(270, 10, 45, 30)];
    [sendBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBut setTitle:@"发送" forState:UIControlStateNormal];
    sendBut.titleLabel.font = [UIFont systemFontOfSize:15];
    sendBut.titleLabel.textAlignment = YES;
    [sendBut addTarget:self action:@selector(sendon) forControlEvents:UIControlEventTouchUpInside];
    [_textViewBack addSubview:sendBut];
    
    //表情
    emojiButton              = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiButton.tag          = 100;//229 + 45
    [emojiButton setFrame:CGRectMake(0, 0, 49,49)];
    [emojiButton addTarget:self action:@selector(showBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [emojiButton setImage:[UIImage imageNamed:@"xuanzebiaoqing"] forState:UIControlStateNormal];
    [emojiButton setImage:[UIImage imageNamed:@"xuanzebiaoqingSelect"] forState:UIControlStateHighlighted];
    [_textViewBack addSubview:emojiButton];
    
    //输入框
    textViewXian = [[UIView alloc]initWithFrame:CGRectMake(45, 36, 229, 5)];
    textViewXian.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xian"]];
    [_textViewBack addSubview:textViewXian];
    
    //表情视图
    _emojiView                            = [[smileView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 174)];
    _emojiView.userInteractionEnabled     = YES;
    _emojiView.delegate                   = self;
    [self.view addSubview:_emojiView];
    
}

- (void)showBottomView:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    _textViewBack.frame = CGRectMake(0,self.view.bounds.size.height - 174 - BJHeight, 320, BJHeight);
    _emojiView.frame = CGRectMake(0, self.view.bounds.size.height-174, 320, 174);
    
}

- (void)sendon//发送
{
    NSLog(@"发送");
    if(_textView.text.length >= 60){
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"评论最多60字";
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
    if(![_textView.text isEqualToString:@""]){
        [_textView resignFirstResponder];
        //笑脸转义
        [self addSeekFromUser:_user Type:_type];
        _textViewBack.hidden = YES;
        xBarV.hidden = NO;
        
      
        NSLog(@"%@", _textView.text);
        CGRect frame =  _textViewBack.frame;
        frame.origin.y = frame.origin.y + (frame.size.height - 49);
        frame.size.height = 49;
        BJHeight = 49;
        _textViewBack.frame = frame;
        
        frame = _textView.frame;
        frame.size.height = 30;
        _textView.frame = frame;
        
        frame = emojiButton.frame;
        frame.origin.y = 0;
        emojiButton.frame = frame;
        
        frame = sendBut.frame;
        frame.origin.y = 10;
        sendBut.frame = frame;
        
        frame = textViewXian.frame;
        frame.origin.y = 36;
        textViewXian.frame = frame;
        
        frame = _emojiView.frame;
        frame.origin.y = Main_screen_height;
        _emojiView.frame = frame;
    }
    
}

//表情包代理方法
- (void)didSelectSmileView:(smileView *)view emojiText:(NSString *)text
{
    _textStr = @"";
    _textLable.text = _textStr;
    [self _textViewChangeWhere:2];
    [self.view endEditing:YES];
    [_textView setTextColor:[UIColor blackColor]];
    NSMutableString *faceString = [[NSMutableString alloc]initWithString:_textView.text];
    [faceString appendString:text];
    //    _textView.text = faceString;
    [_textView setText:faceString];
    
    //    [_textView becomeFirstResponder];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
        //    //该判断用于联想输入
    UILabel * number = (id)[self.view viewWithTag:333];
    int k = [TxetViewChar textViewCharWish:textView.text];
    //   int k =textView.text.length;
    if((60 - k) > 0){
        number.text = [NSString stringWithFormat:@"%d",60-k];
    }else{
        number.text = @"0";
    }
    if (k > 60 )
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"字数不能超过60字" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 112;
        [alert show];
//        isNumber = NO;r
    }
    if([_textView.text isEqualToString:@""]){
        _textLable.text = _textStr;
    }else{
        _textLable.text = @"";
    }
    
    [self _textViewChangeWhere:1];
}


- (void)deleteSmile
{
    CGFloat smileLen = 6;
    NSString *smileHead = @"\\u";
    NSString *str = [_textView.text emoteStringWithDict:self.SmileDict];
    
    NSLog(@"smileHead = %@, %@", smileHead,str);
    
    NSInteger length = str.length;
    NSLog(@"textView.text = %@,长度 %d", str, length);
    if (length) {
        NSString *temp = nil;
        if ( length >= smileLen) {
            
            temp = [str substringFromIndex:length - smileLen];
            NSRange range = [temp rangeOfString:smileHead];
            if (range.location == 0) {
                str = [str substringToIndex:
                       [str rangeOfString:smileHead
                                  options:NSBackwardsSearch].location];
            }else{
                str = [str substringToIndex:length - 1];
            }
            str = [str emoteStringToHanzi];
            _textView.text = str;
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

/**1.键盘 2.表情*/
- (void)_textViewChangeWhere:(int)where
{
    //一行，17.895000
    //四行，71.580002
    CGRect frame =  _textView.frame;
    CGRect BJframe =  _textViewBack.frame;
    //    CGRect textViewBjTempframe   = textViewBj.frame;
    CGSize size = [_textView.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(190, MAXFLOAT)];
    
    if (size.height >= 54) {
        CGPoint offset;
        offset.y = size.height - 54;
        _textView.contentOffset = offset;
        size.height = 54;
    }else if (size.height <= 18) {
        size.height = 30;
    }
    
    if (size.height  != (_textView.frame.size.height)) {
        //backView
        BJframe.size.height = 49 + (size.height - 30) + 10;
        if (where == 1) {
            BJframe.origin.y = (textY - 49) - (size.height - 30) - 10;
        }else if (where == 2)
        {
            BJframe.origin.y = (Main_screen_height - 174 - 49) - (size.height - 30) - 10;
        }
        
        //textView
        frame.size.height = size.height + 10;
        
        //按钮
        CGFloat centerY = BJframe.size.height / 2;
        
        CGPoint center = sendBut.center;
        center.y = centerY;
        sendBut.center = center;
        
        center = emojiButton.center;
        center.y = centerY;
        emojiButton.center = center;
        
        CGRect temp = textViewXian.frame;
        temp.origin.y = BJframe.size.height - 13;
        textViewXian.frame = temp;
        
    }
    
    BJHeight = _textViewBack.frame.size.height;
    _textView.frame = frame;
    _textViewBack.frame = BJframe;
}



//***************************************************************************************************

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
