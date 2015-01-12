//
//  YWXQViewController.m
//  DSBBM
//
//  Created by bisheng on 14-9-1.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "YWXQViewController.h"
#import "UIImageView+WebCache.h"
#import "PLModel.h"
#import "PLTableViewCell.h"
#import "chatViewController.h"

@interface YWXQViewController ()

@end

@implementation YWXQViewController
{
    UITableView * plTableView;
    NSMutableArray * plarray;
    UIView * pinglv;
    UITextView * pingltv;
    
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
    plTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-50)];
    plTableView.delegate = self;
    plTableView.dataSource = self;
    [self.view addSubview:plTableView];
    [self createUI];
    [self createXBar];
    [self array];
    [self pingllan];
    
    
    
    
    
}
-(void)array{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
    [bquery orderByDescending:@"updatedAt"];
    bquery.limit = 15;
    [bquery includeKey:@"user"];
    
    BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:@"Wish" objectId:self.object.objectId];
    [bquery whereObjectKey:@"comments" relatedTo:obj];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        plarray = [[NSMutableArray alloc] init];
        
        for (BmobObject * obj in array) {
            PLModel * pl = [[PLModel alloc] init];
            BmobObject * postObj = [obj objectForKey:@"user"];
            pl.name = [postObj objectForKey:@"nickname"];
            pl.url = [postObj objectForKey:@"avatar"];
            pl.neirong = [obj objectForKey:@"content"];
            [plarray addObject:pl];
            [plTableView reloadData];
        }
        
    }];

}
-(void)createNaBar{

    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIColor colorWithRed:0.94 green:0.93 blue:0.95 alpha:1];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIView * bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
    [iv addSubview:bar];
    UILabel * zbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 44)];
    zbl.text = @"<  返回";
    zbl.textColor = [UIColor colorWithRed:0.49 green:0.47 blue:0.49 alpha:1];
    zbl.userInteractionEnabled = YES;
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [but addTarget:self action:@selector(but) forControlEvents:UIControlEventTouchUpInside];
    [zbl addSubview:but];
    [iv addSubview:zbl];
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tit.text = @"愿望详情";
    tit.textAlignment = YES;
    tit.textColor = [UIColor whiteColor];
    [iv addSubview:tit];
}

-(void)but{

    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createXBar{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-50, 320, 50)];
    for(int i= 0 ; i < 3 ;i ++){
    UIButton * b = [[UIButton alloc] initWithFrame:CGRectMake(320/3*i, 0, 320/3, 50)];
        [b addTarget:self action:@selector(dianzan:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = 400+i;
    [v addSubview:b];
    }
    [self.view addSubview:v];
}

-(void)pingllan{
    pinglv = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 50)];
   pingltv = [[UITextView alloc] initWithFrame:CGRectMake(70, 10, 200, 30)];
    pingltv.delegate = self;
    UIButton * fasong = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 50, 50)];
    [fasong addTarget:self action:@selector(fasong) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pinglv addSubview:fasong];
    [pinglv addSubview:pingltv];
    [self.view addSubview:pinglv];
}
-(void)fasong{
    if([pingltv.text isEqualToString:@""]){
       
    }else{
        BmobUser * b = [BmobUser getCurrentObject];
        BmobObject  *gameScore = [BmobObject objectWithClassName:@"Comment"];
        [gameScore setObject:pingltv.text forKey:@"content"];
        [gameScore setObject:[BmobUser objectWithoutDatatWithClassName:nil objectId:b.objectId] forKey:@"user"];
        
        [gameScore saveInBackground];
        pingltv.frame = CGRectMake(320, 0, 0, 0);
        [pingltv resignFirstResponder];
    }

}
-(void)dianzan:(UIButton *)btn{
       BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Wish"];
    switch (btn.tag) {
        case 402:{
        
            [bquery getObjectInBackgroundWithId:self.object.objectId block:^(BmobObject *object,NSError *error){
                if (!error) {
                    //对象存在
                    if (object) {
                        
                        [object setObject:[NSNumber numberWithInt:([[self.object objectForKey:@"like"] intValue]+1)] forKey:@"like"];
                        //异步更新数据
                        [object updateInBackground];
                    }
                }else{
                    //进行错误处理
                }
                
            }];}
            break;
        case 401:{
            pinglv.frame = CGRectMake(0, self.view.bounds.size.height-50, 320, 50);
            
            
        }
            break;
        case 400:{
            chatViewController * cvc = [[chatViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
            
        }
            break;
    }
    
    
    
    
   }
- (void)textViewDidBeginEditing:(UITextView *)textView{
    pinglv.frame = CGRectMake(0, self.view.bounds.size.height-260, 320, 50);

}
-(void)createUI{
        
    
    UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 168)];
    back.backgroundColor = [UIcol hexStringToColor:@"#f8f5fb"];
    UIView * fgxian = [[UIView alloc] initWithFrame:CGRectMake(10, 68, 300, 0.5)];
    fgxian.backgroundColor = [UIcol hexStringToColor:@"#e0e0e0"];
    UIView * fgxians = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    fgxians.backgroundColor = [UIcol hexStringToColor:@"#e0e0e0"];
    UIView * fgxianx = [[UIView alloc] initWithFrame:CGRectMake(0, 167.5, 320, 0.5)];
    fgxianx.backgroundColor = [UIcol hexStringToColor:@"#e0e0e0"];
    UIImageView * t1 = [[UIImageView alloc] initWithFrame:CGRectMake(45/2, 12, 40, 40)];
    t1.layer.cornerRadius = 8;
    t1.layer.masksToBounds = YES;
    UIImageView * t2 = [[UIImageView alloc] initWithFrame:CGRectMake(213, 79,69, 69)];
    t2.layer.cornerRadius = 8;
    t2.layer.masksToBounds = YES;
    NSURL * imu = [NSURL URLWithString:self.t1];
    [t1 setImageWithURL:imu];
    NSURL * td = [NSURL URLWithString:self.t2];
    [t2 setImageWithURL:td];
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 20)];
    name.textColor = [UIcol hexStringToColor:@"#76757b"];
    name.text = self.nickname;
    name.font = [UIFont systemFontOfSize:13];
    UIView * agev = [[UIView alloc] initWithFrame:CGRectMake(70, 40, 24, 12)];
    agev.backgroundColor = [UIcol hexStringToColor:@"f19149"];
    agev.layer.cornerRadius = 2;
    agev.layer.masksToBounds = YES;
    UILabel * age = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 12)];
    age.textColor = [UIColor whiteColor];
    age.text = self.age;
    age.font = [UIFont systemFontOfSize:10];
    age.textAlignment = YES;
    [agev addSubview:age];
    UIView * xingzv = [[UIView alloc] initWithFrame:CGRectMake(100,40, 24, 12)];
    xingzv.backgroundColor = [UIcol hexStringToColor:@"ea68a2"];
    UILabel * xinz = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 12)];
    xinz.font = [UIFont systemFontOfSize:12];
    xinz.text = self.xingz;
    xinz.textAlignment = YES;
    xinz.textColor = [UIColor whiteColor];
    xingzv.layer.cornerRadius = 2;
    xingzv.layer.masksToBounds = YES;
    
    [xingzv addSubview:xinz];
    
    UITextView * neirong = [[UITextView alloc] initWithFrame:CGRectMake(22.5, 73, 180, 81)];
    neirong.backgroundColor = [UIColor clearColor];
    neirong.text = self.nairong;
    neirong.userInteractionEnabled = NO;
    neirong.font = [UIFont systemFontOfSize:13];
    UIImageView * zan = [[UIImageView alloc] initWithFrame:CGRectMake(25.5, 142, 12, 12)];
    zan.image = [UIImage imageNamed:@"赞"];
    UIImageView * pingl = [[UIImageView alloc] initWithFrame:CGRectMake(82, 142, 12, 12)];
    pingl.image = [UIImage imageNamed:@"评论"];
    UILabel * zan1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 142, 80, 12)];
    zan1.font = [UIFont systemFontOfSize:11];
    zan1.text = self.like;
    zan1.textColor = [UIcol hexStringToColor:@"767576"];
    UILabel * pinglun = [[UILabel alloc] initWithFrame:CGRectMake(96.5, 142, 80, 12)];
    pinglun.font = [UIFont systemFontOfSize:11];
    pinglun.text = self.comment;
    pinglun.textColor = [UIcol hexStringToColor:@"767576"];
    UILabel * juli = [[UILabel alloc] initWithFrame:CGRectMake(150, 20, 150, 12)];
    juli.font = [UIFont systemFontOfSize:11];
    juli.textAlignment = NSTextAlignmentRight;
    juli.textColor = [UIcol hexStringToColor:@"767576"];

    CGRect rect = [[NSString stringWithFormat:@"%@",self.shijian] boundingRectWithSize:CGSizeMake(300, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    juli.text = [NSString stringWithFormat:@"%@",self.juli];
    
    UIView * xian = [[UIView alloc] initWithFrame:CGRectMake(320, 21, 1, 10)];
    xian.backgroundColor = [UIcol hexStringToColor:@"#767576"];
    xian.center = CGPointMake(300-rect.size.width-5,xian.center.y );
    
    [back addSubview:xian];
    [back addSubview:juli];
    [back addSubview:pinglun];
    [back addSubview:zan];
    [back addSubview:pingl];
    [back addSubview:zan1];
    [back addSubview:neirong];
    [back addSubview:xingzv];
    [back addSubview:agev];
    [back addSubview:name];
    [back addSubview:t2];
    [back addSubview:t1];
    [back addSubview:fgxian];
    [back addSubview:fgxians];
    [back addSubview:fgxianx];
    [back addSubview:name];
    plTableView.tableHeaderView = back;
    
   
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
           return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return plarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pl"];
    if (!cell) {
        cell = [[PLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pl"] ;
    }
    PLModel * pl =plarray[indexPath.row];
    cell.neirong.text = pl.neirong;
    cell.name.text = pl.name;
    NSURL * imu = [NSURL URLWithString:pl.url];
    [cell.tu setImageWithURL:imu];

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
