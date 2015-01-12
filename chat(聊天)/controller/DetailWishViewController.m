//
//  YWXQViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-1.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "DetailWishViewController.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "ChatViewController.h"
#import "WishViewController.h"
#import "friendDatumViewController.h"
#import "RecentlyViewController.h"

#import "friendInfoViewController.h"

@interface DetailWishViewController ()

@end

@implementation DetailWishViewController
{
    UITableView * commentTableView;
    NSMutableArray * commentarray;
    NSMutableArray * likearray;
    UIView * commentv;
    UITextView * commenttv;
    UIView * back;
    BOOL likeBool;
    int _type;
    NSString * _user;
    NSString * likeObject;
    
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
    
    self.view.backgroundColor = [UIcol hexStringToColor:@"#f0ecf3"];
    [self createNaBar];
    likeBool = YES;
    _type = 0;
    _user = [NSString stringWithString:self.chatid.objectId];
    commentTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-50)];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:commentTableView];
    [self createUI];
    [self createXBar];
    [self getData];
    [self getLike];
    [self addcomment];
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
     commentv.frame = CGRectMake(0, self.view.bounds.size.height, 320, 50);
    [commenttv resignFirstResponder];
}

-(void)getData{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"WishMsg"];
    [bquery orderByDescending:@"updatedAt"];
    bquery.limit = 15;
    [bquery includeKey:@"wish,fromUser,toUser"];
    [bquery whereKey:@"msgType" containedIn:@[[NSNumber numberWithInt:2],[NSNumber numberWithInt:0]]];
    [bquery whereKey:@"wish" equalTo:self.object.objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        commentarray = [[NSMutableArray alloc] init];
        for (BmobObject * obj in array) {
            CommentModel * comment = [[CommentModel alloc] init];
            BmobUser * bUser = [obj objectForKey:@"fromUser"];
            BmobUser * toUser = [obj objectForKey:@"toUser"];
            if([[obj objectForKey:@"msgType"] integerValue] == 0){
                comment.name = [bUser objectForKey:@"nick"];
            }else{
                comment.name = [NSString stringWithFormat:@"%@ 回复: %@",[bUser objectForKey:@"nick"],[toUser objectForKey:@"nick"]];
            }
            comment.userId = bUser.objectId;
            comment.url = [bUser objectForKey:@"avatar"];
            comment.context = [obj objectForKey:@"content"];
            comment.createTime = obj.createdAt;
            
            [commentarray addObject:comment];
            [commentTableView reloadData];
        }
    }];
    
}

-(void)getLike{
    likearray = [[NSMutableArray alloc] init];
    
    BmobUser * user = [BmobUser getCurrentObject];
    BmobQuery *query = [BmobQuery queryWithClassName:@"WishMsg"];
    [query includeKey:@"fromUser"];
    [query whereKey:@"msgType" equalTo:[NSNumber numberWithInt:1]];
    [query whereKey:@"wish" equalTo:self.object.objectId];
    [query whereKey:@"fromUser" equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count != 0){
            likeObject = [array[0] objectId];
            UIButton * btn  = (id)[self.view viewWithTag:402];
            [btn setImage:[UIImage imageNamed:@"yikaopu"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"yikaopuselect"] forState:UIControlStateHighlighted];
            btn.tag = 403;
        }
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"WishMsg"];
        [bquery orderByDescending:@"updatedAt"];
        bquery.limit = 7;
        [bquery includeKey:@"fromUser"];
        [bquery whereKey:@"msgType" equalTo:[NSNumber numberWithInt:1]];
        [bquery whereKey:@"wish" equalTo:self.object.objectId];
        
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            for (BmobObject * obj in array) {
                [likearray addObject:[[obj objectForKey:@"fromUser"] objectForKey:@"avatar"]];
            }
            [self createImage];
        }];
    }];
    

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
    bar.image = [UIImage imageNamed:@"yuanwangxiangqing"];
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
    
}

-(void)more{
    BmobUser * user = [BmobUser getCurrentUser];
    UIActionSheet *as;
    if([user.objectId isEqualToString:_chatid.objectId]){
       as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"分享",@"删除", nil];
    }else{
        as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"分享",@"举报", nil];
    }
    [as showInView:self.view];


}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createXBar{
    UIView * xBarV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, 320, 49)];
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
    [self.view addSubview:xBarV];
}

-(void)addcomment{
    commentv = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 50)];
    commentv.backgroundColor = [UIColor lightGrayColor];
    commenttv = [[UITextView alloc] initWithFrame:CGRectMake(70, 10, 200, 30)];
    commenttv.delegate = self;
    UIButton * addbut = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 50, 50)];
    [addbut addTarget:self action:@selector(addSeek) forControlEvents:UIControlEventTouchUpInside];
    UILabel * addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    addLabel.text = @"发送";
    [addbut addSubview:addLabel];
    [commentv addSubview:addbut];
    [commentv addSubview:commenttv];
    [self.view addSubview:commentv];
}

-(void)addSeek{
    [self addSeekFromUser:_user Type:_type];
}

-(void)addSeekFromUser:(NSString *)user Type:(int)type{
    NSLog(@"%@",user);
    if(![commenttv.text isEqualToString:@""]){
        BmobUser * bUser = [BmobUser getCurrentObject];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setValue:user forKey:@"toUser"];
        [dict setValue:bUser.objectId forKey:@"fromUser"];
        [dict setValue:[NSNumber numberWithInt:type] forKey:@"tag"];
        [dict setValue:self.object.objectId forKey:@"wish"];
        [dict setValue:commenttv.text forKey:@"content"];
        [BmobCloud callFunctionInBackground:@"addWishMsg" withParameters:dict block:^(id object, NSError *error) {
            [self getData];
        }];

        _type = 0;
        _user = self.chatid.objectId;
        commentv.frame = CGRectMake(320, 0, 200, 30);
        commenttv.text = @"";
        [commenttv resignFirstResponder];
    
    }
}

-(void)addlike:(UIButton *)btn{
    BmobUser *bUser = [BmobUser getCurrentUser];
    
    switch (btn.tag) {
        case 403:{
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setValue:bUser.objectId forKey:@"fromUser"];
            [dict setValue:_chatid.objectId forKey:@"toUser"];
            [dict setValue:self.object.objectId forKey:@"wish"];
            [dict setValue:@"1" forKey:@"tag"];
            if([[_chatid objectForKey:@"deviceType"]isEqualToString:@"ios"]){
                [dict setValue:@"deviceToken" forKey:@"installId"];
            }else{
                [dict setValue:@"installationId" forKey:@"installId"];
            }
            [BmobCloud callFunctionInBackground:@"addWishMsg" withParameters:dict block:^(id object, NSError *error) {
                btn.tag = 402;
                [btn setImage:[UIImage imageNamed:@"kaopu"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"kaopuselect"] forState:UIControlStateHighlighted];
                NSLog(@"11111%@",object);
            }];
          
            
        }
            break;
        case 402:{
            
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setValue:bUser.objectId forKey:@"fromUser"];
            [dict setValue:_chatid.objectId forKey:@"toUser"];
            [dict setValue:self.object.objectId forKey:@"wish"];
            [dict setValue:@"1" forKey:@"tag"];
            if([[_chatid objectForKey:@"deviceType"]isEqualToString:@"ios"]){
                [dict setValue:@"deviceToken" forKey:@"installId"];
            }else{
                [dict setValue:@"installationId" forKey:@"installId"];
            }
            [BmobCloud callFunctionInBackground:@"addWishMsg" withParameters:dict block:^(id object, NSError *error) {
                btn.tag = 403;
                [btn setImage:[UIImage imageNamed:@"yikaopu"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"yikaopuselect"] forState:UIControlStateHighlighted];
                NSLog(@"22222%@",object);
            }];
            
        }
            break;
        case 401:{
            commentv.frame = CGRectMake(0, self.view.bounds.size.height-50, 320, 50);
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
            NSString *str = self.object.objectId;
            [infoDic setObject:str forKey:@"objectId"];
            
            ChatViewController * cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }
            break;
    }
    
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    commentv.frame = CGRectMake(0, self.view.bounds.size.height, 320, 50);
    [commenttv resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    commentv.frame = CGRectMake(0, self.view.bounds.size.height-260, 320, 50);
}

-(void)createUI{
    int i;
    CGSize size = [self.context boundingRectWithSize:CGSizeMake(219, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size;
    i = size.height;
    if(![self.image isEqualToString:@""] && self.image != nil && ![self.image isEqualToString:@"(null)"] ){
        i += 80;
    }
    back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, i + 80)];
    
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
    [avatarImageView sd_setImageWithURL:avatarimu];
    [avatar setImage:avatarImageView.image forState:UIControlStateNormal];
    if(![self.image isEqualToString:@""] && self.image != nil && ![self.image isEqualToString:@"(null)"] ){
        UIButton * drawing = [[UIButton alloc] initWithFrame:CGRectMake(75,i - 28, 70, 70)];
        drawing.layer.cornerRadius = 8;
        drawing.layer.masksToBounds = YES;
        UIImageView * drawingImageView = [[UIImageView alloc] init];
        NSURL * imageimu = [NSURL URLWithString:self.image];
        [drawingImageView sd_setImageWithURL:imageimu];
        [drawing setImage:drawingImageView.image forState:UIControlStateNormal];
        [back addSubview:drawing];
    }

    UIImageView * likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(75, i + 50, 12, 12)];
    likeIcon.image = [UIImage imageNamed:@"kaopuliebiao"];
    UIImageView * commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(137, i + 50, 12, 12)];
    commentIcon.image = [UIImage imageNamed:@"pingluliebiao"];
    
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
    
    
    UILabel * distance = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 160, 15)];
    distance.font = [UIFont systemFontOfSize:11];
    distance.textAlignment = NSTextAlignmentRight;
    distance.textColor = [UIcol hexStringToColor:@"bebebe"];
  
    CGRect rect = [[NSString stringWithFormat:@"%@",self.attime] boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    distance.text = [NSString stringWithFormat:@"%@",self.distance];
    UIView * xian = [[UIView alloc] initWithFrame:CGRectMake(320, 17, 1, 10)];
    xian.backgroundColor = [UIcol hexStringToColor:@"#bebebe"];
    xian.center = CGPointMake(305-rect.size.width,xian.center.y );
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(75, 37.5, 320, 0.5)];
    line2.backgroundColor = [UIcol hexStringToColor:@"#e6e6e6"];
    
    UILabel * createTime = [[UILabel alloc] initWithFrame:CGRectMake(160, i + 50, 150, 12)];
    createTime.textAlignment = NSTextAlignmentRight;
    createTime.font = [UIFont systemFontOfSize:11];
    createTime.textColor = [UIcol hexStringToColor:@"#bebebe"];
    createTime.text = [[NSString stringWithFormat:@"%@",self.timeDate] substringWithRange:NSMakeRange(2,8)];
    
    [back addSubview:createTime];
    [back addSubview:commentText];
    [back addSubview:likeText];
    [back addSubview:line2];
    [back addSubview:xian];
    [back addSubview:distance];
    [back addSubview:agev];
    [back addSubview:name];
    [back addSubview:line];
    [back addSubview:commentIcon];
    [back addSubview:likeIcon];
    [back addSubview:avatar];
    [back addSubview:contextv];
    [self.view addSubview:back];
}

-(void)wishBtn{
    friendDatumViewController * fdvc = [[friendDatumViewController alloc] init];
    fdvc.tempIdStr = self.chatid.objectId;
    [self presentViewController:fdvc animated:YES completion:^{
        
    }];
}

-(void)createImage{
    
    if(likearray.count != 0){
        UIView * line;
        back.frame = CGRectMake(0,64, 320,back.frame.size.height + 35);
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, back.frame.size.height - 35, 320, 35)];
        btn.tag = 2000;
        [btn addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIcol imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] size:btn.bounds.size] forState:UIControlStateHighlighted];
        line = [[UIView alloc] initWithFrame:CGRectMake(0,back.frame.size.height-0.5, 320, 0.5)];
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
    }
     commentTableView.tableHeaderView = back;
}

-(void)likeBtn{
    RecentlyViewController * rvc = [[RecentlyViewController alloc] init];
    rvc.i = 1;
    rvc.userObject = self.object.objectId;
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
    commentcell.createTime.text = [[NSString stringWithFormat:@"%@",comment.createTime] substringWithRange:NSMakeRange(5,11)];
    NSURL * imu = [NSURL URLWithString:comment.url];
    [commentcell.image sd_setImageWithURL:imu];
    
    CGSize size = [comment.context boundingRectWithSize:CGSizeMake(170, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;


   
    if(size.height > 50){
        commentcell.context.frame = CGRectMake(87, 38, 200,size.height + 20);
       commentcell.line.frame = CGRectMake(0, size.height + 49.5, 320, 0.5);
    }
   
    return commentcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton * btn = [[UIButton alloc] init];
    btn.tag = 401;
     CommentModel * comment =commentarray[indexPath.row];
    _user = comment.userId;
    _type = 2;
     [commenttv resignFirstResponder];
    [self addlike:btn];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel * comment =commentarray[indexPath.row];

    CGSize size = [comment.context boundingRectWithSize:CGSizeMake(170, 999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    if(size.height > 50)
    return size.height + 50;
    return 80;
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
