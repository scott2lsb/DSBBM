//
//  friendDatumViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-3.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "friendDatumViewController.h"
#define backBtnWidth 20.0f
#define backBtnHeight 16.5f
//自定义导航imageView的高
#define barViewHeight 44.0f
//屏幕宽度
#define Main_Screen_Width   320
//屏幕高度
#define Main_Screen_Height  480
//用户名字大小
#define nameLableWidth 100.0f
#define nameLableHeight 30.0f
//相册大小边距
#define photoImageViewWidth 67.0f
#define photoImageViewHeight 67.0f
#define photoImageViewLeft 14.0f
#define photoImageViewTop 10.0f
//粉色条的边距
#define pinkLableHeight 23.0f
//基本资料lable边距大小
#define pinkSmallLableLeft 9.0f
//第二个lable的高度
#define secondLableHeight 102.0f
//第二个lable的头像的大小
#define userImageViewWidth 70.0f
//第二个lable的头像的边距
#define userImageViewLeft 20.0f
//详细资料lable高度
#define personLableHeight 40.0f
//小的lable的大小
#define smallPersonLableWidth 55.0f
//底部按钮高度
#define bottomBtnWidth 96.0f
#define bottomBtnHeight 30.0f
//
#define textLableLeft 15.0f
//返回按钮
#define baackBtnHeight 18.0f
#define baackBtnWidth 12.0f
#define baackBtnLeft 9.0f
#define baackBtnTop  13.0f
//
#define scro_View_Height 416.0f
#define photoViewHeight 161.0f
#define btnHeight 40.0f
#define lineHeight 1.0f
//
#define lableHeight 25.0f
//
#define iconLableLeft 15.0f
#define iconLableWidth 9.0f
#define iconLableHeight 10.0f
#define distanceLableWidth 80.0f
//view高度
#define view1Height 58.0f
#define view2Height 76.0f
//中间所有按钮的左边距
#define btnLeft 13.0f
#define btnHeight 40.0f
//lable的高度
#define lable1Height 27.0f
#define lable2Height 9.0f
//线高度
#define lineHeight 1.0f
//愿望头像左边距以及上边距
#define wishImageViewLeft 25.0f
#define wishImageViewtop 18.0f
//愿望lable上边距
#define wishLableTop 14.0f
#define wishLableWidth 150.0f
#define wishLableHeight 30.0f
//箭头
#define jianViewHeight 15.0f
#define jianViewWidth 10.0f
#define jianViewLeft 288.0f
//赞上边距
#define countLableTop 51.0f
#define headPhotoImageViewWidth 45.0f
#define btnBackViewHeight 49.0f

@implementation friendDatumViewController
{
    UIView *backgroundView;
    UIImageView *btnImageView;
    UIView *barView;
    UIImageView *barImageView;
    //
    UITableView *_tableView;
    //第二个lable
    UILabel *secondLable;
    UIScrollView *scrollView;
    UIButton *bottomBtn;
    //底部按钮
    UIImageView *btnImageView1;
    //存放
    NSMutableArray *arr;
    //数据源
    NSMutableArray *_dataArray;
    //数组存放数据
    NSMutableArray *array1;
    NSMutableArray *array2;
    //button被点击次数
    NSInteger *_a;
    //用户头像
    UIImage *image1;
    //定义一个数组接一下拿到的照片数组
    NSMutableArray * tempArray;
    //
    UIImageView *photoImageView1;
    UIImageView *photoImageView2;
    //相册的数组
    NSMutableArray *fourArray;
    NSMutableArray *fourLaterArray;
    UIButton* jianBtn;
    UIImageView* wishImageView ;
    UILabel*wishLable;
    UILabel*countLable;
    UILabel*personLable;
    UILabel*personLables;
    UILabel*tempLable;
    UILabel *distanceLable;
    UIButton *bottomBtn1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//除去电量条的背景view及滚动视图
-(void)creatBackgroundView
{
    backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0, 20, 320, 460);
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, barViewHeight,Main_Screen_Width , scro_View_Height
                                  );
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.contentSize = CGSizeMake(0,  scro_View_Height*2);
    scrollView.userInteractionEnabled = YES;
    [backgroundView addSubview:scrollView];
    
    barView = [[UIView alloc] init];
    barView.frame = CGRectMake(0, 20, Main_Screen_Width , barViewHeight);
    barView.backgroundColor = [UIcol hexStringToColor:@"#fad219"];
    barView.userInteractionEnabled = YES;
    [self.view addSubview:barView];
    
    //菜单按钮
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(baackBtnLeft, barViewHeight/2-baackBtnHeight/2 ,baackBtnWidth,baackBtnHeight);
    backBtn.userInteractionEnabled = YES;
    [backBtn addTarget:self action:@selector(btnClick:)forControlEvents: UIControlEventTouchUpInside];
    backBtn.tag = 1000+1;
    backBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fanhui.png"]];
    [barView addSubview:backBtn];

    //传值name
    UILabel *lable = [[UILabel alloc] init];
    lable.frame= CGRectMake(barView.frame.size.width/2-nameLableWidth/2,barViewHeight/2-nameLableHeight/2, nameLableWidth, nameLableHeight);
    lable.backgroundColor = [UIColor clearColor];
    lable.text = _nextTitle;
    lable.textAlignment =  NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [barView addSubview:lable];

    
}

- (void)viewDidLoad
{
    //背景色
    self.view.backgroundColor = [UIColor blackColor];
    arr =[[NSMutableArray alloc] initWithObjects:@"siliao.png",@"quxiaoguanzhu.png",@"lahei.png", nil];
    _dataArray = [[NSMutableArray alloc] init];
    tempArray = [[NSMutableArray alloc] init];
    //_a初始值
    _a = 0;
    [super viewDidLoad];
    [self creatBackgroundView];
    [self getData];
}

//点击事件
-(void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1001:
            //回到menu
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
            case 30:
        {
            //聊天
            ChatViewController *chat = [[ChatViewController alloc] init];
            chat.where =1;
            [self presentViewController:chat animated:YES completion:^{
                
            }];
        }
            break;
        case 31:
        {

            //**第一次点击
            if (_a == 0) {
                //点击之后先将图片改称"取消关注"
                UIButton *tempBtn=(id)[self.view viewWithTag:31];
                [tempBtn setImage:[UIImage imageNamed:@"quxiaoguanzhu.png"] forState:UIControlStateNormal ];
                [tempBtn setImage:[UIImage imageNamed:@"quxiaoguanzhuselect.png"] forState: UIControlStateHighlighted];
                //关注建立一个关联关系
                //表名User,id为a1419df47a的BmobObject对象
                BmobUser *bUser = [BmobUser getCurrentObject];
                if (bUser) {
                    //新建relation对象
                    BmobRelation *relation = [[BmobRelation alloc] init];
                    //relation添加id为当前用户的用户
                    [relation addObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_tempIdStr]];
                    //obj 添加关联关系到likes列中
                    [bUser addRelation:relation forKey:@"follows"];
                    //异步更新obj的数据
                    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        NSLog(@"error %@",[error description]);
                        if (isSuccessful) {
                            NSLog(@"关注成功");
                        }
                        else
                        {
                            NSLog(@"关注失败");
                        }
                    }];
                    
                }else{
                    //对象为空时，可打开用户注册界面
                }
                _a = _a +1;
            }
            else{
                //第二次点击
                //还原原来的图片
                UIButton *tempBtn=(id)[self.view viewWithTag:31];
                [tempBtn setImage:[UIImage imageNamed:@"guanzhu.png"] forState:UIControlStateNormal ];
                [tempBtn setImage:[UIImage imageNamed:@"guanzhuselect.png"] forState: UIControlStateHighlighted];
                //删除关联关系
                BmobUser *bUser1 = [BmobUser getCurrentObject];
                if (bUser1) {
                    //进行操作
                    //新建relation对象
                    BmobRelation *relation = [[BmobRelation alloc] init];
                    //relation要移除id为27bb999834的用户
                    [relation removeObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_tempIdStr]];
                    //obj 更新关联关系到likes列中
                    [bUser1 addRelation:relation forKey:@"likes"];
                    [bUser1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        NSLog(@"error %@",[error description]);
                        if (isSuccessful) {
                            NSLog(@"取消关注成功");
                        }
                    }];
                }else{
                    //对象为空时，可打开用户注册界面
                }
                _a = _a -1;
            }
            

        }
            break;
            case 32:
        {
            //拉黑
           UIButton *tempBtn1=(id)[self.view viewWithTag:32];
            [tempBtn1 setImage:[UIImage imageNamed:@"quxiaolahei.png"] forState:UIControlStateNormal ];
            [tempBtn1 setImage:[UIImage imageNamed:@"quxiaolaheiselect.png"] forState: UIControlStateHighlighted];
            if (_a == 0) {
            BmobUser *bUser1 = [BmobUser getCurrentObject];
            if (bUser1) {
            //新建relation对象
            BmobRelation *relation = [[BmobRelation alloc] init];
            //relation添加id为27bb999834的用户
            [relation addObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_tempIdStr]];
            //obj 添加关联关系到likes列中
            [bUser1 addRelation:relation forKey:@"blacklist"];
            //异步更新obj的数据
            [bUser1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                NSLog(@"error %@",[error description]);
                if (isSuccessful) {
                    NSLog(@"拉黑成功");
                }
            }];
            
        }
            else{
                //对象为空时，可打开用户注册界面
            }
                _a = _a +1;
            }
            else
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
                    [relation removeObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:_tempIdStr]];
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
                _a = _a -1;
            }
        }
    
        default:
            break;
    }
}

//数据
-(void)getData
{
    BmobQuery * bq = [BmobQuery queryForUser];
    [bq includeKey:@"userInfo"];
    [bq getObjectInBackgroundWithId:_tempIdStr block:^(BmobObject *object, NSError *error) {
        BmobObject * n = [object objectForKey:@"userInfo"];
        friendModel *model = [[friendModel alloc] init];
        model.personBbNumber =[object  objectForKey:@"username"];
        model.personAge = [object  objectForKey:@"birthday"];
        model.userUrl = [object  objectForKey:@"avatar"];
        //计算时间
        model.UserupDateAt = [mistiming returnUploadTime:[object objectForKey:@"updatedAt"]];
        //计算location的距离
        BmobGeoPoint * point = [object objectForKey:@"location"];
       // NSString*string = [model.UserupDateAt stringByAppendingString:@"|"];
        CLLocationManager * locManager = [[CLLocationManager alloc] init];
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locManager startUpdatingLocation];
        locManager.distanceFilter = 1000.0f;
        //第一个坐标
        CLLocation *current=[[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:locManager.location.coordinate.latitude longitude:locManager.location.coordinate.longitude];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
         model.UserLocation = [NSString stringWithFormat:@"%.2fkm",meters/1000];
        //NSString *srting2 = [str1 stringByAppendingString:@"|"];
         image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.userUrl]]];
        model.personMarriage = [n  objectForKey:@"isAvailable"];
        model.personSchool = [n  objectForKey:@"institution"];
        model.personTopic = [n  objectForKey:@"topic"];
        model.personCareer = [n  objectForKey:@"career"];
        model.personHometown = [n objectForKey:@"hometown"];
        tempArray= [n objectForKey:@"personalAlbum"];
        model.personWishDeclaration = [n  objectForKey:@"wishDeclaration"];
        model.personDreamDeclaration = [n objectForKey:@"dreamDeclaration"];
        [_dataArray addObject:model];
        [self creatUI];
    }];
}
//创建UI
-(void)creatUI
{
    
    
    friendModel *tempModel = [_dataArray lastObject];
    
    NSString *ageStr = [mistiming returnUploadTime:tempModel.personAge];
    NSString *bbIdStr =tempModel.personBbNumber;
    NSString *merriageStr = tempModel.personMarriage;
    NSString *nameStr = _nextTitle;
    NSString *wish = _tempStr;
    NSString *zans = _zan;
    NSString *pingluns = _pinglun;
    NSString *gengxins = _update;
    NSString *distanceStr = tempModel.UserLocation;
    //放到一个数组
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithObjects:zans,pingluns,@"2014-5-5", nil];
    NSString *schoolStr  =tempModel.personSchool;
    //NSString *topicStr  = tempModel.personTopic;
    NSArray *array = [tempModel.personAge componentsSeparatedByString:@"-"];
    NSString*str1 = [array objectAtIndex:1];
    NSString*str2 = [array objectAtIndex:2];
    NSString *conStr = [constellation getAstroWithMonth:[str1 intValue] day:[str2 intValue]];
    NSString*hometownStr = tempModel.personHometown;
    NSString *careerStr= tempModel.personCareer;
    NSString *wishDeStr = tempModel.personWishDeclaration;
    NSString *dreamDeStr = tempModel.personDreamDeclaration;
    //相册背景
    UIView*photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Main_Screen_Width , photoViewHeight)];
    photoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:photoView];
    //拆分成两个数组
    fourArray = [[NSMutableArray alloc] init];
    fourLaterArray  =[[NSMutableArray alloc] init];
    for (int i = 0; i < tempArray.count; i ++) {
        if (i < 4) {
            [fourArray addObject:[tempArray objectAtIndex:i]];
        }
        else
        {
            [fourLaterArray addObject:[tempArray objectAtIndex:i]];
        }
    }
    
    //如果照片数量小于等于4
    if (tempArray.count <=4)
    {
        for (int i = 0; i < tempArray.count; i ++)
        {
            _photoImageView = [[UIImageView alloc] init];
            _photoImageView.frame = CGRectMake(11+photoImageViewWidth*i+10*i, photoImageViewTop, photoImageViewWidth, photoImageViewHeight);
            NSURL * avatarimu = [NSURL URLWithString:fourArray[i]];
            [_photoImageView sd_setImageWithURL:avatarimu];
            _photoImageView.layer.cornerRadius = 10;
            [photoView addSubview:_photoImageView];
        }
        
    }
    
    else
    {
        //第一排照片
        for (int i = 0; i< 4; i++) {
            photoImageView2 = [[UIImageView alloc] init];
            photoImageView2.frame = CGRectMake(11+photoImageViewWidth*i+10*i, photoImageViewTop, photoImageViewWidth, photoImageViewHeight);
            NSURL* avatarimu1 = [NSURL URLWithString:fourArray[i]];
            [photoImageView2 sd_setImageWithURL:avatarimu1];
            photoImageView2.layer.cornerRadius = 10;
            [photoView addSubview:photoImageView2];
        }
        //第二拍照片
        for (int i = 0; i< tempArray.count-4; i++) {
            photoImageView1 = [[UIImageView alloc] init];
            photoImageView1.frame = CGRectMake(11+photoImageViewWidth*i+10*i, photoImageViewTop*2+photoImageViewWidth, photoImageViewWidth, photoImageViewHeight);
            NSURL* avatarimu1 = [NSURL URLWithString:fourLaterArray[i]];
            [photoImageView1 sd_setImageWithURL:avatarimu1];
            photoImageView1.layer.cornerRadius = 10;
            [photoView addSubview:photoImageView1];
        }
    }
    // 线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, photoViewHeight-lineHeight, Main_Screen_Width, lineHeight)];
    line1.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [photoView addSubview:line1];
    //locationlable
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, photoViewHeight, Main_Screen_Width, lableHeight)];
    lable.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:lable];
    // 线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, lableHeight-lineHeight, Main_Screen_Width, lineHeight)];
    line2.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [lable addSubview:line2];
    //location小图标
    UILabel *iconLable = [[UILabel alloc] initWithFrame:CGRectMake(iconLableLeft, lableHeight/2-iconLableHeight/2, iconLableWidth, iconLableHeight)];
    iconLable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"juli.png"]];
    [lable addSubview:iconLable];
    //具体位置
    UILabel *locationLable = [[UILabel alloc] initWithFrame:CGRectMake(iconLableLeft*2+iconLableWidth, 0, 150, lableHeight)];
    locationLable.textColor =[UIcol hexStringToColor:@"#787878"];
    locationLable.font = [UIFont systemFontOfSize:13];
    locationLable.text =@"北京西城区" ;
    [lable addSubview:locationLable];
    //距离几千米以及时间
    distanceLable = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width-iconLableLeft-distanceLableWidth, 0, distanceLableWidth, lableHeight)];
    distanceLable.textColor =[UIcol hexStringToColor:@"#787878"];
    distanceLable.font = [UIFont systemFontOfSize:13];
    distanceLable.text = distanceStr;
    [lable addSubview:distanceLable];
    //棒棒资料条
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, photoViewHeight+lableHeight, Main_Screen_Width, lable1Height)];
    lable1.text = @"  帮帮资料";
    lable1.font = [UIFont systemFontOfSize:11];
    lable1.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    lable1.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [scrollView addSubview:lable1];
    // 愿望背景
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, photoViewHeight+lableHeight+lable1Height, Main_Screen_Width, view2Height)];
    view2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"di.png"]];
    [scrollView addSubview:view2];
    //背景上的箭头
    jianBtn = [[UIButton alloc] initWithFrame:CGRectMake(jianViewLeft, view2Height/2-jianViewHeight/2, jianViewWidth, jianViewHeight)];
    jianBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jiantou.png"]];
    [jianBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    jianBtn.tag = 2;
    [view2 addSubview:jianBtn];
    //愿望头像
    wishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(wishImageViewLeft, view2Height/2-headPhotoImageViewWidth/2, headPhotoImageViewWidth, headPhotoImageViewWidth)];
    wishImageView.layer.cornerRadius = 10;
    wishImageView.layer.masksToBounds = YES;
    NSURL * avatarimu = [NSURL URLWithString:_tempWishImageStr];
    [wishImageView sd_setImageWithURL:avatarimu];
    [view2 addSubview:wishImageView];
    //愿望内容
    wishLable = [[UILabel alloc] initWithFrame:CGRectMake(wishImageViewLeft*2+headPhotoImageViewWidth, wishImageViewLeft-10, wishLableWidth, wishLableHeight)];
    wishLable.text =wish;
    wishLable.font = [UIFont systemFontOfSize:14];
    wishLable.textColor = [UIcol hexStringToColor:@"#787878"];
    wishLable.lineBreakMode = NSLineBreakByWordWrapping ;
    wishLable.numberOfLines = 0;
    [view2 addSubview:wishLable];
    //赞 评论 创建时间
    for (int i=0; i < 3; i++) {
        countLable = [[UILabel alloc] init];
        countLable.textColor =[UIcol hexStringToColor:@"#bebebe"];
        countLable.font = [UIFont systemFontOfSize:11];
        countLable.tag = 10+i;
//        countLable.text = [arr1 objectAtIndex:i];
        [view2 addSubview:countLable];
        switch (countLable.tag) {
            case 10:
            {
                countLable.frame = CGRectMake(99, countLableTop, 50, 15);
            }
                break;
            case 11:
            {
                countLable.frame = CGRectMake(140, countLableTop, 50, 15);
            }
                break;
            case 12:
            {
                countLable.frame = CGRectMake(200, countLableTop, 100, 15);
            }
            default:
                break;
        }
        
    }
    
    //线
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2Height-lineHeight, Main_Screen_Width, lineHeight)];
    line3.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [view2 addSubview:line3];
    //基本资料条
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, photoViewHeight+lableHeight+lable1Height+view2Height, Main_Screen_Width, lable1Height)];
    lable2.text = @"  基本资料";
    lable2.font = [UIFont systemFontOfSize:11];
    lable2.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    lable2.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [scrollView addSubview:lable2];
    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithObjects:@"帮帮号",@"昵称",@"年龄",@"星座",@"情感状态",@"学校",@"职业",@"所在地", nil];
    for (int i = 0; i < 8; i ++) {
        personLable = [[UILabel alloc] init];
        personLable.frame = CGRectMake(75,photoViewHeight+lableHeight+lable1Height*2+view2Height+personLableHeight*i , Main_Screen_Width, personLableHeight);
        personLable.textAlignment =  NSTextAlignmentLeft ;
        personLable.tag = 5000+i;
        personLable.backgroundColor =[UIColor whiteColor];
        personLable.textColor =[UIcol hexStringToColor:@"#787878"];
        personLable.font = [UIFont systemFontOfSize:12];
        switch (personLable.tag)
        {
            case 5000:
                personLable.text = bbIdStr;
                break;
            case 5001:
                personLable.text = nameStr;
                break;
            case 5002:
                personLable.text = ageStr;
                break;
            case 5003:
                personLable.text = conStr;
                break;
            case 5004:
                personLable.text =  merriageStr;
                break;
            case 5005:
                personLable.text = schoolStr;
                break;
            case 5006:
                personLable.text = careerStr;
                break;
            case 5007:
                personLable.text = hometownStr;
            default:
                break;
        }
        [scrollView addSubview:personLable];
        UILabel *smallPersonLable = [[UILabel alloc] initWithFrame:CGRectMake (0, photoViewHeight+lableHeight+lable1Height*2+view2Height+personLableHeight*i, smallPersonLableWidth, personLableHeight)];
        smallPersonLable.text = [titleArray objectAtIndex:i];
        smallPersonLable.textColor =  [UIcol hexStringToColor:@"#2e2e2e"];
        smallPersonLable.font = [UIFont systemFontOfSize:12];
        smallPersonLable.backgroundColor = [UIColor whiteColor];
        smallPersonLable.textAlignment = NSTextAlignmentRight;
        [scrollView addSubview:smallPersonLable];
        //循环创建线
        UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, personLableHeight-1, 245, 1)];
        line5.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
        line5.tag = 70+i;
        [personLable addSubview:line5];
        UIView *tempView = (id)[self.view viewWithTag:77];
        tempView.hidden = YES;
    }
    //愿望与梦想条
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(0, photoViewHeight+lableHeight+lable1Height*2+view2Height+personLableHeight*8, Main_Screen_Width, lable1Height)];
    lable3.text = @"  愿望与梦想";
    lable3.font = [UIFont systemFontOfSize:11];
    lable3.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    lable3.backgroundColor = [UIcol hexStringToColor:@"#f2f2f2"];
    [scrollView addSubview:lable3];
    //线
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0,0, Main_Screen_Width, 1)];
    line6.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [lable3 addSubview:line6];
    //数组
    NSMutableArray *titleArray1 = [[NSMutableArray alloc] initWithObjects:@"愿望",@"愿望宣言", nil];
    for (int i = 0; i < 2; i ++) {
        personLables = [[UILabel alloc] init];
        personLables.frame = CGRectMake(75, photoViewHeight+lableHeight+lable1Height*2+view2Height+personLableHeight*8+lable1Height+personLableHeight*i, Main_Screen_Width, personLableHeight);
        personLables.textAlignment =  NSTextAlignmentLeft ;
        personLables.tag = 800+i;
        personLables.backgroundColor = [UIColor whiteColor];
        personLables.textColor =[UIcol hexStringToColor:@"#787878"];
        personLables.font = [UIFont systemFontOfSize:12];
        switch (personLables.tag)
        {
            case 800:
                personLables.text = wishDeStr;
                break;
            case 801:
                personLables.text = dreamDeStr;
                
            default:
                break;
        }
        [scrollView addSubview:personLables];
        UILabel *smallPersonLables = [[UILabel alloc] initWithFrame:CGRectMake (0, photoViewHeight+lableHeight+lable1Height*2+view2Height+personLableHeight*8+lable1Height+personLableHeight*i, smallPersonLableWidth, personLableHeight)];
        smallPersonLables.text = [titleArray1 objectAtIndex:i];
        smallPersonLables.textColor =  [UIcol hexStringToColor:@"#2e2e2e"];
        smallPersonLables.font = [UIFont systemFontOfSize:12];
        smallPersonLables.backgroundColor = [UIColor whiteColor];
        smallPersonLables.textAlignment = NSTextAlignmentRight;
        [scrollView addSubview:smallPersonLables];
    }
    tempLable =(id)[self.view viewWithTag:800];
    //线
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, personLableHeight-1, 245, 1)];
    line8.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [tempLable addSubview:line8];
    //线
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0,photoViewHeight+lableHeight+lable1Height*2+view2Height+personLableHeight*8+lable1Height+personLableHeight*2, Main_Screen_Width, 1)];
    line7.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    [scrollView  addSubview:line7];

}

-(void)viewWillAppear:(BOOL)animated
{
    //底部按钮背景图
    UIView *btnBackView = [[UIView alloc] init];
    btnBackView.frame = CGRectMake(0, Main_Screen_Height-btnBackViewHeight-20, Main_Screen_Width, btnBackViewHeight);
    btnBackView.backgroundColor = [UIColor blackColor];
      btnBackView.userInteractionEnabled = YES;
    [backgroundView addSubview:btnBackView];
       //底部按钮
    for (int i = 0; i < 3; i ++)
    {
        bottomBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(8+bottomBtnWidth*i+8*i, btnBackViewHeight/2-bottomBtnHeight/2, bottomBtnWidth, bottomBtnHeight)];
        bottomBtn1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[arr objectAtIndex:i]]];
        [bottomBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn1.tag = 30+i;
        [btnBackView addSubview:bottomBtn1];
        
    }
}
#pragma mark -- 编辑按钮

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
