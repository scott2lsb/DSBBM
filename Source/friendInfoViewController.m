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

@interface friendInfoViewController ()<UIAlertViewDelegate>

@end

@implementation friendInfoViewController
{
    BmobObject * userObject;
    BmobObject *personObject;
    //底部图片数组
    NSMutableArray *arr;
    
    //关注点击次数
    int focus;
    //拉黑点击次数
    NSInteger *black;
    
    UIView *LastWishView;
    //关系中的ID
    NSString *relationId;
    //是否是朋友
    BOOL isfriend;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LastWishView.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arr =[[NSMutableArray alloc] initWithObjects:@"siliao.png",@"quxiaoguanzhu.png",@"lahei.png", nil];
    [self createNarBar];
    [self getDate];
    isfriend = NO;
}


-(void)getDate
{
    BmobQuery * userQuery = [BmobQuery queryForUser];
    [userQuery includeKey:@"userInfo,lastWish"];
    [userQuery getObjectInBackgroundWithId:self.userId block:^(BmobObject *object, NSError *error) {
        if(!error){
            userObject = object;
//            userObject = [object objectForKey:@"userInfo"];
            
            [self createUI];
        }
    }];
    
    
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
    
    for (friendModel *model in _allFollows) {
        if ([model.userId isEqualToString:_userId]) {
            isfriend = YES;
        }
    }
    
    if (isfriend == NO) {
        UIButton *tempBtn= (id)[self.view viewWithTag:31];
        //                        tempBtn.backgroundColor =
        [tempBtn setImage:[UIImage imageNamed:@"guanzhu.png"] forState:UIControlStateNormal ];
        [tempBtn setImage:[UIImage imageNamed:@"guanzhuselect.png"] forState: UIControlStateHighlighted];
        focus += 1;
    }
    
    NSArray *aaa =  [sqlStatusTool readFromSqlite:nil];
    NSLog(@"aaa  %d", aaa.count);
    
    

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
            [self presentViewController:chat animated:YES completion:^{
                
            }];
        }
            break;
        case 31:
        {

            //**第一次点击
            if (focus == 0) {
                
                //点击之后先将图片改称"取消关注"
                UIButton *tempBtn=(id)[self.view viewWithTag:31];
                [tempBtn setImage:[UIImage imageNamed:@"guanzhu.png"] forState:UIControlStateNormal ];
                [tempBtn setImage:[UIImage imageNamed:@"guanzhuselect.png"] forState: UIControlStateHighlighted];

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
                                NSLog(@"id = %@,userId = %@, fuid = %@", bUser.objectId,_userId, followsObj.objectId);
                                //如果fuid与要删除的id相同,删除
                                if ([followsObj.objectId isEqualToString:_userId]) {
                                    NSLog(@"zhejiu删除");
                                    //删除
                                    [bquery getObjectInBackgroundWithId:obj.objectId block:^(BmobObject *object, NSError *error){
                                        NSLog(@"第二层");
                                        if (error) {
                                            //进行错误处理
                                            NSLog(@"没有成功");
                                        }
                                        else{
                                            if (object) {
                                                
//                                                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                                                //设置cheatMode为YES
                                                [object setObject:[NSNumber numberWithInt:1] forKey:@"status"];
                                                //异步更新数据
                                                [object updateInBackground];
                                                
                                                /*
                                                //异步删除object
                                                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                                                //设置cheatMode为YES
                                                [obj1 setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
                                                //异步更新数据
                                                [obj1 updateInBackground];
                                                 */
                                                
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
                [tempBtn setImage:[UIImage imageNamed:@"quxiaoguanzhu.png"] forState:UIControlStateNormal ];
                [tempBtn setImage:[UIImage imageNamed:@"quxiaoguanzhuselect.png"] forState: UIControlStateHighlighted];
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
                            for(BmobObject *obj in array){
                                BmobObject *followsObj = [obj objectForKey:@"fuid"];
                                NSLog(@"id = %@,userId = %@, fuid = %@", bUser1.objectId,_userId, followsObj.objectId);
                                
                                //关系表中存在，则将status该为0
                                if ([followsObj.objectId isEqualToString:_userId]) {
                                    //删除
                                    [bquery getObjectInBackgroundWithId:obj.objectId block:^(BmobObject *object, NSError *error){
                                        if (error) {
                                            //进行错误处理
                                            NSLog(@"没有成功");
                                        }
                                        else{
                                            if (object) {
                                             
                                                [object setObject:[NSNumber numberWithInt:0] forKey:@"status"];
                                                //异步更新数据
                                                [object updateInBackground];
                                            }
                                        }
                                    }];
                                    
                                    
                                }else//如果关系表中没有
                                {
                                    //进行操作
                                    //在GameScore创建一条数据，如果当前没GameScore表，则会创建GameScore表
                                    BmobObject  *relationShip = [BmobObject objectWithClassName:@"RelationShip"];
                                    //设置uid,fuid
                                    
                                    //关联user表中id为25fb9b4a61的对象
                                    [relationShip setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:bUser1.objectId] forKey:@"uid"];
                                    [relationShip setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_userId] forKey:@"fuid"];
                                    //异步保存
                                    [relationShip saveInBackground];
                                }
                                
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
                //新建relation对象
                BmobRelation *relation = [[BmobRelation alloc] init];
                //relation添加id为27bb999834的用户
                [relation addObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_userId]];
                //obj 添加关联关系到likes列中
                [bUser1 addRelation:relation forKey:@"blacklist"];
                //异步更新obj的数据
                [bUser1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    NSLog(@"error %@",[error description]);
                    if (isSuccessful) {
                        NSLog(@"拉黑成功");
                    }
                }];
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
                //进行操作
                //新建relation对象
                BmobRelation *relation = [[BmobRelation alloc] init];
                //relation要移除id为27bb999834的用户
                [relation removeObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_userId]];
                //obj 更新关联关系到likes列中
                [bUser1 addRelation:relation forKey:@"blacklist"];
                [bUser1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    NSLog(@"error %@",[error description]);
                    if (isSuccessful) {
                        NSLog(@"取消拉黑成功");
                    }
                }];
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
    UIView * photoView = [[UIView alloc] init];
    photoView.backgroundColor = [UIColor whiteColor];
    NSMutableArray * photoArray = [[userObject objectForKey:@"userInfo"] objectForKey:@"personalAlbum"];
    if(photoArray.count == 0){
        [photoArray addObject:[userObject objectForKey:@"avatar"]];
    }
    [photoArray removeObject:@""];
    [photoArray removeObject:[NSNull null]];
    if(photoArray.count == 0){
        UIImageView * avatar = [[UIImageView alloc] init];
        photoView.frame = CGRectMake(0, 0, 320, 90);
        avatar.frame  = CGRectMake(9.5, 10, 70, 70);
        NSURL * imageimu = [NSURL URLWithString:[userObject objectForKey:@"avatar"]];
        avatar.layer.cornerRadius = 6;
        avatar.layer.masksToBounds = YES;
        [avatar sd_setImageWithURL:imageimu];
        [photoView addSubview:avatar];
    }
    for(int i = 0 ; i < photoArray.count ; i++){
        UIImageView * avatar = [[UIImageView alloc] init];
        if(i < 4){
            photoView.frame = CGRectMake(0, 0, 320, 90);
            avatar.frame  = CGRectMake(9.5 + i * 77, 10, 70, 70);
        }else{
            photoView.frame =CGRectMake(0, 0, 320, 170);
            avatar.frame  = CGRectMake(9.5 + (i - 4) * 77, 90, 70, 70);
        }
        NSURL * imageimu = [NSURL URLWithString:photoArray[i]];
        avatar.layer.cornerRadius = 6;
        avatar.layer.masksToBounds = YES;
        [avatar sd_setImageWithURL:imageimu];
        [photoView addSubview:avatar];
    }
    UIView * photoLine = [[UIView alloc] initWithFrame:CGRectMake(0, photoView.bounds.size.height - 0.5, 320, 0.5)];
    photoLine.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [photoView addSubview:photoLine];
    [sv addSubview:photoView];
   
    
    
    
    if (_furcation != 1) {
        
        //我的愿望————数据
        //    BmobObject *person = [userObject objectForKey:@"lastWish"];
        // 愿望背景———view
        CGFloat LastWishViewHeight = (76 + 25) ;
        LastWishView = [[UIView alloc] initWithFrame:CGRectMake(0, photoView.bounds.size.height, Main_Screen_Width, LastWishViewHeight)];
        //    UIView *LastWishView = [[UIView alloc] init];
        //    LastWishView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"di.png"]];
        LastWishView.backgroundColor = [UIColor whiteColor];
        [sv addSubview:LastWishView];
        BmobObject *lastwishObj = [userObject objectForKey:@"lastWish"];
        
        UIView *boomView = [[UIView alloc]initWithFrame:CGRectMake(0, 25, Main_Screen_Width, LastWishViewHeight - 25)];
        boomView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"di.png"]];
        [LastWishView addSubview:boomView];

        //头愿望label
        CGFloat headHeight = 25;
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, headHeight)];
        lable1.text = @"  我的愿望";
        lable1.font = [UIFont systemFontOfSize:11];
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
        CGFloat lableHeight = 50;
        CGFloat iconWidth = 40;
        CGFloat whiteHeight = 76;
        if([self isBlankString:urlStr]){
            
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(wishLeft, headHeight + (LastWishViewHeight - wishLeft- iconWidth) * 0.5, iconWidth, iconWidth)];
            iconView.layer.cornerRadius = 10;
            iconView.layer.masksToBounds = YES;
            NSURL *iconUrl = [NSURL URLWithString:urlStr];
            [iconView sd_setImageWithURL:iconUrl];
            [LastWishView addSubview:iconView];
            
        }else{
            iconWidth = 0;
        }
        
        //内容
        UILabel *wishContentlable = [[UILabel alloc]init];
        wishContentlable.textColor = [UIcol hexStringToColor:@"787878"];
        wishContentlable.numberOfLines = 2;
        wishContentlable.backgroundColor = [UIColor clearColor];
        wishContentlable.text = [[userObject objectForKey:@"lastWish"] objectForKey:@"text"];
        UIFont *contetfont = [UIFont systemFontOfSize:12];
        wishContentlable.font = contetfont;
        [LastWishView addSubview:wishContentlable];
        
        CGSize lableSize = [self sizeWithNsstring:wishContentlable.text Font:contetfont maxSize:CGSizeMake(150, 30)];
        wishContentlable.frame = CGRectMake(wishLeft * 2 + iconWidth, 25, lableSize.width, lableHeight);
        
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
                    countLable.frame = CGRectMake(140, countLableTop, 15, 15);
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

    }
    
    
    
    //基本资料的数据
    NSMutableArray * basicsTitle = [NSMutableArray arrayWithArray:@[@"帮帮号",@"昵称",@"年龄",@"星座"]];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:[userObject objectForKey:@"birthday"]];
    NSLog(@"birthday = %@", [userObject objectForKey:@"birthday"]);
    NSTimeInterval dateDiff = [d timeIntervalSinceNow];
    int age=trunc(dateDiff/(60*60*24))/365;
    
    NSString * star = [constellation getAstroWithMonth:[[[NSString stringWithFormat:@"%@",d] substringWithRange:NSMakeRange(5, 2)] integerValue] day:[[[NSString stringWithFormat:@"%@",d] substringWithRange:NSMakeRange(8, 2)] integerValue]];
    
    NSMutableArray * basicsComment = [NSMutableArray arrayWithArray:@[[userObject objectForKey:@"username"],[userObject objectForKey:@"nick"],[NSString stringWithFormat:@"%d",-age],star]];
    
    NSLog(@"userObject.institution = %@",[[userObject objectForKey:@"userInfo"] objectForKey:@"institution"]);
    int i = 1 ;
    [basicsTitle addObject:@"情感状态"];
    //    [dataArray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
    if(![[[userObject objectForKey:@"userInfo"] objectForKey:@"isAvailable"]isEqualToString:@""] && [[userObject objectForKey:@"userInfo"] objectForKey:@"isAvailable"] != nil){
        [basicsComment addObject:[[userObject objectForKey:@"userInfo"] objectForKey:@"isAvailable"]];
    }else{
        [basicsComment addObject:@"保密"];
    }
    if(![[[userObject objectForKey:@"userInfo"] objectForKey:@"institution"]isEqualToString:@""] && [[userObject objectForKey:@"userInfo"] objectForKey:@"institution"] != nil){
        NSLog(@"%@",[[userObject objectForKey:@"userInfo"] objectForKey:@"institution"]);
        [basicsTitle addObject:@"学校"];
        [basicsComment addObject:[[userObject objectForKey:@"userInfo"] objectForKey:@"institution"]];
        i++;
    }
    if(![[[userObject objectForKey:@"userInfo"] objectForKey:@"career"]isEqualToString:@""]  && [[userObject objectForKey:@"userInfo"] objectForKey:@"career"] != nil){
        [basicsTitle addObject:@"职业"];
        [basicsComment addObject:[[userObject objectForKey:@"userInfo"] objectForKey:@"career"]];
        i++;
    }
    if(![[[userObject objectForKey:@"userInfo"] objectForKey:@"hometown"]isEqualToString:@""]  && [[userObject objectForKey:@"userInfo"] objectForKey:@"hometown"] != nil){
        [basicsTitle addObject:@"所在地"];
        [basicsComment addObject:[[userObject objectForKey:@"userInfo"] objectForKey:@"hometown"]];
        i++;
    }
//    UIView * basicsView  = [[UIView alloc] initWithFrame:CGRectMake(0,photoView.bounds.size.height, 320,226 + i * 50)];
    //基本资料
    UIView * basicsView  = [[UIView alloc] init];
    basicsView.backgroundColor = [UIColor whiteColor];
    [sv addSubview:basicsView];
    
    UILabel * basicsLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,Main_Screen_Width,25)];
    basicsLab.text = @"  基本资料";
    basicsLab.font = [UIFont systemFontOfSize:11];
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
        
        label.textColor = [UIcol hexStringToColor:@"787878"];
        
        [basicsView addSubview:label];

        //********************************
        
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
        userTitle.textColor = [UIcol hexStringToColor:@"2e2e2e"];
        userTitle.font = [UIFont systemFontOfSize:13];
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
    if(![[[userObject objectForKey:@"userInfo"] objectForKey:@"dream"]isEqualToString:@""]  && [[userObject objectForKey:@"userInfo"] objectForKey:@"dream"] != nil){
        j++;
        [titarray addObject:@"愿望"];
        [comarray addObject:[[userObject objectForKey:@"userInfo"] objectForKey:@"dream"]];
    }
    if(![[[userObject objectForKey:@"userInfo"] objectForKey:@"wishDeclaration"]isEqualToString:@""]  && [[userObject objectForKey:@"userInfo"] objectForKey:@"wishDeclaration"] != nil){
        j++;
        [titarray addObject:@"愿望宣言"];
        [comarray addObject:[[userObject objectForKey:@"userInfo"] objectForKey:@"wishDeclaration"]];
    }
    
    UIView * wishView;
    if(j != 0){
        wishView = [[UIView alloc] init];
        wishView.backgroundColor = [UIColor whiteColor];
        UILabel * wishLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,25)];
        wishLab.text = @"  愿望与梦想";
        wishLab.backgroundColor = [UIcol hexStringToColor:@"f2f2f2"];
        wishLab.font = [UIFont systemFontOfSize:11];
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
            
            label.textColor = [UIcol hexStringToColor:@"787878"];
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
            userTitle.textColor = [UIcol hexStringToColor:@"2e2e2e"];
            userTitle.font = [UIFont systemFontOfSize:13];
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
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
    
}

-(void)editData{
    
    EditDataViewController * edvc = [[EditDataViewController alloc] init];
    edvc.userObject = userObject;
    [self.navigationController pushViewController:edvc animated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Actiondo:(id)sender{
    
    LastWishView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    
    MyWishViewController *myWish = [[MyWishViewController alloc]init];
    myWish.userId = _userId;
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
