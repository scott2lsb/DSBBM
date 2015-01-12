//
//  SearchViewController.m
//  DSBBM
//
//  Created by 我想要大双眼皮子 on 14-9-30.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "SearchViewController.h"
#import "friendInfoViewController.h"
#import "SearchBar.h"


//屏幕宽度
#define Main_Screen_Width   320
#define Main_Screen_Height [UIScreen mainScreen].bounds.size.height
#define searchBackViewHeight 41.0f
//深色格子高度

@interface SearchViewController ()<SearchTableViewCellGuanzhuDelegate>
{
    //定义一个数组来存放搜索的结果
    NSMutableArray *resultArray;
    //获取输入框的内容
    NSString * toBeString;
    UITextField *search;
    NSMutableArray *_dataArray;
    //搜索条背景
    UIView *view1;
    //搜索结果
    NSMutableArray *userPhotoArray;
    NSMutableArray *usernameArray;
    NSMutableArray *userIdArray;
    UITableView *_newTableView;
    //plachoder
    UILabel *lable;
    //
    SearchBar *seacher;

}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

//创建UI
-(void)createUI
{
    //自定义导航imageView的高
#define barViewHeight 44.0f
    
    //返回按钮
#define baackBtnHeight 18.0f
#define baackBtnWidth 12.0f
#define baackBtnLeft 10.0f
    
    
    UIView *barView = [[UIView alloc] init];
    barView.frame = CGRectMake(0, 20, Main_Screen_Width , barViewHeight);
    barView.backgroundColor = [UIcol hexStringToColor:@"#fad219"];
    barView.userInteractionEnabled = YES;
    [self.view addSubview:barView];
    
    //菜单按钮
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(0, 0,44,44);
    backBtn.userInteractionEnabled = YES;
    [backBtn addTarget:self action:@selector(btnClick:)forControlEvents: UIControlEventTouchUpInside];
    backBtn.tag = 1;
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [barView addSubview:backBtn];
    
    //*************************************
    
    seacher = [[SearchBar alloc]initWithFrame:CGRectMake(44, 7, 260, 30)];
    seacher.delegate = self;
    seacher.returnKeyType = UIReturnKeySearch;
    [barView addSubview:seacher];
    
    
    _newTableView = [[UITableView alloc] init];
    _newTableView.frame = CGRectMake(0, 61, 320, Main_Screen_Height - searchBackViewHeight);
    _newTableView.delegate = self;
    _newTableView.dataSource = self;
    _newTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_newTableView setSeparatorColor:[UIcol hexStringToColor:@"#f8f5fb"]];
    _newTableView.userInteractionEnabled = YES;
    _newTableView.tag = 2000+2;
    _newTableView.separatorColor = [UIcol hexStringToColor:@"#e2dee5"];
    [self.view addSubview:_newTableView];

}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==1) {
//        [self dismissViewControllerAnimated:YES completion:^{}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    _dataArray =[[ NSMutableArray alloc] init];
    usernameArray = [[NSMutableArray alloc] init];
    userPhotoArray = [[NSMutableArray alloc] init];
    userIdArray = [NSMutableArray array];
    
//    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [super viewDidLoad];
    [self createUI];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [usernameArray count];
}

//控件有多少分段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


//返回实例
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *string1 = @"cell1";
        SearchTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:string1];
    
    
        if (searchCell == nil)
        {
            searchCell = [[[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:self options:nil] lastObject];
        }
    
        if (usernameArray.count >0) {
            NSString *str = [usernameArray objectAtIndex:indexPath.row];
            NSString *userId = [userIdArray objectAtIndex:indexPath.row];
            if (str!=nil) {
                searchCell.searchName.text = str;
                searchCell.userId = userId;
            }
        }
        if (userPhotoArray.count >0) {
            NSString *str1 = [userPhotoArray objectAtIndex:indexPath.row];
            if (str1!=nil) {
                NSURL * avatarimu = [NSURL URLWithString:str1];
                [searchCell.searchImageView sd_setImageWithURL:avatarimu];

                }
        }
    
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        searchCell.delegate  = self;
        return searchCell;
        
    }


//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = indexPath.row;
    
    friendInfoViewController *info = [[friendInfoViewController alloc]init];
    info.userId = userIdArray[count];
    info.userName = usernameArray[count];
    
    [self.navigationController pushViewController:info animated:YES];

}


//
#pragma mark --textFieldDelegate
//结束编辑时点击return结束编辑 同时键盘收起
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [seacher resignFirstResponder];
    //搜索结果数组
    userPhotoArray = [[NSMutableArray alloc] init];
    usernameArray = [[NSMutableArray alloc] init];
    
    
    //当点击确定之后开始搜索(模糊查询)
    //查询username表
    
    if (seacher.text!=nil) {
        
        BmobQuery *bquery5 = [BmobQuery queryForUser];
        [bquery5 whereKey:@"nick" matchesWithRegex:seacher.text];
        [bquery5 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                [usernameArray addObject:[obj objectForKey:@"nick"]];
                [userIdArray addObject:obj.objectId];
                NSString *str = [obj objectForKey:@"avatar"];
                
                if (str!=nil) {
                    
                    [userPhotoArray addObject:str];
                    [_newTableView reloadData];
                    
                }
                
            }
        }];

    }
    return YES;
}

//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [seacher  resignFirstResponder];
}

//刚开始编辑的时候让plahorder消失
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    lable.hidden = YES;
}

//
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


//限制框内只能输入20个字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    lable.hidden = YES;
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (seacher == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
            seacher.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    
    return YES;
    
}


//当清零内容时
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    lable.hidden = NO;
    userPhotoArray = nil;
    usernameArray = nil;
    [_newTableView reloadData];
   return YES;
}

- (void)guanzhuOnclickWithUseName:(NSString *)name UseId:(NSString *)userId
{
    NSLog(@"ssssksssksskss");
    NSLog(@"guanzhuOnclick:name = %@, id = %@", name, userId);
    
    friendInfoViewController *info = [[friendInfoViewController alloc]init];
    info.userId = userId;
    info.userName = name;
    
    [self.navigationController pushViewController:info animated:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
