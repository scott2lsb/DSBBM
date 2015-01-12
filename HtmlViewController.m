//
//  HtmlViewController.m
//  DSBBM
//
//  Created by bisheng on 14-12-10.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "HtmlViewController.h"

@interface HtmlViewController ()

@end

@implementation HtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaBar];
    NSString *filePath;
    if(self.i == 1){
        filePath = [[NSBundle mainBundle]pathForResource:@"user_assistance" ofType:@"html"];
    }else{
        filePath = [[NSBundle mainBundle]pathForResource:@"user_agreement" ofType:@"html"];
    }
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width ,self.view.bounds.size.height - 64)];
    
    [self.view addSubview:web];
    web.backgroundColor = [UIcol hexStringToColor:@"f2f2f2"];
    [web loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}

#pragma mark nabar
-(void)createNaBar{
    self.view.backgroundColor = [UIColor blackColor];
    UIView * iv = [[UIView alloc] initWithFrame:CGRectMake(0, 20,320, self.view.bounds.size.height-20)];
    iv.backgroundColor =  [UIColor whiteColor];
    [self.view addSubview:iv];
    iv.userInteractionEnabled = YES;
    UIImageView * bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bar.image = [UIImage imageNamed:@"tou"];
    [iv addSubview:bar];
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [but setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"fanhuiselect"] forState:UIControlStateHighlighted];
    [but addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:but];
    
    UILabel * tit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    if(self.i == 0){
    tit.text = @"用户协议";
    }else{
    tit.text = @"用户帮助";
    }
    tit.shadowColor = [UIcol hexStringToColor:@"cd9933"];
    tit.shadowOffset = CGSizeMake(1, 0.5);
    tit.font = [UIFont systemFontOfSize:18];
    tit.textAlignment = YES;
    tit.textColor = [UIColor whiteColor];
    [iv addSubview:tit];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    
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
