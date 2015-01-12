//
//  friendInfoViewController.m
//  DSBBM

//
//  Created by morris on 14/11/21.
//  Copyright (c) 2014年 qt. All rights reserved.
//

//屏幕宽度
#define Main_Screen_Width   [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define Main_Screen_Height  [UIScreen mainScreen].bounds.size.height

#define btnBackViewHeight 49.0f
//底部按钮高度
#define bottomBtnWidth 96.0f
#define bottomBtnHeight 30.0f

#import "friendInfoViewController.h"
#import "ChatViewController.h"
#import "UIcol.h"
#import "constellation.h"
#import "UIImageView+WebCache.h"
#import "MyWishViewController.h"

#import "sqlStatusTool.h"
#import "friendModel.h"
#import "synFriends.h"
#import "MBProgressHUD+NJ.h"
#import "isBlackTool.h"
#import <CoreLocation/CoreLocation.h>

#import "photosView.h"
#import "NSString+Emote.h"
#import "BmobIMSaveMessage.h"

@interface friendInfoViewController ()<UIAlertViewDelegate>


@end

@implementation friendInfoViewController
{
    BmobObject * userObject;
    BmobObject *personObject;
    //底部图片数组
    NSMutableArray *arr;
    BmobChatUser * _chatUser;
    
    //关注点击次数
    int focus;
    //拉黑点击次数
    int black;
    
    UIView *LastWishView;
    //关系中的ID
    NSString *relationId;
    //是否是朋友
    BOOL isfriend;
    
    //当前经纬度
    CGFloat _latitude;
    CGFloat _longitude;
    NSMutableArray * photoArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [MBProgressHUD showMessage:@"正在登陆中..."];
    
    
    [self getBlackList];
   
    black = 0;
    _latitude = 0;
    _longitude = 0;

    BmobUser *user = [BmobUser getCurrentUser];
    if ([user.objectId isEqualToString:self.userId]) {
        self.furcation = 1;
    }else{
         [self vistUser];
    }
    
    NSArray *locationArray =  [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
    NSString * longitude = [locationArray objectAtIndex:0];
    NSString * latitude = [locationArray objectAtIndex:1];
    _longitude = [longitude floatValue];
    _latitude = [latitude floatValue];
    
    // Do any additional setup after loading the view.
    arr =[[NSMutableArray alloc] initWithObjects:@"siliao",@"quxiaoguanzhu",@"lahei", nil];
    [self createNarBar];
}

- (void)vistUser
{
    BmobUser *user = [BmobUser getCurrentUser];
    NSDictionary *parameters =  @{@"from": user.objectId,@"to": _userId};
    [BmobCloud callFunctionInBackground:@"visitUser" withParameters:parameters block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LastWishView.backgroundColor = [UIColor whiteColor];
    BmobUser *user = [BmobUser getCurrentUser];
    if ([user.objectId isEqualToString:self.userId]) {
        UIScrollView * sv = (id)[self.view viewWithTag:3000];
        [sv removeFromSuperview];
        [self getDate];
    }
}

-(void)getDate
{
    BmobQuery * userQuery = [BmobQuery queryForUser];
    [userQuery includeKey:@"userInfo,lastWish"];
    [userQuery getObjectInBackgroundWithId:self.userId block:^(BmobObject *object, NSError *error) {
        if(!error){
            userObject = object;

            [self isfriend];
        }
    }];
    
    
}

- (void)getBlackList
{
    BmobUser *bUser = [BmobUser getCurrentObject];
    BmobQuery *bquery = [BmobQuery queryForUser];
    [bquery whereObjectKey:@"blacklist" relatedTo:bUser];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            for (BmobUser *user in array) {
                if ([user.objectId isEqualToString:self.userId]) {
                    black = 1;break;
                }
            }
        }
        [self getDate];
    }];
}

- (void)isfriend
{
    BmobUser *bUser = [BmobUser getCurrentObject];
    isfriend = NO;
    if (bUser) {
        //查询自己关注的
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"RelationShip"];
        [bquery includeKey:@"uid,fuid"];
        [bquery whereKey:@"uid" equalTo:bUser.objectId];
        //第一层查询
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if(!error){
                for(BmobObject *obj in array){
                    BmobObject *followsObj = [obj objectForKey:@"fuid"];
                    //若fuid是与_userid相同，则关注
                    NSNumber *status = [obj objectForKey:@"status"];
                    if ([followsObj.objectId isEqualToString:_userId] && !([status integerValue] == 1)) {
                        isfriend = YES;
                    }
                    
                }
                [self createUI];
            }
            
            
//            [MBProgressHUD hideHUD];
            
        }];
        
    }
    
}


//最低端的三个按钮
- (void)setBottomBar
{
    
    //底部按钮背景图
    UIView *btnBackView = [[UIView alloc] init];
    btnBackView.frame = CGRectMake(0, Main_Screen_Height-btnBackViewHeight, Main_Screen_Width, btnBackViewHeight);
    btnBackView.backgroundColor = [UIColor blackColor];
    btnBackView.userInteractionEnabled = YES;
    [self.view addSubview:btnBackView];
    
    //底部按钮
    for (int i = 0; i < 3; i ++)
    {
        UIButton *bottomBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(8+bottomBtnWidth*i+8*i, btnBackViewHeight/2-bottomBtnHeight/2, bottomBtnWidth, bottomBtnHeight)];
        
        bottomBtn1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[arr objectAtIndex:i]]];
        
        [bottomBtn1 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn1.tag = 30+i;
        [btnBackView addSubview:bottomBtn1];
        
    }
    
    
    if (isfriend == NO) {
        UIButton *tempBtn= (id)[self.view viewWithTag:31];
        //                        tempBtn.backgroundColor =
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu.png"] forState:UIControlStateNormal ];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"guanzhuselect.png"] forState: UIControlStateHighlighted];
        focus += 1;
    }
    
    if (black == 0) {
        UIButton *tempBtn= (id)[self.view viewWithTag:32];
        //                        tempBtn.backgroundColor =
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"lahei"] forState:UIControlStateNormal ];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"laheiselect"] forState: UIControlStateHighlighted];

    }else if (black == 1){
        UIButton *tempBtn= (id)[self.view viewWithTag:32];
        //                        tempBtn.backgroundColor =
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"quxiaolahei"] forState:UIControlStateNormal ];
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"quxiaolaheiselect"] forState: UIControlStateHighlighted];
    }
    
}



-(void)sendMessageWithContent:(NSString *)content type:(NSInteger)type{
    
    _chatUser = [[BmobChatUser alloc] init];
    _chatUser.objectId = _userId;
    _chatUser.username = _userName;
    _chatUser.nick = [userObject objectForKey:@"nick"];
    _chatUser.avatar = [userObject objectForKey:@"avatar"];
    
    BmobMsg * msg = [BmobMsg createAMessageWithType:type statue:STATUS_SEND_SUCCESS content:content targetId:_chatUser.objectId];
    msg.status = 0;
    msg.isReaded = 0;
    
    msg.status = STATUS_SEND_SUCCESS;
    msg.chatId = _chatUser.objectId;
    
    [[BmobChatManager currentInstance] sendMessageWithUser:_chatUser
                                                   message:msg
                                                     block:^(BOOL isSuccessful, NSError *error) {
                                                         if(error)
                                                         {
                                                             NSLog(@"%@", error);
                                                         }
                                                         if(isSuccessful){}
                                                     }];
    
    
}

- (void)btnOnClick:(UIButton *)btn
{
    switch (btn.tag) {
            
        case 30:
        {
            
            //聊天
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:_userId forKey:@"uid"];
            [dict setObject:[userObject objectForKey:@"username"] forKey:@"name"];
            [dict setObject:[userObject objectForKey:@"avatar"] forKey:@"avatar"];
            [dict setObject:[userObject objectForKey:@"nick"] forKey:@"nick"];
            
            ChatViewController *chat = [[ChatViewController alloc] initWithUserDictionary:dict];
            chat.where = 1;//0，是从愿望进入。其他随意
            [self.navigationController pushViewController:chat animated:YES];
        }
            break;
        case 31:
        {
            
            //**第一次点击
            if (focus == 0) {
                
                //取消关注———关注
                UIButton *tempBtn=(id)[self.view viewWithTag:31];
                [tempBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu.png"] forState:UIControlStateNormal ];
                [tempBtn setBackgroundImage:[UIImage imageNamed:@"guanzhuselect.png"] forState: UIControlStateHighlighted];
                
                //关注建立一个关联关系
                //表名User,id为a1419df47a的BmobObject对象
                BmobUser *bUser = [BmobUser getCurrentObject];
                
                if (bUser) {
                    //查询自己关注的
                    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"RelationShip"];
                    [bquery includeKey:@"uid,fuid"];
                    [bquery whereKey:@"uid" equalTo:bUser.objectId];
                    //第一层查询
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if(!error){
                            for(BmobObject *obj in array){
                                BmobObject *followsObj = [obj objectForKey:@"fuid"];
                                //如果fuid与要删除的id相同,删除
                                if ([followsObj.objectId isEqualToString:_userId]) {
                                    //删除
                                    [bquery getObjectInBackgroundWithId:obj.objectId block:^(BmobObject *object, NSError *error){
                                        if (error) {
                                            //进行错误处理
                                            NSLog(@"没有成功");
                                        }
                                        else{
                                            if (object) {
                                                /**更新网络数据*/
                                                //设置status为1--取消关注
                                                [object setObject:[NSNumber numberWithInt:1] forKey:@"status"];
                                                //异步更新数据
                                                [object updateInBackground];
                                                
                                                /**更新数据库*/
                                                NSString *Ftype = [sqlStatusTool selectFriendstypeWithUid:_userId];
                                                if ([Ftype isEqualToString:@"0"]) {//朋友--粉丝
                                                    [sqlStatusTool updatesqlWithId:_userId friendsType:@"2"];
                                                }else if ([Ftype isEqualToString:@"1"]){//关注
                                                    [sqlStatusTool updatesqlWithId:_userId status:@"1"];
                                                }
                                            }
                                        }
                                    }];
                                }
                            }
                        }
                    }];
                    
                }
                focus = focus +1;
            }
            else{
                //第二次点击
                //还原原来的图片
                UIButton *tempBtn=(id)[self.view viewWithTag:31];
                [tempBtn setBackgroundImage:[UIImage imageNamed:@"quxiaoguanzhu.png"] forState:UIControlStateNormal];
                [tempBtn setBackgroundImage:[UIImage imageNamed:@"quxiaoguanzhuselect.png"] forState: UIControlStateHighlighted];
                //删除关联关系
                BmobUser *bUser1 = [BmobUser getCurrentObject];
                if (bUser1) {
                    
                    //查询自己关注的
                    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"RelationShip"];
                    [bquery includeKey:@"uid,fuid"];
                    [bquery whereKey:@"uid" equalTo:bUser1.objectId];
                    //第一层查询
                    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if(!error){
                            static int index = 0;
                            for(BmobObject *obj in array){
                                BmobObject *followsObj = [obj objectForKey:@"fuid"];
                                //  NSLog(@"id = %@,userId = %@, fuid = %@", bUser1.objectId,_userId, followsObj.objectId);
                                
                                //关系表中存在，则将status该为0
                                if ([followsObj.objectId isEqualToString:_userId]) {
                                    //
                                    [bquery getObjectInBackgroundWithId:obj.objectId block:^(BmobObject *object, NSError *error){
                                        if (error) {
                                            //进行错误处理
                                            NSLog(@"没有成功");
                                        }
                                        else{
                                            if (object) {
                                                NSLog(@"关注");
                                                //设置status为0--关注
                                                [object setObject:[NSNumber numberWithInt:0] forKey:@"status"];
                                                //异步更新数据
//                                                [object updateInBackground];
                                                
                                                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                                    
                                                    /**更新数据库*/
                                                    [sqlStatusTool updatesqlWithId:_userId status:@"0"];
                                                    NSString *Ftype = [sqlStatusTool selectFriendstypeWithUid:_userId];
                                                    if ([Ftype isEqualToString:@"2"]) {//朋友--粉丝
                                                        [sqlStatusTool updatesqlWithId:_userId friendsType:@"0"];
                                                    }else if ([Ftype isEqualToString:@"1"]){//关注
                                                        [sqlStatusTool updatesqlWithId:_userId status:@"0"];
                                                    }
                                                    //发送信息
                                                    NSString *nick = [[BmobUser getCurrentUser] objectForKey:@"nick"];
                                                    NSString *str = [NSString stringWithFormat:@"%@关注了你", nick];
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        [self sendMessageWithContent:str type:1];
                                                    });
                                                    
                                                    
                                                }];
                                               
                                            }
                                        }
                                        
                                    }];
                                    index ++;
                                    
                                }
                            }
                            if (index == 0) {//如果关系表中没有
                                //进行操作
                                //在GameScore创建一条数据，如果当前没GameScore表，则会创建GameScore表
                                BmobObject  *relationShip = [BmobObject objectWithClassName:@"RelationShip"];
                                //设置uid,fuid
                                
                                //关联user表中id为25fb9b4a61的对象
                                [relationShip setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:bUser1.objectId] forKey:@"uid"];
                                [relationShip setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_userId] forKey:@"fuid"];
                                [relationShip setObject:[NSNumber numberWithInt:0] forKey:@"status"];
                                //异步保存
                                //                                [relationShip saveInBackground];
                                
                                [relationShip saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    
                                    if (error) {
                                        NSLog(@"%@", error);
                                    }
                                    
                                    NSLog(@"关系表中没有");
                                    if (isSuccessful) {
                                        //数据库中保存
                                        NSString *time = [synFriends readSynchtime];
                                        [synFriends SynchFriendWithTime:time friends:@"follows" type:@"1"];
                                        [synFriends saveSynchtime];
                                        //发送信息
                                        NSString *nick = [[BmobUser getCurrentUser] objectForKey:@"nick"];
                                        NSString *str = [NSString stringWithFormat:@"%@关注了你", nick];
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self sendMessageWithContent:str type:1];

                                        });
                                    }
                                }];
                            }
                        }
                    }];
                    
                 }else{
                    //对象为空时，可打开用户注册界面
                }
                focus = focus -1;
            }
            
            //通知代理
            if ([self.delegete respondsToSelector:@selector(cancelFriend:)]) {
                [self.delegete cancelFriend:focus];
            }
        }
            
            
            
            break;
        case 32:
        {
            if (black == 0) {
                //弹框
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加入黑名单" message:@"加入黑名单，你将不再收到对方的消息，确定要继续吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 10;
                [alert show];
            }
            else
            {
                //弹框
                NSString *nameMessage = [NSString stringWithFormat:@"你确定把 %@ 移除黑名单吗？", _userName];
                
                
                
                UIAlertView *alertCancel = [[UIAlertView alloc]initWithTitle:@"移除黑名单" message:nameMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertCancel.tag = 11;
                [alertCancel show];
                
            }
        }
            
        default:
            break;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            NSLog(@"确定啊确定魂淡");
            
            //拉黑
            UIButton *tempBtn1=(id)[self.view viewWithTag:32];
            [tempBtn1 setImage:[UIImage imageNamed:@"quxiaolahei.png"] forState:UIControlStateNormal ];
            [tempBtn1 setImage:[UIImage imageNamed:@"quxiaolaheiselect.png"] forState: UIControlStateHighlighted];
            
            
            BmobUser *bUser1 = [BmobUser getCurrentObject];
            if (bUser1) {
                [isBlackTool laheiWithBlackId:_userId];
                black = black +1;
                
            }
            else{
                //对象为空时，可打开用户注册界面
            }
            
            
        }
        
    }else if (alertView.tag == 11)
    {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1)
        {
            UIButton *tempBtn1=(id)[self.view viewWithTag:32];
            [tempBtn1 setImage:[UIImage imageNamed:@"lahei.png"] forState:UIControlStateNormal ];
            [tempBtn1 setImage:[UIImage imageNamed:@"laheiselect.png"] forState: UIControlStateHighlighted];                //删除关联关系
            BmobUser *bUser1 = [BmobUser getCurrentObject];
            if (bUser1) {
                [isBlackTool cancelBlackListWithBlackId:_userId];
                
            }else{
                //对象为空时，可打开用户注册界面
            }
            black = black -1;
            
        }
        
    }
    
}

- (CGSize)sizeWithNsstring:(NSString *)str Font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


-(void)createUI{
    //1.底层的
    UIScrollView * sv;
    if(self.furcation == 1){
        
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
        
    }else{
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64 - 49)];
        [self setBottomBar];
    }
    sv.tag = 3000;
    sv.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    sv.contentSize = CGSizeMake(320, self.view.bounds.size.height - 64 - 49);
    sv.delegate =self;
    [self.view addSubview:sv];
    
    //2.最上方的图片
    CGFloat pictureHeight = 90 + 25;
    UIView * photoView = [[UIView alloc] init];
    photoView.backgroundColor = [UIColor whiteColor];
    photoArray = [[NSMutableArray alloc] init];
    
    [photoArray addObjectsFromArray:[userObject objectForKey:@"album"]];
    
    if(photoArray.count == 0){
        if([[userObject objectForKey:@"avatar"] isBlankString]){
            [photoArray addObject:[userObject objectForKey:@"avatar"]];
        }
    }
    
    [photoArray removeObject:@""];
    
    [photoArray removeObject:[NSNull null]];
    NSMutableArray *array = [NSMutableArray array];
    if(photoArray.count == 0){
        CGRect frame = CGRectMake(0, 0, 320, pictureHeight);
        
        photosView *photo = [[photosView alloc]init];
         if([[userObject objectForKey:@"avatar"] isBlankString]){
             [array addObject:[userObject objectForKey:@"avatar"]];
         }
        photo.picUrls = array;
        
        photoView.frame = frame;
        [photoView addSubview:photo];

    }
    
    for(int i = 0 ; i < photoArray.count ; i++){
        CGRect frame;
        if (i < 4) {
            pictureHeight = 90 + 25;
            frame = CGRectMake(0, 0, 320, pictureHeight);
        }else{
            pictureHeight = 170 + 25;
            frame = CGRectMake(0, 0, 320, pictureHeight);
        }
        
        photosView *pho = [[photosView alloc]init];
        pho.picUrls = photoArray;
        photoView.frame = frame;
        
        [photoView addSubview:pho];

    }
    
    UIView * photoLine = [[UIView alloc] initWithFrame:CGRectMake(0, pictureHeight - 25 - 0.5, 320, 0.5)];
    photoLine.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [photoView addSubview:photoLine];
    [sv addSubview:photoView];
    
    //***
    CGFloat lableHeight     = 25.0f;
    CGFloat lineHeight      = 0.5;
    CGFloat iconLableLeft   = 15;
    CGFloat iconLableWidth  = 9;
    CGFloat iconLableHeight = 10;
    
    //locationlable
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, pictureHeight -25, Main_Screen_Width, lableHeight)];
    lable.backgroundColor = [UIColor clearColor];
    [photoView addSubview:lable];
    //    NSLog(@"pictureHeight = %f, lable.frame = %@", pictureHeight, NSStringFromCGRect(lable.frame) );
    // 线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, lableHeight-lineHeight, Main_Screen_Width, lineHeight)];
    line2.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [lable addSubview:line2];
    //location小图标
    //    UILabel *iconLable = [[UILabel alloc] initWithFrame:CGRectMake(iconLableLeft, lableHeight/2-iconLableHeight/2, iconLableWidth, iconLableHeight)];
    //    iconLable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"juli.png"]];
    //    [lable addSubview:iconLable];
    
    UIImageView *imageLoca = [[UIImageView alloc] initWithFrame:CGRectMake(iconLableLeft, lableHeight/2-iconLableHeight/2, iconLableWidth, iconLableHeight)];
    [imageLoca setImage:[UIImage imageNamed:@"juli.png"]];
    [lable addSubview:imageLoca];
    //具体位置
    /*
     NSMutableArray * array = [NSMutableArray array];
     [array addObject:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude]];
     [array addObject:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude]];
     [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"location"];
     */
    
    BmobGeoPoint *point = [userObject objectForKey:@"location"];
    NSLog(@"latitude = %f, longitude = %f", point.latitude, point.longitude);
    
    BmobUser *user1 = [BmobUser getCurrentUser];
    BmobGeoPoint *point1 = [user1 objectForKey:@"location"];
    _latitude = point1.latitude;
    _longitude = point1.longitude;
    NSLog(@"latitude1 = %f, longitude1 = %f", point1.latitude, point1.longitude);

    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    
    //
    UILabel *locationLable = [[UILabel alloc] initWithFrame:CGRectMake(iconLableLeft*2+iconLableWidth, 0, 150, lableHeight)];
    locationLable.textColor =[UIcol hexStringToColor:@"#787878"];
    locationLable.font = [UIFont systemFontOfSize:13];
    
    [lable addSubview:locationLable];
    
    //距离几千米以及时间
    CGFloat distanceLableWidth = 80;
    UILabel * distanceLable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width-iconLableLeft-distanceLableWidth, 0, distanceLableWidth, lableHeight)];
    distanceLable.textColor =[UIcol hexStringToColor:@"#787878"];
    distanceLable.font = [UIFont systemFontOfSize:13];
    //比较距离
    CLLocation *loc1 = [[CLLocation alloc]initWithLatitude:point1.latitude longitude:point1.longitude];
    CLLocation *loc2 = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
    NSLog(@"loc1 = %@, loc2 = %@", loc1, loc2);
    
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2]/1000;
    NSString *disText = [NSString stringWithFormat:@"%.2fkm", distance];
    NSLog(@" distance = %f",distance);
    distanceLable.text = disText;
    //距离
    //    [lable addSubview:distanceLable];
    
    //***
    //115.661163,32.183773
    if (point.latitude && point.longitude) {
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
        [geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            
            
            CLPlacemark *pm = [placemarks firstObject];
            /*
             NSLog(@"pm.name = %@", pm);
             locationLable.text = pm.name;
             NSLog(@"locationText = %@",pm.name);//详细地址
             NSLog(@"thoroughfare = %@", pm.thoroughfare);//路
             NSLog(@"locality = %@", pm.locality);//二级地址
             NSLog(@"subLocality = %@", pm.subLocality);//三级地址
             NSLog(@"administrativeArea = %@", pm.administrativeArea);//一级地址
             */
            NSString *loca = [NSString stringWithFormat:@"%@ %@", pm.administrativeArea,pm.subLocality];
//            locationLable.text = loca;
            if ([self isBlankString:pm.administrativeArea]) {
                locationLable.text = loca;
            }else
            {
                locationLable.text = @"未知";
            }
        }];
    }else
    {
        locationLable.text = @"未知";
    }
    //***
    
    BmobObject *lastwishObj;
    BOOL sexBool;
    lastwishObj = [userObject objectForKey:@"lastWish"];
    sexBool = [[userObject objectForKey:@"sex"] boolValue];
    
    //我的愿望————数据
    //    BmobObject *person = [userObject objectForKey:@"lastWish"];
    // 愿望背景———view
    CGFloat LastWishViewHeight = (76 + 25) ;
    LastWishView = [[UIView alloc] initWithFrame:CGRectMake(0, photoView.bounds.size.height, Main_Screen_Width, LastWishViewHeight)];
    //    UIView *LastWishView = [[UIView alloc] init];
    //    LastWishView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"di.png"]];
    LastWishView.backgroundColor = [UIColor whiteColor];
    [sv addSubview:LastWishView];
    
    UIView *boomView = [[UIView alloc]initWithFrame:CGRectMake(0, 25, Main_Screen_Width, LastWishViewHeight - 25)];
    boomView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"di.png"]];
    [LastWishView addSubview:boomView];
    
    //区分男女
    NSString *sex;
    if (sexBool) {
        sex = @"男";
    }else sex = @"女";
    
    //头愿望label
    [userObject objectForKey:@"sex"];
    CGFloat headHeight = 25;
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, headHeight)];
    if ([sex isEqualToString:@"男"]) {
        lable1.text = @"  我的动态";
    }else if ([sex isEqualToString:@"女"]){
        lable1.text = @"  我的愿望";
    }
    
    lable1.font = [UIFont systemFontOfSize:13];
    lable1.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    lable1.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [LastWishView addSubview:lable1];
    
    //
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = boomView.frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(Actiondo:) forControlEvents:UIControlEventTouchUpInside];
    [LastWishView addSubview:btn];
    
    //头像
    NSString *urlStr =  [lastwishObj objectForKey:@"url"];
    CGFloat wishLeft = 25;
    CGFloat conLableHeight = 50;
    
    if([self isBlankString:urlStr]){
        CGFloat iconWidth = 40;
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(wishLeft, headHeight + (LastWishViewHeight - wishLeft- iconWidth) * 0.5, iconWidth, iconWidth)];
        iconView.layer.cornerRadius = 10;
        iconView.layer.masksToBounds = YES;
        NSURL *iconUrl = [NSURL URLWithString:urlStr];
        [iconView sd_setImageWithURL:iconUrl];
        [LastWishView addSubview:iconView];
        
    }
    
    //内容
    UILabel *wishContentlable = [[UILabel alloc]init];
    wishContentlable.textColor = [UIcol hexStringToColor:@"#787878"];
    wishContentlable.numberOfLines = 2;
    wishContentlable.backgroundColor = [UIColor clearColor];
    //        wishContentlable.text = [[userObject objectForKey:@"lastWish"] objectForKey:@"text"];
    NSString *text = [[userObject objectForKey:@"lastWish"] objectForKey:@"text"];
    text = [text smileTrans];
    NSDictionary *attrib = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    wishContentlable.attributedText = [text emoteStringWithAttrib:attrib];
    UIFont *contetfont = [UIFont systemFontOfSize:12];
    wishContentlable.font = contetfont;
    [LastWishView addSubview:wishContentlable];
    CGSize lableSize = [self sizeWithNsstring:text Font:contetfont maxSize:CGSizeMake(150, 30)];
    wishContentlable.frame = CGRectMake(wishLeft * 2 + 40, 25, lableSize.width, conLableHeight);
    
    LastWishView.frame = CGRectMake(0, photoView.bounds.size.height, Main_Screen_Width, LastWishViewHeight);
    
    
    //赞 评论 创建时间
    CGFloat countLableTop = 51 + 25;
    for (int i=0; i < 3; i++) {
        UILabel *countLable = [[UILabel alloc] init];
        countLable.textColor =[UIcol hexStringToColor:@"#bebebe"];
        countLable.font = [UIFont systemFontOfSize:11];
        countLable.tag = 10+i;
        
        [LastWishView addSubview:countLable];
        switch (countLable.tag) {
            case 10:
            {
                
                NSNumber *num = [lastwishObj objectForKey:@"like"];
                countLable.text = [NSString stringWithFormat:@"%@",num];
                countLable.frame = CGRectMake(99, countLableTop, 15, 15);
            }
                break;
            case 11:
            {
                NSNumber *num = [lastwishObj objectForKey:@"comment"];
                countLable.text = [NSString stringWithFormat:@"%@",num];
                countLable.frame = CGRectMake(165, countLableTop, 15, 15);
            }
                break;
            case 12:
            {
                
                NSDate *num = lastwishObj.createdAt;;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM月dd日"];
                NSString *strDate = [dateFormatter stringFromDate:num];
                
                
                countLable.text = [NSString stringWithFormat:@"%@",strDate];
                countLable.frame = CGRectMake(200, countLableTop, 100, 15);
            }
            default:
                break;
        }
        
    }
    
    //基本资料的数据
    NSMutableArray * basicsTitle = [NSMutableArray arrayWithArray:@[@"帮帮号",@"昵称",@"年龄",@"性别",@"星座"]];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:[userObject objectForKey:@"birthday"]];
    //    NSLog(@"birthday = %@", [userObject objectForKey:@"birthday"]);
    NSTimeInterval dateDiff = [d timeIntervalSinceNow];
    int age=trunc(dateDiff/(60*60*24))/365;
    NSString * star;
    if(d){
        star  = [constellation getAstroWithMonth:[[[NSString stringWithFormat:@"%@",d] substringWithRange:NSMakeRange(5, 2)] integerValue] day:[[[NSString stringWithFormat:@"%@",d] substringWithRange:NSMakeRange(8, 2)] integerValue]];
    }
    
    //区分男女
    if (sexBool) {
        sex = @"男";
    }else sex = @"女";
    
    NSMutableArray * basicsComment = [NSMutableArray arrayWithArray:@[[userObject objectForKey:@"bbID"],[userObject objectForKey:@"nick"],[NSString stringWithFormat:@"%d",-age], sex, star]];
    
    //    NSLog(@"userObject.institution = %@",[[userObject objectForKey:@"userInfo"] objectForKey:@"institution"]);
    int i = 1 ;
    [basicsTitle addObject:@"情感状态"];
    //    [dataArray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
    if(![[userObject objectForKey:@"available"]isEqualToString:@""] && [userObject objectForKey:@"available"] != nil){
        [basicsComment addObject:[userObject objectForKey:@"available"]];
    }else{
        [basicsComment addObject:@"保密"];
    }
    if(![[userObject objectForKey:@"school"]isEqualToString:@""] && [userObject objectForKey:@"school"]!= nil){
        [basicsTitle addObject:@"学校"];
        [basicsComment addObject:[userObject objectForKey:@"school"]];
        i++;
    }
    if(![[userObject objectForKey:@"job"]isEqualToString:@""]  && [userObject objectForKey:@"job"] != nil){
        [basicsTitle addObject:@"职业"];
        [basicsComment addObject:[userObject objectForKey:@"job"]];
        i++;
    }
    if(![[userObject objectForKey:@"hometown"]isEqualToString:@""]  && [userObject objectForKey:@"hometown"] != nil){
        [basicsTitle addObject:@"所在地"];
        [basicsComment addObject:[userObject objectForKey:@"hometown"]];
        i++;
    }
    //    UIView * basicsView  = [[UIView alloc] initWithFrame:CGRectMake(0,photoView.bounds.size.height, 320,226 + i * 50)];
    //基本资料
    UIView * basicsView  = [[UIView alloc] init];
    basicsView.backgroundColor = [UIColor whiteColor];
    [sv addSubview:basicsView];
    
    UILabel * basicsLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,Main_Screen_Width,25)];
    basicsLab.text = @"  基本资料";
    basicsLab.font = [UIFont systemFontOfSize:13];
    basicsLab.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    basicsLab.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [basicsView addSubview:basicsLab];
    
    CGFloat allBaseViewHeigth = 0;
    CGFloat tempHeigth = 50;
    for (int i = 0 ; i < basicsTitle.count ; i++) {
        
        //*********************************
        
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        label.text = basicsComment[i];
        UIFont *font = [UIFont systemFontOfSize:15];
        label.font = font;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:font forKey:NSFontAttributeName];
        CGSize size = [basicsComment[i] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        
        //        label.backgroundColor = [UIColor yellowColor];
        
        //        label.textColor = [UIcol hexStringToColor:@"787878"];
        label.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        
        [basicsView addSubview:label];
        
        //**********************************************
        
        if ((size.height + 17.5) > 50) {
            tempHeigth = size.height + 17.5;
            
        }else
        {
            tempHeigth = 50;
        }
        
        label.frame =CGRectMake(96, 25 + (tempHeigth - size.height) * 0.5 + allBaseViewHeigth, size.width, size.height);
        //title
        
        UILabel * userTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 25+ allBaseViewHeigth, 67,tempHeigth)];
        userTitle.text = basicsTitle[i];
        userTitle.textAlignment = NSTextAlignmentRight;
        //        userTitle.textColor = [UIcol hexStringToColor:@"2e2e2e"];
        userTitle.textColor = [UIcol hexStringToColor:@"#787878"];
        userTitle.font = [UIFont systemFontOfSize:15];
        [basicsView addSubview:userTitle];
        //********************************
        //        NSLog(@"size.height = %f", size.height);
        
        if(i != basicsTitle.count - 1){
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(81, tempHeigth, 220, 0.5)];
            line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
            [userTitle addSubview:line];
        }else{
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(-30, tempHeigth, 350, 0.5)];
            line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
            [userTitle addSubview:line];
        }
        allBaseViewHeigth = allBaseViewHeigth + tempHeigth;
    }
    
    
    basicsView.frame = CGRectMake(0, photoView.bounds.size.height + LastWishView.frame.size.height, Main_Screen_Width, 26 + allBaseViewHeigth);
    //    NSLog(@"size.height = %f, basicsView.frame = %@", allBaseViewHeigth ,NSStringFromCGRect(basicsView.frame));
    //********************************
    
    allBaseViewHeigth = 0;
    tempHeigth = 50;
    int j = 0;
    NSMutableArray * titarray = [[NSMutableArray alloc] init];
    NSMutableArray * comarray = [[NSMutableArray alloc] init];
    if(![[userObject objectForKey:@"dream"]isEqualToString:@""]  && [userObject objectForKey:@"dream"] != nil){
        j++;
        [titarray addObject:@"愿望"];
        [comarray addObject:[userObject objectForKey:@"dream"]];
    }
    if(![[userObject objectForKey:@"declaration"]isEqualToString:@""]  && [userObject objectForKey:@"declaration"] != nil){
        j++;
        [titarray addObject:@"愿望宣言"];
        [comarray addObject:[userObject objectForKey:@"declaration"]];
    }
    
    UIView * wishView;
    if(j != 0){
        wishView = [[UIView alloc] init];
        wishView.backgroundColor = [UIColor whiteColor];
        UILabel * wishLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,25)];
        wishLab.text = @"  愿望与梦想";
        wishLab.backgroundColor = [UIcol hexStringToColor:@"f2f2f2"];
        wishLab.font = [UIFont systemFontOfSize:13];
        wishLab.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
        wishLab.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
        [wishView addSubview:wishLab];
        
        for ( int k = 0; k < j; k++) {
            
            //************************
            
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 0;
            
            label.lineBreakMode = NSLineBreakByWordWrapping;
            
            label.text = comarray[k];
            
            UIFont *font = [UIFont systemFontOfSize:15];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:font forKey:NSFontAttributeName];
            CGSize size = [comarray[k] boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            //            CGSize size = [label sizeThatFits:CGSizeMake(200, MAXFLOAT)];
            
            //            label.textColor = [UIcol hexStringToColor:@"787878"];
            //颜色对调一下
            label.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
            label.font = [UIFont systemFontOfSize:15];
            
            [wishView addSubview:label];
            
            //************************
            if ((size.height + 17.5) > 50) {
                tempHeigth = size.height + 17.5;
                
            }else
            {
                tempHeigth = 50;
            }
            
            label.frame =CGRectMake(96, 25 + (tempHeigth - size.height) * 0.5 + allBaseViewHeigth, size.width, size.height);
            //15, 25+ allBaseViewHeigth, 67,tempHeigth
            UILabel * userTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 + allBaseViewHeigth, 67,tempHeigth)];
            userTitle.text = titarray[k];
            userTitle.textAlignment = NSTextAlignmentRight;
            //            userTitle.textColor = [UIcol hexStringToColor:@"2e2e2e"];
            userTitle.textColor = [UIcol hexStringToColor:@"#787878"];
            userTitle.font = [UIFont systemFontOfSize:15];
            [wishView addSubview:userTitle];
            
            UIView * line;
            if(j - 1 != k){
                line = [[UIView alloc] initWithFrame:CGRectMake(81, tempHeigth - 0.5,self.view.bounds.size.width,0.5)];
            }else{
                line = [[UIView alloc] initWithFrame:CGRectMake(-30,tempHeigth,self.view.bounds.size.width + 30,0.5)];
            }
            line.backgroundColor = [UIcol hexStringToColor:@"e6e6e6"];
            
            [userTitle addSubview:line];
            allBaseViewHeigth = allBaseViewHeigth + tempHeigth;
        }
        
        wishView.frame = CGRectMake(0, photoView.bounds.size.height + LastWishView.bounds.size.height +basicsView.bounds.size.height, self.view.bounds.size.width, allBaseViewHeigth + 25);
        
        [sv addSubview:wishView];
    }
    
    sv.contentSize = CGSizeMake(320,photoView.bounds.size.height + LastWishView.bounds.size.height + basicsView.bounds.size.height + wishView.bounds.size.height);
    
}



-(void)createNarBar{
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
    
    if(self.furcation == 1){
        
        UIButton * publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(276, 0, 44, 44)];
        [publishBtn addTarget:self action:@selector(editData) forControlEvents:UIControlEventTouchUpInside];
        UILabel * publishLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        publishLab.text = @"编辑";
        publishLab.textColor = [UIColor whiteColor];
        [publishBtn addSubview:publishLab];
        [iv addSubview:publishBtn];
        
    }
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.text = self.userName;
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
    
}

-(void)editData{
    
    EditDataViewController * edvc = [[EditDataViewController alloc] init];
    [self.navigationController pushViewController:edvc animated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Actiondo:(id)sender{
    
    LastWishView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    
    MyWishViewController *myWish = [[MyWishViewController alloc]init];
    myWish.userId = _userId;
    myWish.userName = self.userName;
    [self.navigationController pushViewController:myWish animated:YES];
}

- (BOOL )isBlankString:(NSString *)string{
    
    BOOL flag = YES;
    
    if (string == nil) {
        
        flag = NO;
        
    }
    
    if (string == NULL) {
        flag = NO;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        flag = NO;
        
    }
    
    return flag;
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
