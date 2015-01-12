//
//  PerSetViewController.m
//  DSBBM
//
//  Created by bisheng on 14-11-6.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "PerSetViewController.h"
#import "EditDataViewController.h"

@interface PerSetViewController ()

@end

@implementation PerSetViewController
{
    NSArray * dataArray;
    NSMutableArray * getArray;
    UITableView * selectTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNarBar];
    if(self.i == 7 || self.i == 5 || self.i == 3){
        [self getDate];
    }else{
        [self createTextF];
    }
  
  
}

-(void)createTextF{
    
    if(self.i == 1){
        UIView * back = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 44.5)];
        back.backgroundColor = [UIColor whiteColor];
        UITextField * nick = [[UITextField alloc] initWithFrame:CGRectMake(20,0, 280, 44.5)];
        nick.tag = 100 + self.i;
        [nick becomeFirstResponder];
        [back addSubview:nick];
        [self.view addSubview:back];
    }else if (self.i == 8 || self.i == 4){
        UITextView * wish = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, 320, 109)];
        wish.backgroundColor = [UIColor whiteColor];
        wish.tag = 100 + self.i;
        [wish becomeFirstResponder];
        [self.view addSubview:wish];
    }
    
}

-(void)getDate{
    if(self.i == 7){
        dataArray = @[@"画家",@"作家",@"演员",@"商人",@"睡懒觉",@"摄影师",@"旅行家",@"美食家",@"梦想家",@"手艺人",@"品酒师",@"设计师",@"吃不胖",@"变漂亮",@"不要加班",@"环游世界",@"海边别墅",@"找到对的人"];
        getArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
         NSArray * array = [self.str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/ " ]];
        for(int i= 0 ; i < dataArray.count ; i++){
            for (int j = 0 ; j < array.count ; j++) {
                if([dataArray[i]isEqualToString:array[j]]){
                   [getArray replaceObjectAtIndex:i withObject:@"1"];
                }
            }
        }
        
    }else if (self.i == 5){
        dataArray = @[@"计算机/互联网/通信 ",@"项目工程/管理",@"生产/工艺/制造",@"商业/服务业/个体经营",@"金融/银行/投资/保险",@"文化/广告/传媒/设计",@"娱乐/艺术/表演",@"医疗/护理/制药",@"律师/法务",@"教育/培训",@"公务员/事业单位/军人",@"学生",@"无"];
        getArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
        for(int i= 0 ; i < dataArray.count ; i++){
            NSString *cleanString = [dataArray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([cleanString isEqualToString:self.str]){
                [getArray replaceObjectAtIndex:i withObject:@"1"];
            }
        }
    }else if (self.i == 3){
        dataArray = @[@"保密",@"单身",@"恋爱中",@"已婚",@"同性"];
       getArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
        for(int i= 0 ; i < dataArray.count ; i++){
            NSString *cleanString = [dataArray[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([cleanString isEqualToString:self.str]){
                [getArray replaceObjectAtIndex:i withObject:@"1"];
            }
        }
    }
    
    
    [self createTableView];
}

-(void)createTableView{
    selectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
    selectTable.delegate = self;
    selectTable.dataSource = self;
    selectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:selectTable];
}

#pragma mark tableView 方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    PerSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PerSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = dataArray[indexPath.row];
    cell.textLabel.textColor = [UIcol hexStringToColor:@"#2e2e2e"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if([getArray[indexPath.row] integerValue] == 1){
        [cell.choose setImage:[UIImage imageNamed:@"xuanze"]];
    }else{
        [cell.choose setImage:nil];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if(getArray.count == 0){
            [getArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [selectTable reloadData];
        }else{
            if(self.i == 3 || self.i == 5){
                [getArray removeObject:@"1"];
                [getArray addObject:@"0"];
                [getArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                [selectTable reloadData];
            }else{
                int j = 0;
                for (int i = 0 ; i < getArray.count ; i++) {
                    if([getArray[i] isEqualToString:@"1"]){
                        j++;
                    }
                }
                if(j < 4){
                if([getArray[indexPath.row] isEqualToString:@"0"]){
                    [getArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                }else{
                     [getArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                }
                }else if(j == 4){
                    [getArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                }else{
                    
                }
            }
            [selectTable reloadData];
        }
  
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(void)createNarBar{
    UIView * gj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    gj.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gj];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor = [UIcol hexStringToColor:@"f2f2f2"];
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
    
    UILabel * titleBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    if(self.i == 7){
        titleBar.text = @"选择愿望";
    }else if (self.i == 5){
        titleBar.text = @"选择职业";
    }else if (self.i == 3){
       titleBar.text = @"情感状态";
    }else if (self.i == 1){
        titleBar.text = @"输入昵称";
    }else if (self.i == 4){
        titleBar.text = @"学校";
    }else if (self.i == 8){
        titleBar.text = @"愿望宣言";
    }
    titleBar.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    titleBar.shadowOffset = CGSizeMake(1, 0.5);
    titleBar.font = [UIFont systemFontOfSize:18];
    titleBar.textAlignment = YES;
    titleBar.textColor = [UIcol hexStringToColor:@"ffffff"];
    [iv addSubview:titleBar];
    
}

-(void)goBack{
  
     NSArray * array = self.navigationController.viewControllers;
    EditDataViewController * edvc = array[array.count - 2];
    if(self.i == 1 || self.i == 8 || self.i == 4){
        UITextField * tf = (id)[self.view viewWithTag:self.i + 100];
        if(![tf.text isEqualToString:@""]){
            edvc.m = self.i;
            edvc.string = tf.text;
        }
    }else if(self.i == 7){
        NSMutableString * str = [NSMutableString string];
        for (int j = 0;j < getArray.count ; j++) {
            if([getArray[j]isEqualToString:@"1"]){
                [str appendFormat:@"%@/",dataArray[j]];
            }
        }
        if(str.length != 0){
            [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
            edvc.m = self.i;
            edvc.string = str;
        }
        
    }else{
        for (int j = 0;j < getArray.count ; j++) {
            if([getArray[j]isEqualToString:@"1"]){
                edvc.m = self.i;
                edvc.string = dataArray[j];
            }
        }
       
        
    }
    
    
    [self.navigationController popToViewController:edvc animated:YES];

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
